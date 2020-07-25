# to configure a connection with a user (make this for admin, homolo and prod)
.\mc.exe config host add cookwi-<admin|homolo|prod> https://s3.cookwi.com <key> <secret>

# add user
.\mc.exe admin user add cookwi-admin <key> <secret>

# add policy
.\mc.exe admin policy add cookwi-admin <policy-name> policy-homolo.json

# set policy to a user
.\mc.exe admin policy set cookwi-admin <policy-name> user=<key>