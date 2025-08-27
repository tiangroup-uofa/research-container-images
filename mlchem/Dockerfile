# Main image for mlchem applications
# most desired packages should be present
# and the user are welcome to add more
ARG BASE_IMAGE="ghcr.io/alchem0x2a/mlchem_pytorch"
ARG VARIANT="cpu"
FROM ${BASE_IMAGE}:${VARIANT}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"

USER $NB_UID

WORKDIR $HOME

RUN mamba install --yes -c conda-forge\
    "pymatgen>=2024" "ase>=3.25" "xtb" "xtb-python" \
    "matplotlib" "tqdm" "wandb" "spglib" "openbabel" \
    "gpaw" "gpaw-data" \
    "openmm" \
    "sparc-x-api" \
    "phonopy" &&\
    mamba clean --all -f -y

RUN UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir \
    "mace-torch" &&\
    uv cache clean && rm -rf ${HOME}/.cache/uv
