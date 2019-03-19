ARG arch=x86_64
FROM multiarch/alpine:${arch}-v3.9

RUN apk add --no-cache bash shadow vsftpd && \
    rm /etc/vsftpd/vsftpd.conf;

COPY docker-entrypoint /docker-entrypoint

EXPOSE 20
EXPOSE 21
ENTRYPOINT ["/docker-entrypoint"]

