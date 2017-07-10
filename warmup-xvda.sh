#! /bin/bash

# this is a simple script that warms up the root volume of an EC2 instance
# call it from rc.local
# for better game server performance, run this first and let it block

if [ ! -f /var/log/warmup-xvda.out ]; then
  fio --filename=/dev/xvda --rw=read --bs=128k --iodepth=32 --ioengine=libaio --direct=1 --name=volume-initialize --max-jobs=2 > /var/log/warmup-xvda.out
fi
