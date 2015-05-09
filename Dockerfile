FROM ubuntu:15.04
MAINTAINER Extra <extra84@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y mumble-server

RUN useradd -u 1000 mumble && \
    mkdir /data && chown 1000 /data && \
    chown 1000 /etc/mumble-server.ini && \
    chown 1000 /var/lib/mumble-server 

VOLUME ["/data","/var"]
EXPOSE 64738 64738/udp

USER mumble
ENTRYPOINT ["/usr/sbin/murmurd", "-fg", "-ini", "/etc/mumble-server.ini"]
