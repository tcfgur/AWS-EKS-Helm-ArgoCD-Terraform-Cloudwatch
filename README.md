# Guardian Professional Project

## Overview
The Guardian Professional Project is designed to provide a robust infrastructure and application setup using modern cloud-native technologies. This project integrates Terraform for infrastructure management, ArgoCD for continuous deployment, Helm charts for application deployment, and a modular application structure.


## Project Structure
- *Terraform*: Manages cloud resources, ensuring infrastructure is provisioned in a consistent and repeatable manner.
- *ArgoCD*: Used for deploying applications in a Kubernetes environment in an automated and declarative manner.
- *Helm*: Facilitates the package management of Kubernetes applications, making it easy to deploy and manage applications.
- *app*: Contains the application code, divided into frontend and backend services to support a microservices architecture.

## Components

### Terraform
   - *.tf files: Define the infrastructure as code, including VPC, security groups, IAM roles, EKS cluster, RDS databases, and more.
   - Scripts like oidc-thumbprint.sh assist in setting up OIDC for the EKS cluster.

### ArgoCD
   - YAML configurations such as repo.yaml, backendjob.yaml, frontendjob.yaml, and serviceaccount.yaml to manage application deployment lifecycle through GitOps.
   - ArgoCD server deployment is handled using a Helm chart.

### Helm
   - Contains Helm charts for both frontend and backend components.
   - get_helm.sh: Script to install Helm, a package manager for Kubernetes.

### app
   - Divided into frontend and backend directories, housing the respective parts of the application, facilitating a microservices architecture.

## Deployment Instructions

### Terraform Setup
   - Navigate to the Terraform directory and initialize the Terraform environment.
   - Apply the Terraform configurations to set up the infrastructure.

### ArgoCD Setup
   - Set up ArgoCD in your Kubernetes cluster using the Helm chart.
   - Configure your repositories and deploy environments using ArgoCD for continuous deployment.

### Helm Deployment
   - Use the Helm charts to deploy your applications.
   - Customize the Helm values as per your environment and application needs.

### Running the Application
   - Ensure all services are properly configured and interconnected.
   - Verify deployments through ArgoCD’s dashboard.

## GitHub Actions Workflow

### UK Case Project CI/CD Workflow
  - *Trigger*: The workflow is triggered on a push to the main branch.
  - *Build*: Sets up the environment and builds the backend Docker image, which is then pushed to an AWS ECR repository. It also packages the backend using Helm and applies Terraform configurations.
  - *Deployment*: Depends on the build job. It updates the Kubernetes configuration, builds the frontend Docker image, packages it using Helm, and deploys it using ArgoCD.
- *Steps*:
  - Checkout code.
  - Setup Python 3.9.
  - Configure AWS credentials.
  - Login to AWS ECR.
  - Build and push Docker images.
  - Package and push Helm charts.
  - Initialize and apply Terraform.
  - Deploy jobs using ArgoCD.

## Additional Notes
- Ensure that all the prerequisites like Kubernetes cluster, Helm, and ArgoCD are set up before starting the deployment.
- Review and customize the configurations according to your organizational security policies and requirements.

This README provides a basic guide to navigating and using the Guardian Professional Project. For detailed instructions, refer to the specific documentation in each component directory.

