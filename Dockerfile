FROM nvidia/cuda:10.1-base-ubuntu18.04
LABEL maintainer="skinlayers@gmail.com"

ARG VERSION=0.17.1
ARG ARCHIVE_NAME=ethminer-${VERSION}-linux-x86_64.tar.gz
ARG ARCHIVE_URL=https://github.com/ethereum-mining/ethminer/releases/download/v${VERSION}/${ARCHIVE_NAME}
ARG ARCHIVE_SHA256=823908ab8a22b6c319eda4922a4708ae2600061f09683325f72b330119769a1d
ARG ARCHIVE_SHA256_FILE=ethminer-${VERSION}-linux-sha256.txt
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
