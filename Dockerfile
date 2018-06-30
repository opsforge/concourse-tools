# Dockerfile for Concourse CI pipelines tools image (C) opsforge 2018

FROM ubuntu:18.04

ENV TFVER="0.11.6"
ENV BOSHVER="3.0.1"

MAINTAINER opsforge.io
LABEL name="concourse-tools"
LABEL version="0.1.0"
LABEL type="minimal"

# Ubuntu package installs

USER root
RUN apt-get update && \
    apt-get -y install zip git jq python-pip unzip pwgen groff curl wget && \
    apt-get clean
    
# PIP package installs

RUN pip install awscli

# Install terraform

RUN cd /tmp && \
    curl -LO https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip && \
    unzip terraform_${TFVER}_linux_amd64.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/terraform && \
    rm -rf /tmp/*
    
# Install BOSH cli

RUN cd /tmp && \
    curl -LO https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSHVER}-linux-amd64 && \
    chmod +x bosh-cli-${BOSHVER}-linux-amd64 && \
    mv bosh-cli-${BOSHVER}-linux-amd64 /usr/local/bin/bosh
    
# Install CF CLI using pivotal method

RUN cd /tmp && \
    curl -L -o cf.deb "https://cli.run.pivotal.io/stable?release=debian64&source=github" && \
    dpkg -i cf.deb && \
    rm -rf /tmp/*
