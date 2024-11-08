#!/bin/bash

# Set REST advertised host name
export REST_ADVERTISED_HOST_NAME="$(hostname -i):8083"
echo "Setting REST_ADVERTISED_HOST_NAME to $REST_ADVERTISED_HOST_NAME"

# Substitute environment variables in Kafka configuration templates
envsubst < /etc/kafka/templates/connect-distributed.properties > /etc/kafka/connect-distributed.properties
envsubst < /etc/kafka/templates/connect-log4j.properties > /etc/kafka/connect-log4j.properties

# Start Kafka Connect in Distributed Mode
echo "Starting Kafka Connect in Distributed Mode..."
/usr/bin/connect-distributed /etc/kafka/connect-distributed.properties &

# Wait for Kafka Connect to be available
echo "Waiting for Kafka Connect to start..."
until curl -s "http://$REST_ADVERTISED_HOST_NAME/connectors"; do
  echo "Attempting connection to Kafka Connect at http://$REST_ADVERTISED_HOST_NAME/connectors"
  sleep 5
done

echo "Kafka Connect is up and running."

# Delete all existing connectors
echo "Deleting all existing connectors..."
EXISTING_CONNECTORS=$(curl -s "http://$REST_ADVERTISED_HOST_NAME/connectors" | jq -r '.[]')

for connector in $EXISTING_CONNECTORS; do
  echo "Deleting connector: $connector"
  curl --request DELETE "http://$REST_ADVERTISED_HOST_NAME/connectors/$connector"
done
echo "All existing connectors have been deleted."

# Apply the specific connector configuration from ConfigMap
CONFIG_FILE="/etc/kafka/connect-configs/mqtt-connector-config.json"

if [ -f "$CONFIG_FILE" ]; then
  echo "Applying connector configuration from $CONFIG_FILE"
  connector_name=$(jq -r '.name' "$CONFIG_FILE")
  
  # Check if connector already exists
  EXISTS=$(curl --silent --output /dev/null --write-out "%{http_code}" "http://$REST_ADVERTISED_HOST_NAME/connectors/$connector_name")

  if [ "$EXISTS" -eq 200 ]; then
    echo "Updating existing connector $connector_name (Status: Found)"
    CONFIG_STRING=$(jq '.config' "$CONFIG_FILE")
    echo "PUT request data:"
    echo "$CONFIG_STRING"

    curl --request PUT "http://$REST_ADVERTISED_HOST_NAME/connectors/$connector_name/config" \
         --header 'Content-Type: application/json' \
         --data "$CONFIG_STRING" | jq
  else
    echo "Creating new connector $connector_name (Status: Not Found)"
    echo "POST request data:"
    cat "$CONFIG_FILE"

    curl --request POST "http://$REST_ADVERTISED_HOST_NAME/connectors" \
         --header 'Content-Type: application/json' \
         --data @"$CONFIG_FILE" | jq
  fi
else
  echo "No connector configuration file found at $CONFIG_FILE."
fi

echo "Connector configuration has been applied."

# Keep the container running
wait
