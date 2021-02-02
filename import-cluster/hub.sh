#!/bin/bash
#set -x
if [ -z $1 ] 
then
  echo -e "Missing cluster name\nhub.sh <clusterName>"
  exit 1
fi
oc get ns $1
if [ $? == 0 ]
then
  echo $1" already imported"
  exit 1
fi
echo "apply hub resources"
applier -d hub -values values.yaml
echo "Wait 10s to setle"
sleep 10
echo "Retrieve import-secret.yaml"
oc get secret -n $1 $1-import -o yaml > import-secret.yaml
if [ $? != 0 ]
then
  echo "Error: $?"
  exit 1
fi