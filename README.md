# EKS Multi-Cluster Platform

This repository contains infrastructure and application deployments for a multi-cluster EKS setup with platform and workload separation.

## Architecture

- **Platform Cluster**: ArgoCD, Grafana, Prometheus
- **Workload Cluster**: Applications (TicTacToe, Solar System)
- **Infrastructure**: Terraform modules for VPC and EKS

## Structure

```
├── terraform/              # Infrastructure as Code
│   ├── modules/
│   │   ├── vpc/            # VPC module
│   │   └── eks/            # EKS module
│   └── main.tf             # Main configuration
├── eks-deployments/        # Kubernetes manifests
│   ├── platform/           # Platform cluster apps
│   └── workload/           # Workload cluster apps
└── .github/workflows/      # CI/CD pipelines
```

## Deployment

### Prerequisites
- AWS CLI configured
- kubectl installed
- Terraform installed

### Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Platform Applications
```bash
kubectl apply -f eks-deployments/platform/
```

### Workload Applications
```bash
kubectl apply -f eks-deployments/workload/
```

## Access

- **ArgoCD**: `http://<ALB-URL>/argocd`
- **Grafana**: `http://<ALB-URL>/grafana` (admin/admin)
- **Prometheus**: `http://<ALB-URL>/prometheus`
- **Solar System**: `http://<ALB-URL>/solar-system`

## Local Testing

```bash
cd eks-deployments
docker-compose up -d
```

## CI/CD

GitHub Actions workflows handle:
- Infrastructure deployment
- Platform applications deployment  
- Workload applications deployment