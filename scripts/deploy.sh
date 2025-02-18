#!/bin/bash

set -xe

docker compose -f compose.yml down
docker compose -f compose.yml up -d --build
