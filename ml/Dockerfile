ARG BASE_CONTAINER="ghcr.io/alchem0x2a/base-notebook:cuda"
FROM ${BASE_CONTAINER}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"

USER root
RUN apt-get update &&\
    apt-get install -yq --no-install-recommends \
    curl unzip zip git rsync rclone nano &&\
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&\
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null &&\
    apt-get update && apt-get install gh &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    fix-permissions /opt

USER $NB_UID
# Install the pytorch stack is the most cumbersome part.
# The following only works for amd64 machine
WORKDIR /opt
ARG OCP_COMMIT_HASH=7ad64195b0317f45a148d24b3243b667a4428c83
RUN git clone --depth 1 https://github.com/Open-Catalyst-Project/ocp.git &&\
    cd ocp && git fetch origin ${OCP_COMMIT_HASH} && git checkout ${OCP_COMMIT_HASH}


RUN ARCH=$(uname -m) && echo build on $ARCH &&\
    if [[ "$ARCH" == "x86_64" ]]; then\
      mamba install --yes -c pyg -c pytorch -c nvidia -c conda-forge \
      pyg=2.1.0 pytorch=1.13 cudatoolkit numpy=1.26 scipy=1.11;\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    else\
      mamba install --yes -c pytorch -c nvidia -c conda-forge compilers pytorch=1.13 numpy=1.26 scipy=1.11;\
      pip install pip install torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.1.0+cpu.html;\
      mamba remove --yes compilers;\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    fi
    
RUN mamba install --yes \
    ase>=3.22.1 black>=22.3.0 dask e3nn=0.4.4 ipywidgets matplotlib numba orjson \
    pre-commit=2.10.* pymatgen>=2023.5.10 pyyaml tensorboard tqdm pytest \
    lmdb python-lmdb tqdm submitit syrupy=3.0.6 wandb &&\
     mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}"
    
# RUN chmod 1777 /tmp && chmod 1777 /var/tmp

# ARG NB_USER="jovyan"
# ARG NB_UID="1000"
# ARG NB_GID="100"

# ENV CONDA_DIR=/opt/conda \
#     SHELL=/bin/bash \
#     NB_USER=$NB_USER \
#     NB_UID=$NB_UID \
#     NB_GID=$NB_GID \
#     LC_ALL=en_US.UTF-8 \
#     LANG=en_US.UTF-8 \
#     LANGUAGE=en_US.UTF-8 \
#     HOME=/home/$NB_USER \
#     DEBIAN_FRONTEND=noninteractive

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# RUN apt-get update &&\
#     apt-get install -yq --no-install-recommends \
#     wget \
#     bzip2 \
#     ca-certificates \
#     sudo \
#     git \
#     rsync \
#     rclone \
#     netcat \
#     unzip \
#     nano \
#     locales \
#     fonts-liberation \
#     run-one \
#     && apt-get clean && rm -rf /var/lib/apt/lists/*

# # Fix permissions on user and dir
# COPY fix-permissions /usr/local/bin/fix-permissions
# RUN chmod a+rx /usr/local/bin/fix-permissions
# # Enable prompt color in the skeleton .bashrc before creating the default NB_USER
# RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc
# RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
#     locale-gen

# # Create NB_USER wtih name jovyan user with UID=1000 and in the 'users' group
# # and make sure these dirs are writable by the `users` group.
# RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
#     sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
#     sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
#     useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
#     echo "$NB_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
#     mkdir -p $CONDA_DIR && \
#     chown $NB_USER:$NB_GID $CONDA_DIR && \
#     chmod g+w /etc/passwd && \
#     fix-permissions $HOME && \
#     fix-permissions $CONDA_DIR

# # Make updates
# USER $NB_UID
# WORKDIR $HOME
# ARG PYTHON_VERSION=default
# ENV PATH=$CONDA_DIR/bin:$PATH

# # Install conda as jovyan and check the md5 sum provided on the download site
# ARG MINIFORGE_VERSION="23.3.1-1"

# WORKDIR /tmp
# RUN wget "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-$(uname)-$(uname -m).sh" &&\
#     wget "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-$(uname)-$(uname -m).sh.sha256" &&\
#     sha256sum -c Miniforge3-${MINIFORGE_VERSION}-$(uname)-$(uname -m).sh.sha256 &&\
#     bash Miniforge3-${MINIFORGE_VERSION}-$(uname)-$(uname -m).sh -f -b -p ${CONDA_DIR} &&\
#     # | md5sum -c - && \
#     $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
#     $CONDA_DIR/bin/conda config --system --prepend channels pytorch && \
#     $CONDA_DIR/bin/conda config --system --prepend channels pyg && \
#     $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
#     $CONDA_DIR/bin/conda install --quiet --yes -c conda-forge conda pip mamba setuptools && \
#     $CONDA_DIR/bin/conda update --all --quiet --yes && \
#     $CONDA_DIR/bin/conda clean --all -f -y && \
#     rm -rf /tmp/* &&\
#     rm -rf /home/$NB_USER/.cache/yarn && \
#     fix-permissions $CONDA_DIR && \
#     fix-permissions /home/$NB_USER

# # Generic conda packages
# RUN $CONDA_DIR/bin/mamba install -yq \
#     ipywidgets jupyter-server-proxy jupyter dask joblib \
#     fireworks jsonpickle sqlalchemy spglib scikit-learn \
#     cerberus scikit-image matplotlib-base black pytest \
#     pre-commit tensorboard tqdm wandb lmdb python-lmdb submitit pympler \
#     isort ase gpaw gpaw-data xtb xtb-python sparc-x sparc-x-api psutil &&\
#     mamba clean --all -f -y && \
#     fix-permissions $CONDA_DIR && \
#     fix-permissions /home/$NB_USER

# # x86_64 specific
# RUN if [[ $(uname -m) -eq "x86_64" ]]; then \
#     $CONDA_DIR/bin/mamba install -yq \
#     pyg pytorch cudatoolkit pymatgen; fi

# WORKDIR $HOME
# RUN git clone https://github.com/Open-Catalyst-Project/ocp.git && pip install --no-deps -e ocp
# RUN git clone https://github.com/ulissigroup/finetuna.git && pip install --no-deps -e finetuna
# RUN pip install --no-deps git+https://github.com/ulissigroup/vasp-interactive.git
# RUN mamba init bash
# ENV PATH=$CONDA_DIR/bin:$PATH
# USER $NB_UID
