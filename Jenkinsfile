pipeline {
    agent none
    tools {
        maven "maven3.8.6"
    }
    
    environment {
        DOCKER_CREDS = credentials('dockerCred')
    }

    stages {
        stage('codeCheckout') {
            agent {
              label 'master'
            }
            steps {
                echo 'checking out code'
                git 'https://github.com/ContreecMulitilink/maven-web-application.git'
            }
        }
    
        stage('Build') {
            agent {
              label 'master'
            }
            steps {
                echo 'building bytecode'
                sh "mvn clean package"
            }
        }
        
        // stage('CodeQuality') {
        //     steps {
        //         echo 'code quality inspection'
        //         sh "mvn sonar:sonar"
        //     }
        // }
        
        stage('ImageBuild') {
            agent {
              label 'master'
            }
            steps {
                echo 'building docker image'
                echo "my build number is ${env.BUILD_NUMBER}"
                sh "docker build -t igbasanmi/tesla-web-app:${env.BUILD_NUMBER} ."
            }
        }
        
        stage('UploadImage') {
            agent {
              label 'master'
            }
            steps {
                // sh 'echo "SSH user is $DOCKER_CREDS_USR"'
                // sh 'echo "SSH passphrase is $SSH_CREDS_PSW"'
                // echo 'uploading image to registry'
                sh "docker login -u ${DOCKER_CREDS_USR} -p ${DOCKER_CREDS_PSW}"
                sh "docker push igbasanmi/tesla-web-app:${env.BUILD_NUMBER}"
            }
            
            post {
              always {
                sh 'docker logout'
                sh "docker rmi igbasanmi/tesla-web-app:${env.BUILD_NUMBER}"
              }
            }
        }
        
        stage('deploy2kubernetes') {
            agent {
              label 'master'
            }
            environment {
                KUBE_IMAGE="${env.BUILD_NUMBER}"  
            }
            steps {
                echo "deploying to k8s"
                sh 'sed -i "s/{{ IMAGE_TAG }}/$KUBE_IMAGE/g"'
                sh "kubectl apply -f deployment.yaml"
            }
            post{
                always {
                   cleanWs()
                } 
            }
        }
    }
}
