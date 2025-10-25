pipeline {
  agent any

  environment {
    IMAGE_NAME = 'rakaganteng/flutter-web-app'
    REGISTRY_CREDENTIALS = 'dockerhub-credentials'
  }

  stages {

    stage('Checkout') {
      steps {
        echo 'Checkout source code dari GitHub...'
        checkout scm
      }
    }

    stage('Build Flutter Web') {
      steps {
        bat '''
          echo ===== MULAI BUILD FLUTTER WEB =====
          docker run --rm -v %cd%:/app -w /app cirrusci/flutter:stable bash -c "flutter config --enable-web && flutter build web --release"
        '''
      }
    }

    stage('Smoke Test') {
      steps {
        bat '''
          echo ===== MENJALANKAN SMOKE TEST =====
          bash test_smoke.sh || exit /b 1
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          bat """
            echo Login ke Docker Hub...
            docker login -u %USER% -p %PASS%
            docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} .
            docker logout
          """
        }
      }
    }

    stage('Push Docker Image') {
      when {
        expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
      }
      steps {
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          bat """
            echo Push ke Docker Hub...
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
        bat '''
          echo ===== DEPLOY VIA DOCKER COMPOSE =====
          docker-compose down || echo Tidak ada container lama
          docker-compose up -d
        '''
      }
    }

    stage('Verify Deployment') {
      steps {
        bat '''
          echo Menampilkan container yang berjalan:
          docker ps
        '''
      }
    }
  }

  post {
    success {
      echo ' Pipeline sukses — Flutter Web berhasil dibangun, dites, di-push, dan dijalankan.'
    }
    failure {
      echo ' Pipeline gagal — periksa log error pada tahapan sebelumnya.'
    }
    always {
      echo '🏁 Pipeline selesai dijalankan.'
    }
  }
}

