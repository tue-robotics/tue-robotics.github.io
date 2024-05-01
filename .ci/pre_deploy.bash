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

# TODO(anyone): remove variable logic when tue-env is updated to new variable names
TUE_ENV_WS_DIR=$(docker exec tue-env bash -c 'source ~/.bashrc; [[ -v TUE_ENV_WS_DIR || ! -v TUE_WS_DIR ]] || TUE_ENV_WS_DIR=${TUE_WS_DIR}; echo "${TUE_ENV_WS_DIR}"' | tr -d '\r')

echo -e "\e[35m\e[1mdocker cp tue-env:${TUE_ENV_WS_DIR}/docs .\e[0m"
docker cp tue-env:"${TUE_ENV_WS_DIR}"/docs .
