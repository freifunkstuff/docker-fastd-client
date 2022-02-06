FROM debian:bullseye-backports
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
      fastd batctl iproute2 \
      net-tools inetutils-ping procps \
      radvd radvdump tcpdump ndisc6 ipv6calc \
      bash curl
VOLUME /config
ADD entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh
