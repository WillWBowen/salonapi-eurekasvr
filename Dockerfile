FROM openjdk:8-jdk-alpine
MAINTAINER William Bowen <willwbowen@gmail.com>
RUN apk update && apk upgrade && apk add netcat-openbsd
RUN mkdir -p /usr/local/eurekasvr
COPY /target/salonapi-eurekasvr*SNAPSHOT.jar /usr/local/eurekasvr/app.jar
COPY run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh