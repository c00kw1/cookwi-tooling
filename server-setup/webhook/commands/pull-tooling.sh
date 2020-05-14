#!/bin/bash

# !!!! IMPORTANT !!!!
# The version of this file used by webhooks is in fact located in /var/scripts on the server.
# It means this file (and only this one) has to be updated MANUALLY.
# Updating it itself would kill all the CI ...
#

cd /root/cookwi-tooling
git fetch
# do we need to pull and build and deploy ?
# https://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")
if [ $LOCAL = $REMOTE ]; then # up-to-date
    echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then # we need to pull
    git pull

    # deploy API SQL credentials
    cp -r ./server-setup/credentials /var/www/cookwi-api/
    service cookwi-api restart

    # deploy Webhooks
    cp -r ./server-setup/webhook /var/www/webhook-tmp
    chmod +x /var/www/webhook-tmp/commands/*.sh
    rm -rf /var/www/webhook
    mv /var/www/webhook-tmp /var/www/webhook
    service webhook restart
fi

exit 0