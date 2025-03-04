pipeline {
    agent any

    environment {
        // Docker image reference
        DOCKER_IMAGE = "my-registry/my-devops-project:latest"
        // The name for the k8s Secret we will create
        K8S_SECRET_NAME = "wordpress-secrets"
    }

    stages {

        stage('Checkout') {
            steps {
                // Checkout code
                git branch: 'master', url: 'https://github.com/guyhagever/my-devops-project.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Ansible Configuration') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook playbook.yml -i hosts.ini'
                }
            }
        }
        stage('Retrieve Secrets') {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'db-username', variable: 'DB_USER'),
                        string(credentialsId: 'db-password', variable: 'DB_PASS')
                    ]) {
                        echo "Retrieved DB credentials from Jenkins credentials."
                        env.WORDPRESS_DB_USER = DB_USER
                        env.WORDPRESS_DB_PASS = DB_PASS
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
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
                    // This uses a Jenkins credential with ID `dockerhub-credentials`
                    // that stores your DockerHub (or other registry) username/password
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

        // ---------------------------------------------------------------------
        // Create/Update Kubernetes Secret
        // ---------------------------------------------------------------------
        stage('Create/Update K8s Secret') {
            steps {
                script {
                    // We assume you have `kubectl` installed on the Jenkins agent
                    // and that your agent is already authenticated to the cluster (kubeconfig in place).
                    // We will create a K8s secret with base64-encoded credentials from
                    // the environment variables we stored after "Retrieve Secrets" stage.

                    def b64User = sh(
                        script: "echo -n \"${env.WORDPRESS_DB_USER}\" | base64",
                        returnStdout: true
                    ).trim()

                    def b64Pass = sh(
                        script: "echo -n \"${env.WORDPRESS_DB_PASS}\" | base64",
                        returnStdout: true
                    ).trim()

                    // We'll apply a Secret definition to K8s.
                    // The 'replace' strategy ensures it updates if it already exists.
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

        // ---------------------------------------------------------------------
        // Deploy to Kubernetes
        // ---------------------------------------------------------------------
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    /**
                     * In your k8s/wordpress-deployment.yaml, you can reference the above secret like this:
                     *
                     * env:
                     *   - name: WORDPRESS_DB_USER
                     *     valueFrom:
                     *       secretKeyRef:
                     *         name: wordpress-secrets
                     *         key: db-user
                     *   - name: WORDPRESS_DB_PASSWORD
                     *     valueFrom:
                     *       secretKeyRef:
                     *         name: wordpress-secrets
                     *         key: db-pass
                     *
                     * That way, your DB username/password are never hardcoded in the YAML or in Git.
                     */

                    sh 'kubectl apply -f k8s/'
                }
            }
        }

        // ---------------------------------------------------------------------
        // Post-Deployment Check
        // ---------------------------------------------------------------------
        stage('Post-Deployment Check') {
            steps {
                script {
                    echo "Performing post-deployment checks..."
                    // Example: Check if the WordPress service is responding
                    // sh "curl -I http://my-wordpress-service-url"
                }
            }
        }
    } // end stages

    post {
        always {
            echo "Pipeline finished. Cleaning up or collecting logs if needed."
        }
        success {
            echo "Pipeline succeeded!"
        }
        failure {
            echo "Pipeline failed. Check the logs for details."
        }
    }
}
