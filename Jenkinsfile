pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO = "554461595648.dkr.ecr.ap-south-1.amazonaws.com/devops-task"
        ECS_CLUSTER = "devops-task-cluster"
        ECS_SERVICE = "devops-task-app-service-potubetn"

        IMAGE_TAG = "${env.BUILD_NUMBER}"  // unique tag per build
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning GitHub repository...'
                git branch: 'main', url: 'https://github.com/shivam8001/devops_task.git'
            }
        }

       
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${ECR_REPO}:${IMAGE_TAG} ."
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to ECR...'
                sh "docker push ${ECR_REPO}:${IMAGE_TAG}"
            }
        }

        stage('Deploy to ECS') {
            steps {
                echo 'Deploying to ECS...'
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh """
                    aws ecs update-service \
                        --cluster ${ECS_CLUSTER} \
                        --service ${ECS_SERVICE} \
                        --force-new-deployment
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check console logs for details.'
        }
    }
}