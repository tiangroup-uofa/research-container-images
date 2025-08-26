# Adding pytorch as one layer to the image
# We will not use the whole cuda toolkit, but rather
# uv pip install the cu11.8 
ARG BASE_IMAGE="ghcr.io/alchem0x2a/mlchem_worker:latest"
ARG CUDA_VERSION="cu118"
ARG PYTORCH_VERSION="2.7"

FROM ${BASE_IMAGE}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"
ARG CUDA_VERSION
ARG PYTORCH_VERSION

USER "$NB_UID"
WORKDIR "$HOME"

# versions with cpu / gpu
RUN UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir \
    -extra-index-url=https://pypi.nvidia.com \
    --index-url "https://download.pytorch.org/whl/${CUDA_VERSION}" \
    "torch==${PYTORCH_VERSION}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/docker-specialized.html#dockerfiles
#ENV NVIDIA_VISIBLE_DEVICES="all" \
#    NVIDIA_DRIVER_CAPABILITIES="compute,utility"

# Puts the nvidia-smi binary (system management interface) on path
# with associated library files to execute it
#ENV PATH="${PATH}:/usr/local/nvidia/bin" \
#    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/nvidia/lib64"
    # uv cache clean && rm -rf ${HOME}/.cache/uv &&\
    # mamba remove --prefix /opt/conda -y compilers &&\
    # mamba clean --all -f -y && \
    # fix-permissions "${CONDA_DIR}" && \
    # fix-permissions "/home/${NB_USER}"
