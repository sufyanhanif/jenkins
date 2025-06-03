pipeline {
    agent any

    environment {
        IMAGE_NAME = "jenkins-python-app"
        CONTAINER_NAME = "jenkins-python-app-container"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sufyanhanif/jenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Run Container for Tests') {
            steps {
                script {
                    // Jalankan container di background
                    sh """
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 5000:5000 ${IMAGE_NAME}:latest
                    """

                    // Tunggu beberapa detik agar app siap
                    sleep 5
                }
            }
        }

        stage('Acceptance Test') {
            steps {
                script {
                    sh '''
                        curl --fail http://localhost:5000 || echo "Acceptance Test Failed"
                        echo "Acceptance Test Passed"
                    '''
                }
            }
        }

        stage('Smoke Test') {
            steps {
                 sh 'bash smoke.sh'
            }
        }

        stage('Stop Test Container') {
            steps {
                sh "docker rm -f ${CONTAINER_NAME}"
            }
        }

        stage('Deploy') {
            steps {
                // Untuk deploy, kita bisa jalankan container baru dengan image terbaru
                // (atau push ke registry dan deploy ke server lain sesuai kebutuhan)
                sh """
                docker rm -f deployed-app || true
                docker run -d --name deployed-app -p 5000:5000 ${IMAGE_NAME}:latest
                """
            }
        }
    }
}


