FROM ubuntu:bionic

MAINTAINER Franz Support <support@franz.com>

ARG AG_ARCHIVE
ARG AG_VERSION

RUN apt-get update && apt-get install -y openssl openssl1.0

RUN groupadd agraph && useradd -d /agraph -g agraph agraph -s /bin/bash

ADD $AG_ARCHIVE ./

RUN if [ -f "${AG_ARCHIVE##*/}" ]; then \
        tar zxf "${AG_ARCHIVE##*/}" && rm -f "${AG_ARCHIVE##*/}"; fi    \
        && ./agraph-${AG_VERSION}/install-agraph /agraph --no-configure \
        && mkdir /agraph/data /agraph/etc \
        && chown -R agraph:agraph /agraph \
        && rm -r agraph-${AG_VERSION}

ENV PATH=/agraph/bin:$PATH

VOLUME /agraph/data
VOLUME /agraph/etc

EXPOSE 10000-10034 10035

USER agraph
WORKDIR /agraph

COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
