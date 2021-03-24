# Copyright Contributors to the Open Cluster Management project

#!/bin/bash

# set -x
set -e
while getopts o:i:dh flag
do 
  case "${flag}" in
    i) IN="--values ${OPTARG}";;
    o) OUT="-o ${OPTARG}";;
    d) DEL="--delete";;
    h) HELP="help"
  esac
done
if [ -n "$HELP" ]
then
  echo "hub.sh [-i values.yaml] [-o output-file] [-d]"
  echo "-i: the path to the values.yaml, default values.yaml"
  echo "-o: output-file: generate an output-file instead of applying"
  echo "-d: When set the managed-cluster will be removed"
  echo "-h: this help"
  exit 0
fi
INSTALL_DIR=$(dirname $0)
if [ -z ${IN+x} ]
then
  IN="-values values.yaml"
fi
PARAMS="$(applier -d $INSTALL_DIR/params.yaml $IN -o /dev/stdout --silent)"
NAME=$(echo "$PARAMS" | grep "name:" | cut -d ":" -f2 | sed 's/^ //')
KBCG=$(echo "$PARAMS" | grep "kubeConfig:" | cut -d ":" -f2 | sed 's/^ //')
TOKEN=$(echo "$PARAMS" | grep "token:" | cut -d ":" -f2 | sed 's/^ //')
RHACM_NAMESPACE=$(oc get clustermanagers cluster-manager -o=jsonpath='{.metadata.labels.installer\.namespace}{"\n"}')
VERSION=$(oc get multiclusterhubs.operator.open-cluster-management.io multiclusterhub -n $RHACM_NAMESPACE -o=jsonpath='{.status.currentVersion}{"\n"}')
if [ "$VERSION" \< "2.3.0" ] && [ "$FUNCTIONAL_TEST" != "true" ] && ([ "$KBCG" != "" ] || [ "$TOKEN" != "" ])
then
  echo "The auto-import capability is not yet implemented on the backend"
  exit 1
fi
if [ -z "$NAME" ] 
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
  applier -d $INSTALL_DIR/hub $IN $OUT $VERBOSE --silent
  if [ -z ${OUT+x} ] && [ -z "$KBCG" ] && [ -z "$TOKEN" ]
  then
    echo "Wait 10s to settle"
    sleep 10
    echo "Retrieve import secret"
    set +e
    oc get secret -n $NAME $NAME-import -o yaml > $INSTALL_DIR/import-secret.yaml
    if [ $? != 0 ]
    then
      echo "Error: $?"
      exit 1
    fi
  fi
else
  applier -d $INSTALL_DIR/hub/managedcluster_cr.yaml $IN $DEL $OUT $VERBOSE
fi