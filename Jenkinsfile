pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'  // Must match Jenkins config
        jdk 'jdk-17'         // Must match Jenkins config
    }

    environment {
        APP_DIR = "/srv/myapp"
        JAR_NAME = "demoapp.jar"
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
                bat 'mvn clean package -DskipTests'  // Use 'bat' for Windows
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['root']) {
                    sh """
                    scp -P 2222 target/*.jar root@localhost:${APP_DIR}/${JAR_NAME}
                    ssh -p 2222 root@localhost 'cd ${APP_DIR} && \
                    nohup java -jar ${JAR_NAME} > ${APP_DIR}/app.log 2>&1 &'
                    """
                }
            }
        }
    }

    post {
        success {
            slackSend message: "Deployed Java 17 app to HDP VM: http://localhost:8080"
        }
    }
}