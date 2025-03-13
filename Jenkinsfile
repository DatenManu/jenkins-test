pipeline {
    agent any

    parameters {
        string(name: 'CONTAINER_ID', defaultValue: '', description: 'ID des Docker-Containers')
        choice(name: 'ACTION', choices: ['START', 'STOP', 'REMOVE'], description: 'Aktion auswählen')
    }

    stages {
        stage('Validate Container ID') {
            steps {
                script {
                    def containerId = params.CONTAINER_ID
                    // Überprüfen, ob der Container existiert
                    if (containerId && !sh(script: "docker ps -a -q -f id=${containerId}", returnStdout: true).trim()) {
                        error("Container ID ist ungültig oder der Container existiert nicht.")
                    } else {
                        echo "Container ID ${containerId} ist gültig."
                    }
                }
            }
        }

        stage('Docker Action') {
            steps {
                script {
                    def containerId = params.CONTAINER_ID
                    def action = params.ACTION
                    
                    switch(action) {
                        case 'START':
                            def startResult = sh(script: "docker start ${containerId}", returnStatus: true)
                            if (startResult == 0) {
                                echo 'Ok'
                            } else {
                                echo 'Nicht Ok'
                            }
                            break

                        case 'STOP':
                            def stopResult = sh(script: "docker stop ${containerId}", returnStatus: true)
                            if (stopResult == 0) {
                                echo 'Ok'
                            } else {
                                echo 'Nicht Ok'
                            }
                            break

                        case 'REMOVE':
                            // Zuerst sicherstellen, dass der Container gestoppt ist, bevor er gelöscht wird
                            def stopBeforeRemove = sh(script: "docker stop ${containerId}", returnStatus: true)
                            if (stopBeforeRemove != 0) {
                                echo 'Container konnte nicht gestoppt werden, eventuell bereits angehalten oder nicht vorhanden.'
                            }

                            def removeResult = sh(script: "docker rm ${containerId}", returnStatus: true)
                            if (removeResult == 0) {
                                echo 'Ok'
                            } else {
                                echo 'Nicht Ok'
                            }
                            break

                        default:
                            echo 'Ungültige Aktion gewählt.'
                    }
                }
            }
        }
    }
}
