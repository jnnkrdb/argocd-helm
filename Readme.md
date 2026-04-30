# ArgoCD Helm

## Installation

Install the Chart with the following commands:

### Install ArgoCD

```bash
helm upgrade argocd oci://ghcr.io/jnnkrdb/argocd-helm --install --create-namespace --namespace argocd --version {VERSION}
```
