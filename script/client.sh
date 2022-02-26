#!/bin/bash 

function main {
	check_var "$1"
	while true; do
		###### ENVOIE REQUÊTE DNS_SYN
		request_syn
		request_fin "$1"
		request_ip "$1"
		request_fin "FIN"
		exit
	done
}

function request_ip {
	req=$1
	request "$req"
	var=$(cat ../out/heard.out)
	if [[ $var == "-1" ]]; then 
		echo "Le serveur n'a pas renvoyé d'IP car le nom n'existe pas dans la base de donnée"
	else 
	 	echo "Le serveur à renvoyé l'adresse IP et masque suivant :"
	 	IFS=';' #setting comma as delimiter  
	 	read -a strarr <<<"$var" #reading str as an array as tokens separated by IFS  
	 	echo -e "1  IP address :     ${strarr[0]} "  
	 	echo -e "2  Subnet mask :     ${strarr[1]} " 
	fi
}

function request_fin {
	req=$1 
	if [[ $req == "FIN" ]]; then 
		request "$req"
		echo "Le serveur à bien été coupé"
		exit
	fi
}

function request_syn {
	# Check si le serveur à bien répondu sinon on eteins le programme 
	request "DNS_SYN"
	answer=$(cat ../out/heard.out)
	
	if [[ $answer == 1 ]]; then 
		echo "Le serveur à bien reçu la réponse"
	else
		echo "Le serveur n'est pas joignable ou n'est pas bien configuré, veuillez réessayer"
		exit
	fi
}

function check_var { # Function to see if the client gave a parameter
	if [[ -z $1 ]]; then 
		echo "Veuillez donnez un nom"
		exit 
	fi
}

function request() {
	echo $1 | nc localhost 12345 > ../out/heard.out
	echo $1 | nc localhost 12345 > ../out/heard.out
}

service="start"
main "$1"
