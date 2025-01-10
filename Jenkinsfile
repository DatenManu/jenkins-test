pipeline {
    agent any

    environment {
        IMAGE_NAME = "webapp"
        PROJECT_NAME = "pipeline-${BUILD_ID}"
    }

    stages {
        stage('Prepare index.html') {
            steps {
                sh 'echo "Pipeline Build ${BUILD_ID}" > index.html'
            }
        }
        stage('Cleanup Existing Containers') {
            steps {
                sh 'docker-compose -p ${PROJECT_NAME} down || true'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker-compose -p ${PROJECT_NAME} build'
            }
        }
        stage('Deploy Docker Containers') {
            steps {
                sh 'docker-compose -p ${PROJECT_NAME} up -d'
            }
        }
        stage('Get Container Ports') {
            steps {
                script {
                    def webappPort = sh(
                        script: "docker ps --filter 'name=${PROJECT_NAME}_webapp' --format '{{.ID}}' | xargs docker inspect --format='{{(index (index .NetworkSettings.Ports \"80/tcp\") 0).HostPort}}'",
                        returnStdout: true
                    ).trim()
                    echo "Webapp is running on: http://localhost:${webappPort}"

                    def mariadbPort = sh(
                        script: "docker ps --filter 'name=${PROJECT_NAME}_mariadb' --format '{{.ID}}' | xargs docker inspect --format='{{(index (index .NetworkSettings.Ports \"3306/tcp\") 0).HostPort}}'",
                        returnStdout: true
                    ).trim()
                    echo "MariaDB is accessible on: localhost:${mariadbPort}"

                    def redisPort = sh(
                        script: "docker ps --filter 'name=${PROJECT_NAME}_redis' --format '{{.ID}}' | xargs docker inspect --format='{{(index (index .NetworkSettings.Ports \"6379/tcp\") 0).HostPort}}'",
                        returnStdout: true
                    ).trim()
                    echo "Redis is accessible on: localhost:${redisPort}"
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline complete. Containers will remain running.'
        }
    }
}
