#! /usr/bin/env bash
# shellcheck disable=SC2016

# Stop on errors
set -o errexit

BASEDIR=$(dirname "$0")

# Standard argument parsing, example: install-package --branch=master --package=ros_robot
for i in "$@"
do
    case $i in
        -b=* | --branch=* )
        # BRANCH should allways be targetbranch
            BRANCH="${i#*=}" ;;

        -i=* | --image=* )
            IMAGE_NAME="${i#*=}" ;;

        --ssh )
            USE_SSH=true ;;

        --ssh-key=* )
            SSH_KEY="${i#*=}" ;;

        --bl=* | --blacklist=* )
            BLACKLIST="${BLACKLIST:+$BLACKLIST }${i#*=}" ;;

        * )
            # unknown option
            if [[ -n "$i" ]]
            then
                echo -e "\e[35m\e[1mUnknown input argument '$i'. Check CI yaml file\e[0m"
                exit 1
            fi ;;
    esac
    shift
done

echo -e "\e[35m\e[1mBRANCH       = ${BRANCH}\e[0m"
echo -e "\e[35m\e[1mBLACKLIST    = ${BLACKLIST}\e[0m"

# Set default value for IMAGE_NAME
[ -z "$IMAGE_NAME" ] && IMAGE_NAME='tuerobotics/tue-env'
echo -e "\e[35m\e[1mIMAGE_NAME   = ${IMAGE_NAME}\e[0m"

# Determine docker tag if the same branch exists there
BRANCH_TAG=$(echo "${BRANCH}" | tr '[:upper:]' '[:lower:]' | sed -e 's:/:_:g')

# Set the default fallback branch to latest
MASTER_TAG="latest"

# Remove any previously started containers if they exist (if not exist, still return true to let the script continue)
docker stop tue-env  &> /dev/null || true
docker rm tue-env &> /dev/null || true

# Pull the identical branch name from dockerhub if exist, use master as fallback
echo -e "\e[35m\e[1mTrying to fetch docker image: ${IMAGE_NAME}:${BRANCH_TAG}\e[0m"
if ! docker pull "${IMAGE_NAME}:${BRANCH_TAG}"
then
    echo -e "\e[35m\e[1mNo worries, we just test against the master branch: ${IMAGE_NAME}:${MASTER_TAG}\e[0m"
    docker pull "${IMAGE_NAME}":"${MASTER_TAG}"
    BRANCH_TAG=${MASTER_TAG}
fi

if [ -f ~/.ssh/known_hosts ]
then
    MERGE_KNOWN_HOSTS="true"
    DOCKER_MOUNT_KNOWN_HOSTS_ARGS="--mount type=bind,source=${HOME}/.ssh/known_hosts,target=/tmp/known_hosts_extra"
fi

# Run the docker image along with setting new environment variables
# shellcheck disable=SC2086
docker run --detach --interactive --tty -e CI="true" -e BRANCH="${BRANCH}" --name tue-env ${DOCKER_MOUNT_KNOWN_HOSTS_ARGS} "${IMAGE_NAME}:${BRANCH_TAG}"

if [ "$MERGE_KNOWN_HOSTS" == "true" ]
then
    docker exec -t tue-env bash -c "sudo chown 1000:1000 /tmp/known_hosts_extra && ~/.tue/ci/ssh-merge-known_hosts.py ~/.ssh/known_hosts /tmp/known_hosts_extra --output ~/.ssh/known_hosts"
fi

if [ "$USE_SSH" == "true" ]
then
    docker exec -t tue-env bash -c "echo '${SSH_KEY}' > ~/.ssh/id_rsa && chmod 700 ~/.ssh/id_rsa"
    docker exec -t tue-env bash -c "eval $(ssh-agent -s)"
fi

echo -e "\e[35m\e[1mtue-get install tue-documentation-github --no-ros-deps --doc-depend\e[0m"
docker exec tue-env bash -c 'source ~/.bashrc; tue-get install tue-documentation-github --no-ros-deps --doc-depend'

DOCKER_HOME=$(docker exec -t tue-env bash -c 'source ~/.bashrc; echo "$HOME"' | tr -d '\r')

echo -e "\e[35m\e[1mdocker cp ${BASEDIR}/get_install_build_packages.py tue-env:${DOCKER_HOME}\e[0m"
docker cp "${BASEDIR}"/get_install_build_packages.py tue-env:"${DOCKER_HOME}"

echo -e "\e[35m\e[1m~/get_message_packages.py base_local_planner costmap_2d\e[0m"
eval "$(docker exec -t tue-env bash -c 'source ~/.bashrc; ${HOME}/get_install_build_packages.py base_local_planner costmap_2d' | tr -d '\r')" # Skip base_local_planner and costmap_2d as these take too much time
INSTALL_BUILD_TARGETS=(${INSTALL_BUILD_PKGS[@]/#/ros-})
echo -e "\e[35m\e[1mINSTALL_BUILD_PKGS=" "${INSTALL_BUILD_PKGS[*]}" "\e[0m"
echo -e "\e[35m\e[1mBUILD_PKGS=" "${BUILD_PKGS[*]}" "\e[0m"

echo -e "\e[35m\e[1mtue-get install ros-python_orocos_kdl" "${INSTALL_BUILD_TARGETS[*]}" "\e[0m"
# shellcheck disable=SC2145
docker exec tue-env bash -c "source ~/.bashrc; tue-get install ros-python_orocos_kdl ${INSTALL_BUILD_TARGETS[*]}" # Needs to be installed fully as it needs to be build to generate docs

echo -e '\e[35m\e[1mcatkin config --workspace $TUE_SYSTEM_DIR --blacklist' "${BLACKLIST}"'\e[0m'
docker exec -t tue-env bash -c 'source ~/.bashrc; catkin config --workspace $TUE_SYSTEM_DIR --blacklist' "${BLACKLIST}" # It is an exec-depend of ed_object_models, but we don't need to build it

echo -e "\e[35m\e[1mtue-make --no-status python_orocos_kdl" "${INSTALL_BUILD_PKGS[*]}" "${BUILD_PKGS[*]}" "\e[0m"
# shellcheck disable=SC2145
docker exec -t tue-env bash -c "source ~/.bashrc; tue-make --no-status python_orocos_kdl ${INSTALL_BUILD_PKGS[*]} ${BUILD_PKGS[*]}" # Needs to be build to generate docs

echo -e '\e[35m\e[1mcatkin config --workspace $TUE_SYSTEM_DIR --no-blacklist\e[0m'
docker exec -t tue-env bash -c 'source ~/.bashrc; catkin config --workspace $TUE_SYSTEM_DIR --no-blacklist' # Clear blacklist
