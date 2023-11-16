ARG BASE_CONTAINER="ghcr.io/alchem0x2a/base-notebook:cuda"
FROM ${BASE_CONTAINER}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"



USER $NB_UID
# Install the pytorch stack is the most cumbersome part.
# The following only works for amd64 machine
WORKDIR $HOME
ARG OCP_COMMIT_HASH=7ad64195b0317f45a148d24b3243b667a4428c83
    
# Several dependencies are lacking in the conda-forge aarch64 channel. Use pip
# ambertools / packmol are currently only available in linux-64
RUN mamba install --yes -c conda-forge\
    "ase>=3.22" black dask e3nn ipywidgets matplotlib numba orjson \
    pre-commit pyyaml tensorboard tqdm pytest \
    lmdb python-lmdb tqdm submitit syrupy wandb joblib loguru\
    monty networkx palettable pandas plotly pybtex requests ruamel.yaml spglib sympy \
    fireworks custodian tabulate uncertainties \
    # Quantum chem depedencies
    openbabel xtb xtb-python dftd3-python dftd4-python gpaw gpaw-data sparc-x sparc-x-api psutil openmm\
    &&\
    ARCH=$(uname -m) && echo build on $ARCH &&\
    if [[ "$ARCH" == "x86_64" ]]; then\
      mamba install --yes -c conda-forge pymatgen rdkit datamol ambertools packmol &&\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    else\
      pip install --no-cache-dir pymatgen rdkit datamol;\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    fi &&\
    git clone --depth 1 https://github.com/Open-Catalyst-Project/ocp.git &&\
    cd ocp && git fetch origin ${OCP_COMMIT_HASH} && git checkout ${OCP_COMMIT_HASH} && cd ../ &&\
    pip install --no-deps -e ./ocp &&\
    git clone --depth 1 https://github.com/ulissigroup/finetuna.git && pip install --no-deps -e ./finetuna &&\
    git clone --depth 1 https://github.com/ulissigroup/vasp-interactive.git && pip install --no-deps -e ./vasp-interactive
