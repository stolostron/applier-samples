#!/bin/bash
#set -x
set -e
while getopts o:dv:h flag
do 
  case "${flag}" in
    o) OUT="-o ${OPTARG}";;
    d) DEL="-delete";;
    v) VERBOSE="-v ${OPTARG}";;
    h) HELP="help"
  esac
done
if [ -n "$HELP" ]
then
  echo "hub.sh [-o output-file] [-d] [-v [0-99]]"
  echo "-o output-file: generate an output-file instead of applying"
  echo "-d: When set the managed-cluster will be removed"
  echo "-v: verbose level"
  echo "-h: this help"
  exit 0
fi
PARAMS="$(applier -d params.yaml -values values.yaml -o /dev/stdout -s)"
NAME=$(echo "$PARAMS" | grep "name:" | cut -d ":" -f2 | sed 's/^ //')
if [ -z ${NAME+x} ] 
then
  echo "Missing cluster name in value.yaml"
  exit 1
fi
if [ -z ${DEL+x} ]
then
  set +e
  oc get ns $NAME > /dev/null 2>&1
  if [ $? == 0 ]
  then
    echo $NAME" already exits"
    exit 1
  fi
  set -e
fi
if [ -z ${DEL+x} ]
then
  applier -d hub -values values.yaml $OUT $VERBOSE -s
  if [ -z ${OUT+x} ] 
  then
    echo "Wait 10s to settle"
    sleep 10
    echo "Retrieve import secret"
    set +e
    oc get secret -n $NAME $NAME-import -o yaml > import-secret.yaml
    if [ $? != 0 ]
    then
      echo "Error: $?"
      exit 1
    fi
  fi
else
  applier -d hub/managedcluster_cr.yaml -values values.yaml $DEL $OUT $VERBOSE
fi