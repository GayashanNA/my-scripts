#!/usr/bin/env bash
# https://askubuntu.com/a/1123488

set -o errexit
set -o pipefail
set -o nounset

# If the language is not English, free will output localized text and parsing fails
LANG=en_US.UTF-8

THRESHOLD=${1:-"1024"}
INTERVAL=${2:-"300"}
POPUP_DELAY=999
echo "How to use: alertoom <threshold> <interval>"
echo "You will receive an alert when available memory is less than ${THRESHOLD}."
# sleep some time so the shell starts properly
sleep 30

while :
do
    available=$(free -mw | awk '/^Mem:/{print $8}')
    echo "Available memory: ${available}"
    if [ $available -lt $THRESHOLD ]; then
        title="Low memory! $available MB available"
        message=$(top -bo %MEM -n 1 | grep -A 3 PID | awk '{print $(NF - 6) " \t" $(NF)}')
        # KDE Plasma notifier
        # kdialog --title "$title" --passivepopup "$message" $POPUP_DELAY
        # use the following command if you are not using KDE Plasma, comment the line above and uncomment the line below
        # please note that timeout for notify-send is represented in milliseconds
        notify-send -u critical "$title" "$message" -t $POPUP_DELAY
    fi
    sleep $INTERVAL
done
