-- IMS Content Packaging Data Model
--
-- @author Nima Mazloumi (mazloumi@uni-mannheim.de)
-- @creation-date 6 Jan 2004
-- @cvs-id $Id$

--
--  Copyright (C) 2004 Nima Mazloumi
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
--   Drop all object types
-----


    select acs_object_type__drop_type (
                'ims_manifest',          -- object_type
                'f'
        );
        
       
    select acs_object_type__drop_type (
                'ims_organization',          -- object_type
                'f'
        );
 
     select acs_object_type__drop_type (
                 'ims_item',          -- object_type
                 'f'
        );
        
     select acs_object_type__drop_type (
                 'ims_resource',          -- object_type
                 'f'
        );        

-----
--   Drop tables
----

-- Manifest files
DROP TABLE ims_cp_manifest_class;

-- Manifests
drop table ims_cp_dependencies;
drop sequence ims_cp_dependencies_seq;
drop table ims_cp_files;
drop table ims_cp_items_to_resources;
drop table ims_cp_resources;
drop table ims_cp_items;
drop table ims_cp_organizations;
drop table ims_cp_manifest_class;
drop table ims_cp_manifests;
drop table lors_available_presentation_formats;

