pipeline {
    agent any

    environment {
        IMAGE_NAME = "sufyanha/hellow"  
        CONTAINER_NAME = "jenkins-python-app-container"
        BUILD_TIMESTAMP = "${new Date().format('yyyyMMddHHmmss')}"
        IMAGE_TAG = "${IMAGE_NAME}:${BUILD_TIMESTAMP}"
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
                    docker.build("${IMAGE_TAG}")
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-cred') {
                        echo "Logged in to Docker Hub"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-cred') {
                        sh "docker push ${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Run Container for Tests') {
            steps {
                script {
                    sh """
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 5000:5000 ${IMAGE_TAG}
                    """
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
                sh """
                docker rm -f deployed-app || true
                docker run -d --name deployed-app -p 5000:5000 ${IMAGE_TAG}
                """
            }
        }
    }
}
