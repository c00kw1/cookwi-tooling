#!/bin/bash

#!/bin/bash
script="setup-api"
#Declare the number of mandatory args
margs=2

# Common functions - BEGIN
function example {
    echo -e "example: $script -u user1 -p my_password"
}

function usage {
    echo -e "usage: $script MANDATORY [OPTION]\n"
}

function help {
  usage
    echo -e "MANDATORY:"
    echo -e "  -u, --user   Your jenkins user"
    echo -e "  -p, --password   Your jenkins password"
    echo -e "  -h,  --help   Prints this help\n"
  example
}

# Ensures that the number of passed args are at least equals
# to the declared number of mandatory args.
# It also handles the special case of the -h or --help arg.
function margs_precheck {
	if [ $2 ] && [ $1 -lt $margs ]; then
		if [ $2 == "--help" ] || [ $2 == "-h" ]; then
			help
			exit
		else
	    	usage
			example
	    	exit 1 # error
		fi
	fi
}

# Ensures that all the mandatory args are not empty
function margs_check {
	if [ $# -lt $margs ]; then
	    usage
	  	example
	    exit 1 # error
	fi
}
# Common functions - END

# Custom functions - BEGIN
# Put here your custom functions
# Custom functions - END

# Main
margs_precheck $# $1

user=
password=

# Args while-loop
while [ "$1" != "" ];
do
  case $1 in
  -u  | --user )        shift
                        user=$1
                        ;;
  -p  | --password )    shift
                        password=$1
                        ;;
  -h   | --help )       help
                        exit
                        ;;
   *)                     
        echo "$script: illegal option $1"
        usage
        example
        exit 1 # error
        ;;
    esac
    shift
done

# Pass here your mandatory args for check
margs_check $user $password

# see for installed stuff
toinstall=
if [ ! -x /usr/bin/wget ] ; then
  toinstall="$toinstall wget"
fi
if [ ! -x /usr/bin/unzip ] ; then
  toinstall="$toinstall unzip"
fi
sudo apt install -y $toinstall

# Clean
rm -rf ./bin

# Get last jenkins builds for the api
mkdir -p ./bin
wget --auth-no-challenge --user=$user --password=$password -P ./bin/ https://jenkins.cookwi.com/job/Api-Homologation-BUILD/lastSuccessfulBuild/artifact/api-package.zip
wget --auth-no-challenge --user=$user --password=$password -P ./bin/ https://jenkins.cookwi.com/job/Api-Homologation-BUILD/lastSuccessfulBuild/artifact/docker-config.zip

unzip ./bin/api-package.zip -d ./bin/api-package
unzip ./bin/docker-config.zip -d ./bin/

rm -rf ./bin/*.zip

# Setup API configuration
sed -i 's/Homologation/Development/g' ./bin/Dockerfile

# Build container
docker build ./bin -t cookwi/api-dev:latest
# Clean running one if there is
docker container stop api-dev || true
docker rm api-dev || true
# Launch
docker run --name api-dev --restart=unless-stopped -d -p 127.0.0.1:5000:5000 --network="cookwi-dev" cookwi/api-dev:latest
docker image prune -f