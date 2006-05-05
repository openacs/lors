-- IMS Content Packaging Package
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

create or replace function ims_manifest__new (
    varchar,   -- course_name
    varchar,   -- identifier
    varchar,   -- version
    varchar,   -- orgs_default
    boolean,   -- hasmetadata
    integer,   -- parent_man_id
    boolean,   -- isscorm 
    integer,   -- folder_id 
    integer,   -- fs_package_id
    timestamp with time zone, -- creation_date
    integer,   -- creation_user
    varchar,    -- creation_ip
    integer,    -- package_id
    integer,    -- community_id
    varchar,     -- class_key
    integer,     -- new revision_id for the item in the CR
    boolean,      -- is shared
    integer 	-- course_presentation_format
)
returns integer as '
declare
    p_course_name                alias for $1;
    p_identifier                 alias for $2;
    p_version                    alias for $3;
    p_orgs_default               alias for $4;
    p_hasmetadata                alias for $5;
    p_parent_man_id              alias for $6;
    p_isscorm                    alias for $7;
    p_folder_id                  alias for $8;
    p_fs_package_id              alias for $9;
    p_creation_date              alias for $10;
    p_creation_user              alias for $11;
    p_creation_ip                alias for $12;
    p_package_id                 alias for $13;
    p_community_id               alias for $14;
    p_class_key                  alias for $15;
    p_revision_id                alias for $16;
    p_isshared                   alias for $17;
    p_course_presentation_format alias for $18;
begin
  
        -- we make an update here because the content::item::new already inserts a row in the ims_cp_manifests
        update ims_cp_manifests
        set course_name=p_course_name, identifier=p_identifier, version=p_version, 
            orgs_default=p_orgs_default, hasmetadata=p_hasmetadata, parent_man_id=p_parent_man_id, 
            isscorm=p_isscorm, folder_id=p_folder_id, fs_package_id=p_fs_package_id, isshared = p_isshared,
            course_presentation_format=p_course_presentation_format
        where man_id = p_revision_id;
	-- now we add it to the manifest_class relation table

	insert into ims_cp_manifest_class
	(man_id, lorsm_instance_id, community_id, class_key, isenabled, istrackable)
	values
	(p_revision_id, p_package_id, p_community_id, p_class_key, ''t'', ''f'');
        
        return p_revision_id;
end;
' language 'plpgsql';

create or replace function ims_manifest__delete (
    integer    --manifest_id
)
returns integer as '
declare 
    p_man_id        alias for $1;
begin
        perform acs_object__delete(p_man_id);
        delete from ims_cp_manifests where man_id = p_man_id;
        return 0;
end;
' language 'plpgsql';


create or replace function ims_organization__new (
    integer,   -- org_id
    integer,   -- man_id 
    varchar,   -- identifier
    varchar,   -- structure
    varchar,   -- title
    boolean,   -- hasmetadata
    timestamp with time zone, -- creation_date
    integer,   -- creation_user
    varchar,    -- creation_ip
    integer,    -- package_id
    integer    -- revision_id
)
returns integer as '
declare
    p_org_id                alias for $1;
    p_man_id                alias for $2;
    p_identifier            alias for $3;
    p_structure             alias for $4;
    p_title                 alias for $5;
    p_hasmetadata           alias for $6;
    p_creation_date         alias for $7;
    p_creation_user         alias for $8;
    p_creation_ip           alias for $9;
    p_package_id            alias for $10;
    p_revision_id           alias for $11;
begin
        -- we make an update here because the content::item::new already inserts a row in the ims_cp_organizations
        update ims_cp_organizations
        set man_id=p_man_id, identifier=p_identifier, structure=p_structure, 
            org_title=p_title, hasmetadata=p_hasmetadata
	where org_id = p_revision_id;

        return p_revision_id;
end;
' language 'plpgsql';

create or replace function ims_organization__delete (
    integer    --manifest_id
)
returns integer as '
declare 
    p_org_id        alias for $1;
begin
        perform acs_object__delete(p_org_id);
        delete from ims_cp_organizations where org_id = p_org_id;
        return 0;
end;
' language 'plpgsql';

create or replace function ims_item__new (
    integer,   -- item_id
    integer,   -- org_id 
    varchar,   -- identifier
    varchar,   -- identifierref
    boolean,   -- isvisible
    varchar,   -- parameters
    varchar,   -- title
    integer,   -- parent_item
    boolean,   -- hasmetadata
-- SCORM extension
    varchar,   -- prerequisites_t
    varchar,   -- prerequisites_s
    varchar,   -- type
    varchar,   -- maxtimeallowed
    varchar,   -- timelimitaction
    varchar,   -- datafromlms
    varchar,   -- masteryscore
    timestamp with time zone, -- creation_date
    integer,   -- creation_user
    varchar,    -- creation_ip
    integer,    -- package_id
    integer    -- revision_id
)
returns integer as '
declare
    p_item_id               alias for $1;
    p_org_id                alias for $2;
    p_identifier            alias for $3;
    p_identifierref         alias for $4;
    p_isvisible             alias for $5;
    p_parameters            alias for $6;
    p_title                 alias for $7;
    p_parent_item           alias for $8;
    p_hasmetadata           alias for $9;
    p_prerequisites_t       alias for $10;
    p_prerequisites_s       alias for $11;
    p_type                  alias for $12;
    p_maxtimeallowed        alias for $13;
    p_timelimitaction       alias for $14;
    p_datafromlms           alias for $15;
    p_masteryscore          alias for $16;
    p_creation_date         alias for $17;
    p_creation_user         alias for $18;
    p_creation_ip           alias for $19;
    p_package_id            alias for $20;
    p_revision_id           alias for $21;
begin
        update ims_cp_items
         set org_id=p_org_id, identifier=p_identifier, identifierref=p_identifierref, 
             isvisible=p_isvisible, parameters=p_parameters, item_title=p_title, parent_item=p_parent_item, 
             hasmetadata=p_hasmetadata, prerequisites_t=p_prerequisites_t, prerequisites_s=p_prerequisites_s, 
             type=p_type, maxtimeallowed=p_maxtimeallowed, timelimitaction=p_timelimitaction, 
             datafromlms=p_datafromlms, masteryscore=p_masteryscore
             where ims_item_id = p_revision_id;

        return p_revision_id;
end;
' language 'plpgsql';


create or replace function ims_item__delete (
    integer    --manifest_id
)
returns integer as '
declare 
    p_item_id        alias for $1;
begin
        perform acs_object__delete(p_item_id);
        delete from ims_cp_items where ims_item_id = p_item_id;
        return 0;
end;
' language 'plpgsql';

create or replace function ims_resource__new (
    integer,   -- res_id
    integer,   -- man_id
    varchar,   -- identifier
    varchar,   -- type
    varchar,   -- href
    varchar,   -- scorm_type
    boolean,   -- hasmetadata
    timestamp with time zone, -- creation_date
    integer,   -- creation_user
    varchar,    -- creation_ip
    integer,    -- package_id
    integer    -- revision_id
)
returns integer as '
declare
    p_res_id               alias for $1;
    p_man_id               alias for $2;
    p_identifier           alias for $3;
    p_type                 alias for $4;
    p_href                 alias for $5;
    p_scorm_type           alias for $6;
    p_hasmetadata          alias for $7;
    p_creation_date        alias for $8;
    p_creation_user        alias for $9;
    p_creation_ip          alias for $10;
    p_package_id           alias for $11;
    p_revision_id          alias for $12;
begin
        update ims_cp_resources
        set man_id=p_man_id, identifier=p_identifier, type=p_type, 
        href=p_href, scorm_type=p_scorm_type, hasmetadata=p_hasmetadata
        where res_id = p_revision_id;
       
        return p_revision_id;
end;
' language 'plpgsql';

create or replace function ims_resource__delete (
    integer    --manifest_id
)
returns integer as '
declare 
    p_res_id        alias for $1;
begin
        perform acs_object__delete(p_res_id);
        delete from ims_cp_resources where res_id = p_res_id;
        return 0;
end;
' language 'plpgsql';

-- ims_cp_item_to_resource table

create or replace function ims_cp_item_to_resource__new (
    integer,   -- item_id
    integer    -- res_id
)
returns integer as '
declare
    p_item_id           alias for $1;
    p_res_id            alias for $2;
begin

    insert into ims_cp_items_to_resources (ims_item_id, res_id)
    values
    (p_item_id, p_res_id);

    return 0;
end;
' language 'plpgsql';

comment on function ims_cp_item_to_resource__new (integer, integer) is '
Function to insert relationships between items and resources within a manifest.';

create or replace function ims_dependency__new (
    integer,   -- sequence_id
    integer,   -- res_id
    varchar    -- identifierref
)
returns integer as '
declare
    p_dep_id            alias for $1;
    p_res_id            alias for $2;
    p_identifierref     alias for $3;
 
begin

    insert into ims_cp_dependencies (dep_id, res_id, identifierref)
    values
    (p_dep_id, p_res_id, p_identifierref);

    return p_dep_id;
end;
' language 'plpgsql';


create or replace function ims_dependency__delete (
    integer    --dep_id
)
returns integer as '
declare 
    p_dep_id        alias for $1;
begin
        perform acs_object__delete(p_dep_id);
        delete from ims_cp_dependencies where dep_id = p_dep_id;
        return 0;
end;
' language 'plpgsql';


create or replace function ims_file__new (
    integer,   -- file_id
    integer,   -- res_id
    varchar,    -- pathtofile
    varchar,    -- filename
    boolean     -- hasmetadata
)
returns integer as '
declare
    p_file_id          alias for $1;
    p_res_id           alias for $2;
    p_pathtofile       alias for $3;
    p_filename         alias for $4;
    p_hasmetadata      alias for $5;
 
begin

    insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
    values
    (p_file_id, p_res_id, p_pathtofile, p_filename, p_hasmetadata);

    return p_file_id;
end;
' language 'plpgsql';


-- put in and correct some stuff for ims_cp_items

-- function name
create or replace function ims_item__get_title (integer)
returns varchar as '
declare
  name__object_id        alias for $1;  
  v_title                ims_cp_items.item_title%TYPE;  
  v_object_id            integer;
begin

  select item_title 
  into v_title
  from ims_cp_items
  where ims_item_id = name__object_id;

  return v_title;
  
end;' language 'plpgsql' stable strict;


update acs_object_types
set table_name = 'ims_cp_items',
    name_method = 'ims_item__get_title',
    pretty_name = 'IMS Item',
    pretty_plural = 'IMS Items'
where object_type = 'ims_item';

