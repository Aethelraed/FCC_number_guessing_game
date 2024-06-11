#!/bin/bash
#a number guessing game
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_RN=$(( $RANDOM%1000 ))
echo $SECRET_RN

WELCOME_BACK(){
  N_GAMES=$($PSQL "select count(game_id) from games where user_id=$USER_ID;")
  BEST_N=$($PSQL "select min(n_guesses) from games where user_id=$USER_ID;")
  echo "Welcome back, $USER_NAME! You have played $N_GAMES games, and your best game took $BEST_N guesses."
}

USER_REGISTRATION(){
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
  REGIS_RETURN=$($PSQL "insert into users(user_name) values('$USER_NAME');")
  USER_ID=$($PSQL "select user_id from users where user_name='$USER_NAME';")
}

echo -e "\nEnter your username:\n"
read USER_NAME 

USER_ID=$($PSQL "select user_id from users where user_name='$USER_NAME';")

if [[ -z $USER_ID ]]
then 
  USER_REGISTRATION
else
  WELCOME_BACK
fi