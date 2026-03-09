#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

source openshift-ci/capz-test-env.sh

# Phase 03: Management Cluster
# Installs CAPI/CAPZ/ASO controllers on the CI-provisioned OpenShift cluster,
# then validates that all controllers and webhooks are ready.

# Install CAPI and infrastructure provider controllers via deploy-charts.sh.
# The installer repo is pre-cloned in the container image at /tmp/cluster-api-installer-aro.
REPO_DIR="/tmp/cluster-api-installer-aro"
DEPLOY_SCRIPT="${REPO_DIR}/scripts/deploy-charts.sh"

if [ ! -f "${DEPLOY_SCRIPT}" ]; then
  echo "ERROR: deploy-charts.sh not found at ${DEPLOY_SCRIPT}"
  exit 1
fi

# Configure deploy-charts.sh for external cluster mode (no Kind creation)
export USE_K8S=true
export DO_INIT_KIND=false
export DO_DEPLOY=true
export DO_CHECK=false
export KUBECONFIG="${SHARED_DIR}/kubeconfig"

cd "${REPO_DIR}"
bash "${DEPLOY_SCRIPT}" cluster-api cluster-api-provider-azure

# Validate that controllers are ready via the Go test suite
cd "${OLDPWD}"
export TEST_RESULTS_DIR="${ARTIFACT_DIR}"
make _management_cluster RESULTS_DIR="${ARTIFACT_DIR}"
