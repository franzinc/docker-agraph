
FROM centos:centos6
MAINTAINER Franz Support <support@franz.com>

RUN yum -y update; yum clean all
# glibc-common and coreutils are likely redundant, but they're
# in the .spec file for agraph, so list them here.
RUN yum -y install glibc-common coreutils wget tar; yum clean all

RUN wget -q http://franz.com/ftp/pri/acl/ag/ag5.1/linuxamd64.64/agraph-5.1-linuxamd64.64.tar.gz \
    && groupadd agraph \
    && useradd -d /data -g agraph agraph \
    && tar zxf agraph-5.1-linuxamd64.64.tar.gz \
    && rm -f agraph-5.1-linuxamd64.64.tar.gz \
    && cd agraph-5.1 \
    && ./install-agraph /app/agraph --non-interactive --runas-user agraph --super-password ignored \
    && mkdir /app/agraph/etc \
    && chown -R agraph:agraph /app \
    && yum -y remove wget tar \
    && yum clean all

COPY agraph.cfg /app/agraph/etc/agraph.cfg
EXPOSE 10035 
VOLUME ["/app", "/data"]

CMD /app/agraph/bin/agraph-control --config /app/agraph/etc/agraph.cfg start \
    && tail -f /data/log/agraph.log
