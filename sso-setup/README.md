# SSO setup

We use [Keycloak](https://www.keycloak.org/) as SSO for cookwi applications.

## Install

We use it in docker containers. This way, it's very handy and easy to setup an SSO on the dev machine and to replicate the same SSO configuration on homologation and production environments.

* see `scripts.sh` to fresh install an SSO
* see `cookwi-sso` nginx config file for Homologation/Production hosting