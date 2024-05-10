#/bin/bash

set -e

default_version="10"

version=${1:-"$default_version"}

docker build -t ichiky/woody_api:"$version" api
docker tag ichiky/woody_api:"$version" ichiky/woody_api:latest

docker build -t ichiky/woody_rp:"$version" reverse-proxy
docker tag ichiky/woody_rp:"$version" ichiky/woody_rp:latest

docker build -t ichiky/woody_database:"$version" database
docker tag ichiky/woody_database:"$version" ichiky/woody_database:latest

docker build -t ichiky/woody_front:"$version" front
docker tag ichiky/woody_front:"$version" ichiky/woody_front:latest

# avec le "set -e" du début, je suis assuré que rien ne sera pushé si un seul build ne s'est pas bien passé

docker push ichiky/woody_api:"$version"
docker push ichiky/woody_api:latest

docker push ichiky/woody_rp:"$version"
docker push ichiky/woody_rp:latest

docker push ichiky/woody_front:"$version"
docker push ichiky/woody_front:latest

docker push ichiky/woody_database:"$version"
docker push ichiky/woody_database:latest
