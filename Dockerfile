#FROM tomcat:9.0.64-jdk8-corretto
FROM tomcat:8.0
### Good stuff
COPY target/*.war /usr/local/tomcat/webapps/maven-web-app.war
