pipeline { 
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/sufyanhanif/jenkins.git', branch: 'main'
            }
        }

        stage('Prepare Scripts') {
            steps {
                sh 'chmod +x smoke.sh acceptance.sh'
            }
        }

        stage('Staging') {
            steps {
                sh './smoke.sh'
                sh './acceptance.sh'
            }
        }
    }

    post {
        success {
            echo 'Pipeline sukses!'
        }
        failure {
            echo 'Pipeline gagal.'
        }
    }
}
