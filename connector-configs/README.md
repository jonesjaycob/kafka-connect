### How to use

1. Update/add your directory to `connector-configs/**`
2. Add you configs to `configs/**`
3. Update `Dockerfile` to install connector or insert your jar files in the correct directory
4. Create a build file

### Naming Convention

For root follow

`[cloud_provider/on-prem]-[connectors]`

### ENV

```
ENVIRONMENT=
KAFKA_CONNECT_LOG4J_ROOT_LOGLEVEL=
BROKERS=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_SESSION_TOKEN=
```

```
docker run -d \
  --name kafka-connect-aws-datagen \
  -e ENVIRONMENT=dev \
  -e BROKERS=<broker1,broker2,broker3> \
  -e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
  -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
  -e AWS_SESSION_TOKEN=<AWS_SESSION_TOKEN> \
  -e KAFKA_CONNECT_LOG4J_ROOT_LOGLEVEL=DEBUG 
  -p 8083:8083 \
  -p 7073:7073 \
  jaycobjones/kafka-connect-aws-datagen:latest
```

