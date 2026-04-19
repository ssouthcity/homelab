# AGENTS.md

Guide for agentic coding agents working in this homelab repository.

## Overview

This is a Kubernetes homelab configuration repository using GitOps with FluxCD, Talos Linux, and Nix for reproducible tooling. All Kubernetes manifests are managed as code with SOPS for secret encryption.

## Build/Lint/Test Commands

This repository uses Nix flakes for development environment and pre-commit hooks for validation:

```bash
# Enter development shell (installs all tools)
nix develop

# Run all pre-commit hooks (linting/formatting)
nix fmt
# Or equivalently:
pre-commit run --all-files

# Validate specific file types
pre-commit run yamlfmt --files <file.yaml>
pre-commit run sops --files <file.enc.yaml>

# No test suite - this is infrastructure-as-code
```

## Available Tools (via Nix)

When in `nix develop` shell:
- `kubectl` - Kubernetes CLI
- `flux` - FluxCD CLI
- `helm` - Helm package manager
- `sops` - Secret encryption
- `talosctl` - Talos Linux control
- `k9s` - Kubernetes TUI
- `age` - Encryption tool

## Code Style Guidelines

### YAML Formatting
- **Indentation**: 2 spaces (enforced by yamlfmt)
- **Line endings**: Unix-style (LF)
- **Trailing whitespace**: Not allowed
- Run `nix fmt` before committing to auto-format

### File Organization
```
clusters/homelab/        # FluxCD Kustomizations per environment
├── flux-system/         # Flux bootstrap (auto-generated)
├── apps.yaml            # Apps Kustomization
├── infrastructure.yaml  # Infra Kustomization
├── monitoring.yaml      # Monitoring Kustomization
└── addons.yaml          # Cluster addons

infrastructure/          # Core infrastructure
├── controllers/         # HelmReleases & controllers
├── configs/             # Cluster configs
├── secrets/             # Encrypted secrets (*.enc.yaml)
└── alerts/              # Alert configurations

apps/                    # Application deployments
├── base/                # Base manifests per app
└── homelab/             # Environment-specific patches

monitoring/              # Observability stack
├── base/
└── homelab/

addons/                  # Cluster-wide addons
```

### Naming Conventions

**Files:**
- Regular manifests: `<resource-name>.yaml`
- Encrypted secrets: `<name>.enc.yaml`
- Kustomize files: `kustomization.yaml`
- Helm values patches: `<app>-values.yaml`

**Kubernetes Resources:**
- Use kebab-case for resource names: `cert-manager`, `external-dns`
- Namespace names: lowercase, descriptive: `monitoring`, `ingress-nginx`
- HelmRelease names: match chart name or app name

**Kustomizations:**
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../base/app-name
patches:
  - path: app-values.yaml
    target:
      kind: HelmRelease
```

### Secret Management (SOPS)

**Critical**: All secrets MUST be encrypted with SOPS:

1. Create secret file with `.enc.yaml` suffix
2. Pre-commit hook auto-encrypts files matching `\.enc\.(yml|yaml)$`
3. Configuration in `.sops.yaml`:
   - Encrypted fields: `^(data|stringData)$`
   - Key: age1th32fhtm6wlmy824uwpsykwhe08ycj6nj5m8lvedfq5nwnz095ts93uzsm

Example:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
  namespace: default
type: Opaque
stringData:
  token: <plaintext-will-be-encrypted>  # This field gets encrypted
```

### HelmRelease Patterns

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: app-name
  namespace: app-namespace
spec:
  releaseName: app-name
  interval: 30m
  chart:
    spec:
      chart: chart-name
      sourceRef:
        kind: HelmRepository
        name: repo-name
  values:
    # Inline values for simple configs
    # Or use patches for complex values
```

### Kustomization (FluxCD) Patterns

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: component-name
  namespace: flux-system
spec:
  interval: 10m0s
  dependsOn:
    - name: dependency-name
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./path/to/manifests
  prune: true
  wait: true
  timeout: 5m0s
```

## Common Tasks

**Add a new application:**
1. Create directory in `apps/base/<app-name>/`
2. Add namespace, deployment, service, etc.
3. Add kustomization.yaml referencing resources
4. Reference in `apps/homelab/kustomization.yaml`

**Add a secret:**
1. Create file in `infrastructure/secrets/<name>.enc.yaml`
2. Pre-commit will auto-encrypt on commit
3. Reference decryption in parent Kustomization

**Update encrypted secret:**
```bash
sops infrastructure/secrets/name.enc.yaml
# Edit and save
```

## Pre-commit Checks

The following are enforced:
- yamlfmt: All YAML files formatted with 2-space indent
- sops: Files matching `*.enc.yaml` must have `sops:` key (encrypted)

## No-Go Areas

- Never commit unencrypted secrets (without `.enc.yaml` suffix)
- Never modify `clusters/homelab/flux-system/` (managed by Flux)
- Never use tabs in YAML files
