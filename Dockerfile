FROM ubuntu:eoan


ARG ARCH=amd64

RUN apt-get update && \
    apt-get install -y \
        curl \
        unzip \
        && apt-get clean

EXPOSE 19132/udp

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/entrypoint-demoter", "--match", "/data", "--debug", "--stdin-on-term", "stop", "/opt/bedrock-entry.sh"]

FROM debian

# ARCH is only set to avoid repetition in Dockerfile since the binary download only supports amd64
ARG ARCH=amd64

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    unzip \
    dumb-init \
    && apt-get clean

EXPOSE 19132/udp

VOLUME ["/data/worlds"]

ADD run.sh /data/run.sh

WORKDIR /data

RUN curl -o /tmp/minecraft.zip -fsSL https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.32.1.zip && \
    cd /data && unzip -o -q /tmp/minecraft.zip && rm /tmp/minecraft.zip

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/data/run.sh"]