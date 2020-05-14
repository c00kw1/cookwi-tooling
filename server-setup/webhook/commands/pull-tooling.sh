#!/bin/bash

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
    # replace the scripts for hooks
    cp -r ./server-setup/webhook /var/www/webhook-tmp
    chmod +x /var/www/webhook-tmp/commands/*.sh
    rm -rf /var/www/webhook
    mv /var/www/webhook-tmp /var/www/webhook
    service webhook restart
fi

exit 0