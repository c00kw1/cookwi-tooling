create table if not exists rcpingunt
(
    nam varchar(50) not null
        constraint rcpingunt_pk
            primary key
);

comment on column rcpingunt.nam is 'Name (and key) of the unit type';

create table if not exists tag
(
    id     uuid default uuid_generate_v4() not null
        constraint tag_pk
            primary key,
    tagnam varchar(25)                     not null
);

create table if not exists usr
(
    id     uuid default uuid_generate_v4() not null
        constraint usr_pk
            primary key,
    bthdat date,
    gen    varchar(6)
);

comment on column usr.id is 'Unique identifier';

comment on column usr.bthdat is 'User''s birthdate';

comment on column usr.gen is 'User''s gender';

create table if not exists rcp
(
    id     uuid default uuid_generate_v4() not null
        constraint recipes_pk
            primary key,
    ownid  uuid                            not null
        constraint rcp_fk
            references usr,
    rcptit varchar(255)                    not null,
    datadd timestamp                       not null,
    rcpdsc text,
    rcpimg text,
    coktim time,
    baktim time
);

comment on column rcp.id is 'Unique Id';

comment on column rcp.ownid is 'Id of the owner of the recipe';

comment on column rcp.rcptit is 'Title of the recipe';

comment on column rcp.datadd is 'Date of creation';

comment on column rcp.rcpdsc is 'Recipe description';

comment on column rcp.rcpimg is 'Url of the img describing the recipe';

comment on column rcp.coktim is 'Cooking time';

comment on column rcp.baktim is 'Baking time';

create table if not exists rcping
(
    id     uuid default uuid_generate_v4() not null
        constraint rcping_pk
            primary key,
    rcpid  uuid                            not null
        constraint rcping_fk
            references rcp,
    nam    varchar(250)                    not null,
    qty    double precision                not null,
    qtyunt varchar(50)                     not null
        constraint rcping_fk_1
            references rcpingunt
);

comment on column rcping.id is 'Unique identifier';

comment on column rcping.rcpid is 'Recipe Id it belongs to';

comment on column rcping.nam is 'Name of the ingredient';

comment on column rcping.qty is 'Quantity of the ingredient';

comment on column rcping.qtyunt is 'Unit of the quantity';

create table if not exists rcpstp
(
    id     uuid default uuid_generate_v4() not null
        constraint rcpstp_pk
            primary key,
    rcpid  uuid                            not null
        constraint rcpstp_fk
            references rcp,
    stpnum integer                         not null,
    stptxt text                            not null
);

comment on column rcpstp.id is 'Unique identifier';

comment on column rcpstp.rcpid is 'Id of the recipe the step depends';

comment on column rcpstp.stpnum is 'Place num of the step into the recipe';

comment on column rcpstp.stptxt is 'Content of the step';

create table if not exists rcptag
(
    rcpid uuid not null
        constraint rcptag_fk
            references rcp,
    tagid uuid not null
        constraint rcptag_fk_1
            references tag,
    constraint rcptag_pk
        primary key (rcpid, tagid)
);

create table if not exists usrinv
(
    id     uuid    default uuid_generate_v4() not null
        constraint usrinv_pk
            primary key,
    datadd timestamp                          not null,
    datexp timestamp                          not null,
    use    boolean default false              not null
);

comment on table usrinv is 'Invitations for users registration';

comment on column usrinv.id is 'Invitation id';

comment on column usrinv.datadd is 'Date when the entry was generated';

comment on column usrinv.datexp is 'Date for invitation expiration';

comment on column usrinv.use is 'Invitation has been used';

