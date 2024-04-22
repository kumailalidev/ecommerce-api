#!/bin/bash

# if any of the commands in your code fails for any reason, the entire script fails
set -o errexit
# exits if any of your variables is not set
set -o nounset

exec watchfiles \
    --filter python \
    'celery -A config.celery worker -l INFO'
