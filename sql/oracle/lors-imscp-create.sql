-- IMS Content Packaging Data Model
--
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 25/07/2006
-- @cvs-id $Id$
--
--  Copyright (C) 2006 Mario Aguado--
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
    course_name     varchar2(1000),
    identifier      varchar2(1000),
    version         varchar2(100),
    orgs_default    varchar2(100),
    hasmetadata     char(1) default 'f' 
		    constraint ims_cp_manifest_hasmetadata_ck
		    check(hasmetadata in ('t','f')) not null, 
 -- A manifest could have multiple submanifests
    parent_man_id   integer,
    isscorm         char(1)
		    constraint ims_cp_manifest_isscorm_ck
		    check(isscorm in ('t','f')),
    folder_id       integer,
    fs_package_id   integer,
    isshared	    char(1) default 'f' 
		    constraint ims_cp_manifest_isshared_ck
		    check(isshared in ('t','f')) not null,
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
    identifier      varchar2(100),
    structure       varchar2(100),
    org_title       varchar2(1000),
    hasmetadata     char(1) default 'f' 
		    constraint ims_cp_org_hasmetadata_ck
		    check(hasmetadata in ('f','t')) not null,
    isshared	    char(1) default 'f' 
		    constraint ims_cp_org_isshared_ck
		    check(isshared in ('f','t')) not null
);

-- create index for ims_cp_organizations
create index ims_cp_org_man_id_idx on ims_cp_organizations (man_id);

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
    identifier      varchar2(1000),
    identifierref   varchar2(2000),
    -- isvisible 1 = Yes, 0 = No. Change to char in Oracle
    isvisible       char(1), 
    parameters      varchar2(1000),
    item_title      varchar2(1000),
    parent_item     integer,
    hasmetadata     char(1) default 'f' 
		    constraint ims_cp_items_hasmetadata_ck
		    check(hasmetadata in ('t','f')) not null,
-- SCORM extensions (based on SCORM 1.2 specs)
    prerequisites_t varchar2(100),
    prerequisites_s varchar2(200),
    type            varchar2(1000),
    maxtimeallowed  varchar2(1000),
    timelimitaction varchar2(1000),
    datafromlms     varchar2(200),
    masteryscore    varchar2(255),
    isshared	    char(1) default 'f' 
		    constraint ims_cp_items_isshared_ck
		    check(isshared in ('t','f')) not null,
    sort_order      integer
);

-- create index for ims_cp_items
create index ims_cp_items__org_id_idx on ims_cp_items (org_id);

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
    identifier      varchar2(1000),
    type            varchar2(1000),
    href            varchar2(2000),
    hasmetadata     char(1) default 'f' 
		    constraint ims_cp_resour_hasmetadata_ck
		    check(hasmetadata in ('t','f')) not null,
 -- SCORM specific
    scorm_type      varchar2(1000)
);

-- create index for ims_cp_resources
create index ims_cp_resources__man_id_idx on ims_cp_resources (man_id);



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
                    constraint ims_cp_items_to_resources_pk primary key (ims_item_id, res_id)
);

-- create index for ims_cp_items_to_resources
create index ims_cp_items_2_res_item_id_idx on ims_cp_items_to_resources (ims_item_id);
create index ims_cp_items_2_res_res_id_idx on ims_cp_items_to_resources (res_id);

-- Resource dependencies

create sequence ims_cp_dependencies_seq start with 1;

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
create index ims_cp_dependencies_res_id_idx on ims_cp_dependencies (res_id);

-- Resource files

create table ims_cp_files (
    file_id         integer
                    constraint ims_cp_files_file_if_fk
                    references cr_revisions(revision_id)
                    on delete cascade,
    res_id          integer
                    constraint ims_cp_file_res_id_fk
                    references ims_cp_resources(res_id)
                    on delete cascade,
    pathtofile      varchar2(2000),
    filename        varchar2(2000),
    hasmetadata     char(1) default 'f'
		    constraint ims_cp_files_hasmetadata_ck
		    check(hasmetadata in ('t','f')) not null,
                    constraint ims_cp_file_pk
                    primary key (file_id, res_id)
);
    
-- create index for ims_cp_files
create index ims_cp_files__res_id_idx on ims_cp_files (res_id);


create table ims_cp_manifest_class (
    man_id              integer
                        constraint ims_cp_manif_class_man_id_fk
                        references ims_cp_manifests(man_id)
                        on delete cascade,
    lorsm_instance_id   integer
                        constraint ims_cp_manif_class_lorsm_fk
                        references apm_packages (package_id),
    community_id	integer
			constraint ims_cp_manif_class_comm_id_fk
			references dotlrn_communities_all(community_id),
    class_key		varchar2(100)
			constraint ims_cp_manif_c_class_key_fk
  			references dotlrn_community_types(community_type),
    isenabled           char(1) default 't' 
			constraint ims_cp_manif_c_isenabled_ck
			check (isenabled in ('t','f')) not null,
    istrackable         char(1) default 'f' 
			constraint ims_cp_manif_c_istrackable_ck
			check (istrackable in ('t','f')) not null
                        -- primary key (man_id, lorsm_instance_id)
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

--
-- create content types
--
--

begin

-- create ims manifest content type
-- we do not use CR for content storage (at least not for ims_* objects) as these are just abstract aggregations
-- and organization of objects. We use content types for the sake of versioning
--


	content_type.create_type (
			content_type => 'ims_manifest_object',
			supertype => 'content_revision', -- We search revision content first, before item metadata
			pretty_name => 'IMS Manifest Object',    
			pretty_plural => 'IMS Manifest Objects',
			table_name => 'ims_cp_manifests', 
			id_column => 'man_id',
			name_method => 'ims_manifest.get_title'
	);


-- create ims organization content type
--
	content_type.create_type (
			content_type => 'ims_organization_object',
			supertype => 'content_revision', -- We search revision content first, before item metadata
			pretty_name =>  'IMS Organization Object',
			pretty_plural => 'IMS Organization Objects',
			table_name => 'ims_cp_organizations',
			id_column => 'org_id',
			name_method => 'ims_organization.get_title'
	);

--
-- create ims items content type
--
	content_type.create_type (
			content_type => 'ims_item_object',
			supertype => 'content_revision', -- We search revision content first, before item metadata
			pretty_name => 'IMS Item Object',
			pretty_plural => 'IMS Item Objects',
			table_name => 'ims_cp_items',
			id_column => 'ims_item_id',
			name_method => 'ims_item.get_title'
	);

--
-- create ims resources content type
--
	content_type.create_type (
			content_type => 'ims_resource_object',
			supertype => 'content_revision', -- We search revision content first, before item metadata
			pretty_name => 'IMS Resource Object',
			pretty_plural => 'IMS Resource Objects',
			table_name => 'ims_cp_resources',
			id_column => 'res_id',
			name_method => 'ims_resource.get_title'
	);

end;
/