-- IMS Content Packaging Data Model
--
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- @creation-date 6 Jan 2004
-- @cvs-id $Id$

--
--  Copyright (C) 2004 Ernie Ghiglione
--
--  This package is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  It is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

-- And

-- SCORM 1.2 Specs


-----
--   Create the object types
-----

create function inline_0 ()
returns integer as '
begin

    PERFORM acs_object_type__create_type (
                ''ims_manifest'',          -- object_type
                ''IMS_Manifest'',              -- pretty_name
                ''IMS_Manifests'',             -- pretty_plural
                ''acs_object'',            -- supertype
                ''imscp_manifests'',       -- table_name
                ''man_id'',                -- id_column
                null                ,      -- name_method
                ''f'',
                null,
                null
        );
    PERFORM acs_object_type__create_type (
                ''ims_organization'',       -- object_type
                ''IMS_Organization'',            -- pretty_name
                ''IMS_Organizations'',           -- pretty_plural
                ''ims_manifest'',              -- supertype
                ''imscp_organizations'',     -- table_name
                ''org_id'',                  -- id_column
                null,                        -- name_method
                ''f'',
                null,
                null
        );
    PERFORM acs_object_type__create_type (
                ''ims_item'',       -- object_type
                ''IMS_Item'',            -- pretty_name
                ''IMS_Items'',           -- pretty_plural
                ''ims_organization'',              -- supertype
                ''imscp_items'',     -- table_name
                ''item_id'',                  -- id_column
                null,                        -- name_method
                ''f'',
                null,
                null
        );
    PERFORM acs_object_type__create_type (
                ''ims_resource'',       -- object_type
                ''IMS_Resource'',            -- pretty_name
                ''IMS_Resources'',           -- pretty_plural
                ''ims_item'',              -- supertype
                ''imscp_resources'',     -- table_name
                ''org_id'',                  -- id_column
                null,                        -- name_method
                ''f'',
                null,
                null
        );
    return 0;
end;' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();

-----
--   Create tables
----

-- Manifests
create table ims_cp_manifests (
    man_id          integer
                    constraint ims_cp_man_id_fk
                    references acs_objects(object_id)
                    on delete cascade
                    constraint ims_cp_man_id_pk
                    primary key,
    course_name     varchar(1000),
    identifier      varchar(1000),
    version         varchar(100),
    orgs_default    varchar(100),
    hasmetadata     boolean default 'f' not null, 
 -- A manifest could have multiple submanifests
    parent_man_id   integer,
    isscorm         boolean,
    folder_id       integer,
    fs_package_id   integer,
    isshared	    boolean default 'f' not null,
    presentation_id integer  
);

comment on table ims_cp_manifests is '
This table stores all the available manifests (that could be courses) in the system.
';

comment on column ims_cp_manifests.course_name is '
Manifest course name
Take into account that this might be empty if we are dealing with a manifest that is not 
a course in itself (but just a piece of content)
';

comment on column ims_cp_manifests.identifier is '
Manifest identifier
Identifier get from the imsmanifest.xml file. 
';

comment on column ims_cp_manifests.parent_man_id is '
Parent manifest.
A manifest could have submanifests. If the manifest doesnt have a parent
then we put 0
';

comment on column ims_cp_manifests.folder_id is '
folder where this manifest was imported (this is a CR_Folder)
This is not the parent folder ID that we used in the importing process but the folder we 
created to import the manifest/course (under that parent folder id)
';

comment on column ims_cp_manifests.fs_package_id is '
This is the package id for the file-storage instance that the folder 
belongs to.
';

-- Organizations
create table ims_cp_organizations (
    org_id          integer
                    constraint ims_cp_org_id_fk
                    references acs_objects(object_id)
                    on delete cascade
                    constraint ims_cp_org_id_pk
                    primary key,
    man_id          integer
                    constraint ims_cp_org_man_id_fk
                    references ims_cp_manifests(man_id)
                    on delete cascade,
    identifier      varchar(100),
    structure       varchar(100),
    title           varchar(1000),
    hasmetadata     boolean default 'f' not null,
    isshared	    boolean default 'f' not null
);

-- create index for ims_cp_organizations
create index ims_cp_organizations__man_id_idx on ims_cp_organizations (man_id);


-- Items
create table ims_cp_items (
    item_id         integer
                    constraint ims_cp_items_item_id_fk
                    references acs_objects(object_id)
                    on delete cascade
                    constraint ims_cp_items_item_id_pk
                    primary key,
    org_id          integer
                    constraint ims_cp_items_org_id_fk
                    references ims_cp_organizations(org_id)
                    on delete cascade,
    identifier      varchar(1000),
    identifierref   varchar(2000),
    -- isvisible 1 = Yes, 0 = No
    isvisible       boolean, 
    parameters      varchar(1000),
    title           varchar(1000),
    parent_item     integer,
    hasmetadata     boolean default 'f' not null,
-- SCORM extensions (based on SCORM 1.2 specs)
    prerequisites_t varchar(100),
    prerequisites_s varchar(200),
    type            varchar(1000),
    maxtimeallowed  varchar(1000),
    timelimitaction varchar(1000),
    datafromlms     varchar(200),
    masteryscore    varchar(255),
    isshared	    boolean default 'f' not null
);

-- create index for ims_cp_items
create index ims_cp_items__org_id_idx on ims_cp_items (org_id);

-- Resources
    
create table ims_cp_resources (
    res_id          integer
                    constraint ims_cp_resources_res_id_fk
                    references acs_objects(object_id)
                    on delete cascade
                    constraint ims_cp_resources_res_id_pk
                    primary key,
    man_id          integer
                    constraint ims_cp_resources_man_id_fk
                    references ims_cp_manifests(man_id)
                    on delete cascade,
    identifier      varchar(1000),
    type            varchar(1000),
    href            varchar(2000),
    hasmetadata     boolean default 'f' not null,
 -- SCORM specific
    scorm_type      varchar(1000)
);

-- create index for ims_cp_resources
create index ims_cp_resources__man_id_idx on ims_cp_resources (man_id);

-- An item can have reference to one of more resources
-- therefore we need a table that takes care of this multiple
-- relationship

create table ims_cp_items_to_resources (
    item_id         integer
                    constraint ims_cp_items_to_res_item_id_fk
                    references ims_cp_items(item_id)
                    on delete cascade,
    res_id          integer
                    constraint ims_cp_items_to_resources_fk
                    references ims_cp_resources(res_id)
                    on delete cascade,
                    primary key (item_id, res_id)
);

-- create index for ims_cp_items_to_resources
create index ims_cp_items_to_resources__item_id_idx on ims_cp_items_to_resources (item_id);
create index ims_cp_items_to_resources__res_id_idx on ims_cp_items_to_resources (res_id);

-- Resource dependencies

create sequence ims_cp_dependencies_seq start 1;

create table ims_cp_dependencies (
    dep_id          integer
                    constraint ims_cp_dependencies_dep_id_pk
                    primary key,
    res_id          integer
                    constraint ims_cp_dependencies_res_id_fk
                    references ims_cp_resources(res_id)
                    on delete cascade,
    identifierref   varchar(2000)
);

-- create index for ims_cp_dependencies
create index ims_cp_dependencies__res_id_idx on ims_cp_dependencies (res_id);

-- Resource files

create table ims_cp_files (
    file_id         integer
                    constraint ims_cp_files_file_if_fk
                    references cr_items(item_id)
                    on delete cascade,
    res_id          integer
                    constraint ims_cp_file_res_id_fk
                    references ims_cp_resources(res_id)
                    on delete cascade,
    pathtofile      varchar(2000),
    filename        varchar(2000),
    hasmetadata     boolean default 'f' not null,
                    constraint ims_cp_file_pk
                    primary key (file_id, res_id)
);
    
-- create index for ims_cp_files
create index ims_cp_files__res_id_idx on ims_cp_files (res_id);


create table ims_cp_manifest_class (
    man_id              integer
                        constraint ims_cp_manifest_class__man_id_fk
                        references ims_cp_manifests(man_id)
                        on delete cascade,
    lorsm_instance_id   integer
                        constraint ims_cp_manifest_class__lorsm_fk
                        references apm_packages (package_id),
    community_id	integer
			constraint ims_cp_manifest_class__comm_id_fk
			references dotlrn_communities_all(community_id),
    class_key		varchar(100)
			constraint ims_cp_manifest_class__class_key_fk
  			references dotlrn_community_types(community_type),
    isenabled           boolean default 't' not null,
    istrackable         boolean default 'f' not null,
                        primary key (man_id, lorsm_instance_id)
);

comment on table ims_cp_manifest_class is '
This table  helps us manage the relations between a manifest (course)
and its .LRN class/community
';

comment on column ims_cp_manifest_class.man_id is '
This is the manifest_id for the course
';

comment on column ims_cp_manifest_class.lorsm_instance_id is '
This is the package_id for the instance of LORMS in a particular 
.LRN class/community. This is *NOT* the community_id. 
';

comment on column ims_cp_manifest_class.community_id is '
This is the package_id for the class/community that the manifest got uploaded
';

comment on column ims_cp_manifest_class.class_key is '
This is the class_key for the class/community
';

comment on column ims_cp_manifest_class.isenabled is '
Whether the course is enabled for that community instance.
default true
';

comment on column ims_cp_manifest_class.istrackable is '
Whether the course is trackable for that community instance.
default false
';
