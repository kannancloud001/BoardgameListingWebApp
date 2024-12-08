# Stage 1: Build stage
FROM maven:3.8.1-openjdk-11-slim AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage
FROM adoptopenjdk/openjdk11:alpine-jre

# Expose the application port
EXPOSE 8080

# Set environment variables
ENV APP_HOME /usr/src/app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar $APP_HOME/app.jar

# Set the working directory
WORKDIR $APP_HOME

# Define the command to run the application
CMD ["java", "-jar", "app.jar"]
