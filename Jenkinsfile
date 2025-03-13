pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['START', 'STOP', 'REMOVE'], description: 'Wählen Sie die gewünschte Aktion aus')
    }

    stages {
        stage('Docker Action') {
            steps {
                script {
                    def containerId = ''

                    // Wenn die Aktion 'START' gewählt wird, neuen Container starten
                    if (params.ACTION == 'START') {
                        echo "Starte neuen Docker-Container mit dem Image pipeline-1-webapp..."
                        containerId = sh(script: "docker run -d pipeline-1-webapp", returnStdout: true).trim()
                        echo "Neuer Container gestartet mit ID: ${containerId}"
                        echo 'Ok - Container erfolgreich gestartet.'
                    } 
                    else {
                        // Überprüfen, ob ein Container bereits läuft
                        containerId = sh(script: "docker ps -q -f name=pipeline-1-webapp", returnStdout: true).trim()
                        if (!containerId) {
                            error("Kein laufender Container mit dem Namen 'pipeline-1-webapp' gefunden. Bitte starten Sie den Container zuerst.")
                        }
                    }

                    // Ausführen der ausgewählten Aktion
                    switch(params.ACTION) {
                        case 'STOP':
                            def stopResult = sh(script: "docker stop ${containerId}", returnStatus: true)
                            if (stopResult == 0) {
                                echo 'Ok - Container erfolgreich gestoppt.'
                            } else {
                                echo 'Nicht Ok - Container konnte nicht gestoppt werden.'
                            }
                            break

                        case 'REMOVE':
                            def stopResult = sh(script: "docker stop ${containerId}", returnStatus: true)
                            if (stopResult != 0) {
                                echo 'Container konnte nicht gestoppt werden.'
                            }
                            def removeResult = sh(script: "docker rm ${containerId}", returnStatus: true)
                            if (removeResult == 0) {
                                echo 'Ok - Container erfolgreich gelöscht.'
                            } else {
                                echo 'Nicht Ok - Container konnte nicht gelöscht werden.'
                            }
                            break

                        default:
                            echo 'Ungültige Aktion gewählt. Bitte wählen Sie START, STOP oder REMOVE.'
                    }
                }
            }
        }
    }
}
