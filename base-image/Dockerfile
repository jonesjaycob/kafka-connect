# Docker image for running and deploying Kafka Connect
FROM confluentinc/cp-kafka-connect-base:7.7.0

# Build arguments
ARG AWS_MSK_IAM_VERSION
ENV AWS_MSK_IAM_VERSION=${AWS_MSK_IAM_VERSION:-2.2.0}
ARG AWS_AUTH_VERSION
ENV AWS_AUTH_VERSION=${AWS_AUTH_VERSION:-2.27.3}
ARG JMX_PROMETHEUS_VERSION
ENV JMX_PROMETHEUS_VERSION=${JMX_PROMETHEUS_VERSION:-1.0.1}

# Install required connectors
# RUN confluent-hub install confluentinc/kafka-connect-datagen:latest --no-prompt --verbose \
#     && confluent-hub install confluentinc/kafka-connect-s3:latest --no-prompt --verbose

# Ensure connect-distributed properties setup is added and configured.
COPY cmd.sh /usr/local/bin
COPY templates /etc/kafka/templates
COPY /configs/prometheus/kafka-connect-prometheus.yml /opt

USER root

# Switch to apt-get to install gettext for envsubst
RUN mkdir -p /opt/kafka/libs/ \
    && wget -P /opt/kafka/libs/ https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_PROMETHEUS_VERSION/jmx_prometheus_javaagent-$JMX_PROMETHEUS_VERSION.jar \
    && wget -P /usr/share/java/kafka/ https://github.com/aws/aws-msk-iam-auth/releases/download/v$AWS_MSK_IAM_VERSION/aws-msk-iam-auth-$AWS_MSK_IAM_VERSION-all.jar \
    && wget -P /opt/kafka/libs/ https://repo1.maven.org/maven2/software/amazon/awssdk/auth/$AWS_AUTH_VERSION/auth-$AWS_AUTH_VERSION.jar \
    && chmod +x /usr/local/bin/cmd.sh \
    && chown appuser /etc/kafka \
    && dnf install --assumeyes jq \
    && dnf install --assumeyes gettext
 

USER appuser

ENV KAFKA_OPTS="-javaagent:/opt/kafka/libs/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar=7073:/opt/kafka-connect-prometheus.yml"

EXPOSE 8083 7073

