pipeline {
    agent any
    environment {
        IMAGE_NAME = "dynamic-index"
        PROJECT_NAME = "pipeline-${BUILD_ID}"
        WEB_API_URL = "http://example.com/api/endpoint" // Update with your actual API URL
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
        stage('Get Webapp Port') {
            steps {
                script {
                    def containerPort = sh(
                        script: "docker ps --filter 'name=${PROJECT_NAME}_webapp' --format '{{.ID}}' | xargs docker inspect --format='{{(index (index .NetworkSettings.Ports \"80/tcp\") 0).HostPort}}'",
                        returnStdout: true
                    ).trim()
                    echo "Webapp is running on: http://localhost:${containerPort}"
                }
            }
        }
    }
    post {
        always {
            script {
                // Get the container ID and status
                def containerID = sh(
                    script: "docker ps --filter 'name=${PROJECT_NAME}_webapp' --format '{{.ID}}'",
                    returnStdout: true
                ).trim()
                
                // Define the status based on whether the container ID is present
                def containerStatus = containerID ? "Started" : "Stopped"

                // Create JSON object with container status and ID
                def jsonData = JsonOutput.toJson([
                    containerId: containerID,
                    status     : containerStatus
                ])

                // Send POST request to the web API
                sh "curl -X POST -H 'Content-Type: application/json' -d '${jsonData}' ${WEB_API_URL}"

                echo 'Pipeline complete. Containers will remain running.'
            }
        }
    }
}
