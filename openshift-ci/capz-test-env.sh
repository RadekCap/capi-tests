# Shared environment variables for all CAPZ test steps in Prow.
# Sourced by each step command script to ensure consistent configuration.
# Edit this file to change test parameters for all phases at once.
export INFRA_PROVIDER=aro

# Use the CI-provisioned OpenShift cluster as the management cluster.
# The IPI install chain writes the kubeconfig to ${SHARED_DIR}/kubeconfig
# and sets ${KUBECONFIG} in every step container.
export USE_KUBECONFIG="${SHARED_DIR}/kubeconfig"

# Extract Azure credentials from the cluster profile.
# The cluster_profile: azure4 provides credentials in ${CLUSTER_PROFILE_DIR}.
if [ -f "${CLUSTER_PROFILE_DIR}/osServicePrincipal.json" ]; then
  export AZURE_CLIENT_ID=$(jq -r .clientId "${CLUSTER_PROFILE_DIR}/osServicePrincipal.json")
  export AZURE_CLIENT_SECRET=$(jq -r .clientSecret "${CLUSTER_PROFILE_DIR}/osServicePrincipal.json")
  export AZURE_TENANT_ID=$(jq -r .tenantId "${CLUSTER_PROFILE_DIR}/osServicePrincipal.json")
  export AZURE_SUBSCRIPTION_ID=$(jq -r .subscriptionId "${CLUSTER_PROFILE_DIR}/osServicePrincipal.json")
fi
