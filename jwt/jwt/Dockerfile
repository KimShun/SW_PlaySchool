FROM openjdk:17
WORKDIR /app
COPY . /app
RUN ./gradlew build --no-daemon
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "build/libs/jwt-0.0.1-SNAPSHOT.jar"]

