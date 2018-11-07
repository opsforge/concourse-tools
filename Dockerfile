# Dockerfile for Concourse CI pipelines tools image (C) opsforge 2018

FROM ruby:2.4-stretch

ENV TFVER="0.11.10"
ENV BOSHVER="4.0.1"
ENV OMVER="0.44.0"

MAINTAINER opsforge.io
LABEL name="concourse-tools"
LABEL version="0.1.1"
LABEL type="minimal"

# Ubuntu package installs

USER root
RUN apt-get update && \
    apt-get -y install zip git jq python-pip unzip pwgen groff curl wget sshpass dig && \
    apt-get clean

# PIP package installs

RUN pip install awscli

# Install terraform

RUN cd /tmp && \
    curl -L -o terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip && \
    unzip terraform.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/terraform && \
    rm -rf /tmp/*

# Install BOSH cli

RUN cd /tmp && \
    curl -L -o bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSHVER}-linux-amd64 && \
    chmod +x bosh && \
    mv bosh /usr/local/bin/bosh && \
    rm -rf /tmp/*

# Install CF CLI using pivotal method

RUN cd /tmp && \
    curl -L -o cf.deb "https://cli.run.pivotal.io/stable?release=debian64&source=github" && \
    dpkg -i cf.deb && \
    rm -rf /tmp/*

# Install OM CLI

RUN cd /tmp && \
    curl -L -o om "https://github.com/pivotal-cf/om/releases/download/${OMVER}/om-linux" && \
    chmod +x om && \
    mv om /usr/local/bin/om && \
    rm -rf /tmp/*
