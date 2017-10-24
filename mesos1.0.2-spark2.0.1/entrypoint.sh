#!/bin/sh

PRINCIPAL=${PRINCIPAL:-root}

if [ -n "$SECRET" ]; then
    touch /tmp/credential
    chmod 600 /tmp/credential
    printf '%s %s' "$PRINCIPAL" "$SECRET" > /tmp/credentials
    export MESOS_CREDENTIALS=/tmp/credentials
fi

exec "$@"
