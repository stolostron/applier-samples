
#!/bin/bash
#set -x
oc get crd klusterlets.operator.open-cluster-management.io 
if [ $? == 0 ]
then
   echo "This $1 cluster is already imported"
   exit 1
fi
applier -f managedcluster/import.yaml --values import-secret.yaml
if [ $? != 0 ]
then
  echo "Error: $?"
  exit 1
fi