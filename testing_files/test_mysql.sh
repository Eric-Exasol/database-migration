#!/bin/bash
MY_MESSAGE="Starting test mysql!"
echo $MY_MESSAGE

set -e

#setting up a mysql db image in docker
docker pull mysql:5.7.22
docker run --name mysqldb -p 3360:3306 -e MYSQL_ROOT_PASSWORD=mysql -d mysql:5.7.22
#wait until the postgresdb container if fully initialized
(docker logs -f --tail 0 mysqldb &) 2>&1 | grep -q -i 'port: 3306  MySQL Community Server (GPL)'

#copy .sql file to be executed inside container
docker cp testing_files/mysql_datatypes_test.sql mysqldb:/tmp/
#execute the file inside the mysqldb container
docker exec -ti mysqldb sh -c "mysql < tmp/mysql_datatypes_test.sql -pmysql"

#find the ip address of the mysql container
ip="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' mysqldb)"
echo "create or replace connection mysql_conn to 'jdbc:mysql://$ip:3306' user 'root' identified by 'mysql';" > testing_files/create_conn.sql

#copy .sql file to be executed inside container
docker cp testing_files/create_conn.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/create_conn.sql" -x"



python_path="C:\Users\erll\AppData\Local\Continuum\anaconda2\python.exe"
#create the script that we want to execute
$python_path create_script.py "my_sql_to_exasol_v2.sql"
#this python script executes the export script created by the my_sql_to_exasol_v2.sql script and creates an output.sql file with the result
$python_path export_res.py "MYSQL_TO_EXASOL2" "mysql_conn" "testing_d%" "%"

#delete previous output.sql file if exists : 
file="output.sql"
docker exec -ti exasoldb sh -c "[ ! -e $file ] || rm $file"
#copy new output.sql file to be executed inside container
docker cp $file exasoldb:/
#execute the output.sql file created inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "output.sql" -x"
#delete the file from current directory
[ ! -e $file ] || rm $file
