#!/bin/bash -x

/usr/bin/pgrep -f "node server.js"| /usr/bin/xargs kill -9

