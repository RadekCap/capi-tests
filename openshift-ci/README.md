# OpenShift CI (Prow) Integration

This directory contains reference copies of the OpenShift CI configuration files for the capi-tests project. The actual files are submitted to the [openshift/release](https://github.com/openshift/release) repository.

## Directory Structure

```
openshift-ci/
├── README.md                          # This file
├── ci-operator-config.yaml            # ci-operator config reference
└── step-registry/
    ├── capz-test-check-dependencies-ref.yaml        # Step reference YAML
    └── capz-test-check-dependencies-commands.sh     # Step commands script
```

## Where Files Go in openshift/release

| Local reference file | openshift/release destination |
|---------------------|-------------------------------|
| `ci-operator-config.yaml` | `ci-operator/config/stolostron/capi-tests/stolostron-capi-tests-main.yaml` |
| `step-registry/capz-test-check-dependencies-ref.yaml` | `ci-operator/step-registry/capz/test/check-dependencies/capz-test-check-dependencies-ref.yaml` |
| `step-registry/capz-test-check-dependencies-commands.sh` | `ci-operator/step-registry/capz/test/check-dependencies/capz-test-check-dependencies-commands.sh` |

## How It Works

1. **Dockerfile.prow** (in repo root) builds a container image with all required tools (Go, azure-cli, kind, kubectl, helm, gotestsum, clusterctl)
2. **ci-operator** uses the config to define test jobs that run against PRs and periodically
3. **Step registry** entries define individual test steps — currently Phase 01 (check dependencies)
4. Test results are written as JUnit XML to `${ARTIFACT_DIR}` for Prow to collect and display

## Setting Up in openshift/release

### 1. Fork and clone openshift/release

```bash
gh repo fork openshift/release --clone
cd release
```

### 2. Copy files to their destinations

```bash
# ci-operator config
mkdir -p ci-operator/config/stolostron/capi-tests
cp <path-to-capi-tests>/openshift-ci/ci-operator-config.yaml \
   ci-operator/config/stolostron/capi-tests/stolostron-capi-tests-main.yaml

# Step registry
mkdir -p ci-operator/step-registry/capz/test/check-dependencies
cp <path-to-capi-tests>/openshift-ci/step-registry/capz-test-check-dependencies-ref.yaml \
   ci-operator/step-registry/capz/test/check-dependencies/
cp <path-to-capi-tests>/openshift-ci/step-registry/capz-test-check-dependencies-commands.sh \
   ci-operator/step-registry/capz/test/check-dependencies/
```

### 3. Generate Prow jobs

```bash
make ci-operator-config
make jobs
```

### 4. Submit PR to openshift/release

The generated jobs will appear in `ci-operator/jobs/stolostron/capi-tests/`.

## Testing Locally

### Build the Dockerfile

```bash
docker build -f Dockerfile.prow .
```

### Run check-dependencies in the container

```bash
docker run --rm -it <image> bash -c \
  'gotestsum --junitfile /tmp/junit.xml -- -v ./test -count=1 -run TestCheckDependencies'
```

## Future Work

- Add periodic job config with Azure credentials for full test suite
- Add step registry entries for additional test phases
- Configure `cluster_profile: azure4` for Azure authentication in Prow
