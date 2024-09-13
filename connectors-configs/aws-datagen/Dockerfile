FROM jaycobjones/kafka-connect-base:latest

RUN confluent-hub install confluentinc/kafka-connect-datagen:latest --no-prompt --verbose

COPY /configs/datagen-config.json /etc/kafka/connect/

# Expose ports for Kafka Connect and JMX monitoring
EXPOSE 8083 7073

# Use the base CMD script to start Kafka Connect
CMD ["/usr/local/bin/cmd.sh"]