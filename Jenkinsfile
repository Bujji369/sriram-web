def eksCluster="my-eks-cluster"
def region="ap-south-1"
def artifactName = "${env.BUILD_NUMBER}"
pipeline {
    tools {
        maven 'Maven3'
    }
    agent any
     environment {
        NEW_IMAGE_NAME = "srirammani/k8s_images:devlopment-${artifactName}"
        YAML_FILE_PATH = "sample-webapp.yml"
     }
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
		    withCredentials([string(credentialsId: 'dockerhubpwd', variable: 'dockerhubpwd')]) {
    			
		            
                    sh "docker login -u srirammani -p ${dockerhubpwd}"
		    sh "sleep 20s"
		    }
          
                  sh "docker push srirammani/k8s_images:devlopment-${artifactName}"	    
			   
		}
            }
	}
	stage('Chage Image in yaml') {
            steps {
                script {
                    // Update the .yaml file with the new image name
                    sh "sed -i 's#image:srirammani/k8s_images:*#image: $NEW_IMAGE_NAME#g' $YAML_FILE_PATH"
                    // Commit and push the changes (assuming you have Git configured)
                    sh "git add $YAML_FILE_PATH"
                    sh "git commit -m 'updated the image in YAML file'"
                    sh "git push origin master"  
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
