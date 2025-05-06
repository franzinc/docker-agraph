# Stage 0 - pull the AG distribution tarball, unpack it and install it
# into the /agraph directory.
# NOTE: this is the official Ubuntu image
FROM ubuntu:24.04 AS installation-stage

ARG AG_ARCHIVE
ARG AG_VERSION

# Install the dependencies needed for AG installation.
RUN apt-get update && apt-get install -y openssl

# Pull AG distribution tarball into the image.
ADD $AG_ARCHIVE ./

# Unpack AG distribution archive, install AG into /agraph directory
# and delete the archive and unpacked files.
RUN if [ -f "${AG_ARCHIVE##*/}" ];                                        \
        then tar zxf "${AG_ARCHIVE##*/}" && rm -f "${AG_ARCHIVE##*/}"; fi \
        && ./agraph-${AG_VERSION}/install-agraph /agraph --no-configure



# Stage 1 - prepare a clean Ubuntu, install dependencies, setup a user
# and copy the AG installed during stage 0.
FROM ubuntu:24.04
MAINTAINER Franz Support <support@franz.com>

# Install the same dependencies as for the stage0 (installation) and
# remove apt registries.
# NOTE: update AND upgrade are required.
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install openssl sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create agraph user, enable passwordless sudo and silence the "To run
# a command as administrator ..." notification (for more details, see
# https://askubuntu.com/questions/22607).
RUN useradd -m -G sudo -s /bin/bash -d /agraph agraph            \
        && echo "agraph ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
        && touch /agraph/.sudo_as_admin_successful

COPY --chown=agraph --from=installation-stage /agraph /agraph

ENV PATH=/agraph/bin:$PATH

USER agraph
WORKDIR /agraph

VOLUME /agraph/data
VOLUME /agraph/etc

EXPOSE 10000-10034 10035

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
