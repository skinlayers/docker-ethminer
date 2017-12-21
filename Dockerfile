FROM nvidia/cuda:9.0-base

ENV VERSION 0.12.0
ENV ARCHIVE_NAME ethminer-${VERSION}-Linux.tar.gz
ENV GITHUB_URL https://github.com/ethereum-mining/ethminer/releases/download/v${VERSION}/${ARCHIVE_NAME}
ENV SHA256 be060bd78f9f0386b7a52f97d0c8b0bdc49941b2865e8ff77a0169bfd0b0b8af

WORKDIR /usr/local/bin
RUN apt-get update && apt-get -y install --no-install-recommends curl ca-certificates && \
    curl -L -o "$ARCHIVE_NAME" "$GITHUB_URL" && \
    echo "$SHA256  $ARCHIVE_NAME" > "${ARCHIVE_NAME}_sha256.txt" && \
    sha256sum -c "${ARCHIVE_NAME}_sha256.txt" && \
    tar xf "$ARCHIVE_NAME" --strip 1 && \
    rm "$ARCHIVE_NAME" && \
    apt-get purge -y --auto-remove curl ca-certificates && \
    rm -r /var/lib/apt/lists/*

ENV GPU_FORCE_64BIT_PTR 0
ENV GPU_MAX_HEAP_SIZE 100
ENV GPU_USE_SYNC_OBJECTS 1
ENV GPU_MAX_ALLOC_PERCENT 100
ENV GPU_SINGLE_ALLOC_PERCENT 100

COPY ./docker-entrypoint.sh /

RUN chmod 0755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/ethminer"]
