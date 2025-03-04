pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "guyhagever/my-devops-project:latest"
        K8S_SECRET_NAME = "wordpress-secrets"
    }

    stages {

        stage('Checkout') {
            steps {
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

        stage('Create/Update K8s Secret') {
            steps {
                script {
                    def b64User = sh(
                        script: "echo -n \"${env.WORDPRESS_DB_USER}\" | base64",
                        returnStdout: true
                    ).trim()

                    def b64Pass = sh(
                        script: "echo -n \"${env.WORDPRESS_DB_PASS}\" | base64",
                        returnStdout: true
                    ).trim()

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

                    sh 'kubectl apply -f k8s/'
                }
            }
        }

        stage('Post-Deployment Check') {
            steps {
                script {
                    echo "Performing post-deployment checks..."
                    sh "curl -I http://my-wordpress-service-url"
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
            echo "Pipeline failed. Check the logs for details."
        }
    }
}
