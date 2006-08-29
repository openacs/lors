-- IMS Content Packaging data model
--
-- @author Ernie Ghiglione (ErnieG@ee.usyd.edu.au)
-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 25/07/2006
-- @cvs-id $Id$
--
--  Copyright (C) 2006 Mario Aguado
-- Based on IMS Content Packaging Specifications Version 1.1.2 
-- http://www.imsglobal.org/content/packaging/cpv1p1p2/imscp_infov1p1p2.html

-- And

-- SCORM 1.2 Specs

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

--Drop packages

drop package ims_manifest;
drop package ims_organization;
drop package ims_item;
drop package ims_resource;
drop package ims_cp_item_to_resource;
drop package ims_dependency;
drop package ims_file;


--Drop type
begin
	content_type.drop_type(
		content_type => 'ims_manifest_object'
	);

	content_type.drop_type(
		content_type => 'ims_organization_object'
	);

	content_type.drop_type(
		content_type => 'ims_item_object'
	);

	content_type.drop_type(
		content_type => 'ims_resource_object'
	);

end;
/