#!/bin/bash

export REST_ADVERTISED_HOST_NAME=$(hostname -i)
echo "Setting REST_ADVERTISED_HOST_NAME to $REST_ADVERTISED_HOST_NAME"

envsubst < /etc/kafka/templates/connect-distributed.properties > /etc/kafka/connect-distributed.properties
envsubst < /etc/kafka/templates/connect-log4j.properties > /etc/kafka/connect-log4j.properties

echo "Starting Kafka Connect in Distributed Mode"
/usr/bin/connect-distributed /etc/kafka/connect-distributed.properties
