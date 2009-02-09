-- Create auxiliary tables

create table ims_cp_manifests_copy (
    man_id          integer,
    course_name     varchar(1000),
    identifier      varchar(1000),
    version         varchar(100),
    orgs_default    varchar(100),
    hasmetadata     boolean default 'f' not null, 
    parent_man_id   integer,
    isscorm         boolean,
    folder_id       integer,
    fs_package_id   integer,
    isshared	    boolean default 'f' not null
);

create table ims_cp_organizations_copy (
    org_id          integer,
    man_id          integer,
    identifier      varchar(100),
    structure       varchar(100),
    title           varchar(1000),
    hasmetadata     boolean default 'f' not null,
    isshared	    boolean default 'f' not null
);

create table ims_cp_items_copy (
    item_id         integer,
    org_id          integer,
    identifier      varchar(1000),
    identifierref   varchar(2000),
    isvisible       boolean, 
    parameters      varchar(1000),
    title           varchar(1000),
    parent_item     integer,
    hasmetadata     boolean default 'f' not null,
    prerequisites_t varchar(100),
    prerequisites_s varchar(200),
    type            varchar(1000),
    maxtimeallowed  varchar(1000),
    timelimitaction varchar(1000),
    datafromlms     varchar(200),
    masteryscore    varchar(255),
    isshared	    boolean default 'f' not null
);

create table ims_cp_resources_copy (
    res_id          integer,
    man_id          integer,
    identifier      varchar(1000),
    type            varchar(1000),
    href            varchar(2000),
    hasmetadata     boolean default 'f' not null,
    scorm_type      varchar(1000)
);

create table ims_cp_files_copy (
    file_id         integer,
    res_id          integer,
    pathtofile      varchar(2000),
    filename        varchar(2000),
    hasmetadata     boolean default 'f' not null
);

create table ims_cp_items_to_resources_copy (
    item_id         integer,
    res_id          integer,
    new_ims_item_id integer,
    new_res_id      integer
);

create table ims_cp_manifest_class_copy (
    man_id              integer,
    lorsm_instance_id   integer,
    community_id	integer,
    isenabled           boolean default 't' not null,
    istrackable         boolean default 'f' not null
);

-- Make all the inserts

insert into ims_cp_manifests_copy ( 
	man_id, 
        course_name, 
        identifier, 
        version, 
        orgs_default, 
        hasmetadata, 
        parent_man_id,
        isscorm,
        folder_id,
        fs_package_id,
        isshared
) select * from ims_cp_manifests;

alter table ims_cp_manifests_copy add package_id integer;

create function inline_0 ()
returns integer as '
declare
one_manifest record;
begin
	for one_manifest in select man_id from ims_cp_manifests_copy

 	loop
		update ims_cp_manifests_copy 
		set package_id = ( select context_id 
				   from acs_objects 
			           where object_id = one_manifest.man_id
			         )
		where man_id = one_manifest.man_id;	
	end loop;
    return 1;
end;
' language 'plpgsql';


select inline_0 ();

drop function inline_0 ();

insert into ims_cp_organizations_copy (
	org_id,
	man_id,
	identifier,
	structure,
	title,
	hasmetadata,
	isshared
) select * from ims_cp_organizations;

insert into ims_cp_items_copy (
	item_id,
	org_id,
	identifier,
	identifierref,
	isvisible,
	parameters,
	title,
	parent_item,	
	hasmetadata,
	prerequisites_t,
	prerequisites_s,
	type,
	maxtimeallowed,
	timelimitaction,
	datafromlms,
	masteryscore,
	isshared
) select * from ims_cp_items;

insert into ims_cp_resources_copy (
	res_id,
	man_id,
	identifier,
	type,
	href,
	hasmetadata,
	scorm_type	
) select * from ims_cp_resources;

insert into ims_cp_files_copy (
	file_id,
	res_id,
	pathtofile,
	filename,
	hasmetadata
) select * from ims_cp_files;

insert into ims_cp_items_to_resources_copy (
	item_id,
	res_id
) select * from ims_cp_items_to_resources;

insert into ims_cp_manifest_class_copy (
	man_id,
    	lorsm_instance_id,
    	community_id,
    	isenabled,
        istrackable
) select * from ims_cp_manifest_class;


-- Delete content from original tables

delete from ims_cp_manifest_class;
delete from ims_cp_items_to_resources;
delete from ims_cp_files;
delete from ims_cp_items;
delete from ims_cp_resources;
delete from ims_cp_organizations;
delete from ims_cp_manifests;

-- Make all the changes to the tables
alter table ims_cp_manifests drop constraint ims_cp_man_id_fk;
alter table ims_cp_manifests add constraint ims_cp_man_id_fk foreign key (man_id) references cr_revisions(revision_id) on delete cascade;
alter table ims_cp_organizations drop constraint ims_cp_org_id_fk;
alter table ims_cp_organizations add constraint ims_cp_org_id_fk foreign key (org_id) references cr_revisions(revision_id) on delete cascade;
alter table ims_cp_organizations rename title to org_title;
alter table ims_cp_items drop constraint ims_cp_items_item_id_fk;
alter table ims_cp_items rename item_id to ims_item_id;
alter table ims_cp_items rename title to ims_item_title;
alter table ims_cp_items_to_resources rename item_id to ims_item_id;
alter table ims_cp_items add sort_order integer;
alter table ims_cp_items add constraint ims_cp_ims_item_id_fk foreign key (ims_item_id) references cr_revisions(revision_id) on delete cascade;
alter table ims_cp_manifest_class drop constraint ims_cp_manifest_class_pkey;
alter table ims_cp_files drop constraint ims_cp_files_file_if_fk;
alter table ims_cp_files add constraint ims_cp_files_file_if_fk foreign key (file_id) references cr_revisions(revision_id) on delete cascade;

-- Delete all permissions and acs_objects
delete from acs_permissions where object_id in ( select object_id from acs_objects where object_type like 'ims%' );
delete from acs_objects where object_type like 'ims%';

-- Drop content_types
select content_type__drop_type (
  'ims_resource',   -- content_type
  'f',              -- drop_children_p
  'f'               -- drop_table_p      
);

select content_type__drop_type (
  'ims_item',       -- content_type
  'f',              -- drop_children_p
  'f'               -- drop_table_p      
);

select content_type__drop_type (
  'ims_organization',   -- content_type
  'f',                  -- drop_children_p
  'f'                   -- drop_table_p      
);

select content_type__drop_type (
  'ims_manifest',   -- content_type
  'f',              -- drop_children_p
  'f'               -- drop_table_p      
);

-- Create content_types
select content_type__create_type (
       'ims_manifest_object',    -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'IMS Manifest Object',    -- pretty_name
       'IMS Manifest Objects',   -- pretty_plural
       'ims_cp_manifests',       -- table_name
       'man_id',                 -- id_column
       'ims_manifest__get_title' -- name_method
);

select content_type__create_type (
       'ims_organization_object',    -- content_type
       'content_revision',           -- supertype. We search revision content 
                                     -- first, before item metadata
       'IMS Organization Object',    -- pretty_name
       'IMS Organization Objects',   -- pretty_plural
       'ims_cp_organizations',       -- table_name
       'org_id',                     -- id_column
       'ims_organization__get_title' -- name_method
);

select content_type__create_type (
       'ims_item_object',    -- content_type
       'content_revision',   -- supertype. We search revision content 
                             -- first, before item metadata
       'IMS Item Object',    -- pretty_name
       'IMS Item Objects',   -- pretty_plural
       'ims_cp_items',       -- table_name
       'ims_item_id',        -- id_column
       'ims_item__get_title' -- name_method
);

select content_type__create_type (
       'ims_resource_object',    -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'IMS Resource Object',    -- pretty_name
       'IMS Resource Objects',   -- pretty_plural
       'ims_cp_resources',       -- table_name
       'res_id',                 -- id_column
       'ims_resource__get_title' -- name_method
);

-- create cr_items for all the objects

-- create cr_revisions for all the objects

-- copy the data back to type-specific tables

