# New Cloud Computing Repository

[![pre-commit](https://github.com/Tom-Notch/Cloud-Computing-Repository-Template/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/Tom-Notch/Cloud-Computing-Repository-Template/actions/workflows/pre-commit.yml)

## Dependencies

- [Docker](https://docs.docker.com/get-docker/)
- [Singularity/Apptainer](https://apptainer.org/)

## Usage Guidelines

TLDR: Search for `todo` and update all occurrences to your desired name

Docker and singularity is not a must unless you cannot install some dependencies locally on HPC shell environment due to permission issue

### Base Repo

1. Change [LICENSE](LICENSE) if necessary

1. Modify [.pre-commit-config.yaml](.pre-commit-config.yaml) according to your need

1. Modify/add GitHub workflow status badges in [README.md](README.md)

### Docker Config

1. Modify `DOCKER_USER`, `IMAGE_NAME`, `IMAGE_USER` in [.env](.env)

   - [.env](env) will be loaded when you use docker compose for build/run/push/...
   - `DOCKER_USER` refers to your docker hub account username
   - `IMAGE_USER` refers to the default user inside the image, which is used to determine home folder

1. Modify the service name from `default` to your service name in [docker-compose.yml](docker-compose.yml), add additional volume mounting options such as dataset directories

1. Update [Dockerfile](docker/latest/Dockerfile) and [.dockerignore](.dockerignore)

   - Existing dockerfile has screen & tmux config, oh-my-zsh, cmake, and other basic goodies
   - Add any additional dependency installations at appropriate locations

1. [build_docker_image.sh](scripts/build_docker_image.sh) to build and test the image locally in your machine's architecture

   - Do this on a machine where you have docker permission, HPC clusters usually restrict docker access for security reasons
   - The scripts uses buildx to build multi-arch image, you can disable this by removing redundant archs in [docker-compose.yml](docker-compose.yml)
   - Building stage does not have GPU access, if some of your dependencies need GPU, build them inside a running container and commit to the final image

1. To run and test a built image, use [run_docker_container.sh](scripts/run_docker_container.sh) or `docker compose up -d`

   - The service by default will mount the whole repository onto `CODE_FOLDER` inside the container so any modification inside also takes effect outside, which is useful when you use vscode remote extension to develop inside a running container with remote docker context

1. [push_docker_image.sh](scripts/push_docker_image.sh) to push the multi-arch image to docker hub

   - You should have the docker hub repository set up before pushing

### Singularity Config

1. [pull_singularity_image.sh](scripts/pull_singularity_image.sh) to build the singularity image locally

   - Singularity image can be built upon existing docker image

1. [run_singularity_instance.sh](scripts/run_singularity_instance.sh) to test the image

   - Add additional volume binding options to the script such as dataset directories, best practice is to define in [.env](.env) then export in [variables.sh](scripts/variables.sh) with `resolve_host_path` to turn relative path into absolute real path
   - Singularity instances by default has less environment separation than docker containers unless you specify the additional options like the script

### Job Config

1. Modify job specifications under [jobs/](jobs/)

   - Each (HPC) Slurm environment has different partition definitions, which are often heterogeneous, you can query this by `sinfo` with some options
   - All the jobs has `-l`(login) options in shebang so that any command working in your current shell environment should also run as a job

1. Submit job by `sbatch jobs/your-cluster/your-job.job` or `jobs/your-cluster/your-job.job`

1. Recommend [turm](https://github.com/kabouzeid/turm) for job monitor, use `turm -u your-slurm-user` after installation

## Developer Quick Start

- Run [dev_setup.sh](scripts/dev_setup.sh) to setup the development environment

## Maintainer

- Mukai (Tom Notch) Yu: [mukaiy@andrew.cmu.edu](mailto:mukaiy@andrew.cmu.edu)
