pipeline {
  agent any

  environment {
    IMAGE_NAME = 'rakaganteng/flutter-web'
    REGISTRY_CREDENTIALS = 'dockerhub-credentials'
  }

  stages {

    stage('Checkout') {
      steps {
        echo ' Checkout source code dari GitHub...'
        checkout scm
      }
    }

    stage('Build Flutter Web') {
      steps {
        echo ' Membangun Flutter Web App...'
        bat """
          docker run --rm -v %cd%:/app -w /app cirrusci/flutter:stable bash -c "flutter config --enable-web && flutter build web --release"
        """
      }
    }

    stage('Smoke Test') {
      steps {
        echo ' Menjalankan smoke test...'
        bat 'bash test_smoke.sh || exit /b 1'
      }
    }

    stage('Build Docker Image') {
      steps {
        bat 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .'
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          bat """
            docker login -u %USER% -p %PASS%
            docker push ${IMAGE_NAME}:${BUILD_NUMBER}
            docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest
            docker push ${IMAGE_NAME}:latest
            docker logout
          """
        }
      }
    }

    stage('Deploy via Docker Compose') {
      steps {
        echo ' Menjalankan Docker Compose...'
        bat 'docker-compose up -d'
      }
    }

    stage('Expose via Ngrok') {
      steps {
        echo ' Membuka akses container melalui Ngrok...'
        bat 'start /B ngrok http 8080'
        bat 'timeout /t 5'
      }
    }

    stage('Verify Deployment') {
      steps {
        echo ' Verifikasi container dan endpoint...'
        bat 'docker ps'
      }
    }
  }

  post {
    success {
      echo ' Pipeline sukses! Aplikasi Flutter Web berhasil dibangun dan diekspos melalui Ngrok.'
    }
    failure {
      echo ' Pipeline gagal — periksa log error di tiap stage.'
    }
    always {
      echo ' Pipeline selesai dijalankan.'
    }
  }
}
