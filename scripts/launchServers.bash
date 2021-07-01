#!/bin/bash -x

PROGRAM="node server.js"
LOG_PREFIX="websockserv_"
LOG_SUFFIX=".log"
ERR_SUFFIX=".err"

for i in {10001..10010}; do
    nohup ${PROGRAM} ${i} >> ${LOG_PREFIX}${i}${LOG_SUFFIX} 2>>${LOG_PREFIX}${i}${ERR_SUFFIX} &
    nohup /bin/bash watch.bash $! >> watch.log 2>&1 &
done