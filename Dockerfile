FROM ubuntu:24.04

LABEL maintainer.name="Matteo Pietro Dazzi" \
    maintainer.email="matteopietro.dazzi@gmail.com" \
    version="1.0.0" \
    description="VSCode remote tunnels Docker image that can be easily deployed everywhere you want"

ENV MACHINE_NAME=vscode-remote

ARG TARGETARCH
ARG BUILD=stable
ARG INSIDERS=true

COPY --chmod=755 src/* /usr/local/bin/

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    tzdata \
    sudo \
    nano \
    net-tools \
    curl ca-certificates \
    git build-essential && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    download_vscode $TARGETARCH $BUILD $INSIDERS

RUN userdel -r ubuntu && \
    useradd --home-dir /data --shell /bin/bash user && \
    mkdir -p /config && \
    mkdir -p /data

USER root

WORKDIR /data

ENTRYPOINT [ "entrypoint" ]
