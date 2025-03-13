pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['START', 'STOP', 'REMOVE'], description: 'Wählen Sie die gewünschte Aktion aus')
    }

    stages {
        stage('Docker Action') {
            steps {
                script {
                    // Variable für die Container-ID
                    def containerId = ''
                    
                    // Aktionen basierend auf den Parametern
                    if (params.ACTION == 'START') {
                        echo "Starte neuen Docker-Container mit dem Image pipeline-1-webapp..."
                        // Starten Sie den Container und speichern Sie die ID
                        containerId = sh(script: "docker run -d --name pipeline-1-webapp pipeline-1-webapp", returnStdout: true).trim()
                        echo "Neuer Container gestartet mit ID: ${containerId}"
                        echo 'Ok - Container erfolgreich gestartet.'
                    } 
                    else {
                        // Den Container mit dem Namen überprüfen, um die ID zu erhalten
                        containerId = sh(script: "docker ps -q -f name=pipeline-1-webapp", returnStdout: true).trim()
                        if (!containerId) {
                            error("Kein laufender Container mit dem Namen 'pipeline-1-webapp' gefunden. Bitte starten Sie den Container zuerst.")
                        }
                    }

                    // Ausführen der gewählten Aktion
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
                            // Stoppen Sie den Container, bevor Sie ihn löschen
                            sh(script: "docker stop ${containerId}", returnStatus: true)
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
