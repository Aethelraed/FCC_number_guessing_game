#!/bin/bash
#a number guessing game
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_RN=$(( $RANDOM%1000 ))

N_GUESS=0

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

GUESS(){
  if [[ $1 ]]
  then
    echo "$1"
  fi
  read USER_GUESS
  if [[ $USER_GUESS =~ [^0-9]+ ]]
  then 
    GUESS "That is not an integer, guess again:"
    else
      N_GUESS=$(( N_GUESS + 1 ))
      if [[ $USER_GUESS > $SECRET_RN ]]
      then
        GUESS "It's lower than that, guess again:"
      else 
      if [[ $USER_GUESS < $SECRET_RN ]]
        then        
          GUESS "It's higher than that, guess again:"
        else 
        echo "You guessed it in $N_GUESS tries. The secret number was $SECRET_RN. Nice job!"
        INSER_RETURN=$($PSQL "insert into games(n_guesses,user_id) values($N_GUESS,$USER_ID);")
      fi 
      fi
  fi
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
GUESS "Guess the secret number between 1 and 1000:"