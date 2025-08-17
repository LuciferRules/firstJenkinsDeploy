#!/bin/bash

APP_DIR=/srv/myapp # Define app directory
JAR_PATH=$APP_DIR/DemoApplication-1.0-SNAPSHOT.jar # Define JAR path

# Start application and log to app.log
echo "Starting DemoApplication..."
echo "Logging to ${APP_DIR}/app.log"
nohup java -jar ${JAR_PATH} > ${APP_DIR}/app.log 2>&1 &