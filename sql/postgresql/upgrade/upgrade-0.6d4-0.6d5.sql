-- packages/lors/sql/postgresql/upgrade/upgrade-0.6.d4-0.6d5.sql
--
-- Upgrade tables names and column to Oracle compatibility
--
-- Copyright (C) 2006 Innova - UNED
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 16/08/2006
--
-- @cvs-id $Id$
--
-- This is free software distributed under the terms of the GNU Public
-- License.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html
-- Rename sequence 
alter table ims_md_life_cycle_contrib_entity_seq rename to ims_md_lf_c_contrib_enty_seq;
alter table ims_md_life_cycle_contrib_entity rename to ims_md_life_cycle_contrib_enty;
-- Other sequence 
alter table ims_md_metadata_contrib_entity_seq rename to ims_md_meta_contrib_enty_seq;
-- Index
alter table ims_md_te_location__imd_md_id_idx rename to ims_md_te_loc_imd_md_id_idx;
-- Other sequence
alter table ims_md_technical_requirement_seq rename to ims_md_tech_requirement_seq;
-- Other index
alter table ims_md_ed_descrip__imd_md_id_idx rename to ims_md_ed_desc_imd_md_id_idx;
-- Other sequence
alter table ims_md_relation_resource_catalog_seq rename to ims_md_rel_resource_cat_seq;

alter table ims_md_relation_resource_catalog rename to ims_md_rel_resource_catalog;

-- Other index
alter table ims_md_re_re_cat__imd_md_re_re_id_idx rename to ims_md_re__md_re_re_id_idx;

-- Column
alter table ims_md_annotation rename column date to annotation_date;

-- Other index
alter table ims_md_an_desc__imd_md_an_id_idx rename to ims_md_an_desc_md_an_id_idx;
alter table ims_md_cl_desc__imd_md_cl_id_idx rename to ims_md_cl_desc_md_cl_id_idx;
-- Other sequence 
alter table ims_md_classification_taxpath_seq rename to ims_md_classif_taxpath_seq;
alter table ims_md_classification_taxpath_taxon_seq rename to ims_md_classif_tpath_taxon_seq;


alter table ims_md_classification_taxpath_taxon rename to ims_md_classif_taxpath_taxon;

-- Other index
alter table ims_md_cl_tax_tax__imd_md_cl_ta_id_idx rename to ims_md_cl_t_t__md_cl_ta_id_idx;

-- Other sequence
alter table ims_md_classification_keyword_seq rename to ims_md_classif_keyword_seq;

-- Objects in file lors-imscp-create.sql
-- Index
alter table ims_cp_organizations__man_id_idx rename to ims_cp_org_man_id_idx;
alter table ims_cp_items_to_resources__item_id_idx rename to ims_cp_items_2_res_item_id_idx;
alter table ims_cp_items_to_resources__res_id_idx rename to ims_cp_items_2_res_res_id_idx;
alter table ims_cp_dependencies__res_id_idx rename to ims_cp_dependencies_res_id_idx;

