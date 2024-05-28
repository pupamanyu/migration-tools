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
# shellcheck disable=SC2046
SELF_DIR="$(dirname $(readlink -f "$0"))"
SECRETS_DIR="$(dirname "${SELF_DIR}")/.secrets"
docker build --platform=linux/amd64 --file Dockerfile --tag psl-to-kafka:latest \
  --secret id=kafka_sasl_service_account,src="${SECRETS_DIR}/kafka_sasl_service_account" \
  --secret id=kafka_sasl_service_account_key,src="${SECRETS_DIR}/kafka_sasl_service_account_key" \
  --secret id=kafka_bootstrap_servers,src="${SECRETS_DIR}/kafka_bootstrap_servers" \
  --secret id=kafka_sink_topic,src="${SECRETS_DIR}/kafka_sink_topic" \
  --secret id=kafka_connect_group_id,src="${SECRETS_DIR}/kafka_connect_group_id" \
  --secret id=pubsub_lite_gcp_project,src="${SECRETS_DIR}/pubsub_lite_gcp_project" \
  --secret id=pubsub_lite_gcp_location,src="${SECRETS_DIR}/pubsub_lite_gcp_location" \
  --secret id=pubsub_lite_subscription,src="${SECRETS_DIR}/pubsub_lite_subscription" \
  --secret id=kafka_config_storage_topic,src="${SECRETS_DIR}/kafka_config_storage_topic" \
  --secret id=kafka_offset_storage_topic,src="${SECRETS_DIR}/kafka_offset_storage_topic" \
  --secret id=kafka_status_storage_topic,src="${SECRETS_DIR}/kafka_status_storage_topic" \
  --secret id=kafka_ssl_truststore_location,src="${SECRETS_DIR}/kafka_ssl_truststore_location" \
  --secret id=kafka_ssl_truststore_password,src="${SECRETS_DIR}/kafka_ssl_truststore_password" \
  --no-cache .
