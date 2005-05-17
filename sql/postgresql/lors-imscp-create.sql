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
--   Create tables
----
-- Manifests
create table ims_cp_manifests (
    man_id          integer
                    constraint ims_cp_man_id_fk
                    references cr_revisions
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
    course_presentation_format integer  
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

-- create ims manifest content type
-- we do not use CR for content storage (at least not for ims_* objects) as these are just abstract aggregations
-- and organization of objects. We use content types for the sake of versioning
--
select content_type__create_type (
       'ims_manifest_object',    -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'IMS Manifest Object',    -- pretty_name
       'IMS Manifest Objects',   -- pretty_plural
       'ims_cp_manifests',        -- table_name
       'man_id',	         -- id_column
       'ims_manifest__get_title' -- name_method
);



-- Organizations
create table ims_cp_organizations (
    org_id          integer
                    constraint ims_cp_org_id_fk
                    references cr_revisions
                    on delete cascade
                    constraint ims_cp_org_id_pk
                    primary key,
    man_id          integer
                    constraint ims_cp_org_man_id_fk
                    references ims_cp_manifests(man_id)
                    on delete cascade,
    identifier      varchar(100),
    structure       varchar(100),
    org_title       varchar(1000),
    hasmetadata     boolean default 'f' not null,
    isshared	    boolean default 'f' not null
);

-- create index for ims_cp_organizations
create index ims_cp_organizations__man_id_idx on ims_cp_organizations (man_id);


-- create ims organization content type
--
select content_type__create_type (
       'ims_organization_object',    -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'IMS Organization Object',    -- pretty_name
       'IMS Organization Objects',   -- pretty_plural
       'ims_cp_organizations',        -- table_name
       'org_id',	         -- id_column
       'ims_organization__get_title' -- name_method
);




-- Items
create table ims_cp_items (
    ims_item_id     integer
                    constraint ims_cp_items_item_id_fk
                    references cr_revisions
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
    item_title           varchar(1000),
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

-- create ims items content type
--
select content_type__create_type (
       'ims_item_object',    -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'IMS Item Object',    -- pretty_name
       'IMS Item Objects',   -- pretty_plural
       'ims_cp_items',        -- table_name
       'ims_item_id',	         -- id_column
       'ims_item__get_title' -- name_method
);



-- Resources
    
create table ims_cp_resources (
    res_id          integer
                    constraint ims_cp_resources_res_id_fk
                    references cr_revisions
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

-- create ims resources content type
--
select content_type__create_type (
       'ims_resource_object',    -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'IMS Resource Object',    -- pretty_name
       'IMS Resource Objects',   -- pretty_plural
       'ims_cp_resources',        -- table_name
       'res_id',	         -- id_column
       'ims_resource__get_title' -- name_method
);


-- An item can have reference to one of more resources
-- therefore we need a table that takes care of this multiple
-- relationship

create table ims_cp_items_to_resources (
    ims_item_id         integer
                    constraint ims_cp_items_to_res_item_id_fk
                    references ims_cp_items(ims_item_id)
                    on delete cascade,
    res_id          integer
                    constraint ims_cp_items_to_resources_fk
                    references ims_cp_resources(res_id)
                    on delete cascade,
                    primary key (ims_item_id, res_id)
);

-- create index for ims_cp_items_to_resources
create index ims_cp_items_to_resources__item_id_idx on ims_cp_items_to_resources (ims_item_id);
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