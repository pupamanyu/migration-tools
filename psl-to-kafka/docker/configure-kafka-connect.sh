#!/usr/bin/env bash
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
# All the variables must be supplied as environment variables for this script
# Update Kafka Connect Source config
sed -i -e "s#__PUBSUB_LITE_GCP_PROJECT__#${PUBSUB_LITE_GCP_PROJECT}#g; s#__PUBSUB_LITE_GCP_LOCATION__#${PUBSUB_LITE_GCP_LOCATION}#g; s#__PUBSUB_LITE_SUBSCRIPTION__#${PUBSUB_LITE_SUBSCRIPTION}#g" \
    "${KAFKA_CONNECT_CONFIG_FILE}"
# Update Kafka Connect Sink config
sed -i -e "s#__KAFKA_BOOTSTRAP_SERVERS__#${KAFKA_BOOTSTRAP_SERVERS}#g; s#__KAFKA_SINK_TOPIC__#${KAFKA_SINK_TOPIC}#g" \
    "${KAFKA_CONNECT_CONFIG_FILE}"
# Update Kafka Connect internal topics config
sed -i -e "s#__KAFKA_CONFIG_STORAGE_TOPIC__#${KAFKA_CONFIG_STORAGE_TOPIC}#g; s#__KAFKA_OFFSET_STORAGE_TOPIC__#${KAFKA_OFFSET_STORAGE_TOPIC}#g; s#__KAFKA_STATUS_STORAGE_TOPIC__#${KAFKA_STATUS_STORAGE_TOPIC}#g" \
    "${KAFKA_CONNECT_CONFIG_FILE}"
# Update Kafka Connect group id and Kafka Connect plugins directory. Kafka Connect group id needs to be unique and must not conflict with the consumer group ids
sed -i -e "s#__KAFKA_CONNECT_GROUP_ID__#${KAFKA_CONNECT_GROUP_ID}#g; s#__KAFKA_PLUGINS_DIR__#${KAFKA_PLUGINS_DIR}#g" \
    "${KAFKA_CONNECT_CONFIG_FILE}"
# Update Kafka Connect SASL config
sed -i -e "s#__KAFKA_SASL_SERVICE_ACCOUNT__#${KAFKA_SASL_SERVICE_ACCOUNT}#g; s#__KAFKA_SASL_SERVICE_ACCOUNT_KEY__#${KAFKA_SASL_SERVICE_ACCOUNT_KEY}#g" \
    "${KAFKA_CONNECT_CONFIG_FILE}"
# Update Kafka Connect SSL truststore config
sed -i -e "s#__KAFKA_SSL_TRUSTSTORE_LOCATION__#${KAFKA_SSL_TRUSTSTORE_LOCATION}#g; s#__KAFKA_SSL_TRUSTSTORE_PASSWORD__#${KAFKA_SSL_TRUSTSTORE_PASSWORD}#g" \
    "${KAFKA_CONNECT_CONFIG_FILE}"