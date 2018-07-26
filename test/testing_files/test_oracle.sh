#!/bin/bash
MY_MESSAGE="Starting test Oracle!"
echo $MY_MESSAGE

set -e

docker pull sath89/oracle-12c:novnc
docker run --name oracledb -d -p 8080:8080 -p 1521:1521 sath89/oracle-12c:novnc
#wait until the oracledb container if fully initialized
(docker logs -f --tail 0 oracledb &) 2>&1 | grep -q -i 'Database ready to use. Enjoy! ;)'

#copy .sql file to be executed inside container
docker cp testing_files/oracle_datatypes_test.sql oracledb:/tmp/
docker exec -ti oracledb sh -c "echo exit | sqlplus -S system/oracle@localhost:1521/xe @/tmp/oracle_datatypes_test.sql"


#find the ip address of the oracle container
ip="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' oracledb)"
echo "CREATE OR REPLACE CONNECTION OCI_ORACLE TO '$ip:1521/xe' USER 'system' IDENTIFIED BY 'oracle';" > testing_files/create_conn.sql

tmp="$(docker exec -ti exasoldb sh -c "awk '/WritePasswd/{ print $3; }' exa/etc/EXAConf")"
b64pwd=${tmp:21}
pwd="$(echo $b64pwd | base64 -d)"
echo $pwd
docker cp instantclient-basic-linux.x64-12.1.0.2.0.zip exasoldb:/
docker exec -ti exasoldb sh -c "curl -v -X PUT -T instantclient-basic-linux.x64-12.1.0.2.0.zip http://w:$pwd@127.0.0.1:6583/default/drivers/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip"

#copy .sql file to be executed inside container
docker cp testing_files/create_conn.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/create_conn.sql" -x"

#delete output.sql file if exists : 
file="output.sql"
docker exec -ti exasoldb sh -c "[ ! -e $file ] || rm $file"

#copy .sql file to be executed inside container
docker cp oracle_to_exasol_v2.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/ 
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/oracle_to_exasol_v2.sql" -x" 
#execute the output.sql file created inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "output.sql" -x"




