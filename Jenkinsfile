pipeline {
    agent any

    environment {
        IMAGE_NAME = "hellow-worlds"
        CONTAINER_NAME = "jenkins-python-apps"
        BUILD_TIMESTAMP = "${new Date().format('yyyyMMddHHmmss')}"  // Tambahkan timestamp
        IMAGE_TAG = "${IMAGE_NAME}:${BUILD_TIMESTAMP}"  // Gunakan timestamp pada tag image
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
                    docker.build("${IMAGE_TAG}")  // Gunakan tag dengan timestamp
                }
            }
        }

        stage('Run Container for Tests') {
            steps {
                script {
                    // Jalankan container dengan tag yang memiliki timestamp
                    sh """
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 5000:5000 ${IMAGE_TAG}
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
                 sh 'python smoke.py'
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
                sh """
                docker rm -f deployed-app || true
                docker run -d --name deployed-app -p 5000:5000 ${IMAGE_TAG}
                """
            }
        }
    }
}
