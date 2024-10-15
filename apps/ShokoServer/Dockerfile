# FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
ARG VERSION

ARG DATE
ARG CHANNEL
ARG TAG
ARG TARGETPLATFORM
ARG COMMIT

SHELL ["/bin/ash", "-o", "pipefail", "-c"]
#hadolint ignore=DL3018
RUN apk add --no-cache \
        bash \
        curl \
        git \
        jo \
        jq \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && mkdir -p /app/bin \
    && git clone --depth 1 --recurse-submodules --branch "${TAG}" https://github.com/ShokoAnime/ShokoServer.git /tmp/src \
    && dotnet publish \
        /tmp/src/Shoko.CLI/Shoko.CLI.csproj \
        -c Release \
        -r "linux-musl-${ARCH}" \
        -f net8.0 \
        --self-contained true \
        -o /app/bin \
        /p:Version="${VERSION}" \
        /p:InformationalVersion="channel=${CHANNEL},commit=${COMMIT},tag=${TAG},date=${DATE}" \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/*

FROM alpine:3.20 AS runtime
ENV LANG=C.UTF-8 \
    LC_CTYPE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    UMASK="0002" \
    TZ="Etc/UTC"

COPY --from=build /app/bin /app/bin
COPY ./apps/ShokoServer/entrypoint.sh /entrypoint.sh

USER root
WORKDIR /app

SHELL ["/bin/ash", "-o", "pipefail", "-c"]
#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        git \
        icu-libs \
        jo \
        jq \
        libarchive-tools \
        libintl \
        nano \
        sqlite-libs \
        trurl \
        tzdata \
        vim

USER nobody:nogroup
# Hard coded in the app $HOME/.shoko
WORKDIR /.shoko
VOLUME ["/.shoko"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Shoko/ShokoServer"
