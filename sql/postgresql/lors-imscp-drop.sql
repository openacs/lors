-- IMS Content Packaging data model
--
-- @author Ernie Ghiglione (ErnieG@ee.usyd.edu.au)
-- @creation-date 6 Jan 2004
-- @cvs-id $Id$

-- Based on IMS Content Packaging Specifications Version 1.1.2 
-- http://www.imsglobal.org/content/packaging/cpv1p1p2/imscp_infov1p1p2.html

-- And

-- SCORM 1.2 Specs

-- Manifests
drop table ims_cp_dependencies;
drop sequence ims_cp_dependencies_seq;
drop table ims_cp_files;
drop table ims_cp_resources;
drop table ims_cp_items;
drop table ims_cp_organizations;
drop table ims_cp_manifests;
drop table lors_available_presentation_formats;

