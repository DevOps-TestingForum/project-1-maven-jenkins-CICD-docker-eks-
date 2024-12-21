FROM maven:3.8.4-eclipse-temurin-17 AS build
RUN mkdir /app
WORKDIR /app
COPY . .
RUN mvn package
