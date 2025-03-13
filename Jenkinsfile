pipeline {
    agent any

    // Definieren Sie eine Umgebungsvariable für die Container-ID
    environment {
        CONTAINER_ID = ''
    }

    stages {
        stage('Start Docker Container') {
            steps {
                script {
                    // Starten Sie den Container und speichern Sie die Container-ID in der Umgebungsvariable
                    env.CONTAINER_ID = sh(script: 'docker run -d pipeline-1-webapp', returnStdout: true).trim()
                    echo "Container ID: ${env.CONTAINER_ID}"
                }
            }
        }
        
        stage('Stop Docker Container') {
            steps {
                script {
                    // Verwenden Sie die gespeicherte Container-ID zum Stoppen des Containers
                    def response = sh(script: "docker stop ${env.CONTAINER_ID}", returnStatus: true)
                    if (response == 0) {
                        echo "Ok"
                    } else {
                        echo "Nicht Ok"
                    }
                }
            }
        }

        stage('Start Docker Container Again') {
            steps {
                script {
                    // Verwenden Sie die gespeicherte Container-ID zum Starten des Containers
                    def response = sh(script: "docker start ${env.CONTAINER_ID}", returnStatus: true)
                    if (response == 0) {
                        echo "Ok"
                    } else {
                        echo "Nicht Ok"
                    }
                }
            }
        }

        stage('Remove Docker Container') {
            steps {
                script {
                    // Verwenden Sie die gespeicherte Container-ID zum Löschen des Containers
                    def response = sh(script: "docker rm ${env.CONTAINER_ID}", returnStatus: true)
                    if (response == 0) {
                        echo "Ok"
                    } else {
                        echo "Nicht Ok"
                    }
                }
            }
        }
    }
}
