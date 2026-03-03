pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "bkkrish007/spotify-devops:v1"
        EC2_IP = "13.235.179.251"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/BK-KRISH/Spotify-Clone-DevOps.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@13.235.179.251 '
                    docker pull bkkrish007/spotify-devops:v1 &&
                    docker stop spotify || true &&
                    docker rm spotify || true &&
                    docker run -d -p 8081:80 --name spotify bkkrish007/spotify-devops:v1
                    '
                    """
                }
            }
        }
    }
}