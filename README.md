# AllegroGraph in Docker

This repository contains a set of instruments and configuration files
needed to build, configure and run AllegroGraph in Docker. The new
images use Ubuntu as a base image and are not compatible with the old
DockerHub images (AG v6.6.0 and below), which use CentOS.



## Building AllegroGraph Docker images

AllegroGraph Docker images can be conveniently built using the
`agdock` tool by specifying the version of AllegroGraph release to use
in the image. The version can be either a release version in the form
`<major>.<minor>.<patch>` (e.g. `6.6.0` or `7.0.0`), a release
candidate `<release-version>.rc<N>` (e.g. `7.0.0.rc1`), a test release
`<release-version>.t<N>` (e.g. `7.0.0.t5`) or a latest nightly build
`<release-version>-nightly` (e.g. `7.0.0-nightly`):

    $ ./agdock build --version=6.6.0
    $ ./agdock build --version=7.0.0-nightly

Alternatively, the AllegroGraph distribution tarball (either a local
file or a URL) can be supplied via `--dist` argument:

    $ ./agdock build --dist=agraph-7.0.0-linuxamd64.64.tar.gz

The same can be done via `make` by setting `VERSION` environment variable:

    $ VERSION=7.0.0 make

Finally, images prebuilt by Franz, Inc. can be pulled from DockerHub:

    $ docker pull franzinc/agraph:v6.6.0

For other `agdock build` parameters and details, see the help message
that can be printed with `agdock --help`.



## Configuring and running AllegroGraph containers

In order to run an AllegroGraph container with data and configuration
persistence, the externally supplied data and configuration volumes
(either as host directories or Docker volumes) must be mounted at
`/agraph/data` and `/agraph/etc` respectively. The AllegroGraph
configuration file `/agraph/etc/agraph.cfg` is generated on container
start but only if it does not already exist. Superuser credentials can
be supplied in plaintext via `AGRAPH_SUPER_USER` and
`AGRAPH_SUPER_PASSWORD` variables or in files pointed to by
`AGRAPH_SUPER_USER_FILE` and `AGRAPH_SUPER_PASSWORD_FILE`
variables. If none of these variables are supplied, the default user
(`admin`) and a randomly generated password will be created and
printed at the beginning of the AllegroGraph log printed to the
standard output.

Example of configuring AllegroGraph container using Docker volumes:

    # Volume for AllegroGraph data and log files.
    $ docker volume create agdata

    # Volume for AllegroGraph config files.
    $ docker volume create agconfig

    # Start the container with a shared memory size of 1 Gb, which is
    # a required minimum.
    $ docker run -it --rm --shm-size 1g \
             -v agdata:/agraph/data -v agconfig:/agraph/etc \
             -e AGRAPH_SUPER_USER=admin -e AGRAPH_SUPER_PASSWORD=pass \
             -p 10000-10035:10000-10035 \
             --name agraph-instance-1 \
             franzinc/agraph:v7.0.0

AllegroGraph server is run as `agraph:agraph` user, which is also a
default user for the container (it is used to run commands provided to
`docker run` and `docker exec`).

Note, that *`entrypoint.sh` recursively changes the owner of `/agraph`
tree to `agraph:agraph` user on container start*. This may be
undesired when mounting local directories are as `/agraph/data` and
`/agraph/etc` volumes into AllegroGraph container.

For convenience purposes, `agdock` tool provides a `run` command for
running AllegroGraph containers, but it makes a lot of assumptions
about the `docker run` arguments and as a result lacks flexibility. In
the simplest case, the image name and tag can be computed from version
specified in the same form as for `agdock build`:

    $ ./agdock run --version=7.0.0-nightly

Alternatively, the image can be specified explicitly:

    $ ./agdock run --image=franzinc/agraph:v7.0.0

Another useful `agdock` command is `agtool`, which can be used to run
`agtool` CLI in a running AllegroGraph container. The same container
name must be used:

    $ ./agdock run --version=7.0.0 --name=agraph-instance-1
    $ ./agdock agtool --name=agraph-instance-1 -- create-db user:pass@10035/test



## License

Copyright (c) 2020, Franz, Inc.
All rights reserved.

Redistribution and use of this source code, with or without
modification, are permitted provided that the following condition is
met: source code must retain the above copyright notice, this
condition and the following disclaimer.

Redistributions of AllegroGraph in binary requires a license from
Franz, Inc.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
