# Equivalent of cookiecutter-django file compose/production/postgres/Dockerfile using postgres 10 but using alpine as the base.

FROM postgres:10-alpine

LABEL name=django-mobans-pg-image \
      version=0.1 \
      maintainer="jayvdb@gmail.com"

RUN apk add --no-cache \
  bash

COPY docker-healthcheck /usr/local/bin/

COPY command-entrypoint.sh /usr/local/bin/

COPY maintenance/backup /usr/local/bin/

COPY maintenance/restore /usr/local/bin/

COPY maintenance/backups /usr/local/bin/

COPY maintenance/_sourced/constants.sh /usr/local/bin/_sourced/

COPY maintenance/_sourced/countdown.sh /usr/local/bin/_sourced/

COPY maintenance/_sourced/messages.sh /usr/local/bin/_sourced/

COPY maintenance/_sourced/yes_no.sh /usr/local/bin/_sourced/

RUN chmod a+x /usr/local/bin/*

HEALTHCHECK --interval=5m \
            --timeout=15s \
            --start-period=30s \
  CMD docker-healthcheck || exit 1
