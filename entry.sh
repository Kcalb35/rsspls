#!/bin/sh

set -e

trap 'exit' TERM INT

while true; do
  rsspls --config /etc/rsspls.toml
  sleep 3600 # 1 hours
done
