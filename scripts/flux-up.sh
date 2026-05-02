#!/usr/bin/env bash

# Copyright 2025 Stefan Prodan
# SPDX-License-Identifier: AGPL-3.0

set -o errexit

echo "Starting cluster bootstrap"
flux-operator install -f ./clusters/local/flux-instance.yaml

echo ""
echo "Waiting for cluster addons sync to complete"
flux-operator -n flux-system wait rset infra --timeout=5m
flux tree kustomization infra-sync

# echo "Waiting for apps sync to complete"
# flux-operator -n flux-system wait rset apps --timeout=5m
# flux tree kustomization apps-sync

echo "✔ Cluster is ready"
