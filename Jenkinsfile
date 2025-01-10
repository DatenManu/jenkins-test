pipeline {
    agent any
    environment {
        UNIQUE_BUILD_ID = "${BUILD_ID}-${env.BRANCH_NAME}" // Dynamische Namen für Container und Netzwerke
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Prepare index.html') {
            steps {
                sh 'sed -i s|{{BUILD_ID}}|${BUILD_ID}|g index.html'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh """
                docker-compose -f docker-compose.yml -p ${UNIQUE_BUILD_ID} build
                """
            }
        }
        stage('Deploy Docker Containers') {
            steps {
                sh """
                docker-compose -f docker-compose.yml -p ${UNIQUE_BUILD_ID} up -d
                """
            }
        }
        stage('Get Webapp Port') {
            steps {
                script {
                    def containerId = sh(script: "docker ps -qf name=${UNIQUE_BUILD_ID}_webapp", returnStdout: true).trim()
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

