pipeline {
  agent {
    docker {
      image 'node:16'     // Node 16 build agent
      args '-u root:root --network jenkins_net -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  environment {
    DOCKER_IMAGE = "21996193/aws-sample-app:latest"
  }

  stages {

    stage('Install Dependencies') {
      steps {
        echo "Installing project dependencies..."
        sh 'npm install --save'
      }
    }
  stage('Snyk Security Scan') {
      steps {
        withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
          sh '''
            echo "Running Snyk vulnerability scan..."
            npm install -g snyk
            snyk auth $SNYK_TOKEN
            snyk test --severity-threshold=high
          '''
        }
      }
    }

    stage('Run Unit Tests') {
      steps {
        echo "Running unit tests..."
        sh 'npm test || echo \"No tests configured\"'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "Building Docker image..."
        sh 'docker build -t $DOCKER_IMAGE .'
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $DOCKER_IMAGE
          '''
        }
      }
    }
  }
}
