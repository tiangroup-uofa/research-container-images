# Main image for mlchem applications
# most desired packages should be present
# and the user are welcome to add more
ARG BASE_IMAGE="ghcr.io/tiangroup-uofa/jupyter_pytorch"
ARG VARIANT="cpu"

# Computational packages requiring compilation
FROM ${BASE_IMAGE}:${VARIANT} AS build
USER $NB_UID

WORKDIR $HOME

# Install the standard conda-build toolchain (in build stage only)
RUN mamba install --yes -c conda-forge \
    conda-build \
    pip \
    setuptools &&\
    conda-build --version

# Compile SPARC as a local conda package
# We'll use the group fork of SPARC
RUN git clone --depth 1 https://github.com/tiangroup-uofa/SPARC.git &&\
    cd SPARC &&\
    sed -i 's/DEBUG_MODE=1/DEBUG_MODE=0/' .conda/build.sh &&\
    conda-build .conda/ &&\
    mkdir -p /tmp/sparc-package &&\
    sparc_package="$(find /opt/conda/conda-bld -maxdepth 2 -type f -name 'sparc-*' -print -quit)" &&\
    test -n "$sparc_package" &&\
    cp "$sparc_package" /tmp/sparc-package/

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
ARG VARIANT

LABEL maintainer="T.Tian <alchem0x2a@gmail.com>"

USER $NB_UID

WORKDIR $HOME

COPY --from=build /tmp/sparc-package/ /tmp/sparc-package/
COPY --from=build /tmp/gpaw-*.whl /tmp/

USER root
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
    "fftw=*=mpi_openmpi_*" \
    "libxc" \
    "libvdwxc=*=mpi_openmpi_*" &&\
    # Install local sparc-x version
    mamba install --yes /tmp/sparc-package/sparc-* &&\
    UV_PYTHON=/opt/conda/bin/python \
    uv pip install --no-cache-dir --no-deps \
    "click>=8.3.3,<8.4.0" /tmp/gpaw-*.whl gpaw-data &&\
    rm -rf /tmp/* &&\
    # Try best effort to avoid broken pip packages
    pip check &&\
    mamba clean --all -f -y &&\
    fix-permissions /opt/conda

USER $NB_UID
WORKDIR $HOME


# PyTriton is published on PyPI, not conda-forge. torch-sim is currently
# available for the CUDA variant, but its dependency stack is not portable
# to the CPU arm64 build.
RUN export UV_PYTHON=/opt/conda/bin/python &&\
    if [ "$VARIANT" = "cuda" ]; then \
        uv pip install --no-cache-dir \
            --torch-backend="cu126" \
            "nvidia-pytriton" "mace-torch" "torch-sim-atomistic"; \
    else \
        uv pip install --no-cache-dir \
            "nvidia-pytriton" "mace-torch"; \
    fi &&\
    # Try best effort to avoid broken pip packages
    pip check &&\
    uv cache clean && rm -rf ${HOME}/.cache/uv
