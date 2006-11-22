-- IMS Content Packaging Package
--
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 25/07/2006
-- @cvs-id $Id$

--
--  Copyright (C) 2006 Mario Aguado
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

--
-- PL/sql ims_manifest package
--

--Update sql dont' update date if variable = column_name

create or replace package ims_manifest as
	function new(
		p_course_name in ims_cp_manifests.course_name%TYPE,
		p_identifier in ims_cp_manifests.identifier%TYPE,
		p_version in ims_cp_manifests.version%TYPE,
		p_orgs_default in  ims_cp_manifests.orgs_default%TYPE,
		p_hasmetadata in ims_cp_manifests.hasmetadata%TYPE,
		p_parent_man_id in ims_cp_manifests.parent_man_id%TYPE,
		p_isscorm in ims_cp_manifests.isscorm%TYPE,
		p_folder_id in ims_cp_manifests.folder_id%TYPE,
		p_fs_package_id in ims_cp_manifests.fs_package_id%TYPE,
		p_creation_date in acs_objects.creation_date%TYPE 
				default sysdate,
		p_creation_user in acs_objects.creation_user%TYPE
				default null,
		p_creation_ip in acs_objects.creation_ip%TYPE
				default null,
		p_package_id in ims_cp_manifest_class.lorsm_instance_id%TYPE,
		p_community_id in ims_cp_manifest_class.community_id%TYPE,
		p_class_key in ims_cp_manifest_class.class_key%TYPE,
		p_revision_id in ims_cp_manifest_class.man_id%TYPE,
		p_isshared in ims_cp_manifests.isshared%TYPE,
		p_course_presentation_fmt in ims_cp_manifests.course_presentation_format%TYPE
	) return ims_cp_manifest_class.man_id%TYPE;

	procedure delete (
		p_man_id in ims_cp_manifests.man_id%TYPE
	);

	function get_title (
		p_man_id in ims_cp_manifests.man_id%TYPE
	) return ims_cp_manifests.course_name%TYPE;

end ims_manifest;
/
show errors;

create or replace package body ims_manifest as
	function new(
		p_course_name in ims_cp_manifests.course_name%TYPE,
		p_identifier in ims_cp_manifests.identifier%TYPE,
		p_version in ims_cp_manifests.version%TYPE,
		p_orgs_default in  ims_cp_manifests.orgs_default%TYPE,
		p_hasmetadata in ims_cp_manifests.hasmetadata%TYPE,
		p_parent_man_id in ims_cp_manifests.parent_man_id%TYPE,
		p_isscorm in ims_cp_manifests.isscorm%TYPE,
		p_folder_id in ims_cp_manifests.folder_id%TYPE,
		p_fs_package_id in ims_cp_manifests.fs_package_id%TYPE,
		p_creation_date in acs_objects.creation_date%TYPE 
				default sysdate,
		p_creation_user in acs_objects.creation_user%TYPE
				default null,
		p_creation_ip in acs_objects.creation_ip%TYPE
				default null,
		p_package_id in ims_cp_manifest_class.lorsm_instance_id%TYPE,
		p_community_id in ims_cp_manifest_class.community_id%TYPE,
		p_class_key in ims_cp_manifest_class.class_key%TYPE,
		p_revision_id in ims_cp_manifest_class.man_id%TYPE,
		p_isshared in ims_cp_manifests.isshared%TYPE,
		p_course_presentation_fmt in ims_cp_manifests.course_presentation_format%TYPE
	) return ims_cp_manifest_class.man_id%TYPE is
	begin
	        -- we make an update here because the content::item::new already inserts a row in the ims_cp_manifests
	        update ims_cp_manifests
	        set course_name = p_course_name, identifier = p_identifier, version= p_version, 
	            orgs_default = p_orgs_default, hasmetadata = p_hasmetadata, parent_man_id = p_parent_man_id, 
	            isscorm = p_isscorm, folder_id = p_folder_id, fs_package_id = p_fs_package_id, isshared = p_isshared,
	            course_presentation_format = p_course_presentation_fmt
	        where man_id = p_revision_id;
		-- now we add it to the manifest_class relation table

		insert into ims_cp_manifest_class
		(man_id, lorsm_instance_id, community_id, class_key, isenabled, istrackable)
		values
		(p_revision_id, p_package_id, p_community_id, p_class_key, 't', 'f');
	        
	        return p_revision_id;

	end new;

	procedure delete (
		p_man_id in ims_cp_manifests.man_id%TYPE
	) is
	begin
        	
		acs_object.del(p_man_id);
	        delete from ims_cp_manifests where man_id = p_man_id;
	
	end delete;

	function get_title (
		p_man_id in ims_cp_manifests.man_id%TYPE
	) return ims_cp_manifests.course_name%TYPE is
		v_course_name        ims_cp_manifests.course_name%TYPE;  
	begin

		select course_name into v_course_name
		from ims_cp_manifests
		where man_id = p_man_id;
	
		return v_course_name;	

	end get_title;

end ims_manifest;
/
show errors;

--
-- PL/sql ims_organization package
--



create or replace package ims_organization as

	function new(
		p_org_id in ims_cp_organizations.org_id%TYPE,
		p_man_id in ims_cp_organizations.man_id%TYPE,
		p_identifier in ims_cp_organizations.identifier%TYPE,
		p_structure in ims_cp_organizations.structure%TYPE,
		p_title in ims_cp_organizations.org_title%TYPE,
		p_hasmetadata in ims_cp_organizations.hasmetadata%TYPE,
		p_creation_date in acs_objects.creation_date%TYPE
				default sysdate,
		p_creation_user in acs_objects.creation_user%TYPE
				default null,
		p_creation_ip in acs_objects.creation_ip%TYPE
				default null,
		p_package_id in apm_packages.package_id%TYPE,
		p_revision_id in ims_cp_organizations.org_id%TYPE
	) return ims_cp_organizations.org_id%TYPE;

	function delete (
		p_org_id in ims_cp_organizations.org_id%TYPE
	) return integer;

	function get_title (
		p_org_id in ims_cp_organizations.org_id%TYPE
	) return ims_cp_organizations.identifier%TYPE;
	
end ims_organization;
/
show errors;

create or replace package body ims_organization as
	function new(
		p_org_id in ims_cp_organizations.org_id%TYPE,
		p_man_id in ims_cp_organizations.man_id%TYPE,
		p_identifier in ims_cp_organizations.identifier%TYPE,
		p_structure in ims_cp_organizations.structure%TYPE,
		p_title in ims_cp_organizations.org_title%TYPE,
		p_hasmetadata in ims_cp_organizations.hasmetadata%TYPE,
		p_creation_date in acs_objects.creation_date%TYPE
				default sysdate,
		p_creation_user in acs_objects.creation_user%TYPE
				default null,
		p_creation_ip in acs_objects.creation_ip%TYPE
				default null,
		p_package_id in apm_packages.package_id%TYPE,
		p_revision_id in ims_cp_organizations.org_id%TYPE
	) return ims_cp_organizations.org_id%TYPE is 
	begin

        -- we make an update here because the content::item::new already inserts a row in the ims_cp_organizations
	        update ims_cp_organizations
        	set man_id = p_man_id, identifier = p_identifier, structure = p_structure, 
            	org_title = p_title, hasmetadata = p_hasmetadata
		where org_id = p_revision_id;

        	return p_revision_id;

	end new;


	function delete (
		p_org_id in ims_cp_organizations.org_id%TYPE
	) return integer is
	begin
        
		acs_object.del(p_org_id);
	        delete from ims_cp_organizations where org_id = p_org_id;
		return 0;

	end delete;

	function get_title (
		p_org_id in ims_cp_organizations.org_id%TYPE
	) return ims_cp_organizations.identifier%TYPE is
		v_title_identifier ims_cp_organizations.identifier%TYPE;  
	begin
	
		select identifier into v_title_identifier
		from ims_cp_organizations
		where org_id = p_org_id;
	
		return v_title_identifier;	

	end get_title;

end ims_organization;
/
show errors;

--
-- PL/sql ims_item package 
--

create or replace package ims_item as

	function new (
		p_ims_item_id in ims_cp_items.ims_item_id%TYPE,
		p_org_id  in ims_cp_items.org_id%TYPE,
		p_identifier  in ims_cp_items.identifier%TYPE,
		p_identifierref  in ims_cp_items.identifierref%TYPE,
		p_isvisible  in ims_cp_items.isvisible%TYPE,
		p_parameters  in ims_cp_items.parameters%TYPE,
		p_item_title  in ims_cp_items.item_title%TYPE,
		p_parent_item  in ims_cp_items.parent_item%TYPE,
		p_hasmetadata  in ims_cp_items.hasmetadata%TYPE,
		p_prerequisites_t in ims_cp_items.prerequisites_t%TYPE,
		p_prerequisites_s in ims_cp_items.prerequisites_s%TYPE,
		p_type in ims_cp_items.type%TYPE,
		p_maxtimeallowed in ims_cp_items.maxtimeallowed%TYPE,
		p_timelimitaction in ims_cp_items.timelimitaction%TYPE,
		p_datafromlms in ims_cp_items.datafromlms%TYPE,
		p_masteryscore in ims_cp_items.masteryscore%TYPE,
		p_creation_date in acs_objects.creation_date%TYPE
			default sysdate,
		p_creation_user in acs_objects.creation_user%TYPE
			default null,
		p_creation_ip in acs_objects.creation_ip%TYPE
			default null,
		p_package_id in apm_packages.package_id%TYPE,
		p_revision_id in ims_cp_items.ims_item_id%TYPE
	) return ims_cp_items.ims_item_id%TYPE;

	function delete (
		p_ims_item_id in ims_cp_items.ims_item_id%TYPE
	) return integer;

	function get_title (
		p_ims_item_id in ims_cp_items.ims_item_id%TYPE
	) return ims_cp_items.item_title%TYPE;
	
end ims_item;
/
show errors;

create or replace package body ims_item as

	function new (
		p_ims_item_id in ims_cp_items.ims_item_id%TYPE,
		p_org_id  in ims_cp_items.org_id%TYPE,
		p_identifier  in ims_cp_items.identifier%TYPE,
		p_identifierref  in ims_cp_items.identifierref%TYPE,
		p_isvisible  in ims_cp_items.isvisible%TYPE,
		p_parameters  in ims_cp_items.parameters%TYPE,
		p_item_title  in ims_cp_items.item_title%TYPE,
		p_parent_item  in ims_cp_items.parent_item%TYPE,
		p_hasmetadata  in ims_cp_items.hasmetadata%TYPE,
		p_prerequisites_t in ims_cp_items.prerequisites_t%TYPE,
		p_prerequisites_s in ims_cp_items.prerequisites_s%TYPE,
		p_type in ims_cp_items.type%TYPE,
		p_maxtimeallowed in ims_cp_items.maxtimeallowed%TYPE,
		p_timelimitaction in ims_cp_items.timelimitaction%TYPE,
		p_datafromlms in ims_cp_items.datafromlms%TYPE,
		p_masteryscore in ims_cp_items.masteryscore%TYPE,
		p_creation_date in acs_objects.creation_date%TYPE
			default sysdate,
		p_creation_user in acs_objects.creation_user%TYPE
			default null,
		p_creation_ip in acs_objects.creation_ip%TYPE
			default null,
		p_package_id in apm_packages.package_id%TYPE,
		p_revision_id in ims_cp_items.ims_item_id%TYPE
	) return ims_cp_items.ims_item_id%TYPE is 
	begin
		update ims_cp_items
		set org_id = p_org_id, identifier = p_identifier, identifierref = p_identifierref, 
		isvisible= p_isvisible, parameters = p_parameters, item_title = p_item_title, parent_item = p_parent_item, 
		hasmetadata = p_hasmetadata, prerequisites_t = p_prerequisites_t, prerequisites_s = p_prerequisites_s, 
		type = p_type, maxtimeallowed = p_maxtimeallowed, timelimitaction = p_timelimitaction, 
		datafromlms = p_datafromlms, masteryscore = p_masteryscore
		where ims_item_id = p_revision_id;

		return p_revision_id;
end new;


	function delete (
		p_ims_item_id in ims_cp_items.ims_item_id%TYPE
	) return integer is 
	begin

        	acs_object.del(p_ims_item_id);
	        delete from ims_cp_items where ims_item_id = p_ims_item_id;
		return 0;
	end delete;


	function get_title (
		p_ims_item_id in ims_cp_items.ims_item_id%TYPE
	) return ims_cp_items.item_title%TYPE is 
		v_item_title ims_cp_items.item_title%TYPE;
	begin
		
		select item_title into v_item_title
		from ims_cp_items
		where ims_item_id = p_ims_item_id;
	
		return v_item_title;
	
	end get_title;
	
end ims_item;
/
show errors;


--
-- PL/sql ims_resource package 
--

create or replace package ims_resource as

	function new (
		p_res_id in ims_cp_resources.res_id%TYPE,
		p_man_id in ims_cp_resources.man_id%TYPE,
		p_identifier in ims_cp_resources.identifier%TYPE,
		p_type in ims_cp_resources.type%TYPE,
		p_href in ims_cp_resources.href%TYPE,
		p_scorm_type in ims_cp_resources.scorm_type%TYPE,
		p_hasmetadata in ims_cp_resources.hasmetadata%TYPE,
		p_creation_date in acs_objects.creation_date%TYPE
			default sysdate,
		p_creation_user in acs_objects.creation_user%TYPE
			default null,
		p_creation_ip in acs_objects.creation_ip%TYPE
			default null,
		p_package_id in apm_packages.package_id%TYPE,
		p_revision_id in ims_cp_resources.res_id%TYPE
	) return ims_cp_resources.res_id%TYPE;

	function delete (
		p_res_id in ims_cp_resources.res_id%TYPE
	) return integer;

	function get_title (
		p_res_id in ims_cp_resources.res_id%TYPE
	) return ims_cp_resources.identifier%TYPE;

end ims_resource;
/
show errors;

create or replace package body ims_resource as

	function new (
		p_res_id in ims_cp_resources.res_id%TYPE,
		p_man_id in ims_cp_resources.man_id%TYPE,
		p_identifier in ims_cp_resources.identifier%TYPE,
		p_type in ims_cp_resources.type%TYPE,
		p_href in ims_cp_resources.href%TYPE,
		p_scorm_type in ims_cp_resources.scorm_type%TYPE,
		p_hasmetadata in ims_cp_resources.hasmetadata%TYPE,
		p_creation_date in acs_objects.creation_date%TYPE
			default sysdate,
		p_creation_user in acs_objects.creation_user%TYPE
			default null,
		p_creation_ip in acs_objects.creation_ip%TYPE
			default null,
		p_package_id in apm_packages.package_id%TYPE,
		p_revision_id in ims_cp_resources.res_id%TYPE
	) return ims_cp_resources.res_id%TYPE is 
	begin
		update ims_cp_resources
		set man_id = p_man_id, identifier = p_identifier, type = p_type, 
		href = p_href, scorm_type = p_scorm_type, hasmetadata = p_hasmetadata
		where res_id = p_revision_id;

		return p_revision_id;
	end new;


	function delete (
		p_res_id in ims_cp_resources.res_id%TYPE
	) return integer is 
	begin
        	acs_object.del(p_res_id);
	        delete from ims_cp_resources where res_id = p_res_id;
		return 0;        	

	end delete;


	function get_title (
		p_res_id in ims_cp_resources.res_id%TYPE
	) return ims_cp_resources.identifier%TYPE is 
		v_identifier ims_cp_resources.identifier%TYPE;

	begin
		select identifier into v_identifier
		from ims_cp_resources
		where res_id = p_res_id;
		
		return v_identifier;
	end get_title;

end ims_resource;
/
show errors;

create or replace package ims_cp_item_to_resource as
	function new (
		p_ims_item_id in ims_cp_items_to_resources.ims_item_id%TYPE,
		p_res_id in ims_cp_items_to_resources.res_id%TYPE
	) return integer;

end ims_cp_item_to_resource;
/
show errors;

create or replace package body ims_cp_item_to_resource as
	function new (
		p_ims_item_id in ims_cp_items_to_resources.ims_item_id%TYPE,
		p_res_id in ims_cp_items_to_resources.res_id%TYPE
	) return integer is
	begin
		insert into ims_cp_items_to_resources (ims_item_id, res_id)
		values
		(p_ims_item_id, p_res_id);
		return 0;

	end new;
	--Function to insert relationships between items and resources within a manifestn.'
end ims_cp_item_to_resource;
/
show errors;

create or replace package ims_dependency as

	function new (
		p_dep_id in ims_cp_dependencies.dep_id%TYPE,
		p_res_id in ims_cp_dependencies.res_id%TYPE,
		p_identifierref in ims_cp_dependencies.identifierref%TYPE
	) return ims_cp_dependencies.dep_id%TYPE;

	function delete (
		p_dep_id in ims_cp_dependencies.dep_id%TYPE
	) return integer;

end ims_dependency;
/
show errors;

create or replace package body ims_dependency as

	function new (
		p_dep_id in ims_cp_dependencies.dep_id%TYPE,
		p_res_id in ims_cp_dependencies.res_id%TYPE,
		p_identifierref in ims_cp_dependencies.identifierref%TYPE
	) return ims_cp_dependencies.dep_id%TYPE is
	begin

	    insert into ims_cp_dependencies (dep_id, res_id, identifierref)
	    values
	    (p_dep_id, p_res_id, p_identifierref);

	    return p_dep_id;

	end new;

	function delete (
		p_dep_id in ims_cp_dependencies.dep_id%TYPE
	) return integer is
	begin
        	acs_object.del(p_dep_id);
	        delete from ims_cp_dependencies where dep_id = p_dep_id;
		return 0;

	end delete;

end ims_dependency;
/ 
show errors;

create or replace package ims_file as

	function new (
		p_file_id in ims_cp_files.file_id%TYPE,
		p_res_id in ims_cp_files.res_id%TYPE,
		p_pathtofile in ims_cp_files.pathtofile%TYPE, 
		p_filename in ims_cp_files.filename%TYPE,
		p_hasmetadata in ims_cp_files.hasmetadata%TYPE
	) return ims_cp_files.file_id%TYPE;

end ims_file;
/
show errors;

create or replace package body ims_file as

	function new (
		p_file_id in ims_cp_files.file_id%TYPE,
		p_res_id in ims_cp_files.res_id%TYPE,
		p_pathtofile in ims_cp_files.pathtofile%TYPE, 
		p_filename in ims_cp_files.filename%TYPE,
		p_hasmetadata in ims_cp_files.hasmetadata%TYPE
	) return ims_cp_files.file_id%TYPE is 
	begin
	    insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
	    values
	    (p_file_id, p_res_id, p_pathtofile, p_filename, p_hasmetadata);

	    return p_file_id;

	end new;

end ims_file;
/
show errors;

update acs_object_types
set table_name = 'ims_cp_items',
    name_method = 'ims_item.get_title',
    pretty_name = 'IMS Item',
    pretty_plural = 'IMS Items'
where object_type = 'ims_item';

