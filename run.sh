#!/bin/bash

# Usage: file_env_opt VAR [DEFAULT]
file_env_opt() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ -z "${!var:-}" ] && [ -z "${!fileVar:-}" ] && [ -z "${def:-}" ]; then
		return 0
	fi
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env_opt 'GF_DATABASE_PASSWORD'

set -x
set -e

if [ -n "$GRAFANA_GID" -a -n "$APP_USERNAME" -a "$APP_USERNAME" != 'root' ]; then
	groupmod --gid $GRAFANA_GID $APP_USERNAME
	usermod --gid $GRAFANA_GID $APP_USERNAME
fi

if [ -n "$GRAFANA_UID" -a -n "$APP_USERNAME" -a "$APP_USERNAME" != 'root' ]; then
	usermod --uid $GRAFANA_UID $APP_USERNAME
fi

if [ "$1" = 'grafana-app' ]; then
	shift;
	exec /grafana-docker-entrypoint.sh "$@"
fi

exec "$@"
