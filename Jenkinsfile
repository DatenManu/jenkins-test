pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // 1. Code aus Git klonen (oder SVN, je nach SCM)
                checkout scm
            }
        }

        stage('Prepare index.html') {
            steps {
                // 2. Platzhalter '{{BUILD_ID}}' ersetzen durch Jenkins-Build-Nummer
                sh """
                    sed -i 's|{{BUILD_ID}}|${BUILD_NUMBER}|g' index.html
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                // 3. Docker-Compose Build
                sh 'docker-compose build'
            }
        }

        stage('Deploy Docker Containers') {
            steps {
                // 4. Docker-Compose Up
                sh 'docker-compose up -d'
            }
        }
    }
}
