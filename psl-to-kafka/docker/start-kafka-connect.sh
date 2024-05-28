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
START_SCRIPT="${KAFKA_HOME}/bin/connect-distributed.sh"
KAFKA_REST_ADVERTISED_HOST_NAME="$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)"
KAFKA_CONNECT_WORKER_CLIENT_ID="$(hostname --fqdn)"
sed -i -e "s#__KAFKA_REST_ADVERTISED_HOST_NAME__#${KAFKA_REST_ADVERTISED_HOST_NAME}#g; s#__KAFKA_CONNECT_WORKER_CLIENT_ID__#${KAFKA_CONNECT_WORKER_CLIENT_ID}#g" \
    "${KAFKA_CONNECT_CONFIG_FILE}"
${START_SCRIPT} "${KAFKA_CONNECT_CONFIG_FILE}"