
#!/bin/bash
#set -x
set -e
while getopts o:sv:h flag
do 
  case "${flag}" in
    o) OUT="-o ${OPTARG}";;
    s) SILENT="-s";;
    v) VERBOSE="-v ${OPTARG}";;
    h) HELP="help"
  esac
done
if [ -n "$HELP" ]
then
  echo "hub.sh [-o output-file] [-d] [-v [0-99]]"
  echo "-o output-file: generate an output-file instead of applying"
  echo "-v: verbose level"
  echo "-h: this help"
  exit 1
fi
PARAMS="$(applier -d params.yaml -values values.yaml -o /dev/stdout -s)"
NAME=$(echo "$PARAMS" | grep "name:" | cut -d ":" -f2 | sed 's/^ //')
if [ -z ${NAME+x} ] 
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
applier -d managedcluster/import.yaml --values import-secret.yaml $OUT $SILENT $VERBOSE
if [ $? != 0 ]
then
  echo "Error: $?"
  exit 1
fi