#! /usr/bin/env bash
# shellcheck disable=SC2016

# Stop on errors
set -o errexit

# Standard argument parsing, example: install-package --branch=master --package=ros_robot
for i in "$@"
do
    case ${i} in
        * )
            # unknown option
            if [[ -n "${i}" ]]
            then
                echo -e "\e[35m\e[1mUnknown input argument '${i}'. Check CI yaml file\e[0m"
                exit 1
            fi ;;
    esac
    shift
done

echo -e "\e[35m\e[1mtue-make-documentation --no-status\e[0m"
docker exec -t tue-env bash -c 'source ~/.bashrc; tue-make-documentation --no-status'
