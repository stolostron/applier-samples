#!/bin/bash -e

# Copyright Contributors to the Open Cluster Management project

# Go tools
_OS=$(go env GOOS)
_ARCH=$(go env GOARCH)

if ! which applier > /dev/null; then     
    echo "Installing applier ..."
    pushd $(mktemp -d) && \
    GOSUMDB=off git clone git@github.com:open-cluster-management/applier.git && \
    cd applier && \
    make install && \
    popd 
fi

