#!/usr/bin/env bash
# Copyright 2017-2022 @polkadot authors & contributors
# This software may be modified and distributed under the terms
# of the Apache-2.0 license. See the LICENSE file for details.

# remove contents of log temporary files
sed -i '' '/^/d' docker.log

# Build Docker image after setting and exporting environment variables from
# .env file into current shell, then create and run Docker container.
source .env \
    && export APP \
    && export PORT \
    && ./docker/build.sh \
    && printf "\n*** Started building Docker container." \
    && printf "\n*** Please wait... \n***" \
    && DOCKER_BUILDKIT=0 docker compose -f docker-compose-dev.yml up --build \
        | tee -a docker.log \
        | tail -F docker.log \
        | grep --line-buffered 'compiled successfully' \
        | while read ; do
            printf "\n*** Finished building Docker container."
            printf "\n*** Open web browser: http://localhost:${PORT}\n"
            break
        done
