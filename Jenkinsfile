pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare index.html') {
            steps {
                sh 'sed -i "s|{{BUILD_ID}}|${BUILD_ID}|g" index.html'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Deploy Docker Containers') {
            steps {
                sh 'docker-compose up -d'
            }
        }

        stage('Get Webapp Port') {
            steps {
                script {
                    // Container-ID für die Webapp finden
                    def containerId = sh(script: "docker ps -qf 'name=my-webapp'", returnStdout: true).trim()
                    // Dynamischen Port der Webapp auslesen
                    def portInfo = sh(script: "docker inspect --format='{{(index (index .NetworkSettings.Ports \"80/tcp\") 0).HostPort}}' ${containerId}", returnStdout: true).trim()
                    echo "Webapp is running on host port: ${portInfo}"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker-compose down'
        }
    }
}

