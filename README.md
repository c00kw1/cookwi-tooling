# Cookwi tooling

Some tooling for CI, server setup etc...

Each folder has its own readme file !

## Cookwi local development setup

The setup documentation is made for Windows only. It may work on Mac and Linux as well with (maybe) some adaptations in configuration(s).

### Prerequisites

1. Install WSL (debian or ubuntu). Documentation can be [found here](https://docs.microsoft.com/fr-fr/windows/wsl/install-win10).
2. Install Windows Terminal (very convenient)
3. Cookwi relies on docker containers to run SSO, Mongo or S3, so you must [install docker](https://https://docs.docker.com/docker-for-windows/install/) on your computer and setup docker to use your WSL debian/ubuntu distro ([some reading](https://docs.docker.com/docker-for-windows/wsl/) if needed).

### Setup

Open Windows WSL terminal on your distro, then navigate to this repository folder, and in `cookwi-setup/` folder :

```bash
$ ./create-dev-env.sh # this creates the cookwi stack, ready to use (sso / db / mongo / s3)
$ ./setup-dev-api.sh -u <YOUR_JENKINS_USER> -p <YOUR_JENKINS_PASSWORD> # it downloads, prepare and launch the last version of the API on a dedicated container
```

At the end, you have a proper environment setup with an API running and all necessary software running for it to work properly.

## Tools used

- Emails redirection : [https://app.improvmx.com/](https://app.improvmx.com/)
