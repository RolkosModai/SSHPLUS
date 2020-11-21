#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%33s%s%-12s\n' "Galiojimo pabaigos datos keitimas" ; tput sgr0
echo ""
echo -e "\033[1;33m VARTOTOJAI IR GALIOJIMO DATU SARASAS:\033[0m "
echo ""
tput setaf 7 ; tput bold 
database="/root/usuarios.db"
list_user=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody)
i=0
i=0
unset _userPass
while read user; do
	i=$(expr $i + 1)
	_oP=$i
	[[ $i == [1-9] ]] && i=0$i && oP+=" 0$i"
	expire="$(chage -l $user | grep -E "Account expires" | cut -d ' ' -f3-)"
	if [[ $expire == "never" ]]
	then
		echo -e "\033[1;31m[\033[1;36m$i\033[1;31m] \033[1;37m- \033[1;32m$user         \033[1;33m00/00/0000   S/DATA\033[0m"
	else
		databr="$(date -d "$expire" +"%Y%m%d")"
		hoje="$(date -d today +"%Y%m%d")"
		if [ $hoje -ge $databr ]
		then
			_user=$(echo -e "\033[1;31m[\033[1;36m$i\033[1;31m] \033[1;37m- \033[1;32m$user\033[1;37m")
			datanormal="$(echo -e "\033[1;31m$(date -d"$expire" '+%d/%m/%Y')")"
			expired=$(echo -e "\033[1;31mPASIBAIGE\033[0m")
			printf '%-62s%-20s%s\n' "$_user" "$datanormal" "$expired"
			echo "exp" > /tmp/exp
		else
			_user=$(echo -e "\033[1;31m[\033[1;36m$i\033[1;31m] \033[1;37m- \033[1;32m$user\033[1;37m")
			datanormal="$(echo -e "\033[1;33m$(date -d"$expire" '+%d/%m/%Y')")"
			ative=$(echo -e "\033[1;32mGALIOJA\033[0m")
			printf '%-62s%-20s%s\n' "$_user" "$datanormal" "$ative"
		fi
	fi
	_userPass+="\n${_oP}:${user}"
done <<< "${list_user}"
tput sgr0
echo ""
if [ -a /tmp/exp ]
then
	rm /tmp/exp
fi
num_user=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody | wc -l)
echo -ne "\033[1;32mIveskite arba pasirinkite vartotoja \033[1;33m[\033[1;36m1\033[1;33m-\033[1;36m$num_user\033[1;33m]\033[1;37m: " ; read option
if [[ -z $option ]]
then
	echo ""
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "Klaida, tuscias arba neteisingas vartotojo vardas! " ; tput sgr0
	exit 1
fi
usuario=$(echo -e "${_userPass}" | grep -E "\b$option\b" | cut -d: -f2)
if [[ -z $usuario ]]
then
	echo ""
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "Klaida, tuscias arba neteisingas vartotojo vardas!!! " ; tput sgr0
	echo ""
	exit 1
else
	if [[ `grep -c /$usuario: /etc/passwd` -ne 0 ]]
	then
	    echo ""
	    echo -e "\033[1;31mPVZ:\033[1;33m(\033[1;32mDATA: \033[1;37mDIENA/MENUO/METAI \033[1;33mARBA \033[1;32mDIENOS: \033[1;37m30\033[1;33m)"
	    echo ""
	    echo -ne "\033[1;32mNauja vartotojo data arba dienos \033[1;33m$usuario: \033[1;37m"; read inputdate
	    if [[ "$(echo -e "$inputdate" | grep -c "/")" = "0" ]]; then 
	    	udata=$(date "+%d/%m/%Y" -d "+$inputdate days")
	    	sysdate="$(echo "$udata" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
	    else
	    	udata=$(echo -e "$inputdate")
	    	sysdate="$(echo "$inputdate" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
	    fi
		if (date "+%Y-%m-%d" -d "$sysdate" > /dev/null  2>&1)
		then
			if [[ -z $inputdate ]]
			then
				echo ""
				tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Ivedete negaliojancia arba neegzistuojancia data!" ; echo "Iveskite galiojancia data diena/menuo/metai formatu " ; echo "PVZ: 21/04/2018" ; tput sgr0 ; tput sgr0
				echo ""
				exit 1	
			else
				if (echo $inputdate | egrep [^a-zA-Z] &> /dev/null)
				then
					today="$(date -d today +"%Y%m%d")"
					timemachine="$(date -d "$sysdate" +"%Y%m%d")"
					if [ $today -ge $timemachine ]
					then
						echo ""
						tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Ivedete ankstesne date arba dabartine diena!" ; echo "Iveskite galiojancia data diena/menuo/metai formatu" ; echo "PVZ: 21/04/2018" ; tput sgr0
						echo ""
						exit 1
					else
						chage -E $sysdate $usuario
						echo ""
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "Vartotojas $usuario nauja data: $udata " ; tput sgr0
						echo ""
						exit 1
					fi
				else
					echo ""
					tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Ivedete negaliojancia arba neegzistuojancia data!" ; echo "Iveskite galiojancia data diena/menuo/metai formatu" ; echo "PVZ: 21/04/2018" ; tput sgr0
					echo ""
					exit 1
				fi
			fi
		else
			echo ""
			tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Ivedete negaliojancia arba neegzistuojancia data!" ; echo "Iveskite galiojancia data diena/menuo/metai formatu" ; echo "PVZ: 21/04/2018" ; tput sgr0
			echo ""
			exit 1
		fi
	else
		echo " "
		tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Vartotojas $usuario nerastas!" ; tput sgr0
		echo " "
		exit 1
	fi
fi