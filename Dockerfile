FROM openjdk:8-jdk-alpine
COPY target/*.war /usr/local/tomcat/webapps/maven-web-app.war
