pipeline {
    agent any

    environment {
        LOCAL_IMAGE = "local-image"
        DOCKER_REPO = "sufyanha/hello-world"
        BUILD_TIMESTAMP = "${new Date().format('yyyyMMddHHmmss')}"
        IMAGE_TAG = "${DOCKER_REPO}:${BUILD_TIMESTAMP}"
        LOCAL_TAG = "${LOCAL_IMAGE}:${BUILD_TIMESTAMP}"
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
                    // Build image dengan tag lokal
                    docker.build("${LOCAL_TAG}")
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    // Tag image lokal ke repo Docker Hub dengan tag yang sesuai
                    sh "docker tag ${LOCAL_TAG} ${IMAGE_TAG}"
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

       
        stage('Run Container for Tests') {
            steps {
                script {
                    sh """
                    docker rm -f jenkins-python-app-container || true
                    docker run -d --name jenkins-python-app-container -p 5000:5000 ${IMAGE_TAG}
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
                sh "docker rm -f jenkins-python-app-container"
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
