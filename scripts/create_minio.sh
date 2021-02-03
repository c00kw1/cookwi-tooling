#!/bin/sh

$name = "cookwi-minio";
$port = "9000";
$network = "bridge"

$admin_key = "";
$admin_secret = "";

# create volume
docker volume create $name

# run instance
docker run -d -p 0.0.0.0:$port:9000 \
  --name $name \
  -v $name:/data \
  -e "MINIO_ACCESS_KEY=$admin_key" \
  -e "MINIO_SECRET_KEY=$admin_secret" \
  --network=$network \
  minio/minio server /data
