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
        echo ' Build Flutter Web menggunakan Docker Flutter image...'
        bat """
          docker run --rm -v %CD%:/app -w /app cirrusci/flutter:stable bash -c "flutter config --enable-web && flutter pub get && flutter build web --release"
        """
      }
    }

    stage('Smoke Test') {
      steps {
        echo ' Cek apakah hasil build web sudah ada...'
        bat """
          if exist build\\web\\index.html (
            echo Build Web OK 
          ) else (
            echo Build Web Gagal && exit /b 1
          )
        """
      }
    }

    stage('Build Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          bat """
            docker login -u %USER% -p %PASS%
            docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} .
            docker logout
          """
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          bat """
            docker login -u %USER% -p %PASS%
            docker push ${env.IMAGE_NAME}:${env.BUILD_NUMBER}
            docker tag ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ${env.IMAGE_NAME}:latest
            docker push ${env.IMAGE_NAME}:latest
            docker logout
          """
        }
      }
    }

    stage('Deploy via Docker Compose') {
      steps {
        echo ' Deploy aplikasi Flutter Web menggunakan docker-compose...'
        bat """
          docker compose down
          docker compose up -d
        """
      }
    }

    stage('Expose via Ngrok') {
      steps {
        echo ' Menjalankan Ngrok untuk expose port 8082 (Flutter Web)...'
        bat """
          taskkill /IM ngrok.exe /F >nul 2>&1
          start ngrok http 8082
          timeout /t 5 >nul
          curl http://127.0.0.1:4040/api/tunnels > ngrok.json
          type ngrok.json
        """
      }
    }

    stage('Verify Deployment') {
      steps {
        echo ' Verifikasi container aktif...'
        bat "docker ps"
      }
    }
  }

  post {
    success {
      echo ' Pipeline sukses — Flutter Web berhasil dibangun, di-push, dan di-deploy via Docker & Ngrok!'
    }
    failure {
      echo ' Pipeline gagal — cek error log di atas!'
    }
    always {
      echo ' Pipeline selesai dijalankan.'
    }
  }
}
