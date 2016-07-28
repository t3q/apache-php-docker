#!/bin/bash
USER=user
HOST=host
LKEYFNAME=id_rsa_t3q.ajsolutions.pl
RHOST=$USER@$HOST
RPATH=/home/$USER/rsync/
# My MacOS keys
OPT="-C -p2222 -i /Users/$USER/.ssh/$LKEYFNAME"
rsync -avP -e "ssh $OPT" *.docker $RHOST:$RPATH &
echo "Waiting for jobs stops..."
wait
