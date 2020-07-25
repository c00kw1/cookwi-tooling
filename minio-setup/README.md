# S3 setup

We use [Minio](https://min.io/) as S3 solution provider.

## Install

We use it in docker container.
For now we just have one instance for homologation and production and we handle the separation with users and buckets.

* see `minio` nginx config file for Homologation/Production hosting