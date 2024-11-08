# Base image
FROM jaycobjones/kafka-connect-base:latest


USER root
RUN dnf install -y unzip wget

# Install Confluent connectors
RUN confluent-hub install confluentinc/kafka-connect-datagen:latest --no-prompt --verbose \
    && confluent-hub install confluentinc/kafka-connect-mqtt:latest --no-prompt --verbose 

# Download and extract the Lenses.io MQTT connector
RUN wget https://github.com/lensesio/stream-reactor/releases/download/8.0.0/kafka-connect-mqtt-8.0.0.zip -O /tmp/kafka-connect-mqtt.zip \
    && unzip /tmp/kafka-connect-mqtt.zip -d /usr/share/java/kafka-connect-mqtt \
    && rm /tmp/kafka-connect-mqtt.zip

# Copy configuration files
COPY /arvoSchema /etc/kafka/connect/arvo
COPY cmd.sh /usr/local/bin


# Set permissions for the command script
RUN chmod +x /usr/local/bin/cmd.sh \
    && chown -R appuser:appuser /etc/kafka/connect/ \
    && chmod -R 755 /etc/kafka/connect/

# Switch back to appuser
USER appuser

# Add Prometheus JMX monitoring
ENV KAFKA_OPTS="-javaagent:/opt/kafka/libs/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar=7073:/opt/kafka-connect-prometheus.yml"

# Expose ports for Kafka Connect and Prometheus
EXPOSE 8083 7073

# Start Kafka Connect
CMD ["/usr/local/bin/cmd.sh"]
