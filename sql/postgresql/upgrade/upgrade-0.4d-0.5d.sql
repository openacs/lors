-- 
-- packages/lors/sql/postgresql/upgrade/upgrade-0.4d-0.5d.sql
-- 
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- @creation-date 2004-11-14
-- @arch-tag: c62faf32-6b47-4f29-80aa-ea606bd0112e
-- @cvs-id $Id$
--

-- Create a proper sequence for ims md md scheme as it wasn't properly created before
--

drop table ims_md_metadata_scheme;

--create sequence for ims_md_metadata_scheme table
create sequence ims_md_metadata_scheme_seq start 1;

create table ims_md_metadata_scheme (
    ims_md_md_sch_id    integer
                        constraint ims_md_md_sch_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ms_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    scheme              varchar(30)
);

comment on table ims_md_metadata_scheme is '
Names the structure of the meta-data (this includes version).
unordered list; smallest permitted maximum: 10 items
String (30 char)
';
