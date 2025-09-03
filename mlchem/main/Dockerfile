# Main image for mlchem applications
# most desired packages should be present
# and the user are welcome to add more
ARG BASE_IMAGE="ghcr.io/tiangroup-uofa/jupyter_pytorch"
ARG VARIANT="cpu"

# Computational packages requiring compilation
FROM ${BASE_IMAGE}:${VARIANT} as build
USER $NB_UID

WORKDIR $HOME

RUN git clone https://github.com/alchem0x2a/SPARC.git &&\
    mamba install --yes -c conda-forge pip setuptools "conda-build=24.9.0" "colorama=0.4.6"  "ruamel=1.0" ruamel.yaml "rich=13.9" "mamba=1.5.10" "jsonschema=4.23" &&\
    pip install git+https://github.com/mamba-org/boa.git@00a11ffce59f47c0fc576f93d39baf1f8fc92f32 &&\
    cd SPARC &&\
    CPU_COUNT=<ncores> conda mambabuild .conda/
    mamba install --yes -c conda-forge \
    mamba clean --all -f -y

FROM ${BASE_IMAGE}:${VARIANT}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"


USER $NB_UID

WORKDIR $HOME

RUN mamba install --yes -c conda-forge \
    "pymatgen>=2024" "ase>=3.25" "xtb" "xtb-python" \
    "matplotlib" "tqdm" "wandb" "spglib" "openbabel" \
    "openmm" \
    "sparc-x-api" \
    "phonopy" &&\
    mamba clean --all -f -y

# # Computational packages that requires compilation
# RUN  &&\
#     mamba install --yes -c conda-forge \

    

RUN UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir \
    "mace-torch" &&\
    uv cache clean && rm -rf ${HOME}/.cache/uv
