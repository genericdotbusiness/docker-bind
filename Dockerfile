FROM ubuntu:bionic-20180526 AS add-apt-repositories

RUN apt-get update

FROM ubuntu:bionic-20180526

LABEL maintainer="sameer@damagehead.com"

ENV BIND_USER=bind \
    BIND_VERSION=9.11.3 \
    DATA_DIR=/data

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      bind9=1:${BIND_VERSION}* bind9-host=1:${BIND_VERSION}* dnsutils \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
COPY genericbind/ns3/named.conf.local /named.conf.local

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]
