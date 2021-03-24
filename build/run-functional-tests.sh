#!/bin/bash
# Copyright Contributors to the Open Cluster Management project

# set -x
TEST_DIR=test/functional
TEST_RESULT_DIR=$TEST_DIR/tmp
ERROR_REPORT=""
CLUSTER_NAME=$PROJECT_NAME-functional-test
export FUNCTIONAL_TEST=true
kind create cluster --name $CLUSTER_NAME
# Configure the kind cluster
applier -d $TEST_DIR/resources

rm -rf $TEST_RESULT_DIR
mkdir -p $TEST_RESULT_DIR

echo "Test create-cluster/deploy.sh AWS"
create-cluster/deploy.sh -i $TEST_DIR/create-cluster/aws_values.yaml -o $TEST_RESULT_DIR/aws_result.yaml
diff -u $TEST_DIR/create-cluster/aws_result.yaml $TEST_RESULT_DIR/aws_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"create-cluster/deploy.sh AWS failed\n"
fi

echo "Test create-cluster/deploy.sh Azure"
create-cluster/deploy.sh -i $TEST_DIR/create-cluster/azure_values.yaml -o $TEST_RESULT_DIR/azure_result.yaml
diff -u $TEST_DIR/create-cluster/azure_result.yaml $TEST_RESULT_DIR/azure_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"create-cluster/deploy.sh Azure failed\n"
fi

echo "Test create-cluster/deploy.sh GCP"
create-cluster/deploy.sh -i $TEST_DIR/create-cluster/gcp_values.yaml -o $TEST_RESULT_DIR/gcp_result.yaml
diff -u $TEST_DIR/create-cluster/gcp_result.yaml $TEST_RESULT_DIR/gcp_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"create-cluster/deploy.sh GCP failed\n"
fi

echo "Test create-cluster/deploy.sh vSphere"
create-cluster/deploy.sh -i $TEST_DIR/create-cluster/vsphere_values.yaml -o $TEST_RESULT_DIR/vsphere_result.yaml
diff -u $TEST_DIR/create-cluster/vsphere_result.yaml $TEST_RESULT_DIR/vsphere_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"create-cluster/deploy.sh vSphere failed\n"
fi

echo "Test import-cluster/hub.sh manual"
import-cluster/hub.sh -i $TEST_DIR/import-cluster/manual_values.yaml -o $TEST_RESULT_DIR/manual_result.yaml
diff -u $TEST_DIR/import-cluster/manual_result.yaml $TEST_RESULT_DIR/manual_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"import-cluster/hub.sh manual failed\n"
fi

echo "Test import-cluster/hub.sh kubeconfig"
import-cluster/hub.sh -i $TEST_DIR/import-cluster/kubeconfig_values.yaml -o $TEST_RESULT_DIR/kubeconfig_result.yaml
diff -u $TEST_DIR/import-cluster/kubeconfig_result.yaml $TEST_RESULT_DIR/kubeconfig_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"import-cluster/hub.sh kubeconfig failed\n"
fi

echo "Test import-cluster/hub.sh token"
import-cluster/hub.sh -i $TEST_DIR/import-cluster/token_values.yaml -o $TEST_RESULT_DIR/token_result.yaml
diff -u $TEST_DIR/import-cluster/token_result.yaml $TEST_RESULT_DIR/token_result.yaml
if [ $? != 0 ]
then
   ERROR_REPORT=$ERROR_REPORT+"import-cluster/hub.sh token failed\n"
fi

if [ -z "$ERROR_REPORT" ]
then
    echo "Success"
else
    echo -e "\n\nErrors\n======\n"$ERROR_REPORT
    exit 1
fi

kind delete cluster --name $CLUSTER_NAME