FROM openjdk:17
RUN apt-get update && apt-get install -y xargs
WORKDIR /app
COPY . /app
RUN chmod +x gradlew
RUN ./gradlew build --no-daemon
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "build/libs/jwt-0.0.1-SNAPSHOT.jar"]

