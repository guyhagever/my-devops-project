# My DevOps Project

This project demonstrates a comprehensive DevOps pipeline that integrates containerization, infrastructure provisioning, configuration management, CI/CD automation, monitoring, and more.

## Technologies Used

- **Docker / Docker Compose:** Containerization and orchestration.
- **Kubernetes (kubeadm):** Deployment and management of containerized applications.
- **Jenkins:** CI/CD automation.
- **Terraform:** Infrastructure as Code.
- **Ansible:** Configuration management.
- **HashiCorp Vault:** Secrets management.
- **Prometheus & Grafana:** Monitoring and observability.
- **WordPress:** Example application.

## Repository Structure

- **docker/**  
  Contains Dockerfiles, docker-compose.yml, and other container-related assets.  
  *See [docker/README.md](docker/README.md) for details.*

- **k8s/**  
  Kubernetes manifests and deployment instructions.  
  *See [k8s/README.md](k8s/README.md) for details.*

- **terraform/**  
  Infrastructure-as-Code examples using Terraform.  
  *See [terraform/README.md](terraform/README.md) for details.*

- **ansible/**  
  Ansible playbooks, roles, and inventories for configuration management.  
  *See [ansible/README.md](ansible/README.md) for details.*

- **jenkins/**  
  Contains the Jenkins pipeline (Jenkinsfile) and related assets.  
  *The Jenkinsfile in the root demonstrates full CI/CD integration.*

- **vault/**  
  HashiCorp Vault policies and integration examples.  
  *See [vault/README.md](vault/README.md) for details.*

- **monitoring/**  
  Configuration for Prometheus, Grafana, and other observability tools.  
  *See [monitoring/README.md](monitoring/README.md) for details.*

- **scripts/**  
  Scripts to automate various tasks.  
  *See [scripts/README.md](scripts/README.md) for details.*

## Getting Started

1. **Prerequisites:**
   - Docker & Docker Compose
   - Kubernetes (kubeadm)
   - Jenkins (with required plugins)
   - Terraform
   - Ansible
   - HashiCorp Vault
   - Prometheus & Grafana
   - cURL (for health checks)

2. **Setup:**
   - Clone the repository:
     ```bash
     git clone https://github.com/guyhagever/my-devops-project.git
     cd my-devops-project
     ```
   - Adjust configuration files (e.g., Terraform `.tf` files, Ansible playbooks) in each module as needed.
   - Configure Jenkins credentials for Docker Hub and database secrets.

3. **Running the Pipeline:**
   - Trigger the Jenkins pipeline to execute the full CI/CD flow:
     - Infrastructure provisioning using Terraform
     - Configuration management with Ansible
     - Building and pushing Docker images
     - Deployment to Kubernetes
     - Post-deployment health checks

4. **Testing & Monitoring:**
   - Verify that the health endpoint returns HTTP status 200.
   - Monitor deployments via Prometheus & Grafana dashboards.

## Contributing

Contributions are welcome. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for more information.
