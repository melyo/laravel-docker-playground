#!/bin/bash -e

function usage {
    echo -e "Laravel Docker CLI - Tool to work with laravel docker container.\n"
    echo -e "usage: ./container.sh [project name] [command]"
    echo -e "   or: ./container.sh create [project name]"
    echo -e "   or: ./container.sh ssh\n"
    echo "Commands:"
    echo "    create       Create new Laravel instance."
    echo "    ssh          SSH into the docker container."
    echo "    composer     Run composer command in the docker container."
    echo "    php          Run php cli in the docker container."
    echo "    help         Display usage"
}

if [ $# -gt 0 ]; then
    if [ -d "$1" ] && [ "$1" != "docker" ]; then
        if [ "$2" == "php" ] || [ "$2" == "composer" ]; then
            DOCKER="docker-compose run --rm -w /var/www/$1 app"
            $DOCKER "${@:2}"
        else
            usage; exit
        fi
    else
        if [ "$1" == "ssh" ]; then
            docker exec -ti "${PWD##*/}"_app_1 bash
        elif [ "$1" == "create" ]; then
            docker-compose run --rm -w /var/www/ app composer create-project --prefer-dist laravel/laravel "$2"
        elif [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
            usage; exit
        else
            usage; exit
        fi
    fi
else
  usage; exit
fi
