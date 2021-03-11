# Copyright Contributors to the Open Cluster Management project


#!/bin/bash
# set -x
set -e
while getopts o:i:sv:h flag
do 
  case "${flag}" in
    i) IN="-values ${OPTARG}";;
    o) OUT="-o ${OPTARG}";;
    s) SILENT="-s";;
    v) VERBOSE="-v ${OPTARG}";;
    h) HELP="help"
  esac
done
if [ -n "$HELP" ]
then
  echo "managedcluster.sh [-i values-file] [-o output-file] [-d] [-v [0-99]]"
  echo "-i: the path to the values.yaml, default values.yaml"
  echo "-o: output-file: generate an output-file instead of applying"
  echo "-v: verbose level"
  echo "-h: this help"
  exit 1
fi
INSTALL_DIR=$(dirname $0)
if [ -z ${IN+x} ]
then
  IN="-values values.yaml"
fi
PARAMS="$(applier -d $INSTALL_DIR/params.yaml $IN -o /dev/stdout -s)"
NAME=$(echo "$PARAMS" | grep "name:" | cut -d ":" -f2 | sed 's/^ //')
if [ -z "$NAME" ] 
then
  echo "Missing cluster name in value.yaml"
  exit 1
fi
set +e
oc get crd klusterlets.operator.open-cluster-management.io > /dev/null 2>&1
if [ $? == 0 ]
then
   echo "This $NAME cluster is already imported"
   exit 1
fi
applier -d $INSTALL_DIR/managedcluster/import.yaml --values $INSTALL_DIR/import-secret.yaml $OUT $SILENT $VERBOSE
if [ $? != 0 ]
then
  echo "Error: $?"
  exit 1
fi