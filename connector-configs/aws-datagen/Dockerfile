FROM jaycobjones/kafka-connect-base:20240913195424


RUN confluent-hub install confluentinc/kafka-connect-datagen:latest --no-prompt --verbose
COPY /configs /etc/kafka/connect/
COPY cmd.sh /usr/local/bin

USER root
RUN chmod +x /usr/local/bin/cmd.sh

RUN chown -R appuser:appuser /etc/kafka/connect/ \
    && chmod -R 755 /etc/kafka/connect/

USER appuser

ENV KAFKA_OPTS="-javaagent:/opt/kafka/libs/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar=7073:/opt/kafka-connect-prometheus.yml"

EXPOSE 8083 7073

# Use the base CMD script to start Kafka Connect
CMD ["/usr/local/bin/cmd.sh"]