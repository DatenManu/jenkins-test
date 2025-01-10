pipeline {
    agent any
    environment {
        PROJECT_NAME = "pipeline-${BUILD_ID}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Prepare index.html') {
            steps {
                sh '''
                sed -i "s|{{BUILD_ID}}|${BUILD_ID}|g" index.html
                '''
            }
        }
        stage('Cleanup Existing Containers') {
            steps {
                sh '''
                docker-compose -f docker-compose.yml -p ${PROJECT_NAME} down || true
                '''
            }
        }
        stage('Build Docker Image') {
            steps {
                sh '''
                docker-compose -f docker-compose.yml -p ${PROJECT_NAME} build
                '''
            }
        }
        stage('Deploy Docker Containers') {
            steps {
                sh '''
                docker-compose -f docker-compose.yml -p ${PROJECT_NAME} up -d
                '''
            }
        }
        stage('Get Webapp Port') {
            steps {
                script {
                    def containerId = sh(script: "docker ps -qf name=${PROJECT_NAME}_webapp", returnStdout: true).trim()
                    if (!containerId) {
                        error "Container ID for webapp not found!"
                    }
                    def port = sh(script: "docker inspect --format='{{(index (index .NetworkSettings.Ports \"80/tcp\") 0).HostPort}}' ${containerId}", returnStdout: true).trim()
                    echo "Webapp is running on host port: ${port}"
                }
            }
        }
    }
    post {
        always {
            echo 'No cleanup is performed in this pipeline. Containers will remain running.'
        }
    }
}
