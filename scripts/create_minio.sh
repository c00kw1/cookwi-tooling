#!/bin/sh

$name = "s3";
$port = "9000";
$network = "bridge"

$admin_key = "";
$admin_secret = "";

# create volume
docker volume create $name

# run instance
docker run -d -p 127.0.0.1:6000:9000 \
  --name s3 \
  -v minio-data:/data \
  -e "MINIO_ACCESS_KEY=" \
  -e "MINIO_SECRET_KEY=" \
  --network=bridge \
  minio/minio:latest server /data
