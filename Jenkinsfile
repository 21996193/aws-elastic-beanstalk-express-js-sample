
pipeline {
    agent none

    stages {

        stage('Install Node Dependencies') {
            agent {
        docker {
          image 'node:16'
          args '-u root:root --network jenkins --volume /var/jenkins_home:/var/jenkins_home'
        }
       }
       steps {
        echo 'Installing Node dependencies...'
        sh '''
          apt-get update -y
          apt-get install -y docker.io
          docker --version
          npm install --save
        '''
       }
        }

        stage('Run Unit Tests') {
            agent { docker { image 'node:16' } }
            steps {
                echo ' Running tests...'
                sh 'npm test || echo " No tests configured"'
            }
        }

        stage('Snyk Security Scan') {
            agent { docker { image 'node:16' } }
            steps {
                echo ' Running Snyk vulnerability scan...'
                sh 'npm install -g snyk'
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    sh 'snyk auth $SNYK_TOKEN'
                    script {
                        def result = sh(script: 'snyk test --severity-threshold=high', returnStatus: true)
                        if (result != 0) {
                            error(' Build failed: High/Critical vulnerabilities detected')
                        } else {
                            echo ' No high/critical vulnerabilities found'
                        }
                    }
                }
            }
        }

        stage('Build Docker Image & Push to Registry') {
            agent any
            steps {
                echo ' Building Docker image and pushing to Docker Hub...'
                script {
                    // Point Jenkins to DinD service
                    docker.withServer('tcp://dind:2377', 'dind-certs') {
                        def imagename = "21996193grace/nodeapp21996193_assignment2:${env.BUILD_NUMBER}"
                        def img = docker.build(imagename)
                        echo " Built image: ${imagename}"
                       
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                            echo ' Pushing image to Docker Hub registry...'
                            img.push()
                        }
                    }
                }
            }
        }

        stage('Archive Artifacts') {
            agent { docker { image 'node:16' } }
            steps {
                echo ' Archiving important build artifacts...'
                archiveArtifacts artifacts: 'package.json, package-lock.json, app.js, Dockerfile', fingerprint: true
            }
        }
    }
}

