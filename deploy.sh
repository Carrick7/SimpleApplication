# !/usr/bin/env bash
# Check if there is instance running with the image name we are deploying
CURRENT_INSTANCE=$(docker ps -a -q --filter ancestor="$IMAGE_NAME" --format="{{.ID}}")

#if an instance does exist, stop the instance
if [ "$CURRENT_INSTANCE" ]
then
  docker rm $(docker stop $CURRENT_INSTANCE)
fi

# pull down the instance from dockerhub
docker pull $IMAGE_NAME

#check if a docker container exists with the name of node_app, remove if it does.
CONTAINER_EXISTS=$(docker ps -a | grep node_app)
if [ "$CONTAINER_EXISTS" ]
then  
  docker rm node_app
fi

#create container called node_app that is availible on port 8443 from our docker image
docker create -p 8443:8443 --name node_app $IMAGE_NAME
#write the private key to a file 
echo $privatekey > privatekey.pem
#write the server key to a file 
echo $server > server.crt
#Add the private key to the node_app docker container
docker cp ./privatekey.pem node_app:/privatekey.pem
#Add the server key to the node_app docker container
docker cp ./server.crt node_app:/server.crt
#start the node_app container
docker start node_app
