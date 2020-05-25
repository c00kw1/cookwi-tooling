# DB setup

We use [PostgeSQL](https://hub.docker.com/_/postgres/) in docker containers for all our use, and cookwi website is no exception.

## Install

* see `before_restore.sql` for all the scripts to play into new DB before importing backup
* see `after_restore.sql` for all the scripts to play after DB backup is imported into the new DB