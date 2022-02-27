#!/bin/bash

function main {
	# Permet de lire les envois du client 
	while read entree;
	do
		if [[ $entree == "DNS_SYN" ]]; then
			echo "1"
		elif [[ $entree == "FIN" ]]; then 
			exit
		else 
			check_csv "$entree"
			if [[ $check == "1" ]]; then
				read_csv "$entree"
			else
				echo "-1"
			fi
		fi 
	done
}

function check_csv {
	# Regarde si le nom donné par le client existe dans le CSV 
	while IFS="," read -r rec_column1 rec_column2 rec_column3 
		do
  			if [[ $rec_column1 == $entree ]]; then
				check=1
				break
			else
				check=0
				break
			fi 
		done < <(tail -n +2 ../csv/MonDns.csv)
}

function read_csv {
	# Renvoie les informations stockés dans le CSV pour le client
	while IFS="," read -r rec_column1 rec_column2 rec_column3 
		do 			
			if [[ $rec_column1 == $entree ]]; then
				echo "$rec_column2;$rec_column3"
			fi
		done < <(tail -n +2 ../csv/MonDns.csv)
}

function stop_serv {
	# Stop le serveur NETCAT
	exit
}

main

