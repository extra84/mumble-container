FROM alpine:latest
MAINTAINER Extra <extra84@gmail.com>

RUN apk update && \
    apk add --no-cache wget 
RUN wget --no-check-certificate -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64
RUN adduser -D -u 1000 murmur && \
    mkdir -p /data /var/lib/murmur  && chown 1000 /data && \
    touch /data/murmur.ini && \
    chown 1000 /data/murmur.ini && \
    chown 1000 /var/lib/murmur && \
    chmod +x /usr/bin/dumb-init

COPY murmur.x86 /usr/bin/murmur
COPY murmur.ini /data
COPY start.py /home/murmur/start.py
COPY init.sh /usr/bin/init.sh

VOLUME ["/data"]
EXPOSE 64738 64738/udp

#USER murmur

CMD ["/usr/bin/dumb-init","/usr/bin/init.sh"]

