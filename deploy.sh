# !/usr/bin/env bash
sudo apt update && sudo apt install nodejs npm
# Install pm2 which is a production process manager for Node.js witha built-in load balancer
sudo npm install -g pm2
# stop any instance of our application running currently
pm2 stop SimpleApplication
# change directory into folder where application is downloaded
cd SimpleApplication/
# Install application dependencies
npm install
echo $privatekey > privatekey.pem
echo $server > server.crt
# pm2 save error
sudo pm2 save --force
# Start the applciation with the process name SimpleApplication using pm2
pm2 start ./bin/www --name SimpleApplication
