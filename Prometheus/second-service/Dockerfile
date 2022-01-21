FROM openjdk:17-alpine

COPY target/second-service.jar /opt/app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/opt/app/app.jar"]