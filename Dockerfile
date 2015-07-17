FROM ubuntu:15.04
MAINTAINER Extra <extra84@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y mumble-server python
RUN apt-get install -y supervisor



RUN useradd -u 1000 mumble && \
    mkdir /data && chown 1000 /data && \
    touch /data/mumble-server.ini && \
    chown 1000 /data/mumble-server.ini && \
    chown 1000 /etc/mumble-server.ini && \
    chown 1000 /var/lib/mumble-server 

COPY start.py /home/mumble/start.py
COPY supervisord.conf /data/supervisord.conf
VOLUME ["/data"]
EXPOSE 64738 64738/udp

USER mumble

CMD ["/usr/bin/supervisord","-n", "-c", "/data/supervisord.conf"]

