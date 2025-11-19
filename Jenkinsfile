pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        SONARQUBE = "MySonar"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')
        IMAGE_NAME = "anjalitssl/poc6"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-cred',
                    url: 'https://github.com/anjalitssl/POC6.git'
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
                    sh """
                    mvn sonar:sonar \
                      -Dsonar.projectKey=poc6 \
                      -Dsonar.projectName=poc6 \
                      -Dsonar.sources=src/main/java
                    """
                }
            }
        }

        stage('Dependency Check') {
            steps {
                sh '''
                   mvn org.owasp:dependency-check-maven:check \
                   -Dformat=ALL \
                   -Danalyzer.nvd.api.enabled=false \
                   -Danalyzer.nvd.api.delay=0 \
                   -DfailOnError=false \
                   -DfailBuildOnAnyVulnerability=false
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t poc6-image .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image poc6-image || true'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh """
                echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                docker tag poc6-image ${IMAGE_NAME}
                docker push ${IMAGE_NAME}
                """
            }
        }

        stage('Run Container') {
            steps {
                sh "docker run -d -p 8081:8080 ${IMAGE_NAME}"
            }
        }
    }
}
