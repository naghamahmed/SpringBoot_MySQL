FROM openjdk:17-jdk-slim

WORKDIR /app

COPY Toy0Store/target/*.jar /app

EXPOSE 8080

CMD ["java", "-jar", "spring-mysql.jar"]