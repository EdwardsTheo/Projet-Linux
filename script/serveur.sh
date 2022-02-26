#!/bin/bash

function check_csv {
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
	while IFS="," read -r rec_column1 rec_column2 rec_column3 
		do 			
			if [[ $rec_column1 == $entree ]]; then
				echo "$rec_column2;$rec_column3"
			fi
		done < <(tail -n +2 ../csv/MonDns.csv)
}

function stop_serv {
	exit
}

function main {
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

main

