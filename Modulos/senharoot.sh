#!/bin/bash

echo -e "\033[1;31mDEMESIO!!\033[0m"
echo " "
echo -e "\033[1;33mSis slaptazodis bus naudojamas prisijungti prie serverio
\033[0m"
echo -e "\033[1;32mIVESKITE NAUJA SLAPTAZODI \033[1;32m
toliau...\033[1;31m\033[0m"
read  -p : pass
(echo $pass; echo $pass)|passwd 2>/dev/null
sleep 1s
echo -e "\033[1;31mSLAPTAZODIS SEKMINGAI PAKEISTAS!\033[0m"
sleep 5s
cd
clear

