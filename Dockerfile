FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="${VERSION} ${BUILD_DATE}"
LABEL maintainer=""

# global environment settings
ARG DEEZ_DOWNLOAD="https://notabug.org/RemixDevs/DeezloaderRemix/archive/master.tar.gz"
ARG NODE_DOWNLOAD="https://deb.nodesource.com/setup_12.x"
ENV DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config"

RUN \
 echo "**** install runtime packages ****" && \
 apt-get update && \
 apt-get install -y \
	curl \
	git \
	gnupg \
	jq && \
 echo "**** Install Node and npm ****" && \
 curl -sL "${NODE_DOWNLOAD}" | bash - && \
 apt-get install -y nodejs && \
 echo "**** Install Deez ****" && \
 mkdir -p /app/deez && \
 cd /app/deez && \
 curl "${DEEZ_DOWNLOAD}" | tar xz -C /app/deez --strip-components=1 && \
 npm set unsafe-perm true && \
 npm install && \
 echo "**** fix for host id mapping error ****" && \
 chown -R root:root /app/deez && \
 echo "**** ensure abc user's home folder is /config ****" && \
 usermod -d /config abc && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 1730/tcp
VOLUME /config
