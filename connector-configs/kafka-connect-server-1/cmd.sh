#!/bin/bash

# export REST_ADVERTISED_HOST_NAME=$(hostname -i)
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

# Loop through all JSON files in /etc/kafka/connect/ directory
for config in /etc/kafka/connect/*.json; do
  connector_name=$(basename "$config" .json)

  # Check if the connector already exists
  EXISTS=$(curl --silent --output /dev/null --write-out "%{http_code}" "http://localhost:8083/connectors/$connector_name")

  if [ "$EXISTS" -eq 200 ]; then
    # If the connector exists, use PUT to update the configuration
    echo "Updating existing connector $connector_name because of status code $EXISTS --> Found"
    
    # Extract only the config object from the file for the PUT request
    CONFIG_STRING=$(jq '.config' "$config")

    # Echo the data being sent
    echo "Data being sent in PUT request:"
    echo "$CONFIG_STRING"

    curl --request PUT "http://localhost:8083/connectors/$connector_name/config" \
         --header 'Content-Type: application/json' \
         --data "$CONFIG_STRING" | jq
  else
    # If the connector does not exist, use POST to create it
    echo "Creating new connector $connector_name because of status code $EXISTS --> Not Found"

    # Echo the data being sent
    echo "Data being sent in POST request:"
    cat "$config"

    curl --request POST "http://localhost:8083/connectors" \
         --header 'Content-Type: application/json' \
         --data @"$config" | jq
  fi
done

echo "The configurations have been applied"
# Keep the container running
wait
