#!/usr/bin/env bash

# Define the TAG variable
VERSION='5.0.0'
DATE=$(date -I)
REGISTRY='ghcr.io/jahanson'
TAG="v${VERSION}"
WEBUI_VERSION="2.1.0"
TARGETPLATFORM='linux/amd64'
# currently does nothing but set the version property when building the dotnet app.
CHANNEL='stable'

REPO_URL="https://github.com/ShokoAnime/ShokoServer.git"

# Retrieve the short commit hash for the specified tag
COMMIT_HASH=$(git ls-remote --tags ${REPO_URL} ${TAG} | cut -c1-7)


echo "Short commit hash for tag ${TAG}: ${COMMIT_HASH}"

# Build the Docker image for ShokoServer
docker build \
    --build-arg CHANNEL="${CHANNEL}" \
    --build-arg COMMIT="${COMMIT_HASH}" \
    --build-arg DATE="${DATE}" \
    --build-arg TAG="${TAG}" \
    --build-arg TARGETPLATFORM="${TARGETPLATFORM}" \
    --build-arg VERSION="${VERSION}" \
    --build-arg WEBUI_VERSION="${WEBUI_VERSION}" \
    -t ${REGISTRY}/shokoserver:${TAG} . \
    -f ./apps/ShokoServer/Dockerfile
