#!/usr/bin/env bash
# Example script to deploy WordPress containers locally
# using Docker Compose

set -e

cd \$(dirname \$0)/../docker
docker-compose up -d
