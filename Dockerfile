# Step 1: Use Maven image to build the app
FROM maven:3.8.6-openjdk-11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and source code into the container
COPY pom.xml ./

# Step 2: Build the application using Maven (skip tests for faster build)
RUN mvn clean install -DskipTests

# Step 3: Use Tomcat as a base image for deployment
FROM tomcat:9-jdk11-openjdk-slim

# Set the working directory for the runtime container
WORKDIR /usr/local/tomcat/webapps

# Copy the WAR file from the Maven build stage to Tomcat's webapps folder
COPY --from=build /target/*.war /usr/local/tomcat/webapps/my-app.war

# Expose the new port (8081 instead of 8080 to avoid conflict with Jenkins)
EXPOSE 8081

# Change the Tomcat server port to 8081
RUN sed -i 's/8080/8081/g' /usr/local/tomcat/conf/server.xml

# Command to run Tomcat
CMD ["catalina.sh", "run"]
