ARG ALPINE_VERSION=latest
FROM docker.io/alpine:${ALPINE_VERSION}

RUN apk add --no-cache bash shadow vsftpd && \
    rm /etc/vsftpd/vsftpd.conf;

COPY entrypoint.sh /entrypoint.sh

EXPOSE 20
EXPOSE 21
ENTRYPOINT ["/entrypoint.sh"]

