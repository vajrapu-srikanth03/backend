pipeline {
    agent any
    tools {
        // nodejs version 20
        nodejs 'nodejs20' 
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
        //retry(1)
    }
    environment {
        appVersion=''
        SONAR_HOME= tool 'Sonar-scanner'
    }
    stages {
        stage('clean workspace') {
            steps {
                // Clean before build
                cleanWs()
            }
        }
        // stage('checkout') {
        //     steps {
        //         // for public repository
        //         git branch: 'main', url: 'https://github.com/vajrapu-srikanth03/backend.git'
        //         // for private repository
        //         // git branch: 'main', credentialsId: 'github-auth', url: 'https://github.com/vajrapu-srikanth03/argocd-expense.git'
        //     }
        // }
        stage('Read the version') {
            steps {
                script {
                    def props = readJSON file: 'package.json'
                    appVersion = props.version
                    echo "App version: ${appVersion}"
                }
            }
        }        
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('SonarQube Code Analysis'){
            steps{
                withSonarQubeEnv('Sonar-scanner'){
                    sh '$SONAR_HOME/bin/sonar-scanner'
                }
            }
        }
        stage('Quality Gate') {
            steps {
              timeout(time: 5, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
              }
            }
        }
        stage("Trivy filesystem Scan"){
            steps{
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage("Dependency Check using Snyk"){
            steps{
                sh """
                snyk --version
                snyk auth $SNYK_TOKEN
                #snyk test it will fail the pipeline
                snyk monitor --org=vajrapu-srikanth02
                """
            }
        }
        stage('Docker build') {
            steps {
                sh 'docker build -t srikanthhg/$JOB_BASE_NAME:${appVersion}'
                }
        }
        stage('Image scan') {
            steps {
                sh 'trivy image  --format template --template "@contrib/gitlab.tpl" -o container-scanning-report.html srikanthhg/backend:${appVersion}'
            }
        } 
        
    }
    post {
        always{
            echo "This sections runs always"
            deleteDir()
        }
        success{
            echo "This section run when pipeline success"
        }
        failure{
            echo "This section run when pipeline failure"
        }
    }

}