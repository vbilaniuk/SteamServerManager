#! /bin/bash

# Script that checks if the spot instance is marked for termination. If it is, it will broadcast a bunch of warning messages
# to anyone logged into ARK, save state, and exit. To get it running, call it from rc.local (fork it, and run as ubuntu or
# another local user, not root). Note: requires createSnapshot.py and mcrcon.

# Works by polling the metadata every 5 seconds and checking for termination time. If termination-time exists, that
# means the instance has been marked for death and has 2 minutes left to live.

port=$1
passwd=$2

while true ; do
  if curl --output /dev/null --silent --head --fail "http://169.254.169.254/latest/meta-data/spot/termination-time"; then
    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 60 seconds!"
    sleep 30s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 30 seconds!"
    sleep 10s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 20 seconds!"
    sleep 10s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 10 seconds!"
    sleep 5s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 5 seconds!"
    sleep 1s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 4 seconds!"
    sleep 1s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 3 seconds!"
    sleep 1s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 2 seconds!"
    sleep 1s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down in 1 second!"
    sleep 1s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s "broadcast Spot instance termination detected. Saving and shutting down NOW!"

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s saveworld
    sleep 5s

    /bin/mcrcon -p $passwd -H 127.0.0.1 -P $port -s doexit

    # call snapshot code here:
    /usr/bin/python /home/ubuntu/scripts/createSnapshot.py "ARK Backup" 
    break
  fi
  sleep 5s
done
