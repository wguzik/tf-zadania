#!/usr/bin/env bash

PROJECT="statewsbwg"
OWNER="WG"
LOCATION="westeurope"
ENVIRONMENT="dev"
RGNAME=$PROJECT"-"$ENVIRONMENT
SANAME=$PROJECT$ENVIRONMENT$RANDOM

az group create --location $LOCATION --name $RGNAME --tags Environment=$ENVIRONMENT Owner=$OWNER

SANAMEAVAILABILITY=$(az storage account check-name --name $SANAME --query nameAvailable)
echo $SANAMEAVAILABILITY

if [ $SANAMEAVAILABILITY ]; then
  az storage account create --name $SANAME --resource-group $RGNAME --location $LOCATION --sku Standard_ZRS

  az storage container create --name dev --account-name $SANAME
  az storage container create --name prod --account-name $SANAME

  echo "RG name $RGNAME"
  echo "SA name $SANAME"
else
  echo "Error: ${SANAMEAVAILABILITY} name is taken, propose new name."
fi
