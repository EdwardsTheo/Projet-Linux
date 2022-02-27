#!/bin/bash 

function main {
	check_var "$1" # Vérifie qu'un nom a été donnée en paramètres 
	while true; do
		request_syn # Vérifie que le serveur répond 
		wait
		request_fin "$1" # Vérifie si le client veut envoyer un requête fin
		wait
		request_ip "$1" # Demande l'ip + netmask via un nom
		wait
		request_fin "FIN" # Fini la requête en demandant au serveur de s'eteindre 
		exit
	done
}

function request_ip {
	req=$1
	echo -e "\n${Blue}Envoie de la requête DNS_ASK${Blue}"
	request "$req"
	var=$(cat ../out/heard.out)
	if [[ $var == "-1" ]]; then 
		echo -e "\n${Red}Le serveur n'a pas renvoyé d'IP car le nom n'existe pas dans la base de donnée${Red}"
	else 
	 	echo -e "\n${Green}Le serveur a renvoyé l'adresse IP et masque suivant :${Green}"
	 	IFS=';' 
	 	read -a strarr <<<"$var" 
	 	echo -e "1  IP address :     ${strarr[0]} "  
	 	echo -e "2  Subnet mask :     ${strarr[1]} " 
	fi
}

function request_fin {
	req=$1 
	if [[ $req == "FIN" ]]; then 
		echo -e "\n${Blue}Envoie de la requête FIN${Blue}"
		request "$req"
		echo -e "${Green}Le serveur a bien été coupé${Green}"
		exit
	fi
}

function request_syn {
	echo -e "\n${Blue}Envoie de la requête DNS_SYN${Blue}"
	request "DNS_SYN"
	answer=$(cat ../out/heard.out)
	
	if [[ $answer == 1 ]]; then 
		echo -e "${Green}Le serveur a bien reçu la réponse${Green}"
	else
		echo -e "${Red}Le serveur n'est pas joignable ou n'est pas bien configuré, veuillez réessayer${Red}"
		exit
	fi
}

function check_var {
	if [[ -z $1 ]]; then 
		echo -e "\n${Red}Veuillez donner un nom${Red}"
		exit 
	fi
}

function request() {
	echo $1 | nc localhost 12345 > ../out/heard.out
	echo $1 | nc localhost 12345 > ../out/heard.out
}

function wait {
	sleep 2
}

Blue='\033[0;34m'
Red='\033[0;31m'
Green='\033[0;32m'
service="start"
main "$1"
