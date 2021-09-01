#!/bin/bash

MODULE=php8.0-apache

BASEPATH=$( dirname "${BASH_SOURCE[0]}" )
DAEMON=false
REUSE_IMAGE=false
for i in "$@"
do
case $i in
    --source-dir=*)
    SOURCE_DIR="${i#*=}"
    ;;
    --extensions=*)
    EXTENSIONS="${i#*=}"
    ;;
    --image-name=*)
    IMAGE_NAME="${i#*=}"
    ;;
    --container-name=*)
    CONTAINER_NAME="${i#*=}"
    ;;
    --container-port=*)
    CONTAINER_PORT="${i#*=}"
    ;;
    --container-ssl-port=*)
    CONTAINER_SSL_PORT="${i#*=}"
    ;;
    --container-ssl-key=*)
    CONTAINER_SSL_KEY="${i#*=}"
    ;;
    --container-ssl-crt=*)
    CONTAINER_SSL_CRT="${i#*=}"
    ;;
    --server-name=*)
    SERVER_NAME="${i#*=}"
    ;;
    --reuse-image|--reuse-image=true)
    REUSE_IMAGE=true
    ;;
    --daemon|--daemon=true)
    DAEMON=true
    ;;
    *)
            # unknown option
    ;;
esac
done

if [ -z "$SOURCE_DIR" ]; then SOURCE_DIR="$PWD"; fi
if [ -z "$EXTENSIONS" ]; then EXTENSIONS=""; fi
if [ -z "$IMAGE_NAME" ]; then IMAGE_NAME=$MODULE; fi
if [ -z "$CONTAINER_NAME" ]; then CONTAINER_NAME=$MODULE; fi
if [ -z "$CONTAINER_PORT" ]; then CONTAINER_PORT="8080"; fi
if [ -z "$CONTAINER_SSL_PORT" ]; then CONTAINER_SSL_PORT="8443"; fi
if [ -z "$CONTAINER_SSL_CRT" ]; then CONTAINER_SSL_CRT="/home/vagrant/ssl/certificates/mgmt.crt"; fi
if [ -z "$CONTAINER_SSL_KEY" ]; then CONTAINER_SSL_KEY="/home/vagrant/ssl/certificates/mgmt.key"; fi
if [ -z "$SERVER_NAME" ]; then SERVER_NAME="mgmt"; fi
if [ -z "$REUSE_IMAGE" ]; then REUSE_IMAGE="false"; fi


echo "---------------"
echo "Command: $0"
echo "Available installable extensions: xdebug,redis,memcached,gd"
echo "---------------"
echo "    --daemon=$DAEMON";
echo "    --reuse-image=$REUSE_IMAGE";
echo "    --source_dir=$SOURCE_DIR";
echo "    --image-name=$IMAGE_NAME";
echo "    --extensions=$EXTENSIONS";
echo "    --container-name=$CONTAINER_NAME";
echo "    --container-port=$CONTAINER_PORT";
echo "    --container-ssl-port=$CONTAINER_SSL_PORT";
echo "    --container-ssl-crt=$CONTAINER_SSL_CRT";
echo "    --container-ssl-key=$CONTAINER_SSL_KEY";
echo "    --server-name=$SERVER_NAME";
echo "---------------"
echo "    http://$SERVER_NAME:$CONTAINER_PORT/"
echo "    https://$SERVER_NAME:$CONTAINER_SSL_PORT/"
echo "---------------"
read -s -n 1 -p "Press Ctrl+C to stop, enter to continue..."
echo "---------------"

# PROVISION
# stop any containers
echo "Removing old containers if they exists (ignore errors)"
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# build image
cd $BASEPATH/$MODULE
if [[ "$REUSE_IMAGE" == "false" ]]; then
  docker image rm $IMAGE_NAME
  docker build -t $IMAGE_NAME . --build-arg extensions=$EXTENSIONS --build-arg cachebust=$(date +%s) --build-arg server_name=$SERVER_NAME
fi

# start container
cd -
if [[ "$DAEMON" == "true" ]]; then
  # run container as daemon
  docker run --user 1000 -it -d -p $CONTAINER_PORT:80 -p $CONTAINER_SSL_PORT:443 --name $CONTAINER_NAME -v "$SOURCE_DIR":/var/www/html -v $CONTAINER_SSL_CRT:/certificates/cert.crt -v $CONTAINER_SSL_KEY:/certificates/cert.key $IMAGE_NAME
  # connect to container
  docker exec -it $CONTAINER_NAME /bin/bash
else
  # run container as fg
  docker run --user 1000 -it -p $CONTAINER_PORT:80 -p $CONTAINER_SSL_PORT:443 --name $CONTAINER_NAME -v "$SOURCE_DIR":/var/www/html -v $CONTAINER_SSL_CRT:/certificates/cert.crt -v $CONTAINER_SSL_KEY:/certificates/cert.key $IMAGE_NAME
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi



exit 0