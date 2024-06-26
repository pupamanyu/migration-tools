#
#  Copyright 2024 Google Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
FROM --platform=linux/amd64 eclipse-temurin:21-jre
ARG KAFKA_VERSION="3.4.0"
ARG KAFKA_CONNECT_VERSION="${KAFKA_VERSION}"
ARG KAFKA_SCALA_VERSION="2.13"
ARG PUBSUB_GROUP_KAFKA_CONNECTOR_VERSION="1.2.0"
ARG KAFKA_HOME_ROOT="/opt"
ENV KAFKA_HOME="${KAFKA_HOME_ROOT}/kafka"
ARG KAFKA_CONFIG_DIR="${KAFKA_HOME}/config"
ARG KAFKA_RELEASE="kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}"
ARG KAFKA_TARBALL="${KAFKA_RELEASE}.tgz"
ARG KAFKA_DOWNLOAD_URL="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_TARBALL}"
ARG KAFKA_SHA512_DOWNLOAD_URL="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_TARBALL}.sha512"
# The pubsub-group-kafka-connector file needs to be pre-built/downloaded using maven or other similar tool.
# References:
# 1) https://github.com/googleapis/java-pubsub-group-kafka-connector/releases/
# 2) https://central.sonatype.com/artifact/com.google.cloud/pubsub-group-kafka-connector
ARG PUBSUB_GROUP_KAFKA_CONNECTOR_JAR="pubsub-group-kafka-connector-${PUBSUB_GROUP_KAFKA_CONNECTOR_VERSION}.jar"
ARG PUBSUB_GROUP_KAFKA_CONNECTOR_URL="https://repo1.maven.org/maven2/com/google/cloud/pubsub-group-kafka-connector/${PUBSUB_GROUP_KAFKA_CONNECTOR_VERSION}/${PUBSUB_GROUP_KAFKA_CONNECTOR_JAR}"
ARG KAFKA_CONNECT_CONFIGURE_SCRIPT="configure-kafka-connect.sh"
ARG BUILD_KAFKA_CONNECT_STARTUP_SCRIPT="start-kafka-connect.sh"
ARG BUILD_KAFKA_CONNECT_CONFIG_FILE="kafka-connect.properties"
ENV KAFKA_HEAP_OPTS="-Xms2G -Xmx2G"
ENV KAFKA_HOME="${KAFKA_HOME_ROOT}/kafka"
ARG KAFKA_PLUGINS_DIR="${KAFKA_HOME}/plugins"
ENV JAVA_HOME="/opt/java/openjdk"
ENV PATH="${KAFKA_HOME}/bin:${JAVA_HOME}/bin:${PATH}"
ENV KAFKA_CONNECT_STARTUP_SCRIPT="${KAFKA_HOME}/bin/${BUILD_KAFKA_CONNECT_STARTUP_SCRIPT}"
ENV KAFKA_CONNECT_CONFIG_FILE="${KAFKA_CONFIG_DIR}/${BUILD_KAFKA_CONNECT_CONFIG_FILE}"

RUN apt-get -y -qq update \
    && apt-get -y -qq install --no-install-recommends gpg iproute2 bind9-dnsutils \
    && wget -q ${KAFKA_DOWNLOAD_URL} \
    && wget -q ${KAFKA_SHA512_DOWNLOAD_URL} \
    && gpg --print-md SHA512 ${KAFKA_TARBALL} | diff - ${KAFKA_TARBALL}.sha512 \
    && tar -xzf ${KAFKA_TARBALL} -C ${KAFKA_HOME_ROOT} \
    && ln -s ${KAFKA_HOME_ROOT}/${KAFKA_RELEASE} ${KAFKA_HOME} \
    && rm -f ${KAFKA_TARBALL} \
    && rm -f ${KAFKA_TARBALL}.sha512 \
    && wget -q ${PUBSUB_GROUP_KAFKA_CONNECTOR_URL} \
    && mkdir -p ${KAFKA_PLUGINS_DIR} \
    && mv ${PUBSUB_GROUP_KAFKA_CONNECTOR_JAR} ${KAFKA_PLUGINS_DIR}/${PUBSUB_GROUP_KAFKA_CONNECTOR_JAR}
    && apt-get -y -qq remove --purge gpg \
    && apt-get -y -qq autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

COPY ${BUILD_KAFKA_CONNECT_CONFIG_FILE} ${KAFKA_CONNECT_CONFIG_FILE}
COPY --chmod=555 ${KAFKA_CONNECT_CONFIGURE_SCRIPT} .
COPY --chmod=555 ${BUILD_KAFKA_CONNECT_STARTUP_SCRIPT} ${KAFKA_CONNECT_STARTUP_SCRIPT}
RUN --mount=type=secret,id=kafka_bootstrap_servers \
    --mount=type=secret,id=kafka_sasl_service_account \
    --mount=type=secret,id=kafka_sasl_service_account_key \
    --mount=type=secret,id=kafka_sink_topic \
    --mount=type=secret,id=kafka_connect_group_id \
    --mount=type=secret,id=pubsub_lite_gcp_project \
    --mount=type=secret,id=pubsub_lite_gcp_location \
    --mount=type=secret,id=pubsub_lite_subscription \
    --mount=type=secret,id=kafka_config_storage_topic \
    --mount=type=secret,id=kafka_offset_storage_topic \
    --mount=type=secret,id=kafka_status_storage_topic \
    --mount=type=secret,id=kafka_ssl_truststore_location \
    --mount=type=secret,id=kafka_ssl_truststore_password \
    KAFKA_CONNECT_CONFIG_FILE="${KAFKA_CONNECT_CONFIG_FILE}" \
    KAFKA_BOOTSTRAP_SERVERS="$(cat /run/secrets/kafka_bootstrap_servers)" \
    KAFKA_SASL_SERVICE_ACCOUNT="$(cat /run/secrets/kafka_sasl_service_account)"\
    KAFKA_SASL_SERVICE_ACCOUNT_KEY="$(cat /run/secrets/kafka_sasl_service_account_key)" \
    KAFKA_SINK_TOPIC="$(cat /run/secrets/kafka_sink_topic)" \
    KAFKA_CONNECT_GROUP_ID="$(cat /run/secrets/kafka_connect_group_id)" \
    KAFKA_PLUGINS_DIR="${KAFKA_PLUGINS_DIR}" \
    PUBSUB_LITE_GCP_PROJECT="$(cat /run/secrets/pubsub_lite_gcp_project)" \
    PUBSUB_LITE_GCP_LOCATION="$(cat /run/secrets/pubsub_lite_gcp_location)" \
    PUBSUB_LITE_SUBSCRIPTION="$(cat /run/secrets/pubsub_lite_subscription)" \
    KAFKA_CONFIG_STORAGE_TOPIC="$(cat /run/secrets/kafka_config_storage_topic)" \
    KAFKA_OFFSET_STORAGE_TOPIC="$(cat /run/secrets/kafka_offset_storage_topic)" \
    KAFKA_STATUS_STORAGE_TOPIC="$(cat /run/secrets/kafka_status_storage_topic)" \
    KAFKA_SSL_TRUSTSTORE_LOCATION="$(cat /run/secrets/kafka_ssl_truststore_location)" \
    KAFKA_SSL_TRUSTSTORE_PASSWORD="$(cat /run/secrets/kafka_ssl_truststore_password)" \
    ./${KAFKA_CONNECT_CONFIGURE_SCRIPT} \
    && rm -f ./${KAFKA_CONNECT_CONFIGURE_SCRIPT}

EXPOSE 8083

CMD ["bash", "-c", "${KAFKA_CONNECT_STARTUP_SCRIPT}"]
