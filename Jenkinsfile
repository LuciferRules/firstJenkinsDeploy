pipeline {
    agent any

    tools {
        maven 'Maven-default'  // Default name for auto-installed Maven
        jdk 'jdk'              // Default name for auto-installed JDK
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
                sh """
                export JAVA_HOME=/opt/jdk-17.0.2
                export PATH=\$JAVA_HOME/bin:\$PATH
                mvn clean package -DskipTests
                """
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