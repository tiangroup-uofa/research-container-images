# Main image for mlchem applications
# most desired packages should be present
# and the user are welcome to add more
ARG BASE_IMAGE="ghcr.io/tiangroup-uofa/jupyter_pytorch"
ARG VARIANT="cpu"

# Computational packages requiring compilation
FROM ${BASE_IMAGE}:${VARIANT} AS build
USER $NB_UID

WORKDIR $HOME

# Install the mambabuild toolchain (in build stage only)
RUN mamba install --yes -c conda-forge pip setuptools "conda-build=24.9.0" "colorama=0.4.6"  "ruamel=1.0" ruamel.yaml "rich=13.9" "mamba=1.5.10" "jsonschema=4.23" &&\
    pip install git+https://github.com/mamba-org/boa.git@00a11ffce59f47c0fc576f93d39baf1f8fc92f32

# Compile SPARC as a local conda tarball
# We'll use the group fork of SPARC
RUN git clone --depth 1 https://github.com/tiangroup-uofa/SPARC.git &&\
    cd SPARC &&\
    sed -i 's/DEBUG_MODE=1/DEBUG_MODE=0/' .conda/build.sh &&\
    conda mambabuild .conda/

# Compile gpaw as a local wheel (no cleanup needed)
# as gpaw 24.6 from conda-forge still relies on numpy 1.26
COPY gpaw/siteconfig.py /tmp/gpaw/siteconfig.py
RUN mamba install --yes -c conda-forge \
    compilers \
    openblas openmpi=4.* \
    libxc libvdwxc=*=mpi_openmpi_* \
    fftw=*=mpi_openmpi_* \
    scalapack &&\
    GPAW_CONFIG=/tmp/gpaw/siteconfig.py \
    pip wheel -w /tmp --no-deps gpaw==25.7


FROM ${BASE_IMAGE}:${VARIANT}

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"

USER $NB_UID

WORKDIR $HOME

COPY --from=build /opt/conda/conda-bld/*/sparc-*.tar.bz2 /tmp/
COPY --from=build /tmp/gpaw-*.whl /tmp/

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
    # globus-compute-endpoint requests a special version of click
    # so try best to pin
    "click<8.2.0" \
     "tqdm" \
    # SPARC / GPAW runtime dependencies (openmpi 4)
    "openmpi=4.*" \
    "libopenblas" \
    "scalapack" \
    "fftw=*=mpi_openmpi_*" \
    "libxc" \
    "libvdwxc=*=mpi_openmpi_*" &&\
    # Install local sparc-x version
    mamba install --yes /tmp/sparc-*.tar.bz2 &&\
    pip install --no-cache-dir --no-deps /tmp/gpaw-*.whl gpaw-data &&\
    rm -rf /tmp/* &&\
    # Try best effort to avoid broken pip packages
    pip check &&\
    mamba clean --all -f -y



RUN UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir \
    "mace-torch" &&\
    # Try best effort to avoid broken pip packages
    pip check &&\
    uv cache clean && rm -rf ${HOME}/.cache/uv
