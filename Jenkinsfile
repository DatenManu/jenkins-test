pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['START', 'STOP', 'REMOVE'], description: 'Wählen Sie die gewünschte Aktion aus')
        string(name: 'CONTAINER_ID', defaultValue: '', description: 'Geben Sie die Container-ID ein (gilt nur für STOP und REMOVE).')
    }

    stages {
        stage('Start Docker Container') {
            steps {
                script {
                    // Den Docker-Container starten und die Container-ID speichern
                    if (params.ACTION == 'START') {
                        echo 'Starte neuen Docker-Container mit dem Image pipeline-1-webapp...'
                        // Den Container starten und die ID ermitteln
                        def containerId = sh(script: "docker run -d pipeline-1-webapp", returnStdout: true).trim()
                        echo "Neuer Container gestartet mit ID: ${containerId}"
                        
                        // Container-ID für die spätere Verwendung speichern
                        currentBuild.displayName = "${containerId}" // Setzt den Jenkins Job-Namen auf die Container-ID

                    } else {
                        error("Bitte wählen Sie START, um einen neuen Container zu starten, bevor Sie STOP oder REMOVE ausführen.")
                    }
                }
            }
        }

        stage('Docker Action') {
            steps {
                script {
                    def containerId = currentBuild.displayName // Verwendung der gewählten Container-ID

                    switch(params.ACTION) {
                        case 'STOP':
                            def stopResult = sh(script: "docker stop ${containerId}", returnStatus: true)
                            if (stopResult == 0) {
                                echo 'Ok - Container gestoppt.'
                            } else {
                                echo 'Nicht Ok - Container konnte nicht gestoppt werden.'
                            }
                            break

                        case 'REMOVE':
                            // Stellen sicher, dass der Container gestoppt ist, bevor er gelöscht wird
                            def stopResult = sh(script: "docker stop ${containerId}", returnStatus: true)
                            if (stopResult != 0) {
                                echo 'Container konnte nicht gestoppt werden, eventuell bereits gestoppt oder nicht vorhanden.'
                            }

                            def removeResult = sh(script: "docker rm ${containerId}", returnStatus: true)
                            if (removeResult == 0) {
                                echo 'Ok - Container gelöscht.'
                            } else {
                                echo 'Nicht Ok - Container konnte nicht gelöscht werden.'
                            }
                            break

                        default:
                            echo 'Ungültige Aktion gewählt. Bitte wählen Sie STOP oder REMOVE.'
                    }
                }
            }
        }
    }
}
