# My DevOps Project

This project demonstrates a well-rounded DevOps pipeline using:
- Docker / Docker Compose
- Kubernetes (kubeadm)
- Jenkins
- Terraform
- Ansible
- HashiCorp Vault
- Prometheus & Grafana
- WordPress (as an example application)

## Repository Structure

- **docker/**  
  Dockerfiles, docker-compose.yml, and other container-related assets.

- **k8s/**  
  Kubernetes manifests and instructions for deploying to a kubeadm-based cluster.

- **terraform/**  
  Infrastructure-as-Code examples with Terraform.

- **ansible/**  
  Ansible playbooks, roles, and inventories for configuration management.

- **jenkins/**  
  Jenkins pipeline (Jenkinsfile) and possibly Dockerfiles/helm charts if you containerize Jenkins.

- **vault/**  
  HashiCorp Vault policies, placeholders, and integration examples.

- **monitoring/**  
  Prometheus, Grafana, and other observability config files.

- **scripts/**  
  Handy Bash/Python scripts that automate tasks.

Feel free to expand each folder with full configurations and adapt it to your needs!

## Getting Started

1. Install required tools (Docker, Docker Compose, Jenkins, Terraform, Ansible, Vault, etc.).
2. Adjust configuration in the `.tf`, `.yml`, `.yaml`, etc. files as needed.
3. Run your pipeline in Jenkins (or your chosen CI/CD tool).
4. Deploy and enjoy your WordPress site with best-practice DevOps approach.
