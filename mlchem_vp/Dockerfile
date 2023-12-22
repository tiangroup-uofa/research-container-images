# Dockerfile for the proprietary softwares. Only the libraries are installed.
# Other components should be loaded separatedly

# FROM nvcr.io/nvidia/nvhpc:${HPCSDK_VERSION}-devel-cuda_multi-ubuntu${UBUNTU_VERSION} as builder

ARG BASE_CONTAINER="ghcr.io/alchem0x2a/mlchem:nvhpc"

FROM ${BASE_CONTAINER}

ARG HPCSDK_VERSION=23.9
ARG CUDA_VERSION=11.0

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"


USER root
# Detect the version of NVHPC
# RUN HPCSDK_VERSION_DETECT=$(echo $HPCX_DIR | grep -oP 'Linux_x86_64/\K[0-9]+\.[0-9]+(?=/comm_libs)') && \
#     CUDA_VERSION_DETECT=$(echo $HPCX_DIR | grep -oP 'comm_libs/\K[0-9]+\.[0-9]+(?=/hpcx)') && \
#     UBUNTU_VERSION_DETECT=$(lsb_release -sr) &&\
#     if [ "$HPCSDK_VERSION_DETECT" != "$HPCSDK_VERSION" ]; then exit 1; fi &&\
#     # if [ "$CUDA_VERSION_DETECT" != "$CUDA_VERSION" ]; then exit 1; fi &&\
#     if [ "$UBUNTU_VERSION_DETECT" != "$UBUNTU_VERSION" ]; then exit 1; fi

WORKDIR /tmp
COPY nvhpc-qd-23.9.tgz ./
RUN tar xvf nvhpc-qd-23.9.tgz -C / && rm -rf nvhpc*.tgz

#TODO: I don't know how dockerfile screws with the expansion here, lets use harcord first
# COPY --from=nvcr.io/nvidia/nvhpc:23.9-devel-cuda_multi-ubuntu20.04 /opt/nvidia/hpc_sdk/Linux_x86_64/${HPCSDK_VERSION}/compilers/extras /opt/nvidia/hpc_sdk/Linux_x86_64/${HPCSDK_VERSION}/compilers/extras

ENV LD_LIBRARY_PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/${HPCSDK_VERSION}/compilers/extras/qd/lib:/opt/nvidia/hpc_sdk/Linux_x86_64/${HPCSDK_VERSION}/comm_libs/${CUDA_VERSION}/nccl/lib:${LD_LIBRARY_PATH}"

RUN apt-get update &&\
    apt-get install -yq --no-install-recommends intel-mkl-full libfftw3-3 &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID
WORKDIR $HOME

