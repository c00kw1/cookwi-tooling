#!/bin/bash
# This script will install, deploy and start a basic homologation server
# for cookwi.
# TO BE EXECUTED IN /root/<directory> WITH UNCHANGED DIRECTORY STRUCTURE
# example : ./install-instance-scaleway hom-1.cookwi.com [1|0]

if [ $1 = 'help' ] || [ $1 = '--help' ]
then
    echo "To be executed from the directory the script is in (paths are relatives !)."
    echo "This will install basic stuff (update + upgrade also) and setup nginx basic as well."
    echo "./install-instance-scaleway.sh serverAddress [mail] [setupSso] [setupApi] [setupWebclient]"
    echo "Example : ./install-instance-scaleway.sh hom-1.cookwi.com [mail@address.com] [1|0] [1|0] [1|0]"
    exit 0
fi

# FIRST MANUAL STEP :
# * put that into .bashrc of root user : export ASPNETCORE_ENVIRONMENT='Homologation'

host=$1
mail=$2
setup_sso=$3
setup_api=$4
setup_webclient=$5

# install basic software and upgrade server
apt update
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update && apt upgrade -y
apt install -y docker-ce docker-ce-cli containerd.io docker-compose nginx certbot python-certbot-nginx

# gen a self-gen certif
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=$host" -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt

# configure nginx
sed -s -i "s/{replace_host}/$host/g" ./nginx/*
cp ./nginx/* /etc/nginx/site-available/
rm /etc/nginx/site-enables/default # we just remove the link, not the actual default for nginx which could at some point be useful again
ln -s /etc/nginx/sites-available/cookwi-default /etc/nginx/sites-enabled/cookwi-default

# generate and show key for adding to cookwi-bot account
ssh-keygen -t rsa -b 4096 -N '' -f /root/.ssh/id_rsa -q
cat /root/.ssh/id_rsa.pub
echo "Please add this key to cookwi-bot github account"
read -n 1 -p "Press any key to resume the script once it's done ..." # will prompt
# we trust github (avoid ssh key prompts)
ssh-keyscan -H github.com >> /root/.ssh/known_hosts

# setup Webhook
apt install -y webhook # will prompt
cp -r ./webhook /var/www/
cp ./services/webhook.service /etc/systemd/system/
# TODO : setup /var/www/webhook/hook.json here
systemctl enable webhook.service
systemctl start webhook.service
ln -s /etc/nginx/sites-available/cookwi-webhook /etc/nginx/sites-enabled/cookwi-webhook
certbot --nginx --non-interactive --agree-tos --domains webhook.$host -m $mail

# setup SSO
if [ $setup_sso -eq 1 ]
then
    # nginx specific for sso
    ln -s /etc/nginx/sites-available/cookwi-sso /etc/nginx/sites-enabled/cookwi-sso
    certbot --nginx --non-interactive --agree-tos --domains sso.$host -m $mail

    sysctl -w vm.max_map_count=262144
    mkdir /root/fusionauth
    cd /root/fusionauth
    # need to wget both .env and docker-compose.yml here
    docker-compose -f ./fusionauth-docker/docker-compose.yml up -d
fi

# setup .NET core API
if [ $setup_api -eq 1 ]
then
    wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
    wget https://packages.microsoft.com/config/debian/9/prod.list && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list
    apt update
    apt install -y apt-transport-https dotnet-sdk-3.1 # will prompt ...
    # Github stuff
    git clone --branch homologation git@github.com:gjdass/cookwi-api.git /root/cookwi-api-code
    dotnet publish /root/cookwi-api-code/Api.Hosting/Api.Hosting.csproj -c Release -o /var/www/cookwi-api
    ln -s /etc/nginx/sites-available/cookwi-api /etc/nginx/sites-enabled/cookwi-api
    certbot --nginx --non-interactive --agree-tos --domains api.$host -m $mail
    # let's make it a service
    cp ./services/cookwi-api.service /etc/systemd/system/
    systemctl enable cookwi-api.service
    systemctl start cookwi-api.service
fi

# setup Node JS and webclient
if [ $setup_webclient -eq 1 ]
then
    curl -sL https://deb.nodesource.com/setup_14.x | bash -
    apt install -y nodejs
    npm install -g @angular/cli # will prompt
    # Github stuff
    git clone --branch homologation git@github.com:gjdass/cookwi-webclient.git /root/cookwi-webclient-code
    cd /root/cookwi-webclient-code
    npm install
    ng build --output-path=/var/www/cookwi-webclient --configuration=homologation
    cd -
    ln -s /etc/nginx/sites-available/cookwi-webclient /etc/nginx/sites-enabled/cookwi-webclient
    certbot --nginx --non-interactive --agree-tos --domains $host -m $mail
fi

# end of script
service nginx restart
exit 0