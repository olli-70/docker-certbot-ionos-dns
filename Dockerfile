FROM python:3-alpine
LABEL maintainer "Olli <oliver@porrmann.de>"

### Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    TZ=Europe/Berlin \
    LE_SCHED='50 2 * * *' \
    LE_TIER='stage'

### Install Application
RUN set -x && \
    apk --no-cache upgrade && \
    apk add --no-cache --virtual=run-deps \
      certbot \
      bash \
    && \
    rm -rf /tmp/* \
           /var/cache/apk/*  \
           /var/tmp/*

# Install ionos specific parts
RUN pip3 install certbot-dns-ionos

# Set the working directory
WORKDIR /app
COPY certrun.sh  run.sh /app/

RUN chmod 0755 certrun.sh run.sh

CMD /app/run.sh
