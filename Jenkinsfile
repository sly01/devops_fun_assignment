podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'git', image: 'alpine/git', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'python', image: 'python:3.7-slim-buster', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'terraform', image: 'hashicorp/terraform:0.12.3', command: 'cat', ttyEnabled: true),
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
                dir('devops_fun_assignment/terraform') {
                    sh 'make help'
                    sh 'make package'
                    sh 'ls -lR ../lambda_functions/'
                }
            }
        }
    }
}