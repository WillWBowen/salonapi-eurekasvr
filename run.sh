
#!/bin/sh

echo "********************************************************"
echo "Waiting for the Configuration server to start on port $CONFIGSERVER_PORT"
echo "********************************************************"
while ! `nc -z configserver $CONFIGSERVER_PORT`; do sleep 3; done
echo "******* Configuration Server has started"

echo "********************************************************"
echo "Starting the Eureka Server on port $EUREKASERVER_PORT"
echo "********************************************************"
java -Djava.security.egd=file:/dev/./urandom \
      -Dspring.cloud.config.uri=$CONFIGSERVER_URI \
      -Dspring.cloud.config.password=$CONFIGSERVER_PASSWORD \
      -Dspring.profiles.active=$PROFILE  \
      -jar /usr/local/eurekasvr/app.jar
