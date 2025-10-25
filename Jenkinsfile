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
          docker run --rm -v %cd%:/app -w /app ghcr.io/cirruslabs/flutter:3.22.0 bash -c "flutter config --enable-web && flutter pub get && flutter build web --release"
        """
      }
    }

    stage('Smoke Test') {
      steps {
        echo ' Menjalankan smoke test...'
        bat 'bash test_smoke.sh'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo ' Membuat Docker Image...'
        bat "docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          bat """
            echo  Login ke Docker Hub...
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
        echo ' Men-deploy container menggunakan Docker Compose...'
        bat "docker-compose down || exit 0"
        bat "docker-compose up -d --build"
      }
    }

    stage('Expose via Ngrok') {
      steps {
        echo ' Mengekspos port 8080 ke internet dengan Ngrok...'
        bat "start /B ngrok http 8080"
        bat "timeout /t 5"
      }
    }

    stage('Verify Deployment') {
      steps {
        echo ' Verifikasi hasil deployment...'
        bat "docker ps"
      }
    }
  }

  post {
    success {
      echo ' Pipeline sukses — Flutter Web App berhasil dibangun dan di-deploy!'
    }
    failure {
      echo ' Pipeline gagal — periksa log setiap stage di Jenkins.'
    }
    always {
      echo ' Pipeline selesai dijalankan.'
    }
  }
}
