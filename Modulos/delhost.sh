#!/bin/bash
if [ -d "/etc/squid/" ]; then
    payload="/etc/squid/payload.txt"
elif [ -d "/etc/squid3/" ]; then
	payload="/etc/squid3/payload.txt"
fi
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-10s\n' "Pasalinti domena is Squid Proxy" ; tput sgr0
if [ ! -f "$payload" ]
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Failas $payload nerastas" ; tput sgr0
	exit 1
else
	tput setaf 2 ; tput bold ; echo ""; echo "Dabartiniai $payload failo domenai:" ; tput sgr0
	tput setaf 3 ; tput bold ; echo "" ; cat $payload ; echo "" ; tput sgr0
	read -p "Iveskite domena, kuri norite pasalinti is saraso: " host
	if [[ -z $host ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ivedete tuscia arba neegzistuojanti domena!" ; echo "" ; tput sgr0
			exit 1
		else
		if [[ `grep -c "^$host" $payload` -ne 1 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Domenas $host nerastas faile $payload" ; echo "" ; tput sgr0
			exit 1
		else
			grep -v "^$host" $payload > /tmp/a && mv /tmp/a $payload
			tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "Failas $payload atnaujintas, domenas sekmingai pasalintas:" ; tput sgr0
			tput setaf 3 ; tput bold ; echo "" ; cat $payload ; echo "" ; tput sgr0
			if [ ! -f "/etc/init.d/squid3" ]
			then
				service squid3 reload
			elif [ ! -f "/etc/init.d/squid" ]
			then
				service squid reload
			fi	
			tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "Proxy Squid proxy sekmingai pridetas!" ; echo "" ; tput sgr0
			exit 1
		fi
	fi
fi