pipeline{
  agent any
  tools {
    maven 'Maven 3.6.2'
    jdk 'jdk8'
  }
  environment {
    CONFIGSERVER_URI = "http://configsvr:8888"
    EUREKASERVER_PORT = "8761"
    EUREKASERVER_URI = "http://eurekasvr:8761"
    PROFILE = "dev"
    CONFIGSERVER_PORT = "8888"
    CONFIGSERVER_PASSWORD = credentials('salonapi-configserver-password')
    ENCRYPT_KEY = credentials('salonapi-encryption-key')
  }
  stages {
    stage('Initialize') {
      steps {
        sh '''
          echo "PATH = ${PATH}"
          echo "M2_HOME = ${M2_HOME}"
        '''
      }
    }
    stage('Build') {
      steps {
        sh 'mvn install'
      }
    }
    stage('Make Container') {
      steps {
        sh """
          docker build -t willwbowen/salonapi-eurekasvr:${env.BUILD_ID} .
          docker tag willwbowen/salonapi-eurekasvr:${env.BUILD_ID} willwbowen/salonapi-eurekasvr:latest
        """
      }
    }
    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh """
            docker login -u ${USERNAME} -p ${PASSWORD}
            docker push willwbowen/salonapi-eurekasvr:${env.BUILD_ID}
            docker push willwbowen/salonapi-eurekasvr:latest
          """
        }
      }
    }
    stage('Deploy') {
      steps {
        sh """
          envsubst < ./k8s/deployment.yml | kubectl apply -f -
          envsubst < ./k8s/service.yml | kubectl apply -f -
        """
      }
    }
  }
  post {
    always {
      archiveArtifacts 'target/**/*.jar'
    }

  }
}
