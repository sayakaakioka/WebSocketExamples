#!/bin/bash -x

PROGRAM="node server.js"
LOG_PREFIX="./logs/websockserv_"
LOG_SUFFIX=".log"
ERR_SUFFIX=".err"

for i in {10001..10033}; do
    nohup ${PROGRAM} ${i} >> ${LOG_PREFIX}${i}${LOG_SUFFIX} 2>>${LOG_PREFIX}${i}${ERR_SUFFIX} &
    nohup /bin/bash watch.bash $! >> ./logs/watch.log 2>&1 &
done
