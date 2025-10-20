# New Cloud Computing Repository

[![pre-commit](https://github.com/castacks/Cloud-Computing-Repository-Template/actions/workflows/pre-commit.yml/badge.svg?branch=main)](https://github.com/castacks/Cloud-Computing-Repository-Template/actions/workflows/pre-commit.yml)

## Dependencies

- [Docker](https://docs.docker.com/get-docker/)
- [Singularity/Apptainer](https://apptainer.org/)

## Usage Guidelines

TLDR: Search for `todo` and update all occurrences to your desired name

Docker and singularity is not a must unless you cannot install some dependencies locally on HPC shell environment due to permission issue

### Base Repository

1. Change [LICENSE](LICENSE) if necessary

1. Modify [.pre-commit-config.yaml](.pre-commit-config.yaml) according to your need

1. Modify/add GitHub workflow status badges in [README.md](README.md)

### Docker Config

Continue on a machine where you have docker permission, HPC clusters usually restrict docker access for security reasons

1. Modify `todo-docker-user`, `todo-base-image`, `todo-image-name`, `todo-image-user` in [.env](.env)

   - [.env](.env) will be loaded when you use docker compose for build/run/push
   - `todo-docker-user` refers to your docker hub account username
   - `todo-base-image` is the image dockerfile is based on, such as `nvidia/cuda:13.0.0-cudnn-devel-ubuntu24.04`
   - `todo-image-user` refers to the default user inside the image, which is used to determine home folder

1. Modify the service name from `todo-service-name` to your service name in [docker-compose.yml](docker-compose.yml), add additional volume mounting options such as dataset directories

1. Update [Dockerfile](docker/latest/Dockerfile) and [.dockerignore](.dockerignore)

   - Existing dockerfile has screen & tmux config, oh-my-zsh, cmake, and other basic goodies
   - Add any additional dependency installations at appropriate locations

1. [build_docker_image.sh](scripts/build_docker_image.sh) to build and test the image locally in your machine's architecture

   - The scripts uses buildx to build multi-arch image, you can disable this by removing redundant archs in [docker-compose.yml](docker-compose.yml)
   - Building stage does not have GPU access, if some of your dependencies need GPU, build them inside a running container and commit to the final image

1. [run_docker_container.sh](scripts/run_docker_container.sh) or `docker compose up -d` to run and test a built image

   - The service by default will mount the whole repository onto `CODE_FOLDER` inside the container so any modification inside also takes effect outside, which is useful when you use vscode remote extension to develop inside a running container with remote docker context
   - You should be able to run and see GUI applications inside the container if `DISPLAY` is set correctly when you run the script

1. [push_docker_image.sh](scripts/push_docker_image.sh) to push the multi-arch image to docker hub

   - You should have the docker hub repository set up before pushing

### Singularity Config

Continue on the actual HPC cluster environment

1. [pull_singularity_image.sh](scripts/pull_singularity_image.sh) to build the singularity image locally

   - Singularity image can be built upon existing docker image
   - You should see the image `todo-image-name_latest.def` after successfully built

1. [run_singularity_instance.sh](scripts/run_singularity_instance.sh) to test the image

   - Add additional volume binding options to the script such as dataset directories, best practice is to define in [.env](.env) then export in [variables.sh](scripts/variables.sh) with `resolve_host_path` to turn relative path into absolute real path
   - Singularity instances by default have less environment isolation than docker containers unless you specify the additional options like the script

### Job Config

1. Modify job specifications under `jobs/`

   - Each (HPC) Slurm environment has different partition definitions, which are often heterogeneous, you can query this by `sinfo` with some options
   - `--ntasks-per-node` specifies number of parallelization, and it's convenient to tie other resources to task, e.g., `--gpus-per-task`, `--cpus-per-task`, `--mem-per-gpu`, so that you only need to increase ntasks to scale up on a node
   - All the jobs have `-l`(login) options in shebang so that any command working in your current shell environment should also run as a job

1. `sbatch jobs/your-cluster/your-job.job` or `jobs/your-cluster/your-job.job` to submit jobs

   - You should see a file `todo_your_job_name_slurm_job_id.out` in the base folder of this repository, which contains job logs

1. Recommend [turm](https://github.com/kabouzeid/turm) for job monitor outside the job, use `turm -u your-slurm-user` after installation

## Developer Quick Start

- Run [dev_setup.sh](scripts/dev_setup.sh) to setup the development environment

## Maintainer

- Mukai (Tom Notch) Yu: [mukaiy@andrew.cmu.edu](mailto:mukaiy@andrew.cmu.edu)
