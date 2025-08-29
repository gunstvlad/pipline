pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker image') {
      steps {
        script {
          // билдим образ из текущего workspace
          image = docker.build("my-sum:${env.BUILD_NUMBER}")
        }
      }
    }

    stage('Run tests inside image') {
      steps {
        script {
          image.inside("-u root") {
            // быстрый фикс: добавляем PYTHONPATH
            sh 'PYTHONPATH=. pytest --junitxml=pytest-report.xml --maxfail=1 -q'
          }
        }
      }
      post {
        always {
          junit 'pytest-report.xml'
        }
      }
    }

    stage('Archive artifact (optional)') {
      steps {
        archiveArtifacts artifacts: 'dist/**', allowEmptyArchive: true
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
