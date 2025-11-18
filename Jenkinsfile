pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        SONARQUBE = "MySonar"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')
        IMAGE_NAME = "anjali/poc6"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/anjalistssl/POC6.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonar') {
                    sh "mvn sonar:sonar"
                }
            }
        }

        stage('Dependency Check') {
            steps {
                sh 'dependency-check.sh --project poc6 --scan .'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t poc6-image .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image poc6-image'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                sh "docker tag poc6-image ${IMAGE_NAME}"
                sh "docker push ${IMAGE_NAME}"
            }
        }

        stage('Run Container') {
            steps {
                sh "docker run -d -p 8081:8080 ${IMAGE_NAME}"
            }
        }
    }
}
