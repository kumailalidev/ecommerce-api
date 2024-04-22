#!/bin/bash

# if any of the commands in your code fails for any reason, the entire script fails
set -o errexit
# exits if any of your variables is not set
set -o nounset

worker_ready() {
    # Check if Celery workers are ready
    celery -A config.celery inspect ping
}

until worker_ready; do
    >&2 echo 'Celery workers not available'
    sleep 1
done
>&2 echo 'Celery workers is available'

exec celery -A config.celery \
    --broker="${BROKER_URL}" \
    flower
