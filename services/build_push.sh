#/bin/bash

set -e

default_version="25"

version=${1:-"$default_version"}

docker build -t ichiky/woody_api:"$version" api
docker tag ichiky/woody_api:"$version" ichiky/woody_api:latest

docker build -t ichiky/woody_apisec:"$version" api2
docker tag ichiky/woody_apisec:"$version" ichiky/woody_apisec:latest

docker build -t ichiky/woody_rp:"$version" reverse-proxy
docker tag ichiky/woody_rp:"$version" ichiky/woody_rp:latest


docker build -t ichiky/woody_master_database:"$version" database/master
docker tag ichiky/woody_master_database:"$version" ichiky/woody_master_database:latest

docker build -t ichiky/woody_slave_database:"$version" database/slave
docker tag ichiky/woody_slave_database:"$version" ichiky/woody_slave_database:latest

docker build -t ichiky/woody_front:"$version" front
docker tag ichiky/woody_front:"$version" ichiky/woody_front:latest

# avec le "set -e" du début, je suis assuré que rien ne sera pushé si un seul build ne s'est pas bien passé

docker push ichiky/woody_api:"$version"
docker push ichiky/woody_api:latest

docker push ichiky/woody_apisec:"$version"
docker push ichiky/woody_apisec:latest

docker push ichiky/woody_rp:"$version"
docker push ichiky/woody_rp:latest

docker push ichiky/woody_front:"$version"
docker push ichiky/woody_front:latest

docker push ichiky/woody_slave_database:"$version"
docker push ichiky/woody_slave_database:latest

docker push ichiky/woody_master_database:"$version"
docker push ichiky/woody_master_database:latest
