#! /bin/bash


PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "

MY_SALON(){

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

SERVICE_SELECTION
GET_CUSTOMER_DETAILS
CREATE_APPOINTMENT
}


SERVICE_SELECTION(){
    if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES_LIST=$($PSQL "SELECT * FROM SERVICES")
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  
  read SERVICE_ID_SELECTED
  CHOSEN_SERVICE_ERROR_MESSAGE="Please choose a valid service."

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
    SERVICE_SELECTION "$CHOSEN_SERVICE_ERROR_MESSAGE"
  fi
  CHOSEN_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  
  if [[ -z $CHOSEN_SERVICE ]]; then
    SERVICE_SELECTION "$CHOSEN_SERVICE_ERROR_MESSAGE"
  fi
}

  GET_CUSTOMER_DETAILS(){

  echo -e "\n What is your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER ]]; then

    echo -e "\n What is your name?"
    read CUSTOMER_NAME

    CUSTOMER_ADDED_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME' , '$CUSTOMER_PHONE')")
    echo -e "Customer Added\n"

    CUSTOMER=$CUSTOMER_NAME
    
    fi  
  }

  CREATE_APPOINTMENT(){
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  echo -e "What service time would you like?"
  read SERVICE_TIME

  TIMESLOT_RESERVED_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME' , $CUSTOMER_ID , $SERVICE_ID_SELECTED)")

  echo -e "I have put you down for a $(echo $CHOSEN_SERVICE | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER | sed -E 's/^ *| *$//g')."
  }

MY_SALON

