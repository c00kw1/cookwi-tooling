# install choco package minio
choco install minio-client -y

# to configure a connection with a user (make this for admin, homolo and prod)
mc config host add cookwi-<admin|homolo|prod> https://s3.cookwi.com <key> <secret>

# add user
mc admin user add cookwi-admin <key> <secret>

# add policy
mc admin policy add cookwi-admin <policy_name> <policy_file>

# set policy to a user
mc admin policy set cookwi-admin <policy_name> user=<key>