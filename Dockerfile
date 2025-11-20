FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy the exact jar name
COPY target/poc6-1.0-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
