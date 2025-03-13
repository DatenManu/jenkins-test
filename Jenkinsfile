pipeline {
    agent any

    parameters {
        string(name: 'CONTAINER_ID', defaultValue: '', description: 'ID des Docker-Containers')
        choice(name: 'ACTION', choices: ['START', 'STOP', 'REMOVE'], description: 'Aktion auswählen')
    }

    stages {
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
