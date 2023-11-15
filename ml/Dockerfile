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
      pip install --no-cache-dir torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.1.0+cpu.html;\
      mamba remove --yes compilers;\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    fi
    
# pymatgen dependencies are installed
RUN mamba install --yes -c conda-forge\
    ase=3.22 black dask e3nn ipywidgets matplotlib numba orjson \
    pre-commit pyyaml tensorboard tqdm pytest \
    lmdb python-lmdb tqdm submitit syrupy wandb joblib \
    monty networkx palettable pandas plotly pybtex requests ruamel.yaml spglib sympy \
    tabulate uncertainties &&\
    mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}"

# Pymatgen is not available on aarch64 conda yet
RUN ARCH=$(uname -m) && echo build on $ARCH &&\
    if [[ "$ARCH" == "x86_64" ]]; then\
      mamba install --yes -c conda-forge pymatgen &&\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    else\
      pip install --no-cache-dir pymatgen;\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    fi

# Enable ocp
RUN pip install -e /opt/ocp
