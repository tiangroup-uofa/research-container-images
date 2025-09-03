# Main image for mlchem applications
# most desired packages should be present
# and the user are welcome to add more
ARG BASE_IMAGE="ghcr.io/tiangroup-uofa/jupyter_pytorch"
ARG VARIANT="cpu"

# Computational packages requiring compilation
FROM ${BASE_IMAGE}:${VARIANT} AS build
USER $NB_UID

WORKDIR $HOME

RUN git clone https://github.com/alchem0x2a/SPARC.git &&\
    mamba install --yes -c conda-forge pip setuptools "conda-build=24.9.0" "colorama=0.4.6"  "ruamel=1.0" ruamel.yaml "rich=13.9" "mamba=1.5.10" "jsonschema=4.23" &&\
    pip install git+https://github.com/mamba-org/boa.git@00a11ffce59f47c0fc576f93d39baf1f8fc92f32 &&\
    cd SPARC &&\
    sed -i 's/DEBUG_MODE=1/DEBUG_MODE=0/' .conda/build.sh &&\
    conda mambabuild .conda/ &&\
    mamba clean --all -f -y

FROM ${BASE_IMAGE}:${VARIANT}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"

COPY --from=build /opt/conda/conda-bld/*/sparc-*.tar.bz2 /tmp/

USER $NB_UID

WORKDIR $HOME

RUN mamba install --yes -c conda-forge \
    # Atomistic modeling / conversion packages
    "pymatgen>=2024" \
    "ase>=3.25"  \
    "openbabel" \
    "phonopy" \
    # Quantum chemistry packages
    "xtb" "xtb-python" \
    "sparc-x-api" \
    # MD packages
    "openmm" \
    # Helper packages
    "wandb" \
    "tqdm" \
    # SPARC / GPAW runtime dependencies (openmpi 4)
    "openmpi=4.*" \
    "libopenblas" \
    "scalapack" \
    "fftw=*=mpi_openmpi_*" &&\
    # Install local sparc-x version
    mamba install --yes /tmp/sparc-*.tar.bz2 &&\
    rm -rf /tmp/sparc-*.tar.bz2 &&\
    mamba clean --all -f -y

    

RUN UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir \
    "mace-torch" &&\
    uv cache clean && rm -rf ${HOME}/.cache/uv
