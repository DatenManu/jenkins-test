pipeline {
    agent any

    environment {
        CONTAINER_ID = ''
    }

    stages {
        stage('Start Docker Container') {
            steps {
                script {
                    // Starten Sie den Docker-Container und erfassen Sie die Container-ID
                    def command = 'docker run -d pipeline-1-webapp'
                    echo "Executing command: ${command}"

                    // Fangen Sie die Ausgabe des Befehls ein
                    env.CONTAINER_ID = sh(script: command, returnStdout: true).trim()
                    echo "Container ID: ${env.CONTAINER_ID}"

                    // Überprüfen, ob der Container erfolgreich gestartet wurde
                    if (!env.CONTAINER_ID) {
                        error "Der Container konnte nicht gestartet werden. Überprüfen Sie das Docker-Image oder andere Probleme."
                    }
                }
            }
        }
        
        stage('Stop Docker Container') {
            steps {
                script {
                    // Stoppen Sie den Docker-Container
                    def response = sh(script: "docker stop ${env.CONTAINER_ID}", returnStatus: true)
                    if (response == 0) {
                        echo "Container ${env.CONTAINER_ID} wurde gestoppt: Ok"
                    } else {
                        echo "Container ${env.CONTAINER_ID} wurde gestoppt: Nicht Ok"
                    }
                }
            }
        }

        stage('Start Docker Container Again') {
            steps {
                script {
                    // Starten Sie den Docker-Container erneut
                    def response = sh(script: "docker start ${env.CONTAINER_ID}", returnStatus: true)
                    if (response == 0) {
                        echo "Container ${env.CONTAINER_ID} wurde gestartet: Ok"
                    } else {
                        echo "Container ${env.CONTAINER_ID} wurde gestartet: Nicht Ok"
                    }
                }
            }
        }

        stage('Remove Docker Container') {
            steps {
                script {
                    // Löschen Sie den Docker-Container
                    def response = sh(script: "docker rm ${env.CONTAINER_ID}", returnStatus: true)
                    if (response == 0) {
                        echo "Container ${env.CONTAINER_ID} wurde gelöscht: Ok"
                    } else {
                        echo "Container ${env.CONTAINER_ID} wurde gelöscht: Nicht Ok"
                    }
                }
            }
        }
    }
}
