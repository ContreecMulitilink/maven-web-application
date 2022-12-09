#FROM tomcat:9.0.64-jdk8-corretto
FROM tomcat:tomcat:9.0.70-jre8-temurin-jammy
### Good stuff
COPY target/*.war /usr/local/tomcat/webapps/maven-web-app.war
