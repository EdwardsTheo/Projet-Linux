#!/bin/bash 

nc -lk 12345 < /tmp/backpipe | ./serveur.sh 1> /tmp/backpipe
