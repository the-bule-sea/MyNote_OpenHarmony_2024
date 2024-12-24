create table users
(
    id              uuid not null
        primary key,
    hashed_password varchar(255),
    salt            varchar(255),
    user_name       varchar(255)
        unique
);

alter table users
    owner to postgres;

create table notes
(
    created_date       timestamp(6) with time zone,
    last_modified_date timestamp(6) with time zone,
    id                 uuid not null
        primary key,
    user_id            uuid
        constraint fkechaouoa6kus6k1dpix1u91c
            references users,
    title              varchar(255),
    content            oid
);

alter table notes
    owner to postgres;

