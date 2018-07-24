#!/bin/bash
MY_MESSAGE="Starting test sqlserver!"
echo $MY_MESSAGE

set -e

#setting up a sqlserver db image in docker and running a container
docker pull microsoft/mssql-server-linux:2017-latest
docker run --name sqlserverdb -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=my_strong_Password' -p 1433:1433 -d microsoft/mssql-server-linux:2017-latest
#wait until the sqlserverdb container if fully initialized
(docker logs -f --tail 0 sqlserverdb &) 2>&1 | grep -q -i 'SQL Server is now ready for client connections.'

#copy .sql file to be executed inside container
docker cp testing_files/sqlserver_datatypes_test.sql sqlserverdb:/tmp/
#execute the file inside the sqlserver container
docker exec -ti sqlserverdb sh -c "/opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U SA -P 'my_strong_Password' -i tmp/sqlserver_datatypes_test.sql"

#find the ip address of the postgres container
ip="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' sqlserverdb)"
echo "create or replace connection sqlserver_connection TO 'jdbc:jtds:sqlserver://$ip:1433' user 'sa' identified by 'my_strong_Password';" > testing_files/create_conn.sql

#copy .sql file to be executed inside container
docker cp testing_files/create_conn.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/create_conn.sql" -x"

#delete output.sql file if exists : 
file="output.sql"
docker exec -ti exasoldb sh -c "[ ! -e $file ] || rm $file"

#copy .sql file to be executed inside container
docker cp sqlserver_to_exasol_v2.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/ &&
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/sqlserver_to_exasol_v2.sql" -x" &&
#execute the output.sql file created inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "output.sql" -x"
