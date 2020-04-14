# Stage 0 - pull the AG distribution tarball, unpack it and install it
# into the /agraph directory.
FROM ubuntu:bionic AS installation-stage

ARG AG_ARCHIVE
ARG AG_VERSION

# Install the dependencies needed for AG installation.
RUN apt-get update && apt-get install -y openssl openssl1.0

# Pull AG distribution tarball into the image.
ADD $AG_ARCHIVE ./

# Unpack AG distribution archive, install AG into /agraph directory
# and delete the archive and unpacked files.
RUN if [ -f "${AG_ARCHIVE##*/}" ];                                        \
        then tar zxf "${AG_ARCHIVE##*/}" && rm -f "${AG_ARCHIVE##*/}"; fi \
        && ./agraph-${AG_VERSION}/install-agraph /agraph --no-configure



# Stage 1 - copy the AG installed during stage 0 into a clean Ubuntu
# base and proceed building the rest of the image.
FROM ubuntu:bionic
MAINTAINER Franz Support <support@franz.com>

COPY --from=installation-stage /agraph /agraph

# Install the same dependencies as for the stage0 (installation) and
# remove apt registries.
RUN apt-get update && apt-get install -y openssl openssl1.0 sudo \
        && rm -rf /var/lib/apt/lists/*

# Create agraph user, enable passwordless sudo and manually copy skel
# files to the agraph user's home (useradd -m cannot be used, since
# the /agraph directory already exists). For .sudo_as_admin_successful
# file details see https://askubuntu.com/questions/22607.
RUN groupadd -r agraph                                                  \
        && useradd -M -g agraph -G sudo -s /bin/bash -d /agraph agraph  \
        && echo "agraph ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers        \
        && touch /agraph/.sudo_as_admin_successful                      \
        && cp -r /etc/skel/. /agraph

ENV PATH=/agraph/bin:$PATH

VOLUME /agraph/data
VOLUME /agraph/etc

EXPOSE 10000-10034 10035

USER agraph
WORKDIR /agraph

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
