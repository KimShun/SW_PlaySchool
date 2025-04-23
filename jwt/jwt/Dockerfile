FROM openjdk:17-alpine
RUN apk add --no-cache bash xargs
WORKDIR /app
COPY . /app
RUN chmod +x gradlew
RUN ./gradlew build --no-daemon
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "build/libs/jwt-0.0.1-SNAPSHOT.jar"]

