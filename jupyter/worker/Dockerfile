# Basic worker image for parallel computation
# based on parsl + globus compute endpoint
# we install numpy and scipy as most parsl components would depend
ARG BASE_IMAGE="ghcr.io/tiangroup-uofa/jupyter_base:latest"
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
    'tqdm' \
    # Add parsl and GCE
    'parsl' \
    'parsl-with-aws' \
    'parsl-with-globus_compute' \
    'globus-compute-endpoint'    &&\
    pip install --no-cache-dir \
    # Manual fix of dill version in pip check
    'dill==0.3.9' \
    rclone-python &&\
    # Try best effort to avoid broken pip packages
    pip check &&\
    mamba clean --all -f -y    

# parsl and GCE are currently better installed by uv/pip
# RUN mamba install --yes -c conda-forge \
#     compilers &&\
#     UV_PYTHON=/opt/conda/bin/python \
#     uv pip install --no-cache-dir \
#     "parsl[aws,globus_compute]" \
#     "globus-compute-endpoint" \
#     "rclone-python" &&\
#     # Try best effort to avoid broken pip packages
#     pip check &&\ 
#     uv cache clean && rm -rf ${HOME}/.cache/uv &&\
#     mamba remove --prefix /opt/conda -y compilers &&\
#     mamba clean --all -f -y

# Make matplotlib rc file
COPY --chown=${NB_UID}:${NB_GID} ./matplotlibrc "${HOME}/.config/matplotlib/matplotlibrc"
COPY --chown=${NB_UID}:${NB_GID} "./fonts/Felipa,Fira_Code,Fira_Sans.zip" /tmp/Felipa,Fira_Code,Fira_Sans.zip
RUN unzip /tmp/Felipa,Fira_Code,Fira_Sans.zip 
# USER root
# RUN fix-permissions "$HOME/.config"

# USER "$NB_UID"
