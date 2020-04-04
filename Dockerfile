FROM ubuntu:eoan

ARG ARCH=amd64

RUN apt-get update && \
    apt-get install -y \
        curl \
        unzip \
        && apt-get clean

WORKDIR /opt/minecraft

# ARCH is only set to avoid repetition in Dockerfile since the binary download only supports amd64
ARG ARCH=amd64

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    unzip \
    dumb-init \
    && apt-get clean

WORKDIR /opt/minecraft

ADD run.sh run.sh

RUN curl -o /tmp/minecraft.zip -fsSL https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.32.1.zip && \
    unzip -o -q /tmp/minecraft.zip && rm /tmp/minecraft.zip

RUN mkdir /opt/minecraft/config && \
    mv /opt/minecraft/server.properties /opt/minecraft/config && \
    mv /opt/minecraft/permissions.json /opt/minecraft/config && \
    mv /opt/minecraft/whitelist.json /opt/minecraft/config && \
    ln -s /opt/minecraft/config/server.properties /opt/minecraft/server.properties && \
    ln -s /opt/minecraft/config/permissions.json /opt/minecraft/permissions.json && \
    ln -s /opt/minecraft/config/whitelist.json /opt/minecraft/whitelist.json

EXPOSE 19132/udp

VOLUME ["/opt/minecraft/worlds"]
VOLUME ["/data/minecraft/config"]

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/minecraft/run.sh"]