# Homelab

<p align="center">
  <img src="https://raw.githubusercontent.com/cncf/artwork/master/projects/kubernetes/icon/color/kubernetes-icon-color.svg" width="80" />
  <img src="https://www.vectorlogo.zone/logos/fluxcdio/fluxcdio-icon.svg" width="80" />
</p>

<p align="center">
  <a href="https://kubernetes.io/"><img src="https://img.shields.io/badge/Kubernetes-v1.31+-326CE5?logo=kubernetes&logoColor=white" alt="Kubernetes"></a>
  <a href="https://fluxcd.io/"><img src="https://img.shields.io/badge/FluxCD-GitOps-blue?logo=flux&logoColor=white" alt="FluxCD"></a>
  <a href="https://www.talos.dev/"><img src="https://img.shields.io/badge/Talos%20Linux-Secure%20Kubernetes-orange" alt="Talos Linux"></a>
</p>

---

Kubernetes configuration for my personal homelab, managed via GitOps with **FluxCD** and running on **Talos Linux**.

## Architecture

| Component | Technology |
|-----------|------------|
| **OS** | Talos Linux |
| **GitOps** | FluxCD v2 |
| **Package Management** | Helm |
| **Secrets** | SOPS + Age |
| **Development Shell** | Nix |

## Structure

```
├── clusters/homelab/     # FluxCD Kustomizations
├── infrastructure/       # Core infra (networking, storage, etc.)
├── apps/                 # Application deployments
├── monitoring/           # Observability stack
└── addons/               # Cluster-wide addons
```

## Quick Start

```bash
# Enter development shell
nix develop

# Format and validate
nix fmt
```

---

*Built with care for learning, experimentation, and reliable self-hosting.*
