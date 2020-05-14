#!/bin/bash

cd /root/cookwi-webclient-code
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
    ssh-agent bash -c 'ssh-add /root/.ssh/deploy_webclient; git pull'
    npm install
    ng build --output-path=/var/www/cookwi-webclient-tmp --configuration=homologation
    rm -rf /var/www/cookwi-webclient
    mv /var/www/cookwi-webclient-tmp /var/www/cookwi-webclient
fi

exit 0