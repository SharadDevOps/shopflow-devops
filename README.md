# 🚀 ShopFlow — Production DevOps Project

> **Built to crack Lead DevOps Engineer interviews**
> Real project covering every tool interviewers ask about

---

## 🏗️ Architecture

```
Developer → GitHub (feature branch)
         → GitHub Actions (CI/CD Pipeline)
            → Docker Build + Push to ACR
            → Terraform Plan/Apply (Infrastructure)
            → Helm Deploy to AKS
         → Azure AKS Cluster
            → api-gateway    (Node.js  :3000)
            → product-service (Python  :5000)
            → order-service  (Java/Maven :8080)
         → Monitoring
            → Prometheus + Grafana (Metrics)
            → ELK Stack (Logs)
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Cloud | Azure (AKS, ACR, Key Vault, VNet) |
| IaC | Terraform (modules from scratch) |
| CI/CD | GitHub Actions (OIDC, Reusable Workflows) |
| Containers | Docker (multi-stage builds) |
| Orchestration | Kubernetes / AKS |
| Packaging | Helm Charts |
| Monitoring | Prometheus + Grafana + ELK |
| Security | Azure Key Vault + RBAC + OIDC |

---

## 📁 Project Structure

```
shopflow-devops/
├── services/
│   ├── api-gateway/          # Node.js
│   ├── product-service/      # Python Flask
│   └── order-service/        # Java Spring Boot (Maven)
├── terraform/
│   ├── modules/
│   │   ├── aks/              # AKS module from scratch
│   │   ├── acr/              # Container Registry module
│   │   ├── vnet/             # Networking module
│   │   └── keyvault/         # Key Vault module
│   ├── environments/
│   │   ├── dev/
│   │   └── prod/
│   └── main.tf
├── helm/
│   ├── api-gateway/
│   ├── product-service/
│   └── order-service/
├── .github/
│   └── workflows/
│       ├── reusable-build.yml
│       ├── reusable-deploy.yml
│       ├── api-gateway.yml
│       ├── product-service.yml
│       ├── order-service.yml
│       └── terraform.yml
└── monitoring/
    ├── prometheus-rules.yaml
    └── grafana-dashboard.json
```

---

## 🎯 Phase-by-Phase Build Plan

| Phase | What You Build | Interview Topics Covered |
|---|---|---|
| **Phase 1** | Azure infra with Terraform | Terraform modules, tfstate, drift |
| **Phase 2** | 3 Microservices + Docker | Docker, multi-stage builds, Maven |
| **Phase 3** | GitHub Actions CI/CD | OIDC, reusable workflows, caching |
| **Phase 4** | Helm Charts + AKS Deploy | Helm, HPA, Ingress, K8s management |
| **Phase 5** | Monitoring Stack | Prometheus, Grafana, ELK |
| **Phase 6** | Production Hardening | Key Vault, PDB, Cluster Autoscaler |

---

## 🚀 Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/SharadDevOps/shopflow-devops.git
cd shopflow-devops

# 2. Start with Phase 1 — Terraform Infrastructure
cd terraform
terraform init
terraform plan -var-file="environments/dev/dev.tfvars"
```

---

## 📊 What This Gets You In Interviews

> *"I built a 3-service microservices platform on Azure AKS using Terraform modules I wrote from scratch. The CI/CD pipeline uses GitHub Actions with OIDC federated credentials — no static secrets stored anywhere. We use Prometheus and Grafana for metrics with custom alerts routing to Slack via Alertmanager, and ELK for log aggregation."*

---

**GitHub:** [SharadDevOps/shopflow-devops](https://github.com/SharadDevOps/shopflow-devops)
