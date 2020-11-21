#!/bin/bash
datenow=$(date +%s)
remove_ovp () {
if [[ -e /etc/debian_version ]]; then
	GROUPNAME=nogroup
fi
user="$1"
cd /etc/openvpn/easy-rsa/
./easyrsa --batch revoke $user
./easyrsa gen-crl
rm -rf pki/reqs/$user.req
rm -rf pki/private/$user.key
rm -rf pki/issued/$user.crt
rm -rf /etc/openvpn/crl.pem
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
chown nobody:$GROUPNAME /etc/openvpn/crl.pem
[[ -e $HOME/$user.ovpn ]] && rm $HOME/$user.ovpn > /dev/null 2>&1
[[ -e /var/www/html/openvpn/$user.zip ]] && rm /var/www/html/openvpn/$user.zip > /dev/null 2>&1
} > /dev/null 2>&1
echo -e "\E[44;1;37mVartotojas     Data             Statusas         Veiksmas   \E[0m"
echo ""
for user in $(awk -F: '{print $1}' /etc/passwd); do
	expdate=$(chage -l $user|awk -F: '/Account expires/{print $2}')
	echo $expdate|grep -q never && continue
	datanormal=$(date -d"$expdate" '+%d/%m/%Y')
	tput setaf 3 ; tput bold ; printf '%-15s%-17s%s' $user $datanormal ; tput sgr0
	expsec=$(date +%s --date="$expdate")
	diff=$(echo $datenow - $expsec|bc -l)
	tput setaf 2 ; tput bold
	echo $diff|grep -q ^\- && echo "GALIOJA   NEGALIMA PASALINTI" && continue
	tput setaf 1 ; tput bold
	echo "NEGALIOJA   BUVO PASALINTAS"
	pkill -f $user
	userdel --force $user
	grep -v ^$user[[:space:]] /root/usuarios.db > /tmp/ph ; cat /tmp/ph > /root/usuarios.db
	if [[ -e /etc/openvpn/server.conf ]]; then
		remove_ovp $user
	fi
done
echo '0' > /etc/SSHPlus/Exp
tput sgr0 
echo ""