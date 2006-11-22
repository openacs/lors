-- lors data model
--
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 25/07/2006
-- @cvs-id $Id$

--
--  Copyright (C) 2006 Mario Aguado
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

-- Creates a folder to store LOs
create or replace package lors as
 
	function new_folder (
			p_name		cr_items.name%TYPE,
			p_folder_name	cr_folders.label%TYPE,
			p_parent_id	cr_items.parent_id%TYPE,
			p_creation_user	acs_objects.creation_user%TYPE,
			p_creation_ip	acs_objects.creation_ip%TYPE
	) return cr_folders.folder_id%TYPE;
	
	procedure delete_folder(
			p_folder_id cr_folders.folder_id%TYPE
	);
	
END lors;
/
create or replace package body lors as

	function new_folder (
			p_name			cr_items.name%TYPE,
	        	p_folder_name		cr_folders.label%TYPE,
			p_parent_id		cr_items.parent_id%TYPE,
			p_creation_user		acs_objects.creation_user%TYPE,
			p_creation_ip		acs_objects.creation_ip%TYPE
	) return cr_folders.folder_id%TYPE is
	   v_folder_id	cr_folders.folder_id%TYPE;
	begin
        -- Create a new folder
        	v_folder_id := content_folder.new (
				name => p_name,
				label => p_folder_name,
				parent_id => p_parent_id,
				creation_user => p_creation_user,
				creation_ip => p_creation_ip
				);

        -- register the standard content types
        -- JS: Note that we need to set include_subtypes
        -- JS: to true since we created a new subtype.
	        content_folder.register_content_type(
				folder_id => v_folder_id,
				content_type => 'content_revision',
				include_subtypes => 't'
				);
						
	        content_folder.register_content_type(
				folder_id => v_folder_id,
				content_type => 'content_folder',
				include_subtypes => 't'
	                        );

	        content_folder.register_content_type(
				folder_id => v_folder_id,            
				content_type => 'content_extlink',   
				include_subtypes => 't'              
	                	);

	        content_folder.register_content_type(
				folder_id => v_folder_id,            
				content_type => 'content_symlink',  
				include_subtypes => 't'
				);

        -- Give the creator admin privileges on the folder
	        acs_permission.grant_permission (
				object_id => v_folder_id,
				grantee_id => p_creation_user,
				privilege => 'admin'
				);

		return v_folder_id;
	
	end new_folder;

	-- Deletes folder
	procedure delete_folder(
		p_folder_id	cr_folders.folder_id%TYPE
	) is
	begin
	        content_folder.del(
			folder_id => p_folder_id
			);

	end delete_folder;

end lors;
/ 
show errors;

-- loads IMS Metadata Data Model
@@ lors-imsmd-create.sql
@@ lors-imscp-create.sql
@@ lors-imscp-package-create.sql
@@ lors-imsmd-sc-create.sql

