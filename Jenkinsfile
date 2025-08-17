pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'  // Must match Jenkins config
        jdk 'jdk-17'         // Must match Jenkins config
    }

    environment {
        APP_DIR = "/srv/myapp"
        JAR_NAME = "DemoApplication-1.0-SNAPSHOT.jar"
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
                        def result = sh returnStatus: true, script: """
                            echo "Testing SSH connection"
                            ssh -i "${SSH_KEY}" -o StrictHostKeyChecking=no -p 2222 ${SSH_USER}@localhost "mkdir -p ${APP_DIR} && chmod 755 ${APP_DIR}"
                            scp -i "${SSH_KEY}" -o StrictHostKeyChecking=no -P 2222 target/*.jar ${SSH_USER}@localhost:${APP_DIR}
                            ssh -i "${SSH_KEY}" -o StrictHostKeyChecking=no -p 2222 ${SSH_USER}@localhost "cd ${APP_DIR} && pkill -f ${JAR_NAME} || true && nohup java -jar ${JAR_NAME} > ${APP_DIR}/app.log 2>&1 &"
                        """
                        if (result != 0) {
                            error "Deploy stage failed with exit code ${result}"
                        }
                    }
                }
            }
        }
    }
}