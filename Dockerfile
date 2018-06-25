FROM nvidia/cuda:9.0-base-ubuntu16.04
LABEL maintainer="skinlayers@gmail.com"

ARG VERSION=0.15.0rc2
ARG ARCHIVE_NAME=ethminer-$VERSION-Linux.tar.gz
ARG ARCHIVE_URL=https://github.com/ethereum-mining/ethminer/releases/download/v${VERSION}/$ARCHIVE_NAME
ARG ARCHIVE_SHA256=b4b46f3aea760d6a9190a941fa4f7c5985431a0ee366f2ccdf2deb2fa6493fdc
ARG ARCHIVE_SHA256_FILE=ethminer-$VERSION-Linux-sha256.txt
ARG BUILD_DEPENDENCIES=" \
    curl \
    ca-certificates \
"

WORKDIR /usr/local/bin
RUN set -eu && \
    adduser --system --home /data --group ethminer && \
    apt-get update && apt-get -y install --no-install-recommends $BUILD_DEPENDENCIES && \
    curl -L "$ARCHIVE_URL" -o "$ARCHIVE_NAME" && \
    echo "$ARCHIVE_SHA256  $ARCHIVE_NAME" > "$ARCHIVE_SHA256_FILE" && \
    sha256sum -c "$ARCHIVE_SHA256_FILE" && \
    tar xf "$ARCHIVE_NAME" --strip 1 && \
    rm "$ARCHIVE_NAME" "$ARCHIVE_SHA256_FILE" && \
    apt-get purge -y --auto-remove $BUILD_DEPENDENCIES && \
    rm -r /var/lib/apt/lists/*

COPY ./docker-entrypoint.sh /

RUN chmod 0755 /docker-entrypoint.sh

USER ethminer

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/ethminer"]
