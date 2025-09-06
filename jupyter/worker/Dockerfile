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
    'tqdm' &&\
    mamba clean --all -f -y &&\
    # Try best effort to avoid broken pip packages
    pip check

# parsl and GCE are currently better installed by uv/pip
# Add compilers in case aarch64 didn't work
RUN mamba install --yes -c conda-forge \
    compilers &&\
    UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir \
    "parsl[aws,globus_compute]" \
    "globus-compute-endpoint" \
    "rclone-python" &&\
    # Try best effort to avoid broken pip packages
    pip check &&\
    uv cache clean && rm -rf ${HOME}/.cache/uv &&\
    mamba remove --prefix /opt/conda -y compilers &&\
    mamba clean --all -f -y

# Make matplotlib rc file
COPY --chown=${NB_UID}:${NB_GID} ./matplotlibrc "${HOME}/.config/matplotlib/matplotlibrc"

# Update the fonts
RUN mkdir -p "${HOME}/.fonts" && \
    rm -rf /tmp/*.zip && wget -O /tmp/fonts.zip https://github.com/tiangroup-uofa/research-container-images/releases/download/binary/Felipa.Fira_Code.Fira_Sans.zip &&\
    unzip /tmp/fonts.zip -d ~/.fonts &&\
    rm /tmp/*.zip &&\
    # Update mplcache
    # https://github.com/jupyter/docker-stacks/blob/52cc4677349c4a94e7481811d3953c2cc3e9e2fe/docs/using/recipes.md?plain=1#L443
    rm -rf "${HOME}/.cache/matplotlib" &&\
    python -c "import sys; \
               import matplotlib.font_manager; \
               fnames = set([f.name for f in matplotlib.font_manager.FontManager().ttflist]); \
               assert \"Fira Sans\" in fnames; \
               assert \"Fira Code\" in fnames; \
               assert \"Felipa\" in fnames"
