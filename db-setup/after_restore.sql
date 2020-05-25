-- TO RUN AFTER THE RESTORE HAS BEEN DONE

-- cookwi-api user creation
CREATE USER "cookwi-api" WITH PASSWORD '';

-- cookwi-api can connect to db
GRANT CONNECT
ON DATABASE cookwi 
TO "cookwi-api";

-- grant the rights to all existing tables to cookwi-api
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE
ON ALL TABLES IN SCHEMA public 
TO "cookwi-api";

-- grant the rights to all future tables to cookwi-api
ALTER DEFAULT PRIVILEGES 
FOR ROLE "cookwi-api"
IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO "cookwi-api";

-- WE are GOOD to GO