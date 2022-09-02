#!/bin/bash

CONNECTED_PEERS="$( socat - UNIX-CONNECT:/config/fastd/fastd.status | jq -r ".peers[] | select(.connection!=null) .name" )"
CONNECTED_PEER_COUNT=$( echo -n "${CONNECTED_PEERS}" | wc -w)

if [ ${CONNECTED_PEER_COUNT} == 0 ]; then
  echo "No peers connected!"
  exit 1
fi

echo "${CONNECTED_PEER_COUNT} peers connected"
echo "${CONNECTED_PEERS}"
