#!/usr/bin/env bash

# Define the TAG variable
VERSION='5.0.0'
DATE=$(date -I)
REGISTRY='ghcr.io/jahanson'
TAG="v${VERSION}"

REPO_URL="https://github.com/ShokoAnime/ShokoServer.git"

# Retrieve the short commit hash for the specified tag
COMMIT_HASH=$(git ls-remote --tags ${REPO_URL} ${TAG} | cut -c1-7)


echo "Short commit hash for tag ${TAG}: ${COMMIT_HASH}"

# Build the Docker image for ShokoServer
docker build \
    --build-arg VERSION="${VERSION}" \
    --build-arg DATE="${DATE}" \
    --build-arg COMMIT="${COMMIT_HASH}" \
    --build-arg TARGETPLATFORM='linux/amd64' \
    --build-arg CHANNEL='stable' \
    --build-arg TAG="${TAG}" \
    -t ${REGISTRY}/shokoserver:${TAG} . \
    -f ./apps/ShokoServer/Dockerfile
