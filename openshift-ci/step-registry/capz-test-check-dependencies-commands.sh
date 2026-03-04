#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

# Install gotestsum for JUnit XML output
go install gotest.tools/gotestsum@v1.13.0
export PATH="${GOBIN:-$(go env GOPATH)/bin}:${PATH}"

# Run Phase 01: Check Dependencies
# Produces JUnit XML in ${ARTIFACT_DIR} for Prow to collect
gotestsum --junitfile="${ARTIFACT_DIR}/junit-check-dep.xml" -- \
  -v ./test -count=1 -run TestCheckDependencies
