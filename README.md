# New Docker Repository

[![pre-commit](https://github.com/Tom-Notch/Docker-Repository-Template/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/Tom-Notch/Docker-Repository-Template/actions/workflows/pre-commit.yml)

## Dependencies

- [Docker](https://docs.docker.com/get-docker/)

## Usage Guidelines

### Base Repo

1. Change [LICENSE](LICENSE) if necessary

1. Modify [.pre-commit-config.yaml](.pre-commit-config.yaml) according to your need

1. Modify/add GitHub workflow status badges in [README.md](README.md)

### Docker Config

1. Modify **DOCKER_USER**, **IMAGE_NAME** in [.env](.env)

1. Modify the service name from **default** to your service name in [docker-compose.yml](docker-compose.yml)

1. Update [Dockerfile](docker/latest/Dockerfile)

1. [build.sh](scripts/build.sh) to build and test the image locally in your machine's architecture

1. [push.sh](scripts/push.sh) to push the multi-arch image to the registry

## Developer Quick Start

- Run [scripts/dev-setup.sh](scripts/dev-setup.sh) to setup the development environment

## Note

- This template currently only supports docker image for amd64 and arm64, if you want to support other architectures, please modify the [build.sh](scripts/build.sh) script and [docker-compose.yml](docker-compose.yml) accordingly
