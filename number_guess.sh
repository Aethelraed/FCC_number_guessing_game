#!/bin/bash
#a number guessing game

SECRET_RN=$(( $RANDOM%1000 ))
echo $SECRET_RN

echo -e "\nEnter your username:\n"
read USER_NAME 
