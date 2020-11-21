#!/bin/bash
clear
echo -e "\E[44;1;37m               VPS INFORMACIJA                 \E[0m"
echo ""
if [ -f /etc/lsb-release ]
then
echo -e "\033[1;31m• \033[1;32mOPERACINE SISTEMA\033[1;31m •\033[0m"
echo ""
name=$(cat /etc/lsb-release |grep DESCRIPTION |awk -F = {'print $2'})
codename=$(cat /etc/lsb-release |grep CODENAME |awk -F = {'print $2'})
echo -e "\033[1;33mPavadinimas: \033[1;37m$name"
echo -e "\033[1;33mCodeName: \033[1;37m$codename"
echo -e "\033[1;33mKernel: \033[1;37m$(uname -s)"
echo -e "\033[1;33mKernel Release: \033[1;37m$(uname -r)"
if [ -f /etc/os-release ]
then
devlike=$(cat /etc/os-release |grep LIKE |awk -F = {'print $2'})
echo -e "\033[1;33mTinka OS: \033[1;37m$devlike"
echo ""
fi
else
system=$(cat /etc/issue.net)
echo -e "\033[1;31m• \033[1;32mOPERACINE SISTEMA\033[1;31m •\033[0m"
echo ""
echo -e "\033[1;33mPavadinimas: \033[1;37m$system"
echo ""
fi

if [ -f /proc/cpuinfo ]
then
uso=$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')
echo -e "\033[1;31m• \033[1;32mPROCESORIUS\033[1;31m •\033[0m"
echo ""
modelo=$(cat /proc/cpuinfo |grep "model name" |uniq |awk -F : {'print $2'})
cpucores=$(grep -c cpu[0-9] /proc/stat)
cache=$(cat /proc/cpuinfo |grep "cache size" |uniq |awk -F : {'print $2'})
echo -e "\033[1;33mTipas:\033[1;37m$modelo"
echo -e "\033[1;33mNucleos:\033[1;37m $cpucores"
echo -e "\033[1;33mMemoria Cache:\033[1;37m$cache"
echo -e "\033[1;33mArchitektura: \033[1;37m$(uname -p)"
echo -e "\033[1;33mNaudojama: \033[37m$uso"
echo ""
else
echo -e "\033[1;32mPROCESORIUS\033[0m"
echo ""
echo "Nebuvo imanoma gauti informacijos"
fi

if free 1>/dev/null 2>/dev/null
then
ram1=$(free -h | grep -i mem | awk {'print $2'})
ram2=$(free -h | grep -i mem | awk {'print $4'})
ram3=$(free -h | grep -i mem | awk {'print $3'})
usoram=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')

echo -e "\033[1;31m• \033[1;32mATMINTIS RAM\033[1;31m •\033[0m"
echo ""
echo -e "\033[1;33mIs viso: \033[1;37m$ram1"
echo -e "\033[1;33mNaudojama: \033[1;37m$ram3"
echo -e "\033[1;33mLaisva: \033[1;37m$ram2"
echo -e "\033[1;33mSunaudota: \033[37m$usoram"
echo ""
else
echo -e "\033[1;32mATMINTIS RAM\033[0m"
echo ""
echo "Nebuvo imanoma gauti informacijos"
fi
[[ ! -e /bin/versao ]] && rm -rf /etc/SSHPlus
echo -e "\033[1;31m• \033[1;32mVYKDOMI SERVISAI\033[1;31m •\033[0m"
echo ""
PT=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
for porta in `echo -e "$PT" | cut -d: -f2 | cut -d' ' -f1 | uniq`; do
    svcs=$(echo -e "$PT" | grep -w "$porta" | awk '{print $1}' | uniq)
    echo -e "\033[1;33mServisas \033[1;37m$svcs \033[1;33mPortas \033[1;37m$porta"
done