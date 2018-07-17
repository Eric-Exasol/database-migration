#!/bin/sh
MY_MESSAGE="Test message!"
echo $MY_MESSAGE

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
docker run --name mysqldb -p 3360:3360 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mysql -d mysql:5.7.22

#setting up an exasol db image in docker
docker pull exasol/docker-db:latest
docker run --name exasoldb -p 8899:8888 --detach --privileged --stop-timeout 120  exasol/docker-db:latest

docker logs -f exasoldb &

# Wait until database is ready
(docker logs -f --tail 0 exasoldb &) 2>&1 | grep -q -i 'stage4: All stages finished'
sleep 30

#copy .sql file to be executed inside container
docker cp testing_files/mysql_datatypes_test.sql mysqldb:/tmp/
#execute the file inside the mysqldb container
docker exec -ti mysqldb sh -c "mysql < tmp/mysql_datatypes_test.sql -pmysql"


#access the mysqldb container from the exasoldb container
# TODO get the connection string of the mysql container
# TODO get the connection string of the exasoldb container


#copy .sql file to be executed inside container
docker cp testing_files/playground.sql exasoldb:/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/
#execute the file inside the exasoldb container
docker exec -ti exasoldb sh -c "/usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/exaplus  -c "192.168.99.100:8899" -u sys -p exasol -f "usr/opt/EXASuite-6/EXASolution-6.0.10/bin/Console/test/playground.sql""

MY_MESSAGE="Done!"
echo $MY_MESSAGE