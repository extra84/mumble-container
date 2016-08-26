FROM alpine:latest
MAINTAINER Extra <extra84@gmail.com>

RUN apk update && \
    apk add --no-cache wget 
RUN wget --no-check-certificate -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64

COPY murmur.ini /etc/murmur.tpl
COPY murmur.x86 /usr/bin/murmur
COPY init.sh /usr/bin/init.sh

RUN adduser -D -u 9000 murmur && \
    mkdir -p /data  && chown murmur.murmur /data && \
    chmod +x /usr/bin/dumb-init && \
    chmod +r /etc/murmur.tpl

VOLUME ["/data"]
EXPOSE 64738 64738/udp

CMD ["/usr/bin/dumb-init","/usr/bin/init.sh"]

