FROM frolvlad/alpine-glibc:latest

ARG hugo_version

WORKDIR /tmp

# Deps
RUN apk add --no-cache \
      git \
      ca-certificates

# hugo
RUN wget https://github.com/gohugoio/hugo/releases/download/v${hugo_version}/hugo_extended_${hugo_version}_Linux-64bit.tar.gz && \
      tar zxvf hugo_extended_${hugo_version}_Linux-64bit.tar.gz && \
      chmod +x hugo && \
      mv hugo /usr/bin/hugo &&  \
      rm -rf ./*
