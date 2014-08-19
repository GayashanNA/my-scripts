#!/bin/sh
#
# This script can be used to run mvn clean for each repository in the directory.
# Useful when you want to clean multiple repositories.
# How to use:
#       cd <parent directory where all the repos reside>
#       sh <path to the script>/mvn-clean-for-each-dir.sh
#

for D in *; do
    if [ -d "${D}" ]; then
        echo
        echo "##########################################################################"
        echo "${D}"
        cd ${D}
        mvn clean ${1}
        cd ../
    fi
done

echo
echo "##########################################################################"
echo "Done cleaning."
