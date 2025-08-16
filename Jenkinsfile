pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'  // Must match Jenkins config
        jdk 'jdk-17'         // Must match Jenkins config
    }

    environment {
        APP_DIR = "/srv/myapp"
        JAR_NAME = "demoapp.jar"
        SSH_KEY = "C:\\Windows\\System32\\config\\systemprofile\\.ssh\\id_rsa.ppk"
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
                    bat 'echo JAVA_HOME is %JAVA_HOME%'
                    bat 'java -version'
                    bat 'mvn -v'
                    bat 'mvn clean package -DskipTests -B'
                }
            }
        }

        stage('Deploy') {
            steps {
                bat """
                echo Testing SSH connection
                plink -ssh -P 2222 -i %SSH_KEY% root@localhost "mkdir -p %APP_DIR% && chmod 755 %APP_DIR%"
                pscp -P 2222 -i %SSH_KEY% target\\*.jar root@localhost:%APP_DIR%
                plink -ssh -P 2222 -i %SSH_KEY% root@localhost "cd %APP_DIR% && pkill -f %JAR_NAME% || true && nohup java -jar %JAR_NAME% > %APP_DIR%/app.log 2>&1 &"
                """
            }
        }
    }
}