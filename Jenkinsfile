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
          // запускаем контейнер и выполняем pytest, сохраняя junit xml в workspace
          image.inside("-u root") {
            // убедимся, что pytest установлен (в образе должен быть)
            sh 'pytest --junitxml=pytest-report.xml --maxfail=1 -q'
            // скопируем файл (он уже в workspace внутри контейнера)
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
