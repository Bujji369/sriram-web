def eksCluster="my-eks-cluster"
def region="ap-south-1"
def artifactName = "${env.BUILD_NUMBER}"
pipeline {
    tools {
        maven 'Maven3'
    }
    agent any
    stages {
        stage('Git Clone') {
            steps {
			   script {

               git 'https://github.com/Bujji369/sriram-web.git'

			   }
            }
        }
	stage('compile') {
            steps {
                sh 'mvn -B -DskipTests clean compile'
            }
        }
        stage('Build') {
            steps {
                sh "mvn -B -e package -DskipTests"
            }
        }
        stage('Docker Image Build') {
            steps {
                sh "docker build -t srirammani/k8s_images:devlopment-${artifactName} ."
         }
        }
        stage('Image upload DockerHub') {
            steps {
		script {
			   
                   withDockerRegistry([ credentialsId: "docker_hub_Id", url: "https://hub.docker.com/" ]) {
            
                    sh "docker login -u srirammani -p ${DOCKERHUB}"
		    sh "sleep 20s"
		    }
          
                  sh "docker push srirammani/k8s_images:devlopment-${artifactName}"	    
			   
		}
            }
	}
        stage('Integrate Jenkins with EKS Cluster and Deploy App') {
            steps {
                withAWS(credentials: 'aws_Credentials_Id', region: '${region}') {
                  script {
                    sh ('aws eks update-kubeconfig --name ${eksCluster} --region ${region}')
                    sh "kubectl apply -f sample-webapp.yml"
		    sh "sleep 20s"
                }
                }
        }
    }
    }
}
