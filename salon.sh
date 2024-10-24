#!/bin/bash
PSQL="psql  --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e "\n~~~~~ MY SALON ~~~~~\n"






MAIN_MENU(){
if [[ $1 ]] 
then
echo -e "\n$1"
fi


echo "$($PSQL "select service_id,name from services")" | while read SERVICE_ID BAR NAME
do 
echo "$SERVICE_ID) $NAME"
done

read SERVICE_ID_SELECTED
if [[ -z $SERVICE_ID_SELECTED ]]
then
SERVICE_ID_SELECTED=0
fi  
SERVICE_NAME=$($PSQL "SELECT name from services where service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_NAME ]]
then 
MAIN_MENU "I could not find that service. What would you like today?\n"
else


echo -e "What's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")


if [[ -z $CUSTOMER_NAME ]]
then
echo -e "I don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME

INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO CUSTOMERS(name,phone) Values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi




echo -e "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE'")
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME') ")
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."




fi

}
MAIN_MENU "Welcome to My Salon, how can I help you?\n"