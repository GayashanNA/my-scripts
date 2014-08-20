#!/bin/bash
#
# This script can be used to clone a list of forked repos in my GitHub account
# and to add a remote for the upstream to that repo.
# Useful when you want to clone multiple repos and add remotes to those.
#
# How to use:
#   ./<path to the script>/clone-forks-and-add-remote.sh <file with list of forked repos> <GitHub user name> <GitHub organization name>
#
# Note: The list of repos in the file should be each in a new line and the end of file
#       should also contain a new line. Otherwise the last line will be omitted.
#

#TODO: can extract the list of forks from the GitHub API.

FILE=$1
#Read GitHub user name from the input, if not given use my user name as default
USER_NAME=${2:-"GayashanNA"}
#Read GitHub organization name from the input, if not given use wso2-dev as default
ORG_NAME=${3:-"wso2-dev"}
USER_GIT_URL_PREFIX="https://github.com/${USER_NAME}/"
UPSTREAM_GIT_URL_PREFIX="git@github.com:${ORG_NAME}/"
GIT_SUFFIX=".git"

#repos=( "carbon-utils" "carbon-deployment" )
#for repo in "${repos[@]}"; do

while read -r line; do
    repo=$line
    my_git_repo=${USER_GIT_URL_PREFIX}${repo}${GIT_SUFFIX}
    upstream_git_repo=${UPSTREAM_GIT_URL_PREFIX}${repo}${GIT_SUFFIX}
    upstream="${ORG_NAME}-${repo}"

    echo
    echo "Clonning : ${my_git_repo}"
    #git clone ${my_git_repo}

    echo "Adding remote ${upstream} to: ${upstream_git_repo}"
    cd ${repo}
    #git remote add ${upstream} ${upstream_git_repo}
    #git remote -v
    cd ../
    echo "############################ Done ########################################"
done < $FILE

echo
echo "##########################################################################"
echo "Done clonning the forks."

