pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'  // Must match Jenkins config
        jdk 'jdk-17'         // Must match Jenkins config
    }

    environment {
        APP_DIR = "/srv/myapp"
        JAR_NAME = "DemoApplication-1.0-SNAPSHOT.jar"
        BASH_APP = "DemoApplication-starter.sh"
//         SSH_KEY = "/c/Windows/System32/config/systemprofile/.ssh/id_rsa.ppk" // Use .ppk for Windows
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/LuciferRules/firstJenkinsDeploy.git'
            }
        }

        stage('Build') {
            steps {
                tool name: 'jdk-17', type: 'jdk'
                withEnv(["JAVA_HOME=${tool 'jdk-17'}", "PATH+JAVA=${tool 'jdk-17'}\\bin"]) {
                    sh 'echo JAVA_HOME is %JAVA_HOME%'
                    sh 'java -version'
                    sh 'mvn -v'
                    sh 'mvn clean package -DskipTests -B'
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: '594d80bd-fa4e-44c6-b08d-cfae6c150aff', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    script {
                        def SSH_ARG = "-o StrictHostKeyChecking=no -p 2222"
                        def result = sh returnStatus: true, script: """
                            echo "Testing SSH connection"
                            ssh -i ${SSH_KEY} \${SSH_ARG} ${SSH_USER}@localhost "mkdir -p ${APP_DIR} && chmod 755 ${APP_DIR}"
                            scp -i ${SSH_KEY} \${SSH_ARG} target/*.jar ${SSH_USER}@localhost:${APP_DIR}
                            scp -i ${SSH_KEY} \${SSH_ARG} bash/* ${SSH_USER}@localhost:${APP_DIR}
                            ssh -i ${SSH_KEY} \${SSH_ARG} ${SSH_USER}@localhost "source ${APP_DIR}/${BASH_APP}"
                        """
                        if (result != 0) {
                            error "Deploy stage failed with exit code ${result}"
                        }
                    }
                }
            }
        }

        stage('Monitor') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: '594d80bd-fa4e-44c6-b08d-cfae6c150aff', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    script {
                        def result = sh returnStatus: true, script: """
                            SSH_ARG = "-o StrictHostKeyChecking=no -p 2222"
                            echo "Monitoring..."
                            ssh -i ${SSH_KEY} \${SSH_ARG} ${SSH_USER}@localhost "cat ${APP_DIR}/app.log"
                            echo "Checking application endpoint..."
                            ssh -i ${SSH_KEY} \${SSH_ARG} ${SSH_USER}@localhost "curl http://localhost:8081"
                        """
                        if (result != 0) {
                            error "Monitor stage failed with exit code ${result}"
                        }
                    }
                }
            }
        }
    }
}