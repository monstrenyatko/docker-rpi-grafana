FROM resin/rpi-raspbian:jessie

MAINTAINER Oleg Kovalenko <monstrenyatko@gmail.com>

RUN set -x \
	&& apt-get update \
	&& apt-get -y install wget libfontconfig ca-certificates libicu52 libjpeg62-turbo libpng12-0 \
	&& wget https://github.com/fg2it/grafana-on-raspberry/releases/download/v3.1.1-wheezy-jessie/grafana_3.1.1-1472506485_armhf.deb -O /tmp/grafana.deb \
	&& dpkg --install /tmp/grafana.deb \
	&& apt-get install -y -f \
	&& export GOSU_VERSION=1.9 \
	&& dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y wget \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

EXPOSE 3000

VOLUME ["/config", "/data"]

CMD chown -R grafana:grafana /data && gosu grafana grafana-server --homepath=/usr/share/grafana --config=/config/grafana.ini
