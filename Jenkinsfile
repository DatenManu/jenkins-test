pipeline {
    agent any

    parameters {
        string(name: 'API_KEY', defaultValue: '', description: 'API key to access the pipeline and API')
        string(name: 'name', defaultValue: '', description: 'Name of client that is created')
    }

    environment {
        IMAGE_NAME = "dynamic-index"
        PROJECT_NAME = "pipeline-${BUILD_ID}"
        WEB_API_URL = "http://192.168.56.1:3000/api/docker/created"
    }
    
    stages {
        stage('Validate API Key') {
            steps {
                script {
                    if (!params.API_KEY) {
                        error("API key is required to start the pipeline.")
                    }
                }
            }
        }
        
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
                def containerID = sh(
                    script: "docker ps --filter 'name=${PROJECT_NAME}_webapp' --format '{{.ID}}'",
                    returnStdout: true
                ).trim()
                def containerStatus = containerID ? "running" : "stopped"
                def jsonData = "{ \"containerId\": \"${containerID}\", \"status\": \"${containerStatus}\", \"containerName\": \"${params.name}\" }"
                sh "curl -X POST -H 'Content-Type: application/json' -H 'x-api-key: ${params.API_KEY}' -d '${jsonData}' ${WEB_API_URL}"
                echo 'Pipeline complete. Containers will remain running.'
            }
        }
    }
}
