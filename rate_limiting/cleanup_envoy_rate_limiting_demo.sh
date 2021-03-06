#!/usr/bin/env bash

# Get directory this script is located in to access script local files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

source "${SCRIPT_DIR}/../common_scripts.sh"
source "${SCRIPT_DIR}/../working_environment.sh"

cleanup_port_forward_deployment 'gateway-proxy'

kubectl --namespace="${GLOO_NAMESPACE}" delete \
  --ignore-not-found='true' \
  virtualservice/default

kubectl --namespace="${GLOO_NAMESPACE}" patch settings/default \
  --type='json' \
  --patch='[
    {
      "op": "remove",
      "path": "/spec/ratelimit"
    }
  ]'

kubectl --namespace='default' delete \
  --ignore-not-found='true' \
  --filename="${GLOO_DEMO_RESOURCES_HOME}/petstore.yaml"
