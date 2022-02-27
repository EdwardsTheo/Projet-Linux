#!/bin/bash 

# Lance le serveur netcat et permet de lire la sortie et écrire dans un backpipe 

nc -lk 12345 < /tmp/backpipe | ./serveur.sh 1> /tmp/backpipe
