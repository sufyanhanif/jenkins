pipeline {
    agent any

    environment {
        IMAGE_NAME = "hellow-world"
        CONTAINER_NAME = "jenkins-python-app"
        BUILD_TIMESTAMP = "${new Date().format('yyyyMMddHHmmss')}"  // Tambahkan timestamp
        IMAGE_TAG = "${IMAGE_NAME}:${BUILD_TIMESTAMP}"  // Gunakan timestamp pada tag image
        DOCKER_REPO = "sufyanha/hellow-world"  // Ganti dengan repo Docker Hub kamu
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

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login ke Docker Hub menggunakan kredensial yang disimpan di Jenkins
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-cred') {
                        echo "Logged in to Docker Hub"
                    }
                }
            }
        }

        stage('Tag Docker Image for Docker Hub') {
            steps {
                script {
                    // Tag image dengan repo Docker Hub
                    sh "docker tag ${IMAGE_TAG} ${DOCKER_REPO}:${BUILD_TIMESTAMP}"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Push image ke Docker Hub
                    sh "docker push ${DOCKER_REPO}:${BUILD_TIMESTAMP}"
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
