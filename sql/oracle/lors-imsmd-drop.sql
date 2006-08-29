--
--
--
-- @author devopenacs5 (devopenacs5@www)
-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 25/07/2006
-- @cvs-id $Id$
--

drop table ims_md_annotation_descrip;
drop table ims_md_annotation;
drop table ims_md_classification_descrip;
drop table ims_md_classification_keyword;
drop table ims_md_classif_taxpath_taxon;
drop table ims_md_classification_taxpath;
drop table ims_md_classification;
drop table ims_md_educational;
drop table ims_md_educational_context;
drop table ims_md_educational_descrip;
drop table ims_md_educational_ieur;
drop table ims_md_educational_lang;
drop table ims_md_educational_lrt;
drop table ims_md_educational_tar;
drop table ims_md_general;
drop table ims_md_general_cata;
drop table ims_md_general_cover;
drop table ims_md_general_desc;
drop table ims_md_general_iden;
drop table ims_md_general_key;
drop table ims_md_general_lang;
drop table ims_md_general_title;
drop table ims_md_life_cycle;
drop table ims_md_life_cycle_contrib_enty;
drop table ims_md_life_cycle_contrib;

drop table ims_md_metadata;
drop table ims_md_metadata_cata;
drop table ims_md_metadata_contrib_entity;
drop table ims_md_metadata_contrib;

drop table ims_md_metadata_scheme;
drop table ims_md_rel_resource_catalog;
drop table ims_md_relation_resource;
drop table ims_md_relation;
drop table ims_md_rights;
drop table ims_md_technical;
drop table ims_md_technical_format;
drop table ims_md_technical_location;
drop table ims_md_technical_requirement;

drop table ims_md;

--Drop sequences
drop sequence ims_md_general_title_seq;
drop sequence ims_md_general_iden_seq;
drop sequence ims_md_general_cata_seq;
drop sequence ims_md_general_lang_seq;
drop sequence ims_md_general_desc_seq;
drop sequence ims_md_general_key_seq;
drop sequence ims_md_general_cover_seq;

drop sequence ims_md_life_cycle_contrib_seq;
drop sequence ims_md_lf_c_contrib_enty_seq;

drop sequence ims_md_metadata_cata_seq;
drop sequence ims_md_metadata_contrib_seq;
drop sequence ims_md_meta_contrib_enty_seq;
drop sequence ims_md_metadata_scheme_seq;

drop sequence ims_md_technical_format_seq;
drop sequence ims_md_technical_location_seq;
drop sequence ims_md_tech_requirement_seq;

drop sequence ims_md_educational_lrt_seq;
drop sequence ims_md_educational_ieur_seq;
drop sequence ims_md_educational_context_seq;
drop sequence ims_md_educational_tar_seq;
drop sequence ims_md_educational_lang_seq;
drop sequence ims_md_educational_descrip_seq;

drop sequence ims_md_relation_seq;
drop sequence ims_md_relation_resource_seq;
drop sequence ims_md_rel_resource_cat_seq;

drop sequence ims_md_annotation_seq;
drop sequence ims_md_annotation_descrip_seq;

drop sequence ims_md_classification_seq;
drop sequence ims_md_classification_desc_seq;
drop sequence ims_md_classif_taxpath_seq;
drop sequence ims_md_classif_tpath_taxon_seq;
drop sequence ims_md_classif_keyword_seq;

--Drop implementation
declare
	v_impl_alias_id acs_sc_impls.impl_id%TYPE;
begin

--Delete impl ims_manifest 

v_impl_alias_id := acs_sc_impl_alias.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name =>  'ims_manifest',
	impl_operation_name => 'datasource'
);

v_impl_alias_id := acs_sc_impl_alias.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name =>  'ims_manifest',
	impl_operation_name => 'url'
);

acs_sc_binding.del (
	contract_name =>  'FtsContentProvider',
	impl_name =>  'ims_manifest'
);

acs_sc_impl.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_manifest'
);

--Delete impl ims_organization

v_impl_alias_id := acs_sc_impl_alias.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name =>  'ims_organization',
	impl_operation_name => 'datasource'
);

v_impl_alias_id := acs_sc_impl_alias.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name =>  'ims_organization',
	impl_operation_name => 'url'
);

acs_sc_binding.del (
	contract_name =>  'FtsContentProvider',
	impl_name =>  'ims_organization'
);

acs_sc_impl.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_organization'
);



--Delete impl ims_item

v_impl_alias_id := acs_sc_impl_alias.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name =>  'ims_item',
	impl_operation_name => 'datasource'
);

v_impl_alias_id := acs_sc_impl_alias.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name =>  'ims_item',
	impl_operation_name => 'url'
);

acs_sc_binding.del (
	contract_name =>  'FtsContentProvider',
	impl_name =>  'ims_item'
);

acs_sc_impl.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_item'
);

--Delete impl ims_resource

v_impl_alias_id := acs_sc_impl_alias.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name =>  'ims_resource',
	impl_operation_name => 'datasource'
);

v_impl_alias_id := acs_sc_impl_alias.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name =>  'ims_resource',
	impl_operation_name => 'url'
);

acs_sc_binding.del (
	contract_name =>  'FtsContentProvider',
	impl_name =>  'ims_resource'
);

acs_sc_impl.del(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_resource'
);
end;
/