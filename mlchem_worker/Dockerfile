# Basic worker image for parallel computation
# based on parsl + globus compute endpoint
# we install numpy and scipy as most parsl components would depend
ARG BASE_IMAGE="ghcr.io/alchem0x2a/mlchem_base:latest"
FROM ${BASE_IMAGE}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"

USER "$NB_UID"
WORKDIR "$HOME"
RUN mamba install --yes -c conda-forge \
    'conda-forge::blas=*=openblas' \
    'joblib' \
    'matplotlib-base' \
    'numpy' \
    'pandas' \
    'requests' \
    'scipy'  \
    'tqdm' &&\
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" 

# parsl and GCE are currently better installed by uv/pip
RUN mamba install --yes -c conda-forge \
    compilers &&\
    UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir \
    "parsl[aws,globus_compute]" \
    "globus-compute-endpoint" \
    "rclone-python" &&\
    uv cache clean && rm -rf ${HOME}/.cache/uv &&\
    mamba remove --prefix /opt/conda -y compilers &&\
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
