ARG BASE_CONTAINER="ghcr.io/alchem0x2a/base-notebook:cuda"
FROM ${BASE_CONTAINER}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"



USER $NB_UID
# Install the pytorch stack is the most cumbersome part.
# The following only works for amd64 machine
WORKDIR $HOME
ARG OCP_COMMIT_HASH=7ad64195b0317f45a148d24b3243b667a4428c83
RUN 
    
# pymatgen dependencies are installed
RUN mamba install --yes -c conda-forge\
    "ase>=3.22" black dask e3nn ipywidgets matplotlib numba orjson \
    pre-commit pyyaml tensorboard tqdm pytest \
    lmdb python-lmdb tqdm submitit syrupy wandb joblib \
    monty networkx palettable pandas plotly pybtex requests ruamel.yaml spglib sympy \
    fireworks custodian tabulate uncertainties \
    # Quantum chem depedencies
    datamol openbabel xtb xtb-python dftd3-python dftd4-python gpaw gpaw-data sparc-x sparc-x-api psutil &&\
    &&\
    ARCH=$(uname -m) && echo build on $ARCH &&\
    if [[ "$ARCH" == "x86_64" ]]; then\
      mamba install --yes -c conda-forge pymatgen &&\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    else\
      pip install --no-cache-dir pymatgen;\
      mamba clean --all -f -y && fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}";\
    fi &&\
    git clone --depth 1 https://github.com/Open-Catalyst-Project/ocp.git &&\
    cd ocp && git fetch origin ${OCP_COMMIT_HASH} && git checkout ${OCP_COMMIT_HASH} &&\
    pip install -e --no-deps ./ocp &&\
    git clone --depth 1 https://github.com/ulissigroup/finetuna.git && pip install --no-deps -e ./finetuna &&\
    pip install --no-deps git+https://github.com/ulissigroup/vasp-interactive.git
