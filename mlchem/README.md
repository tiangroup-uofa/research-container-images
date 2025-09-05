# `mlchem` series images

The `mlchem_*` series images are intended to be used as the main working images for daily basis.

## Available images
- [`mlchem_slim`](./slim): only add ase / pymatgen / openbabel
- [`mlchem`](./main): the main `mlchem` image containing the ase / pymatgen toolchain, ML force fields, and open source DFT / MD engines.
- [`mlchem_vp`](./proprietary): `mlchem` image with side-loadable proprietary DFT components (currently supporting VASP)


## Variants and Architectures
| Image Name    | Variants          | amd64 | arm64 | Notes                                                           |
|---------------|-------------------|-------|-------|-----------------------------------------------------------------|
| `mlchem_slim` | None              | ✅    | ✅    |                                                                 |
| `mlchem`      | `cpu` (`latest`)  | ✅    | ✅    |                                                                 |
| `mlchem`      | `cuda`            | ✅    | ❌    |                                                                 |
| `mlchem_vp`   | `cpu`  (`latest`) | ✅    | ✅    | GNU compiler libraries + openblas + scalapack + fftw            |
| `mlchem_vp`   | `cuda`            | ✅    | ❌    | Cuda library for torch + OSS compiler libraries                 |
| `mlchem_vp`   | `nvhpc`           | ✅    | ❌    | NVHPC runtime libraries (e.g. sideloading VASP openacc version) |
