# EKS GitOps & Observability Platform

Production-style AWS Kubernetes platform demonstrating Infrastructure as Code, private CI/CD, GitOps delivery and Kubernetes observability.

## Table of Contents

- [Project Overview](#project-overview)
- [Engineering Impact](#engineering-impact)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [CI/CD and GitOps](#cicd-and-gitops)
- [Observability](#observability)
- [Networking](#networking)
- [Security](#security)
- [Folder Structure](#folder-structure)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)
- [Repositories](#repositories)
- [Author](#author)

## Project Overview

This project demonstrates a platform-engineering workflow built around Amazon EKS, Terraform, GitHub Actions, Docker, Helm, Kustomize and Argo CD.

Terraform provisions the AWS infrastructure. A private EC2 GitHub Actions runner performs infrastructure operations, using GitHub OIDC for short-lived AWS credentials. Argo CD then manages the Kubernetes platform and application state from a dedicated GitOps repository.

The platform includes Prometheus, Grafana, Loki, Fluent Bit, Blackbox Exporter, kube-state-metrics and Node Exporter.

## Engineering Impact

The project was built to solve common platform-engineering problems:

- Manual infrastructure provisioning and configuration drift.
- Long-lived cloud credentials in CI/CD.
- Inconsistent Kubernetes deployments.
- Limited visibility into cluster health and application behaviour.
- Difficult operational troubleshooting.

The resulting workflow provides:

- Reusable Terraform infrastructure.
- Short-lived GitHub-to-AWS authentication through OIDC.
- Private CI execution.
- Automated Docker image delivery to ECR.
- GitOps-based Kubernetes reconciliation.
- Automated monitoring and logging.

## Tech Stack

**Cloud:** AWS, EKS, ECR, VPC, S3, IAM, KMS, Route 53, EBS

**IaC:** Terraform, S3 remote state, DynamoDB locking

**Containers:** Docker, Kubernetes, Helm

**GitOps:** Argo CD, Kustomize

**CI/CD:** GitHub Actions, GitHub OIDC, self-hosted EC2 runner

**Observability:** Prometheus, Grafana, Loki, Fluent Bit, Blackbox Exporter, kube-state-metrics, Node Exporter

**Networking:** VPC, public/private subnets, route tables, NAT Gateway, VPC peering, security groups, NGINX Ingress

## Architecture

```text
                         GitHub
                           |
              +------------+------------+
              |                         |
        Terraform CI                Docker CI
              |                         |
        GitHub OIDC                GitHub OIDC
              |                         |
              v                         v
       Private EC2 Runner              ECR
              |
              v
       AWS / Amazon EKS
              |
           Argo CD
              |
       GitOps Repository
              |
       +------+----------------+
       |                       |
   Applications          Platform Services
                               |
                         Observability
                               |
             +-----------------+----------------+
             |          |       |       |       |
          Prometheus  Grafana  Loki  Fluent Bit Exporters
```

## CI/CD and GitOps

### Terraform CI

The Dev workflow performs:

1. Checkout.
2. GitHub OIDC diagnostics.
3. AWS IAM role assumption.
4. Terraform formatting and validation.
5. Checkov validation.
6. Terraform plan.
7. Terraform apply on main.
8. Argo CD bootstrap.
9. Kubernetes health checks.

### Docker CI

The Docker workflow:

1. Checks out the repository.
2. Authenticates to AWS using GitHub OIDC.
3. Logs into ECR.
4. Builds the application image.
5. Tags the image with the Git commit SHA.
6. Pushes the image to ECR.
7. Updates the Helm image tag on main.

### GitOps

Argo CD monitors the dedicated GitOps repository and continuously reconciles the declared Kubernetes state.

The GitOps repository contains applications for:

- ingress-nginx
- cert-manager
- ExternalDNS
- Fluent Bit
- kube-prometheus-stack
- Loki
- Blackbox Exporter
- Grafana dashboards
- the application Helm deployment

Automated sync, pruning and self-healing provide continuous drift correction.

## Observability

### Metrics

Prometheus collects Kubernetes and infrastructure metrics through kube-state-metrics, Node Exporter and Blackbox Exporter.

### Grafana

Grafana provides dashboards for Kubernetes and infrastructure health. Dashboard definitions are generated with Kustomize and delivered through Argo CD.

### Logging

Fluent Bit collects Kubernetes logs and forwards them to Loki. Loki uses Amazon S3 for log object storage.

## Networking

The Dev EKS VPC uses:

- `10.0.0.0/16`
- Public subnets across two Availability Zones.
- Private subnets across two Availability Zones.
- Internet Gateway.
- NAT Gateway.

The CI runner operates in a separate private VPC.

VPC peering connects the CI VPC to the EKS VPC. EKS API access is restricted through explicit CIDRs and security-group rules.

## Security

Security controls demonstrated include:

- GitHub OIDC instead of long-lived AWS access keys.
- Least-privilege IAM roles.
- Private CI runner with no public IP.
- SSM-based runner administration.
- Restricted EKS API access.
- EKS Pod Identity for Kubernetes workloads.
- Encrypted Terraform state.
- Encrypted EBS storage.
- Kubernetes NetworkPolicies.
- Non-root container security controls.

## Folder Structure

```text
.github/
└── workflows/
    ├── docker-ci-dev.yml
    ├── docker-ci-prod.yml
    ├── terraform-ci-dev.yml
    ├── terraform-ci-prod.yml
    ├── terraform-ci-dev-destroy.yml
    ├── terraform-ci-prod-destroy.yml
    ├── terraform-plan-readonly.yml
    └── terraform-state-diagnose.yml

docker/
└── Dockerfile

kubernetes/
└── Helm/
    └── app/

terraform/
├── envs/
│   ├── dev/
│   ├── prod/
│   ├── dns/
│   ├── ci-runner/
│   └── argocd-bootstrap/
└── modules/
    ├── ECR/
    ├── EKS/
    ├── IAM/
    ├── Vpc/
    ├── argocd/
    ├── aws_load_balancer_controller/
    ├── ci_runner/
    ├── ci_vpc/
    ├── kms/
    ├── node_groups/
    ├── pod_identity/
    ├── s3/
    └── vpc_peering/
```

## Deployment

Infrastructure deployment is driven through GitHub Actions.

Terraform provisions the AWS layer and bootstraps Argo CD.

Argo CD then manages Kubernetes platform and application resources from the GitOps repository.

Docker images are tagged using immutable Git commit SHAs and stored in Amazon ECR.

## Troubleshooting

The project has involved real operational troubleshooting, including:

- Private CI runner unable to reach the EKS API.
- NAT and EKS public-access configuration.
- VPC peering and route-table issues.
- Terraform state/resource mismatches.
- Kubernetes node pod-count exhaustion.
- EBS CSI IAM configuration.
- Argo CD field-manager conflicts.
- Grafana dashboard ConfigMap reconciliation.

The general troubleshooting process is:

```text
Observe
  |
Collect evidence
  |
Identify the failing layer
  |
Make the smallest targeted change
  |
Re-run CI
  |
Verify the result
```

## Repositories

### Infrastructure

https://github.com/Ramzan9000/EKS-V1

Contains Terraform, CI/CD workflows, Docker build configuration and Argo CD bootstrap.

### GitOps

https://github.com/Ramzan9000/EKS-V1-gitops

Contains Argo CD Applications, Helm values, Kustomize configuration, observability configuration and application deployment state.

## Notes

Terraform state is stored remotely in Amazon S3 with DynamoDB locking.

The DNS environment is separated from Dev and Prod.

The CI runner is private and administered through SSM.

Argo CD owns the ongoing Kubernetes application state after the initial bootstrap.

This project is a portfolio/platform-engineering demonstration rather than a claim of a fully managed production environment.

## Author

**Ramzan**

- GitHub: https://github.com/Ramzan9000
- LinkedIn: https://www.linkedin.com/in/ramzan-k
