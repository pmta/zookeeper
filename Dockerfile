# -------------------
# The build container
# -------------------
FROM ubuntu:20.10 AS build
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

ENV ZOOKEEPER_URL=https://mirror-2.hosthink.net/apache/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz

RUN apt-get -y update && apt-get -y install curl
RUN curl ${ZOOKEEPER_URL} -o /opt/zookeeper.tgz

# -------------------------
# The application container
# -------------------------
#FROM ubuntu:20.10
FROM debian:bullseye-slim
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y upgrade && \
    mkdir -p /usr/share/man/man1/ && \
    apt-get -y install openjdk-17-jre-headless && \
    apt-get clean

COPY --from=build /opt/zookeeper.tgz /opt/
RUN tar -zxf /opt/zookeeper.tgz -C /opt/ && rm -f /opt/zookeeper.tgz && \
ln -s /opt/apache-* /opt/zookeeper && \
mv /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

WORKDIR /opt/zookeeper

CMD bin/zkServer.sh start

