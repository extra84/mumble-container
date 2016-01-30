FROM alpine:latest
MAINTAINER Extra <extra84@gmail.com>

RUN apk update && \
    apk add --no-cache wget 
RUN wget --no-check-certificate -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64

COPY murmur.x86 /usr/bin/murmur
COPY murmur.ini /etc/murmur.tpl
COPY init.sh /usr/bin/init.sh

RUN adduser -D -u 1000 murmur && \
    mkdir -p /data /var/lib/murmur  && chown 1000 /data && \
#    touch /data/murmur.ini && \
#    chown 1000 /data/murmur.ini && \
    chown 1000 /var/lib/murmur && \
    chmod +x /usr/bin/dumb-init && \
    chmod +r /etc/murmur.tpl


VOLUME ["/data"]
EXPOSE 64738 64738/udp

USER murmur

CMD ["/usr/bin/dumb-init","/usr/bin/init.sh"]

