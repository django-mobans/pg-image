# Equivalent of cookiecutter-django file compose/production/postgres/Dockerfile using postgres 10 but using alpine as the base.

FROM postgres:10-alpine

LABEL name=django-mobans-pg-image \
      version=0.1 \
      maintainer="jayvdb@gmail.com"

RUN apk add --no-cache \
  bash

COPY docker-healthcheck /usr/local/bin/

COPY maintenance/* /usr/local/bin/

RUN chmod a+x /usr/local/bin/*

HEALTHCHECK --interval=5m \
            --timeout=15s \
            --start-period=30s \
  CMD docker-healthcheck || exit 1
