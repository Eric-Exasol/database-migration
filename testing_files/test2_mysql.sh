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
docker network create test-network 

#setting up a mysql db image in docker
docker pull mysql:5.7.22
docker run --name mysqldb --network test-network -p 3360:3360 -e MYSQL_ROOT_PASSWORD=mysql -d mysql:5.7.22

#add bind address to mysqld.cnf conf file
docker cp mysqldb:/etc/mysql/mysql.conf.d/mysqld.cnf .
echo 'bind-address= 127.0.0.1' >> mysqld.cnf
docker cp mysqld.cnf mysqldb:/etc/mysql/mysql.conf.d/mysqld.cnf


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

#copy .sql file to be executed inside container
docker cp my_sql_to_exasol_v2.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/ &&
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/my_sql_to_exasol_v2.sql" -x" &&
#execute the output.sql file created inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "127.0.0.1:8888" -u sys -p exasol -f "output.sql" -x"