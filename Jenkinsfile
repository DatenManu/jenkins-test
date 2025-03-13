pipeline {
    agent any

    environment {
        CONTAINER_ID = ''
    }

    stages {
        stage('Start Docker Container') {
            steps {
                script {
                    // Starten des Containers und Erfassen der Container-ID
                    def command = 'docker run -d pipeline-1-webapp'
                    env.CONTAINER_ID = sh(script: command, returnStdout: true).trim()
                    echo "Container ID: ${env.CONTAINER_ID}"

                    // Debugging: Überprüfen, ob der Container tatsächlich gestartet wurde
                    if (env.CONTAINER_ID == '') {
                        error "Der Container konnte nicht gestartet werden, die Container-ID ist leer."
                    }
                }
            }
        }
        
        stage('Stop Docker Container') {
            steps {
                script {
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
