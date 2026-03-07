#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

source openshift-ci/capz-test-env.sh

# Phase 01: Check Dependencies
# Validates tool availability, authentication, and naming constraints.
# Produces JUnit XML in ${ARTIFACT_DIR} for Prow to collect.
export TEST_RESULTS_DIR="${ARTIFACT_DIR}"
make _check-dep RESULTS_DIR="${ARTIFACT_DIR}"
