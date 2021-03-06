FROM ubuntu:eoan

ARG ARCH=amd64

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        unzip \
        dumb-init \
        && apt-get clean

WORKDIR /opt/minecraft

ARG ARCH=amd64

ADD run.sh run.sh

RUN curl -o /tmp/minecraft.zip -fsSL https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.60.5.zip && \
    unzip -o -q /tmp/minecraft.zip && rm /tmp/minecraft.zip

RUN mkdir /opt/minecraft/config && \
    rm /opt/minecraft/server.properties && \
    mv /opt/minecraft/permissions.json /opt/minecraft/config && \
    mv /opt/minecraft/whitelist.json /opt/minecraft/config 

ADD server.properties config/server.properties

RUN ln -s /opt/minecraft/config/server.properties /opt/minecraft/server.properties && \
    ln -s /opt/minecraft/config/permissions.json /opt/minecraft/permissions.json && \
    ln -s /opt/minecraft/config/whitelist.json /opt/minecraft/whitelist.json

EXPOSE 19132/udp

VOLUME ["/opt/minecraft/worlds"]
VOLUME ["/opt/minecraft/config"]

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/minecraft/run.sh"]