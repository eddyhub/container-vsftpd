#!/bin/sh

ALPINE_VERSION=${1}
REGISTRY_USERNAME=${2}
REGISTRY_PASSWORD=${3}
REGISTRY=${4}
MANIFEST=${5}
declare -A ARCH_MAP
ARCH_MAP[amd64]=amd64
ARCH_MAP[armhf]=arm
ARCH_MAP[arm64]=arm64

export TAG="latest"

echo "$REGISTRY_PASSWORD" | buildah login --username "$REGISTRY_USERNAME" --password-stdin ${REGISTRY}
buildah manifest create "${MANIFEST}:${TAG}"


echo "Building container images"
for i in "${!ARCH_MAP[@]}"; do
  IMAGE="${MANIFEST}-${i}:${TAG}"
  echo "################################################################################"
  echo "Building: ${ARCH_MAP[$i]} -> ${IMAGE}"
  echo "################################################################################"
  buildah build --build-arg="ALPINE_VERSION=${ALPINE_VERSION}" --arch ${i} --tag "${IMAGE}" --manifest "${MANIFEST}" .
done;

echo "################################################################################"
echo "Pushing manifest ${MANIFEST}"
echo "################################################################################"
buildah manifest push --all "${MANIFEST}:${TAG}"

