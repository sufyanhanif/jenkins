pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/sufyanhanif/jenkins.git', branch: 'main'
            }
        }

        stage('Staging') {
            steps {
                echo 'Running staging tests...'

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
