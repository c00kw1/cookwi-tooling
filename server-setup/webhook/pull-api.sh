#!/bin/bash

cd /root/cookwi-api-code
ssh-agent bash -c 'ssh-add /root/.ssh/deploy_webclient; git fetch'
# do we need to pull and build and deploy ?
# https://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")
if [ $LOCAL = $REMOTE ]; then # up-to-date
    echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then # we need to pull
    ssh-agent bash -c 'ssh-add /root/.ssh/deploy_api; git pull'
    dotnet publish /root/cookwi-api-code/Api.Hosting/Api.Hosting.csproj -c Release -o /var/www/cookwi-api-tmp
    service cookwi-api stop
    rm -rf /var/www/cookwi-api
    mv /var/www/cookwi-api-tmp /var/www/cookwi-api
    service cookwi-api start
fi

exit 0