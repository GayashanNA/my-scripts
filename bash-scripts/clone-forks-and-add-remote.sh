#!/bin/bash
#
# This script can be used to clone a list of forked repos in my GitHub account
# and to add a remote for the upstream to that repo.
# Useful when you want to clone multiple repos and add remotes to those.
#
# How to use:
#   ./<path to the script>/clone-forks-and-add-remote.sh <file with list of forked repos>
#
# Note: * THIS IS A WSO2 SPECIFIC SCRIPT!
#       * The list of repos in the file should be each in a new line and the end of file
#         should also contain a new line. Otherwise the last line will be omitted.
#

FILE=$1
USER_GIT_URL_PREFIX="https://github.com/GayashanNA/"
UPSTREAM_GIT_URL_PREFIX="git@github.com:wso2-dev/"
GIT_SUFFIX=".git"

#repos=( "carbon-utils" "carbon-deployment" )
#for repo in "${repos[@]}"; do

while read -r line; do
    repo=$line
    my_git_repo=${USER_GIT_URL_PREFIX}${repo}${GIT_SUFFIX}
    upstream_git_repo=${UPSTREAM_GIT_URL_PREFIX}${repo}${GIT_SUFFIX}
    upstream="wso2dev-${repo}"

    echo
    echo "Clonning : ${my_git_repo}"
    git clone ${my_git_repo}

    echo "Adding remote ${upstream} to: ${upstream_git_repo}"
    cd ${repo}
    git remote add ${upstream} ${upstream_git_repo}
    git remote -v
    cd ../
    echo "############################ Done ########################################"
done < $FILE

echo
echo "##########################################################################"
echo "Done clonning the forks."

