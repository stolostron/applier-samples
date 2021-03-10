# Copyright Contributors to the Open Cluster Management project

export PROJECT_DIR            = $(shell 'pwd')
export PROJECT_NAME			  = $(shell basename ${PROJECT_DIR})
	
BEFORE_SCRIPT := $(shell build/before-make.sh)

.PHONY: deps
deps:
	@build/install-dependencies.sh

.PHONY: check
check: deps
	@build/check-copyright.sh

.PHONY: functional-test-full
functional-test-full: deps
	@build/run-functional-tests.sh
