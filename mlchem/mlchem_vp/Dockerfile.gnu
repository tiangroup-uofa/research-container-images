# MLchem with runtime dependencies for proprietary
# quantum chem codes (like VASP)
# The image only adds the runtime dependencies
ARG BASE_IMAGE="ghcr.io/tiangroup-uofa/mlchem"
ARG VARIANT="cpu"

FROM ${BASE_IMAGE}:${VARIANT}

USER root
COPY ./dependencies/gnu.runtime /tmp/gnu.runtime
RUN apt-get update &&\
    xargs -a /tmp/gnu.runtime \
    apt-get install -yq --no-install-recommends &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    # Create placeholder vasp dirs
    mkdir -p /opt/vasp/cpu /opt/vasp/gpu /opt/vasp/vasp_pp &&\
    fix-permissions /opt/vasp

USER ${NB_UID}
WORKDIR ${HOME}
