## 1. BUILD ARGS
# These allow changing the produced image by passing different build args to adjust
# the source from which your image is built.
# Build args can be provided on the commandline when building locally with:
#   podman build -f Containerfile --build-arg FEDORA_VERSION=40 -t local-image

# SOURCE_IMAGE arg can be anything from ublue upstream which matches your desired version:
# See list here: https://github.com/orgs/ublue-os/packages?repo_name=main
# ARG SOURCE_IMAGE="${SOURCE_IMAGE:-aurora}"
# ARG SOURCE_SUFFIX="${SOURCE_SUFFIX:-dx}"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
# ARG SOURCE_TAG="${SOURCE_TAG:-stable-daily}"

ARG SOURCE_IMAGE="${SOURCE_IMAGE}"
ARG SOURCE_SUFFIX="${SOURCE_SUFFIX}"
ARG SOURCE_TAG="${SOURCE_TAG}"

### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}


### 3. MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

COPY build.sh /tmp/build.sh

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit

# COPY cachyos.sh /tmp/cachyos.sh

# RUN mkdir -p /var/lib/alternatives && \
#     /tmp/cachyos.sh && \
#     ostree container commit