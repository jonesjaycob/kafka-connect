# Kafka Distributed Connector Example w/ IAM Auth

An example to build a Distributed Connector Docker image and run it locally

## Files

- **Dockerfile**: file to build a docker image
- **cmd.sh**: shell script image executes on startup
- **templates/connect-distributed.properties**: Kafka Connect properties file template
- **templates/connect-log4j.properties**: Logging properties file template
- **kafka-connect-prometheus.yml**: Prometheus settings file
- **datagen-config.json**: [Confluent Data Generation source connector](https://www.confluent.io/hub/confluentinc/kafka-connect-datagen) config file
- **s3-json-sink-config.json**: [Confluent S3 sink connector](https://www.confluent.io/hub/confluentinc/kafka-connect-s3) config file
- **build-and-run-image.sh**: script to build image and run it locally within docker
  - Ensure auth environment variables are set (you may not need to set `AWS_SESSION_TOKEN`)
- **configure-connectors.sh**: `curl` commands to delete, create, and query metadata for connectors

Run from directory that has `@s3-json-sink-config.json` and `@datagen-config.json`

```bash
curl --request DELETE "http://localhost:8083/connectors/s3-json-sink"
curl --request DELETE "http://localhost:8083/connectors/datagen-inventory"
curl --request POST "http://localhost:8083/connectors" --header 'Content-Type: application/json' --data @s3-json-sink-config.json | jq
curl --request POST "http://localhost:8083/connectors" --header 'Content-Type: application/json' --data @datagen-config.json | jq
curl --request GET "http://localhost:8083/connectors/s3-json-sink" | jq
curl --request GET "http://localhost:8083/connectors/datagen-inventory" | jq
```
