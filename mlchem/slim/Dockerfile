# Slim mlchem image that does not depend on torch
# and only include minimal ase / pymatgen libraries
ARG BASE_IMAGE="ghcr.io/tiangroup-uofa/jupyter_worker:latest"
FROM ${BASE_IMAGE}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"

USER $NB_UID

WORKDIR $HOME

RUN mamba install --yes -c conda-forge\
    "pymatgen>=2024" "ase>=3.25" \
    "matplotlib" "tqdm" "openbabel" &&\
    mamba clean --all -f -y
