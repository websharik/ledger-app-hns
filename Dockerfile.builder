# Adapted from LedgerHQ/ledger-app-builder (lite)
# https://github.com/LedgerHQ/ledger-app-builder/blob/a5e4a50c400d169149cacfdf49fa92f3ef954862/lite/Dockerfile

# Usage:
#     $ docker build -f Dockerfile.builder -t ledger-hns-builder .

#     Build for Nano X (default):
#     $ docker run --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) \
#         ledger-hns-builder:latest

#     Build for Nano S+:
#     $ docker run --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) \
#         -e MODEL=NANOSP ledger-hns-builder:latest

#     Build for Nano S with debug set:
#     $ docker run --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) \
#         -e MODEL=NANOSP ledger-hns-builder:latest -- DEBUG=1


FROM alpine:3.15
ENV LANG C.UTF-8

# Install dependencies
# --------------------

RUN apk update
RUN apk upgrade

# Adding LLVM-15 APT repository and installing it
# LLVM-15 is only present starting from the v3.17 Alpine version
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/v3.17/main llvm15
RUN ln -s /usr/lib/llvm15/bin/llvm-objcopy /usr/bin/llvm-objcopy-15 && ln -s /usr/lib/llvm15/bin/llvm-nm /usr/bin/llvm-nm-15

RUN apk add \
        bash \
        clang \
        clang-analyzer \
        clang-extra-tools \
        cmake \
        cmocka-dev \
        doxygen \
        gcc-arm-none-eabi \
        git \
        jq \
        lld \
        make \
        musl-dev \
        newlib-arm-none-eabi \
        protoc \
        python3

# Install pip and wheel
RUN python3 -m ensurepip --upgrade \
    && pip3 install --upgrade pip \
    && pip3 install wheel

# These packages contain shared libraries which will be needed at runtime
RUN apk add \
        eudev \
        libjpeg \
        libusb \
        zlib

# Python packages building dependencies, can be removed afterwards
RUN apk add -t python_build_deps eudev-dev \
                                 jpeg-dev \
                                 libusb-dev \
                                 linux-headers \
                                 python3-dev \
                                 zlib-dev

# temporary, until a fixed version of hidapi is released
# (with https://github.com/trezor/cython-hidapi/commit/749da69)
RUN pip3 install 'Cython<3'

# Python package to load app onto device
RUN pip3 install ledgerblue tomli-w

# Cleanup, remove packages that aren't needed anymore
RUN apk del python_build_deps


# Download SDKs for all models
# ----------------------------

ARG NANOS_SDK_TAG=v2.1.0-14
ARG NANOX_SDK_TAG=v5.8.0
ARG NANOSP_SDK_TAG=v1.10.1

# Work around the git security to be able to get informations from repositories
# even if the container is not run with root UID/GID
RUN git config --system --add safe.directory "*"
ENV GIT_SERVER=https://github.com/LedgerHQ

# Latest Nano S SDK
# Will switch to the unified SDK for next OS release.
ENV NANOS_SDK=/opt/nanos-secure-sdk
RUN git clone --branch "$NANOS_SDK_TAG" --depth 1 "$GIT_SERVER/nanos-secure-sdk.git" "$NANOS_SDK"

# Unified SDK
ENV LEDGER_SECURE_SDK=/opt/ledger-secure-sdk
RUN git clone "$GIT_SERVER/ledger-secure-sdk.git" "$LEDGER_SECURE_SDK"

# Nano X
ENV NANOX_SDK=/opt/nanox-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOX_SDK" "$NANOX_SDK_TAG"
RUN echo nanox > $NANOX_SDK/.target

# Nano S+
ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
RUN git -C "$LEDGER_SECURE_SDK" worktree add "$NANOSP_SDK" "$NANOSP_SDK_TAG"
RUN echo nanos2 > $NANOSP_SDK/.target

# Stax
# Not supported.

# Old Nano X SDK, use for <= 2.0.2-2
# ENV NANOX_SDK=/opt/nanox-secure-sdk
# RUN git clone --branch 2.0.2-2 --depth 1 "$GIT_SERVER/nanox-secure-sdk.git" "$NANOX_SDK"

# Old Nano S+ SDK, use for <= 1.0.4
# ENV NANOSP_SDK=/opt/nanosplus-secure-sdk
# RUN git clone --branch 1.0.4 --depth 1 "$GIT_SERVER/nanosplus-secure-sdk.git" "$NANOSP_SDK"


# Build the app
# -------------

WORKDIR /app

# can be: NANOS, NANOX (default), NANOSP
ENV MODEL=NANOX

ENTRYPOINT ["/bin/sh", "-c", "eval \"export BOLOS_SDK=\\${${MODEL}_SDK}\" && make $@"]
