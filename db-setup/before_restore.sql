-- !!!!!!!!!!!!!! TO RUN BEFORE IMPORTING DATA !!!!!!!!!!!!!!!!!!!!

create schema if not exists public;

-- install uuid generator
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";