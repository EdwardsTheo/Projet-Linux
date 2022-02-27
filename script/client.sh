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
	request "$req"
	var=$(cat ../out/heard.out)
	if [[ $var == "-1" ]]; then 
		echo -e "\nLe serveur n'a pas renvoyé d'IP car le nom n'existe pas dans la base de donnée"
	else 
	 	echo -e "\nLe serveur a renvoyé l'adresse IP et masque suivant :"
	 	IFS=';' 
	 	read -a strarr <<<"$var" 
	 	echo -e "1  IP address :     ${strarr[0]} "  
	 	echo -e "2  Subnet mask :     ${strarr[1]} " 
	fi
}

function request_fin {
	req=$1 
	if [[ $req == "FIN" ]]; then 
		request "$req"
		echo -e "\nLe serveur a bien été coupé"
		exit
	fi
}

function request_syn {
	request "DNS_SYN"
	answer=$(cat ../out/heard.out)
	
	if [[ $answer == 1 ]]; then 
		echo -e "\nLe serveur a bien reçu la réponse"
	else
		echo -e "\nLe serveur n'est pas joignable ou n'est pas bien configuré, veuillez réessayer"
		exit
	fi
}

function check_var {
	if [[ -z $1 ]]; then 
		echo -e "\nVeuillez donnez un nom"
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

service="start"
main "$1"
