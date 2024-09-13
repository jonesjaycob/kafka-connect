FROM jaycobjones/kafka-connect-base:latest



COPY /configs/datagen-config.json /etc/kafka/connect/
COPY cmd.sh /usr/local/bin

RUN confluent-hub install confluentinc/kafka-connect-datagen:latest --no-prompt --verbose \
&& chmod +x /usr/local/bin/cmd.sh

# Expose ports for Kafka Connect and JMX monitoring
EXPOSE 8083 7073

# Use the base CMD script to start Kafka Connect
CMD ["/usr/local/bin/cmd.sh"]