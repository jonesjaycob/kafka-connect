#!/bin/bash

export REST_ADVERTISED_HOST_NAME=$(hostname -i)
echo "Setting REST_ADVERTISED_HOST_NAME to $REST_ADVERTISED_HOST_NAME"

envsubst < /etc/kafka/templates/connect-distributed.properties > /etc/kafka/connect-distributed.properties
envsubst < /etc/kafka/templates/connect-log4j.properties > /etc/kafka/connect-log4j.properties

echo "Starting Kafka Connect in Distributed Mode"
/usr/bin/connect-distributed /etc/kafka/connect-distributed.properties &

# Wait for Kafka Connect to be available
echo "Waiting for Kafka Connect to start..."
until curl -s http://localhost:8083/connectors; do
  sleep 5
done

echo "Kafka Connect is up and running, applying connector configurations..."

# Apply connector configurations from /etc/kafka/connect/ directory
for config in /etc/kafka/connect/*.json; do
  connector_name=$(basename "$config" .json)
  echo "Creating or updating connector: $connector_name"
  curl -X PUT -H "Content-Type: application/json" --data @"$config" http://localhost:8083/connectors/$connector_name/config
done

echo "The configurations have been applied"
# Keep the container running
wait
