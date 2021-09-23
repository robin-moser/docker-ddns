# ++++++++++++++++++++++++++++++++++++++
# Dockerfile: robinmoser/ddns
# ++++++++++++++++++++++++++++++++++++++

FROM python:3.9-alpine3.14 as build

RUN apk add --no-cache gcc musl-dev python3-dev libffi-dev openssl-dev
RUN pip install --prefix=/install domain-connect-dyndns

FROM python:3.9-alpine3.14
LABEL maintainer="Robin Moser"

ENV TZ="Europe/Berlin"

COPY --from=build /install /usr/local
COPY crontab /etc/crontabs/application

RUN adduser -D application
RUN rm -rf /etc/crontabs/root
RUN chmod 0600 /etc/crontabs/application

# This runs cron in the foreground with loglevel 2
ENTRYPOINT [ "crond", "-l", "2", "-f" ]
