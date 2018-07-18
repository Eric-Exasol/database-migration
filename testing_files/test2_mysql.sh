#!/bin/sh
MY_MESSAGE="Test message!"
echo $MY_MESSAGE

set -e

#function cleanup() {
#	docker stop exasoldb || true
#   docker rm -v exasoldb || true
#	
#	docker stop mysqldb || true
#   docker rm -v mysqldb || true
#}
#trap cleanup EXIT

#setting up a mysql db image in docker
docker pull mysql:5.7.22
docker run --name mysqldb --network test-network -p 3306:3306 -p 3360:3360 -e MYSQL_ROOT_PASSWORD=mysql -d mysql:5.7.22

docker inspect mysqldb | grep "IPAddress"


#setting up an exasol db image in docker
docker pull exasol/docker-db:latest
docker run --name exasoldb --network test-network -p 8899:8888 --detach --privileged --stop-timeout 120  exasol/docker-db:latest
docker logs -f exasoldb &

# Wait until database is ready
(docker logs -f --tail 0 exasoldb &) 2>&1 | grep -q -i 'stage4: All stages finished'
sleep 30

#copy .sql file to be executed inside container
docker cp testing_files/mysql_datatypes_test.sql mysqldb:/tmp/
#execute the file inside the mysqldb container
docker exec -ti mysqldb sh -c "mysql < tmp/mysql_datatypes_test.sql -pmysql"

#find the ip address of the mysql container
ip_addr_long="$(docker inspect mysqldb | grep "IPAddress")"
len=${#ip_addr_long}
start=$(expr $len - 12)
ip=${ip_addr_long:$start:10}

#creates a file create_conn.sql with connection from the exasoldb to the mysqldb container
echo "create or replace connection mysql_conn to 'jdbc:mysql://$ip:3306' user 'root' identified by 'mysql';" > testing_files/create_conn.sql
#copy .sql file to be executed inside container
docker cp testing_files/create_conn.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/create_conn.sql" -x"


#copy .sql file to be executed inside container
docker cp my_sql_to_exasol_v2.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/ &&
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/my_sql_to_exasol_v2.sql" -x" &&
#execute the output.sql file created inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "output.sql" -x"