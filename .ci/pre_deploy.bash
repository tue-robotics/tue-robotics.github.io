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

TUE_ENV_WS_DIR=$(docker exec tue-env bash -c 'source ~/.bashrc; echo "${TUE_ENV_WS_DIR}"' | tr -d '\r')

# Create deployment directory
echo -e "\e[35m\e[1mCreating _site deployment directory\e[0m"
rm -rf _site
mkdir -p _site

# Copy Jekyll site files to _site
echo -e "\e[35m\e[1mCopying Jekyll site files to _site/\e[0m"
shopt -s nullglob  # Ensure glob patterns expand to nothing if no matches
for item in _config.yml _includes _layouts _posts _sass assets css feed.xml *.html; do
    if [ -e "$item" ]; then
        cp -r "$item" _site/
    fi
done
shopt -u nullglob  # Restore default behavior

# Copy generated documentation from Docker container to _site/docs
echo -e "\e[35m\e[1mdocker cp tue-env:${TUE_ENV_WS_DIR}/docs _site/\e[0m"
docker cp tue-env:"${TUE_ENV_WS_DIR}"/docs _site/
