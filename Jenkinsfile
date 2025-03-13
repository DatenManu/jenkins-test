pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['START', 'STOP', 'REMOVE'], description: 'Wählen Sie die gewünschte Aktion aus')
    }

    stages {
        stage('Docker Action') {
            steps {
                script {
                    // Die Container-ID wird aus einem lokalen Status gespeichert oder ermittelt.
                    def containerId

                    // Versuchen Sie, den Container beim Starten zu starten
                    if (params.ACTION == 'START') {
                        echo 'Starte neuen Docker-Container mit dem Image pipeline-1-webapp...'
                        containerId = sh(script: "docker run -d pipeline-1-webapp", returnStdout: true).trim()
                        echo "Neuer Container gestartet mit ID: ${containerId}"
                        echo 'Ok - Container erfolgreich gestartet.'
                    } 
                    else {
                        // Wenn nicht gestartete ContainerID, dann überprüfen ob der Container existiert
                        containerId = sh(script: "docker ps -q -f name=pipeline-1-webapp", returnStdout: true).trim()
                        if (!containerId) {
                            error("Kein laufender Container mit dem Namen 'pipeline-1-webapp' gefunden.")
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
                            // Stellen sicher, dass der Container gestoppt ist, bevor er gelöscht wird
                            def stopResult = sh(script: "docker stop ${containerId}", returnStatus: true)
                            if (stopResult != 0) {
                                echo 'Container konnte nicht gestoppt werden, eventuell bereits gestoppt oder nicht vorhanden.'
                                echo 'Versuche, Container trotzdem zu löschen.'
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
