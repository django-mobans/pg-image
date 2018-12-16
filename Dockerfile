FROM postgres:10-alpine

LABEL name=django-mobans-pg-image \
      version=0.1 \
      maintainer="jayvdb@gmail.com"

RUN apk add --no-cache \
  bash

COPY docker-healthcheck /usr/local/bin/

HEALTHCHECK --interval=5m \
            --timeout=15s \
            --start-period=30s \
  CMD docker-healthcheck || exit 1
