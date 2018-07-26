#!/bin/bash
MY_MESSAGE="Starting test DB2!"
echo $MY_MESSAGE

set -e

docker pull ibmcom/db2express-c
docker run --name db2db -d -p 50000:50000 -e DB2INST1_PASSWORD=test123 -e LICENSE=accept  ibmcom/db2express-c:latest db2start
#wait until the db2db container if fully initialized
(docker logs -f --tail 0 db2db &) 2>&1 | grep -q -i 'DB2START processing was successful.'

#create a sample database (necessary to use db2)
docker exec -it db2db bin/bash -c "su - db2inst1 -c \"db2 create db sample\""

#copy .sql file to be executed inside container
docker cp test/testing_files/db2_datatypes_test.sql db2db:/home/db2inst1/	
#execute the file inside the db2db container
docker exec -it db2db bin/bash -c "su - db2inst1 -c \"db2 -stvf db2_datatypes_test.sql\""

#find the ip address of the mysql container
ip="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' db2db)"
echo "create or replace CONNECTION db2_connection TO 'jdbc:db2://$ip:50000/sample' USER 'db2inst1' IDENTIFIED BY 'test123';" > test/testing_files/create_conn.sql

#copy .sql file to be executed inside container
docker cp testing_files/create_conn.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/create_conn.sql" -x"

#delete output.sql file if exists : 
file="output.sql"
docker exec -ti exasoldb sh -c "[ ! -e $file ] || rm $file"

#copy .sql file to be executed inside container
docker cp db2_to_exasol_v2.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/ 
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/db2_to_exasol_v2.sql" -x" 
#execute the output.sql file created inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "output.sql" -x"