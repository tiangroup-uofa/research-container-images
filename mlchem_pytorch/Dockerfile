# Adding pytorch as one layer to the image
# Do not use mamba to install pytorch toolchain!
ARG BASE_IMAGE="ghcr.io/alchem0x2a/mlchem_worker:latest"
ARG CUDA_VERSION="cpu"
ARG PYTORCH_VERSION="2.7"

# amd64: cpu / gpu co-exist
# aarch64: cpu only
# what about build matrix?


FROM ${BASE_IMAGE}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"
# The ARG statements should be inherited below LABEL
ARG CUDA_VERSION
ARG PYTORCH_VERSION

USER "$NB_UID"
WORKDIR "$HOME"

# versions with cpu / gpu
RUN UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir \
    --extra-index-url=https://pypi.nvidia.com \
    --index-url "https://download.pytorch.org/whl/${CUDA_VERSION}" \
    "torch==${PYTORCH_VERSION}" &&\
    uv cache clean && rm -rf ${HOME}/.cache/uv


