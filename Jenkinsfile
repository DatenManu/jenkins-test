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
                    
                    // Aktionen basierend auf den Parametern
                    if (params.ACTION == 'START') {
                        echo "Starte neuen Docker-Container mit dem Image pipeline-1-webapp..."
                        // Starten Sie den Container und speichern Sie die ID
                        containerId = sh(script: "docker run -d --name pipeline-1-webapp pipeline-1-webapp", returnStdout: true).trim()
                        echo "Neuer Container gestartet mit ID: ${containerId}"
                        echo 'Ok - Container erfolgreich gestartet.'
                    } 
                    else {
                        // Überprüfen Sie, ob der Container mit dem Namen bereits läuft
                        containerId = sh(script: "docker ps -q -f name=pipeline-1-webapp", returnStdout: true).trim()
                        if (!containerId) {
                            // Überprüfen, ob der Container gestoppt, aber existiert
                            containerId = sh(script: "docker ps -aq -f name=pipeline-1-webapp", returnStdout: true).trim()
                            if (!containerId) {
                                error("Kein Container mit dem Namen 'pipeline-1-webapp' gefunden. Bitte starten Sie den Container zuerst.")
                            } else {
                                echo "Der Container mit dem Namen 'pipeline-1-webapp' existiert, ist aber gestoppt."
                                echo "Sie können ihn starten oder entfernen."
                                currentBuild.result = 'UNSTABLE' // Setvet den Status der Build-Pipeline auf UNSTABLE
                                return // Stoppt die weitere Ausführung
                            }
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
