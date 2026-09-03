#!/bin/bash

set -e

# ============================================================
# EKS CLEANUP SCRIPT
#
# Usage:
#   ./destroy.sh eks-v1-dev
#   ./destroy.sh eks-v1-prod
# ============================================================

REGION="eu-west-2"

# ------------------------------------------------------------
# 1. Require cluster name
# ------------------------------------------------------------

if [ -z "$1" ]; then
  echo ""
  echo "ERROR: You must specify the EKS cluster name."
  echo ""
  echo "Usage:"
  echo "  ./destroy.sh eks-v1-dev"
  echo "  ./destroy.sh eks-v1-prod"
  echo ""
  exit 1
fi

CLUSTER_NAME="$1"

echo ""
echo "=============================================="
echo " EKS CLEANUP"
echo " Cluster: $CLUSTER_NAME"
echo " Region:  $REGION"
echo "=============================================="
echo ""

# ------------------------------------------------------------
# 2. Check that the EKS cluster exists
# ------------------------------------------------------------

echo "Checking EKS cluster..."

if ! aws eks describe-cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION" >/dev/null 2>&1; then

  echo "EKS cluster '$CLUSTER_NAME' does not exist."
  echo "Skipping Kubernetes cleanup."
  echo ""
  echo "Running Terraform destroy..."
  terraform destroy -auto-approve
  exit 0
fi

echo "EKS cluster found."

# ------------------------------------------------------------
# 3. Find the VPC belonging to this EKS cluster
# ------------------------------------------------------------

VPC_ID=$(aws eks describe-cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION" \
  --query 'cluster.resourcesVpcConfig.vpcId' \
  --output text)

echo ""
echo "EKS VPC: $VPC_ID"

# ------------------------------------------------------------
# 4. Delete Argo CD applications
# ------------------------------------------------------------

echo ""
echo "Deleting Argo CD applications..."

kubectl delete applications --all -A \
  --ignore-not-found=true \
  --wait=true || true

# ------------------------------------------------------------
# 5. Delete Kubernetes LoadBalancer services
# ------------------------------------------------------------

echo ""
echo "Deleting Kubernetes LoadBalancer services..."

kubectl get svc -A \
  --field-selector spec.type=LoadBalancer \
  --no-headers 2>/dev/null | while read -r namespace name rest; do

    if [ -n "$namespace" ] && [ -n "$name" ]; then

      echo "Deleting Service: $namespace/$name"

      kubectl delete svc "$name" \
        -n "$namespace" \
        --ignore-not-found=true \
        --wait=true || true

    fi

done

# ------------------------------------------------------------
# 6. Delete Kubernetes Ingress resources
# ------------------------------------------------------------

echo ""
echo "Deleting Kubernetes Ingress resources..."

kubectl delete ingress --all -A \
  --ignore-not-found=true \
  --wait=true || true

# ------------------------------------------------------------
# 7. Wait for Load Balancers in this EKS VPC
# ------------------------------------------------------------

echo ""
echo "Waiting for Load Balancers to disappear..."

for i in {1..60}; do

  LB_COUNT=$(aws elbv2 describe-load-balancers \
    --region "$REGION" \
    --query "length(LoadBalancers[?VpcId=='$VPC_ID'])" \
    --output text 2>/dev/null || echo "0")

  echo "Check $i/60 - Load Balancers remaining: $LB_COUNT"

  if [ "$LB_COUNT" = "0" ]; then
    echo "No Load Balancers remain."
    break
  fi

  sleep 10

done

# ------------------------------------------------------------
# 8. Wait for network interfaces in this VPC
# ------------------------------------------------------------

echo ""
echo "Waiting for AWS network interfaces to disappear..."

for i in {1..60}; do

  ENI_COUNT=$(aws ec2 describe-network-interfaces \
    --region "$REGION" \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query 'length(NetworkInterfaces)' \
    --output text 2>/dev/null || echo "0")

  echo "Check $i/60 - ENIs remaining: $ENI_COUNT"

  if [ "$ENI_COUNT" = "0" ]; then
    echo "No network interfaces remain."
    break
  fi

  sleep 10

done

# ------------------------------------------------------------
# 9. Show anything still remaining
# ------------------------------------------------------------

echo ""
echo "=============================================="
echo " FINAL AWS CHECK"
echo "=============================================="

echo ""
echo "Remaining Load Balancers:"

aws elbv2 describe-load-balancers \
  --region "$REGION" \
  --query "LoadBalancers[?VpcId=='$VPC_ID'].{Name:LoadBalancerName,Type:Type,State:State.Code}" \
  --output table || true

echo ""
echo "Remaining Network Interfaces:"

aws ec2 describe-network-interfaces \
  --region "$REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'NetworkInterfaces[].{ENI:NetworkInterfaceId,Type:InterfaceType,Status:Status,Description:Description}' \
  --output table || true

# ------------------------------------------------------------
# 10. Terraform destroy
# ------------------------------------------------------------

echo ""
echo "=============================================="
echo " AWS/KUBERNETES CLEANUP FINISHED"
echo "=============================================="
echo ""

echo "Starting Terraform destroy..."

terraform destroy -auto-approve

echo ""
echo "=============================================="
echo " DESTROY COMPLETE"
echo "=============================================="
echo ""
