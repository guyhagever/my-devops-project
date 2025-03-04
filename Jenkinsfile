pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "guyhagever/my-devops-project:latest"
    K8S_SECRET_NAME = "wordpress-secrets"
  }
  options {
    // Fail fast if any stage exceeds its limits.
    skipDefaultCheckout(true)
    timeout(time: 1, unit: 'HOURS')
  }
  stages {
    stage('Checkout') {
      steps {
        echo "Checking out the repository..."
        git branch: 'master', url: 'https://github.com/guyhagever/my-devops-project.git'
      }
    }
    stage('Static Analysis') {
      steps {
        echo "Running static analysis on Terraform and Ansible files..."
        // Terraform static analysis is disabled for now.
        // Running ansible-lint with --exit-zero to ignore lint failures.
        dir('ansible') {
          sh 'ansible-lint --exit-zero playbook.yml'
        }
      }
    }
    // Terraform stages have been disabled temporarily.
    /*
    stage('Terraform Provisioning') {
      stages {
        stage('Terraform Init') {
          steps {
            dir('terraform') {
              echo "Initializing Terraform..."
              sh 'terraform init'
            }
          }
        }
        stage('Terraform Plan') {
          steps {
            dir('terraform') {
              echo "Planning Terraform deployment..."
              sh 'terraform plan'
            }
          }
        }
        stage('Terraform Apply') {
          steps {
            dir('terraform') {
              echo "Applying Terraform configuration..."
              sh 'terraform apply -auto-approve'
            }
          }
        }
      }
    }
    */
    stage('Ansible Configuration') {
      steps {
        dir('ansible') {
          echo "Running Ansible playbook..."
          sh 'ansible-playbook playbook.yml -i hosts.ini'
        }
      }
    }
    stage('Retrieve Secrets') {
      steps {
        script {
          echo "Retrieving credentials from Jenkins credentials store..."
          withCredentials([
            string(credentialsId: 'db-username', variable: 'DB_USER'),
            string(credentialsId: 'db-password', variable: 'DB_PASS')
          ]) {
            echo "Credentials retrieved."
            env.WORDPRESS_DB_USER = DB_USER
            env.WORDPRESS_DB_PASS = DB_PASS
          }
        }
      }
    }
    stage('Docker Build and Push') {
      stages {
        stage('Build Docker Image') {
          steps {
            script {
              echo "Building Docker image..."
              sh """
                cd docker
                docker build -t ${env.DOCKER_IMAGE} .
              """
            }
          }
        }
        stage('Push Docker Image') {
          steps {
            script {
              echo "Logging into Docker Hub and pushing image..."
              withCredentials([usernamePassword(
                credentialsId: 'dockerhub-credentials',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
              )]) {
                sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
              }
              sh "docker push ${env.DOCKER_IMAGE}"
            }
          }
        }
      }
    }
    stage('Kubernetes Deployment') {
      stages {
        stage('Create/Update K8s Secret') {
          steps {
            script {
              echo "Creating or updating Kubernetes secret..."
              def b64User = sh(script: "echo -n \"${env.WORDPRESS_DB_USER}\" | base64", returnStdout: true).trim()
              def b64Pass = sh(script: "echo -n \"${env.WORDPRESS_DB_PASS}\" | base64", returnStdout: true).trim()
              sh """
                cat <<EOF > /tmp/wordpress-secret.yaml
                apiVersion: v1
                kind: Secret
                metadata:
                  name: ${env.K8S_SECRET_NAME}
                type: Opaque
                data:
                  db-user: ${b64User}
                  db-pass: ${b64Pass}
                EOF
                kubectl apply -f /tmp/wordpress-secret.yaml
              """
            }
          }
        }
        stage('Deploy to Kubernetes') {
          steps {
            script {
              echo "Deploying application to Kubernetes..."
              sh 'kubectl apply -f k8s/'
            }
          }
        }
      }
    }
    stage('Post-Deployment Check') {
      steps {
        script {
          echo "Performing post-deployment health checks..."
          // Update this URL as needed for your environment.
          def response = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://10.0.2.15:30080/health", returnStdout: true).trim()
          if (response != "200") {
            error "Health check failed: expected 200 but got ${response}"
          }
          echo "Health check passed with status code ${response}"
        }
      }
    }
  }
  post {
    always {
      echo "Pipeline finished. Cleaning up or collecting logs if needed."
    }
    success {
      echo "Pipeline succeeded!"
    }
    failure {
      echo "Pipeline failed. Please review the logs for further details."
    }
  }
}
