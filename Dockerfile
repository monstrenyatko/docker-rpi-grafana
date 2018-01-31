FROM arm32v7/debian:jessie

MAINTAINER Oleg Kovalenko <monstrenyatko@gmail.com>

COPY tmp/qemu-arm-static /usr/bin/qemu-arm-static

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
    && DEBIAN_FRONTEND=noninteractive apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

ENV GOSU_VERSION 1.10
RUN set -x \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

ENV GRAFANA_VERSION 4.6.3
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libfontconfig ca-certificates \
    && wget https://github.com/fg2it/grafana-on-raspberry/releases/download/v${GRAFANA_VERSION}/grafana_${GRAFANA_VERSION}_armhf.deb -O /tmp/grafana.deb \
    && dpkg --install /tmp/grafana.deb \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -f \
    && DEBIAN_FRONTEND=noninteractive apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

ENV APP_USERNAME="grafana"

COPY run.sh /
RUN chmod +x /run.sh

COPY grafana-docker-entrypoint.sh /
RUN chmod +x /grafana-docker-entrypoint.sh

EXPOSE 3000

VOLUME ["/var/lib/grafana"]

ENTRYPOINT ["/run.sh"]
CMD ["grafana-app"]
