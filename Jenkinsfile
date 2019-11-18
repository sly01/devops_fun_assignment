podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'git', image: 'alpine/git', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'docker', image: 'docker',  ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'python', image: 'python:3.7-slim-buster', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'terraform', image: 'aerkoc/terraform:v0.0.1', command: 'cat', ttyEnabled: true),
  ],
  volumes: [
      hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
    ]
) {
    node('mypod') {
        stage('Clone repository') {
            container('git') {
                sh 'git clone -b master https://github.com/sly01/devops_fun_assignment.git'
            }
        }

        stage('Python Lambda Function Unit Tests') {
            container('python') {
                dir('devops_fun_assignment') {
                    sh 'pip install pytest'
                    sh 'pytest lambda_functions/hello1/main_test.py'
                    sh 'pytest lambda_functions/hello2/main_test.py'
                }
            }
        }

        stage('Package python package as zip') {
            container('terraform') {
                dir('devops_fun_assignment') {
                    sh 'cd terraform && make package'
                }
            }
        }
    
        stage('Build Docker image for ECS and Push') {
            container('docker') {
                dir('devops_fun_assignment') {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding',
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_HUB_USER',
                        passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
                            sh """
                            docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
                            cd Docker && docker build -t aerkoc/nginx:v0.0.1 .
                            docker push aerkoc/nginx:v0.0.1
                            """
                    }
                }
            }   
        }

        stage('Terraform init') {
            container('terraform') {
                dir('devops_fun_assignment') {
                   withCredentials([[$class: 'UsernamePasswordMultiBinding',
                        credentialsId: 'awscreds',
                        usernameVariable: 'AWS_ACCESS_KEY',
                        passwordVariable: 'AWS_SECRET_KEY']]) {
                            sh """
                            export AWS_ACCESS_KEY=${AWS_ACCESS_KEY} AWS_SECRET_KEY=${AWS_SECRET_KEY}
                            cd terraform && make init
                            """
                    }
                }
            }
        }

        stage('Terraform Format/Linting') {
            container('terraform') {
                dir('devops_fun_assignment') {
                    sh 'cd terraform && make fmt'
                }
            }
        }

        stage('Terraform Validate') {
            container('terraform') {
                dir('devops_fun_assignment') {
                    sh 'cd terraform && make validate'
                }
            }
        }

        stage('Terraform Plan') {
            container('terraform') {
                dir('devops_fun_assignment') {
                    sh 'cd terraform && make plan'
                }
            }
        }

        stage('Approval') {
            timeout(time: 10, unit: 'MINUTES') {
                input message: "Does Plan look good?"
            }       
        }

        stage('Terraform Apply') {
            container('terraform') {
                dir('devops_fun_assignment') {
                    sh 'cd terraform && make apply'
                }
            }
        }    
    }
}