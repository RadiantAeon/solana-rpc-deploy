#!/bin/bash

# wait to load the binary
# sleep 120

# main pid of solana-validator
while [ -z "$solana_pid" ]; do
    solana_pid=$(pgrep -f "agave-validator --identity")
    if [ -z "$solana_pid" ]; then
        echo "set_affinity: solana_validator_404"
        sleep 20
    fi
done

# find thread id
while [ -z "$thread_pid" ]; do
    thread_pid=$(ps -T -p $solana_pid -o spid,comm | grep 'solPohTickProd' | awk '{print $1}')
    if [ -z "$thread_pid" ]; then
        echo "set_affinity: solPohTickProd_404"
        sleep 120
    fi
done

current_affinity=$(taskset -cp $thread_pid 2>&1 | awk '{print $NF}')
if [ "$current_affinity" == "2" ]; then
    echo "set_affinity: solPohTickProd_already_set"
    exit 1
else
    # set poh to cpu2
    sudo taskset -cp 2 $thread_pid
    echo "set_affinity: set_done"
     # $thread_pid
fi