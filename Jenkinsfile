  pipeline {

  environment {
    dockerimagename = "x3nomorpheus/api"
    dockerImage = ""
  }

  agent any

  stages {

    stage('Running phpunit tests') {
      agent {

      	docker { 
	  image 'php:8.0-apache'
 	}
      } 

      steps {
	  sh 'export HOME=code && curl -sS https://getcomposer.org/installer | php -- --install-dir=code/ --filename=composer'
	  sh 'cd code && php composer install --prefer-dist --no-scripts --no-dev --no-autoloader'
	  sh 'cd code && ./vendor/bin/phpunit --verbose '
      }
    }


    stage('Checkout Source') {
      steps {
        git 'https://github.com/x3nomorpheus/azure_test_api.git'
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhub-credentials'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
          }
        }
      }
    }

    stage('Deploying Php container to Kubernetes') {
      steps {
         sh 'ssh -i /home/jenkins/.ssh/id_rsa -o "StrictHostKeyChecking no" kio@workstation kubectl --kubeconfig /home/kio/k8s/azurek8s delete deployment php-staging || true'
	 sh 'ssh -i /home/jenkins/.ssh/id_rsa -o "StrictHostKeyChecking no" kio@workstation kubectl --kubeconfig /home/kio/k8s/azurek8s apply -f /home/kio/k8s/kubernetes-apps-staging/api.yaml'
      }
    }

  }

}
