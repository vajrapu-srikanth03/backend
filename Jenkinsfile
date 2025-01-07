pipeline {
    agent any
    // agent {
    //     label 'AGENT-1' // this will run on specific agent
    // }
    tools {
        nodejs 'nodejs20' // nodejs version 20
        git 'git' // git tool
        //snyk 'snyk' // snyk tool
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
        //retry(1)
    }
    environment {
        DEBUG='true'
        appVersion=''  // this will become global, we can use across pipeline
        region='us-east-1'
        account_id='608782704145'
        project='expense'
        environment='dev'
        component = 'backend'
        //SONAR_HOME= tool 'sonar-6.2' // scanner configuration servername and scanner name both should be same
        //PATH = "/usr/bin:${env.PATH}"  // Force the pipeline to use /usr/bin/git
    
    }
    stages {
        stage('clean workspace') {
            steps {
                // Clean the workspace before starting the build
                cleanWs()
            }
        }
        stage('checkout') {
            steps {
                // for public repository
                git branch: 'main', url: 'https://github.com/vajrapu-srikanth03/backend.git'
                // for private repository
                // git branch: 'main', credentialsId: 'github-auth', url: 'https://github.com/vajrapu-srikanth03/backend.git'
            }
        }
        stage('Read the version') {
            steps {
                script {
                    def props = readJSON file: 'package.json'
                    appVersion = props.version
                    echo "App version: ${appVersion}"
                }
            }
        }        
        // stage('SonarQube Code Analysis'){
        //     steps{
        //          // sonar server injection
        //         withSonarQubeEnv('sonar-6.2'){
        //             sh '$SONAR_HOME/bin/sonar-scanner'
        //             //generic scanner, it automatically understands the language and provide scan results
        //         }
        //     }
        // }
        // stage('Quality Gate') {
        //     steps {
        //       timeout(time: 5, unit: 'MINUTES') {
        //         waitForQualityGate abortPipeline: true, credentialsId: 'Sonar-token'
        //       }
        //     }
        // }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        // stage("OWASP Dependency Check"){
        //     steps{
        //         dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
        //         dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        //     }
        // }
        // stage("Dependency Check using Snyk"){
        //     steps{
        //         snykSecurity(
        //             organisation: 'vajrapu-srikanth03',
        //             projectName: 'backend',
        //             snykInstallation: 'snyk',
        //             snykTokenId: 'snyk-token',
        //             targetFile: 'package.json',
        //         )
        //     }
        // }
        stage("Trivy filesystem Scan"){
            steps{
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }

        stage('Build') {
            steps {
                script {
                    // Transpile TypeScript, bundle with Webpack, or other build tools
                    sh 'npm run build'
                }
            }
        }
        stage('Docker build') {
            steps {
                sh 'docker build -t srikanthhg/$JOB_BASE_NAME:${appVersion} .'
                }
        }
        stage('Image scan') {
            steps {
                //sh 'trivy image --format template --template "@contrib/gitlab.tpl" -o container-scanning-report.html srikanthhg/backend:${appVersion}'
                sh 'trivy image --format table srikanthhg/$JOB_BASE_NAME:${appVersion}'
            }
        }
        // stage('push image to dockerhub') {
        //     steps {
        //         sh 'docker push srikanthhg/$JOB_BASE_NAME:${appVersion}'
        //     }
        // }
        // stage('push image to AWS ECR') {
        //     steps {
        //         withAWS(region: 'us-east-1', credentials: 'aws-ecr') {
        //             sh 'aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.us-east-1.amazonaws.com'
        //             sh 'docker tag srikanthhg/$JOB_BASE_NAME:${appVersion} ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/$JOB_BASE_NAME:${appVersion}'
        //             sh 'docker push ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/$JOB_BASE_NAME:${appVersion}'
        //         }
        //     }
        // }
        // stage('push image to Azure ACR') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'azure-acr', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        //         }
        //     }
        // }
        
    }
    post {
        always{
            echo "This sections runs always"
            //deleteDir()
        }
        success{
            echo "This section run when pipeline success"
        }
        failure{
            echo "This section run when pipeline failure"
        }
    }

}