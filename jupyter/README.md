# `jupyter` series images

The `jupyter_*` series images are to be used as start-point base images for other images, or directly as test Jupyter environment. The architecture is adapted from https://github.com/jupyter/docker-stacks.

## Available images
This series is composed of layered images, where each sub-image builds on the previous one:

- [`jupyter_base`](./base): minimal container with Jupyter and a few useful cmdline tools (`rsync`, `rclone`, `tmux`, `nano`, etc).
- [`jupyter_worker`](./worker): adding [`parsl`](https://github.com/Parsl/parsl) and [`globus-compute-endpoint`](https://github.com/globus/globus-compute) to `jupyter_base`, can be used as standalone workers on remote systems.
- [`jupyter_pytorch`](./pytorch): adding `pytorch` to `jupyter_worker` image.


## Variants and Architectures
| Image Name        | Variants      | amd64 | arm64      | Notes                      |
|-------------------|---------------|-------|------------|----------------------------|
| `jupyter_base`    | None          | ✅    | ✅         |                            |
| `jupyter_worker`  | None          | ✅    | ✅         |                            |
| `jupyter_pytorch` | `cpu`, `cuda` | ✅    | `cpu` only | `pytorch==2.7` `cuda=11.8` |

