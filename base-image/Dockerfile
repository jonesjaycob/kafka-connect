# Docker image for running and deploying Kafka Connect
FROM confluentinc/cp-kafka-connect-base:7.7.0

# Build arguments
ARG AWS_MSK_IAM_VERSION
ENV AWS_MSK_IAM_VERSION=2.2.0
ARG AWS_AUTH_VERSION
ENV AWS_AUTH_VERSION=2.27.3
ARG JMX_PROMETHEUS_VERSION
ENV JMX_PROMETHEUS_VERSION=1.0.1


COPY templates /etc/kafka/templates
COPY /prometheus/kafka-connect-prometheus.yml /opt

USER root

# Switch to apt-get to install gettext for envsubst
RUN mkdir -p /opt/kafka/libs/ \
    && wget -P /opt/kafka/libs/ https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_PROMETHEUS_VERSION/jmx_prometheus_javaagent-$JMX_PROMETHEUS_VERSION.jar \
    && wget -P /usr/share/java/kafka/ https://github.com/aws/aws-msk-iam-auth/releases/download/v$AWS_MSK_IAM_VERSION/aws-msk-iam-auth-$AWS_MSK_IAM_VERSION-all.jar \
    && wget -P /opt/kafka/libs/ https://repo1.maven.org/maven2/software/amazon/awssdk/auth/$AWS_AUTH_VERSION/auth-$AWS_AUTH_VERSION.jar \
    && chown appuser /etc/kafka \
    && dnf install --assumeyes jq \
    && dnf install --assumeyes gettext
 





