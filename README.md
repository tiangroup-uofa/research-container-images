# Research Container Images Collection

This repository hosts container `Dockerfile`s for research-oriented
workflows, scientific visualization and miscellaneous tasks. The aim
is to provide repeatable and portable environments, across different
users, computational environments and architectures within and beyond
the group. 

> [!NOTE]  
> Public images are hosted on the GitHub Container Registry [ghcr.io](ghcr.io).

## Basic Usage
### Engine selection
To use any of the images in this repository, you will need a container engine (a tool that can run containerized environments).
A variety of engines are available depending on your setup:
- On personal PC / workstation:
  - [`Podman`](https://podman.io): our recommended engine for running container images due to enhanced safety. Available both as GUI desktop app and standalone engine.
  - [`Docker`](https://docs.docker.com/manuals/): one of the most popular engines, but may pose security issue in some cases.
- High-Performance Computing (HPC) clusters
  - [`Apptainer`](https://apptainer.org): formerly known as `Singularity`, runs container on a local file (`.sif` format). This is the container engine used on most Digital Alliance HPC clusters in Canada.
  - [`Shifter`](https://github.com/NERSC/shifter): container engine developed by National Energy Research Scientific Computing Center (NERSC).
- General-purpose clusters
  - [`kubernetes`](https://kubernetes.io): orchestration system for managing containers across nodes in local or cloud environments (GCE, AWS)

Consult your system admin about the container usage and security
policy. Most of the examples in this README will be based on personal
PC usage via `podman` or `docker` commands.

> [!NOTE]  
> The `podman` command from the examples in this repository is interchangeable with `docker`

### Pull the image
All available container images can be found in [the packages page](https://github.com/orgs/tiangroup-uofa/packages?repo_name=research-container-images), which use the following naming convention:
```bash
ghcr.io/tiangroup-uofa/<image-name>:<tag>
```

The `<image-name>` part may look like `mlchem_pytorch` and `<tag>` may accept
`cpu`, `cuda` etc. The container engine (`podman` / `docker` etc) may
choose an image suitable for the current CPU architecture
(amd64/arm64) automatically.

> [!IMPORTANT]  
> Unlike many examples from docker documentation, the `ghcr.io` prefix
> cannot be omitted when pulling an image.

> [!IMPORTANT]  
> If no `<tag>` is provided, it will default to `latest`. In most
> images it assumes the image with only CPU support.

### Run a jupyter server from the container
The `mlchem` series of images have built-in `jupyter` server scripts (as
default command). Without providing 





Supported Architectures • amd64 • arm64

All mlchem images are built on Ubuntu 22.04 and extend the Jupyter Docker Stacks.

⸻

Available Images
