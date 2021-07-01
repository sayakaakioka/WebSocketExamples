#!/bin/bash -x

PID=$1
while ps -p ${PID} > /dev/null; do
    sleep 1
done
/usr/local/bin/python3 slackbot.py ${PID}