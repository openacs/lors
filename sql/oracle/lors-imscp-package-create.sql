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


create or replace package ims_manifest as
	function new(
		course_name in ims_cp_manifests.course_name%TYPE,
		identifier in ims_cp_manifests.identifier%TYPE,
		version in ims_cp_manifests.version%TYPE,
		orgs_default in  ims_cp_manifests.orgs_default%TYPE,
		hasmetadata in ims_cp_manifests.hasmetadata%TYPE,
		parent_man_id in ims_cp_manifests.parent_man_id%TYPE,
		isscorm in ims_cp_manifests.isscorm%TYPE,
		folder_id in ims_cp_manifests.folder_id%TYPE,
		fs_package_id in ims_cp_manifests.fs_package_id%TYPE,
		creation_date in acs_objects.creation_date%TYPE 
				default sysdate,
		creation_user in acs_objects.creation_user%TYPE
				default null,
		creation_ip in acs_objects.creation_ip%TYPE
				default null,
		package_id in ims_cp_manifest_class.lorsm_instance_id%TYPE,
		community_id in ims_cp_manifest_class.community_id%TYPE,
		class_key in ims_cp_manifest_class.class_key%TYPE,
		revision_id in ims_cp_manifest_class.man_id%TYPE,
		isshared in ims_cp_manifests.isshared%TYPE,
		course_presentation_format in ims_cp_manifests.course_presentation_format%TYPE
	) return ims_cp_manifest_class.man_id%TYPE;

	procedure delete (
		man_id in ims_cp_manifests.man_id%TYPE
	);

	function get_title (
		man_id in ims_cp_manifests.man_id%TYPE
	) return ims_cp_manifests.course_name%TYPE;

end ims_manifest;
/
show errors;

create or replace package body ims_manifest as
	function new(
		course_name in ims_cp_manifests.course_name%TYPE,
		identifier in ims_cp_manifests.identifier%TYPE,
		version in ims_cp_manifests.version%TYPE,
		orgs_default in  ims_cp_manifests.orgs_default%TYPE,
		hasmetadata in ims_cp_manifests.hasmetadata%TYPE,
		parent_man_id in ims_cp_manifests.parent_man_id%TYPE,
		isscorm in ims_cp_manifests.isscorm%TYPE,
		folder_id in ims_cp_manifests.folder_id%TYPE,
		fs_package_id in ims_cp_manifests.fs_package_id%TYPE,
		creation_date in acs_objects.creation_date%TYPE 
				default sysdate,
		creation_user in acs_objects.creation_user%TYPE
				default null,
		creation_ip in acs_objects.creation_ip%TYPE
				default null,
		package_id in ims_cp_manifest_class.lorsm_instance_id%TYPE,
		community_id in ims_cp_manifest_class.community_id%TYPE,
		class_key in ims_cp_manifest_class.class_key%TYPE,
		revision_id in ims_cp_manifest_class.man_id%TYPE,
		isshared in ims_cp_manifests.isshared%TYPE,
		course_presentation_format in ims_cp_manifests.course_presentation_format%TYPE
	) return ims_cp_manifest_class.man_id%TYPE is
	begin
	        -- we make an update here because the content::item::new already inserts a row in the ims_cp_manifests
	        update ims_cp_manifests
	        set course_name=course_name, identifier=identifier, version=version, 
	            orgs_default=orgs_default, hasmetadata=hasmetadata, parent_man_id=parent_man_id, 
	            isscorm=isscorm, folder_id=folder_id, fs_package_id=fs_package_id, isshared = isshared,
	            course_presentation_format=course_presentation_format
	        where man_id = revision_id;
		-- now we add it to the manifest_class relation table

		insert into ims_cp_manifest_class
		(man_id, lorsm_instance_id, community_id, class_key, isenabled, istrackable)
		values
		(revision_id, package_id, community_id, class_key, 't', 'f');
	        
	        return revision_id;

	end new;

	procedure delete (
		man_id in ims_cp_manifests.man_id%TYPE
	) is
	begin
        	
		acs_object.del(man_id);
	        delete from ims_cp_manifests where man_id = man_id;
	
	end delete;

	function get_title (
		man_id in ims_cp_manifests.man_id%TYPE
	) return ims_cp_manifests.course_name%TYPE is
		course_name        ims_cp_manifests.course_name%TYPE;  
	begin

		select course_name into course_name
		from ims_cp_manifests
		where man_id = man_id;
	
		return course_name;	

	end get_title;

end ims_manifest;
/
show errors;

--
-- PL/sql ims_organization package
--



create or replace package ims_organization as

	function new(
		org_id in ims_cp_organizations.org_id%TYPE,
		man_id in ims_cp_organizations.man_id%TYPE,
		identifier in ims_cp_organizations.identifier%TYPE,
		structure in ims_cp_organizations.structure%TYPE,
		title in ims_cp_organizations.org_title%TYPE,
		hasmetadata in ims_cp_organizations.hasmetadata%TYPE,
		creation_date in acs_objects.creation_date%TYPE
				default sysdate,
		creation_user in acs_objects.creation_user%TYPE
				default null,
		creation_ip in acs_objects.creation_ip%TYPE
				default null,
		package_id in apm_packages.package_id%TYPE,
		revision_id in ims_cp_organizations.org_id%TYPE
	) return ims_cp_organizations.org_id%TYPE;

	function delete (
	    org_id in ims_cp_organizations.org_id%TYPE
	) return integer;

	function get_title (
		org_id in ims_cp_organizations.org_id%TYPE
	) return ims_cp_organizations.identifier%TYPE;
	
end ims_organization;
/
show errors;

create or replace package body ims_organization as
	function new(
		org_id in ims_cp_organizations.org_id%TYPE,
		man_id in ims_cp_organizations.man_id%TYPE,
		identifier in ims_cp_organizations.identifier%TYPE,
		structure in ims_cp_organizations.structure%TYPE,
		title in ims_cp_organizations.org_title%TYPE,
		hasmetadata in ims_cp_organizations.hasmetadata%TYPE,
		creation_date in acs_objects.creation_date%TYPE
				default sysdate,
		creation_user in acs_objects.creation_user%TYPE
				default null,
		creation_ip in acs_objects.creation_ip%TYPE
				default null,
		package_id in apm_packages.package_id%TYPE,
		revision_id in ims_cp_organizations.org_id%TYPE
	) return ims_cp_organizations.org_id%TYPE is 
	begin

        -- we make an update here because the content::item::new already inserts a row in the ims_cp_organizations
	        update ims_cp_organizations
        	set man_id= man_id, identifier= identifier, structure= structure, 
            	org_title= title, hasmetadata= hasmetadata
		where org_id = revision_id;

        	return revision_id;

	end new;


	function delete (
	    org_id in ims_cp_organizations.org_id%TYPE
	) return integer is
	begin
        
		acs_object.del(org_id);
	        delete from ims_cp_organizations where org_id = org_id;
		return 0;

	end delete;

	function get_title (
		org_id in ims_cp_organizations.org_id%TYPE
	) return ims_cp_organizations.identifier%TYPE is
		title_identifier ims_cp_organizations.identifier%TYPE;  
	begin
	
		select identifier into title_identifier
		from ims_cp_organizations
		where org_id = org_id;
	
		return title_identifier;	

	end get_title;

end ims_organization;
/
show errors;

--
-- PL/sql ims_item package 
--

create or replace package ims_item as

	function new (
		ims_item_id in ims_cp_items.ims_item_id%TYPE,
		org_id  in ims_cp_items.org_id%TYPE,
		identifier  in ims_cp_items.identifier%TYPE,
		identifierref  in ims_cp_items.identifierref%TYPE,
		isvisible  in ims_cp_items.isvisible%TYPE,
		parameters  in ims_cp_items.parameters%TYPE,
		item_title  in ims_cp_items.item_title%TYPE,
		parent_item  in ims_cp_items.parent_item%TYPE,
		hasmetadata  in ims_cp_items.hasmetadata%TYPE,
		prerequisites_t in ims_cp_items.prerequisites_t%TYPE,
		prerequisites_s in ims_cp_items.prerequisites_s%TYPE,
		type in ims_cp_items.type%TYPE,
		maxtimeallowed in ims_cp_items.maxtimeallowed%TYPE,
		timelimitaction in ims_cp_items.timelimitaction%TYPE,
		datafromlms in ims_cp_items.datafromlms%TYPE,
		masteryscore in ims_cp_items.masteryscore%TYPE,
		creation_date in acs_objects.creation_date%TYPE
			default sysdate,
		creation_user in acs_objects.creation_user%TYPE
			default null,
		creation_ip in acs_objects.creation_ip%TYPE
			default null,
		package_id in apm_packages.package_id%TYPE,
		revision_id in ims_cp_items.ims_item_id%TYPE
	) return ims_cp_items.ims_item_id%TYPE;

	function delete (
	    ims_item_id in ims_cp_items.ims_item_id%TYPE
	) return integer;

	function get_title (
		ims_item_id in ims_cp_items.ims_item_id%TYPE
	) return ims_cp_items.item_title%TYPE;
	
end ims_item;
/
show errors;

create or replace package body ims_item as

	function new (
		ims_item_id in ims_cp_items.ims_item_id%TYPE,
		org_id  in ims_cp_items.org_id%TYPE,
		identifier  in ims_cp_items.identifier%TYPE,
		identifierref  in ims_cp_items.identifierref%TYPE,
		isvisible  in ims_cp_items.isvisible%TYPE,
		parameters  in ims_cp_items.parameters%TYPE,
		item_title  in ims_cp_items.item_title%TYPE,
		parent_item  in ims_cp_items.parent_item%TYPE,
		hasmetadata  in ims_cp_items.hasmetadata%TYPE,
		prerequisites_t in ims_cp_items.prerequisites_t%TYPE,
		prerequisites_s in ims_cp_items.prerequisites_s%TYPE,
		type in ims_cp_items.type%TYPE,
		maxtimeallowed in ims_cp_items.maxtimeallowed%TYPE,
		timelimitaction in ims_cp_items.timelimitaction%TYPE,
		datafromlms in ims_cp_items.datafromlms%TYPE,
		masteryscore in ims_cp_items.masteryscore%TYPE,
		creation_date in acs_objects.creation_date%TYPE
			default sysdate,
		creation_user in acs_objects.creation_user%TYPE
			default null,
		creation_ip in acs_objects.creation_ip%TYPE
			default null,
		package_id in apm_packages.package_id%TYPE,
		revision_id in ims_cp_items.ims_item_id%TYPE
	) return ims_cp_items.ims_item_id%TYPE is 
	begin
		update ims_cp_items
		set org_id= org_id, identifier= identifier, identifierref= identifierref, 
		isvisible= isvisible, parameters= parameters, item_title= item_title, parent_item= parent_item, 
		hasmetadata= hasmetadata, prerequisites_t= prerequisites_t, prerequisites_s= prerequisites_s, 
		type= type, maxtimeallowed= maxtimeallowed, timelimitaction= timelimitaction, 
		datafromlms= datafromlms, masteryscore= masteryscore
		where ims_item_id = revision_id;

		return revision_id;
end new;


	function delete (
	    ims_item_id in ims_cp_items.ims_item_id%TYPE
	) return integer is 
	begin

        	acs_object.del(ims_item_id);
	        delete from ims_cp_items where ims_item_id = ims_item_id;
		return 0;
	end delete;


	function get_title (
		ims_item_id in ims_cp_items.ims_item_id%TYPE
	) return ims_cp_items.item_title%TYPE is 
		item_title ims_cp_items.item_title%TYPE;
	begin
		
		select item_title into item_title
		from ims_cp_items
		where ims_item_id = ims_item_id;
	
		return item_title;
	
	end get_title;
	
end ims_item;
/
show errors;


--
-- PL/sql ims_resource package 
--

create or replace package ims_resource as

	function new (
		res_id in ims_cp_resources.res_id%TYPE,
		man_id in ims_cp_resources.man_id%TYPE,
		identifier in ims_cp_resources.identifier%TYPE,
		type in ims_cp_resources.type%TYPE,
		href in ims_cp_resources.href%TYPE,
		scorm_type in ims_cp_resources.scorm_type%TYPE,
		hasmetadata in ims_cp_resources.hasmetadata%TYPE,
		creation_date in acs_objects.creation_date%TYPE
			default sysdate,
		creation_user in acs_objects.creation_user%TYPE
			default null,
		creation_ip in acs_objects.creation_ip%TYPE
			default null,
		package_id in apm_packages.package_id%TYPE,
		revision_id in ims_cp_resources.res_id%TYPE
	) return ims_cp_resources.res_id%TYPE;

	function delete (
	    res_id in ims_cp_resources.res_id%TYPE
	) return integer;

	function get_title (
		res_id in ims_cp_resources.res_id%TYPE
	) return ims_cp_resources.identifier%TYPE;

end ims_resource;
/
show errors;

create or replace package body ims_resource as

	function new (
		res_id in ims_cp_resources.res_id%TYPE,
		man_id in ims_cp_resources.man_id%TYPE,
		identifier in ims_cp_resources.identifier%TYPE,
		type in ims_cp_resources.type%TYPE,
		href in ims_cp_resources.href%TYPE,
		scorm_type in ims_cp_resources.scorm_type%TYPE,
		hasmetadata in ims_cp_resources.hasmetadata%TYPE,
		creation_date in acs_objects.creation_date%TYPE
			default sysdate,
		creation_user in acs_objects.creation_user%TYPE
			default null,
		creation_ip in acs_objects.creation_ip%TYPE
			default null,
		package_id in apm_packages.package_id%TYPE,
		revision_id in ims_cp_resources.res_id%TYPE
	) return ims_cp_resources.res_id%TYPE is 
	begin
		update ims_cp_resources
		set man_id= man_id, identifier= identifier, type= type, 
		href= href, scorm_type= scorm_type, hasmetadata= hasmetadata
		where res_id = revision_id;

		return revision_id;
	end new;


	function delete (
	    res_id in ims_cp_resources.res_id%TYPE
	) return integer is 
	begin
        	acs_object.del(res_id);
	        delete from ims_cp_resources where res_id = res_id;
		return 0;        	

	end delete;


	function get_title (
		res_id in ims_cp_resources.res_id%TYPE
	) return ims_cp_resources.identifier%TYPE is 
		identifier ims_cp_resources.identifier%TYPE;

	begin
		select identifier into identifier
		from ims_cp_resources
		where res_id = res_id;

	end get_title;

end ims_resource;
/
show errors;

create or replace package ims_cp_item_to_resource as
	function new (
		ims_item_id in ims_cp_items_to_resources.ims_item_id%TYPE,
		res_id in ims_cp_items_to_resources.res_id%TYPE
	) return integer;

end ims_cp_item_to_resource;
/
show errors;

create or replace package body ims_cp_item_to_resource as
	function new (
		ims_item_id in ims_cp_items_to_resources.ims_item_id%TYPE,
		res_id in ims_cp_items_to_resources.res_id%TYPE
	) return integer is
	begin
		insert into ims_cp_items_to_resources (ims_item_id, res_id)
		values
		(ims_item_id, res_id);
		return 0;

	end new;
	--Function to insert relationships between items and resources within a manifestn.'
end ims_cp_item_to_resource;
/
show errors;

create or replace package ims_dependency as

	function new (
		dep_id in ims_cp_dependencies.dep_id%TYPE,
		res_id in ims_cp_dependencies.res_id%TYPE,
		identifierref in ims_cp_dependencies.identifierref%TYPE
	) return ims_cp_dependencies.dep_id%TYPE;

	function delete (
	    dep_id in ims_cp_dependencies.dep_id%TYPE
	) return integer;

end ims_dependency;
/
show errors;

create or replace package body ims_dependency as

	function new (
		dep_id in ims_cp_dependencies.dep_id%TYPE,
		res_id in ims_cp_dependencies.res_id%TYPE,
		identifierref in ims_cp_dependencies.identifierref%TYPE
	) return ims_cp_dependencies.dep_id%TYPE is
	begin

	    insert into ims_cp_dependencies (dep_id, res_id, identifierref)
	    values
	    (dep_id, res_id, identifierref);

	    return dep_id;

	end new;

	function delete (
	    dep_id in ims_cp_dependencies.dep_id%TYPE
	) return integer is
	begin
        	acs_object.del(dep_id);
	        delete from ims_cp_dependencies where dep_id = dep_id;
		return 0;

	end delete;

end ims_dependency;
/ 
show errors;

create or replace package ims_file as

	function new (
		file_id in ims_cp_files.file_id%TYPE,
		res_id in ims_cp_files.res_id%TYPE,
		pathtofile in ims_cp_files.pathtofile%TYPE, 
		filename in ims_cp_files.filename%TYPE,
		hasmetadata in ims_cp_files.hasmetadata%TYPE
	) return ims_cp_files.file_id%TYPE;

end ims_file;
/
show errors;

create or replace package body ims_file as

	function new (
		file_id in ims_cp_files.file_id%TYPE,
		res_id in ims_cp_files.res_id%TYPE,
		pathtofile in ims_cp_files.pathtofile%TYPE, 
		filename in ims_cp_files.filename%TYPE,
		hasmetadata in ims_cp_files.hasmetadata%TYPE
	) return ims_cp_files.file_id%TYPE is 
	begin
	    insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
	    values
	    (file_id, res_id, pathtofile, filename, hasmetadata);

	    return file_id;

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

