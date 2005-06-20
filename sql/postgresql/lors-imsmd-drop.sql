--
-- @author Nima Mazloumi (mazloumi@uni-mannheim.de)
-- @creation-date 6 Jan 2004

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

-- IMS Metadata 1.2.1 Compliant
-- http://www.imsglobal.org/metadata/imsmdv1p2p1/imsmd_infov1p2p1.html

-- drop ims metadata table
DROP TABLE ims_md CASCADE;

-- General
DROP TABLE ims_md_general;

-- sequence for ims_md_general_title
DROP sequence ims_md_general_title_seq;

-- drop ims_md_general_title
DROP table ims_md_general_title;

-- drop a sequence for ims_md-general_iden
DROP sequence ims_md_general_iden_seq;

-- drop ims_md_general_iden
DROP table ims_md_general_iden;

-- to ensure better performance we create a sequence for ims_md-general_iden
DROP sequence ims_md_general_cata_seq;

-- drop ims_md_general_cata
DROP table ims_md_general_cata;

-- sequence ims_md_general_lang_seq
DROP sequence ims_md_general_lang_seq;

-- drop ims_md_general_lang
DROP table ims_md_general_lang;

-- drop seq for ims_md_general_desc table
DROP sequence ims_md_general_desc_seq;

-- drop ims_md_general_desc
DROP table ims_md_general_desc;

-- drop seq for ims_md_general_key table
DROP sequence ims_md_general_key_seq;

-- drop index for ims_md_general_key
DROP table ims_md_general_key;

--drop ims_md_general_cover
DROP sequence ims_md_general_cover_seq;

-- drop ims_md_general_cover
DROP table ims_md_general_cover;

-- Life Cycle

DROP table ims_md_life_cycle;

-- drop sequence for life cycle contributors
DROP sequence ims_md_life_cycle_contrib_seq;

-- drop ims_md_life_cycle_contrib
DROP table ims_md_life_cycle_contrib CASCADE;


-- drop sequence for ims_md_life_cycle_contrib_entity table
DROP sequence ims_md_life_cycle_contrib_entity_seq;

DROP table ims_md_life_cycle_contrib_entity;

-- Metadata

DROP table ims_md_metadata;

-- drop seq for ims_md_metadata_cata
DROP sequence ims_md_metadata_cata_seq;

-- drop ims_md_metadata_cata
DROP table ims_md_metadata_cata;

-- drop seq for ims_md_metadata_contrib;
DROP sequence ims_md_metadata_contrib_seq;

-- drop ims_md_metadata_contrib
DROP table ims_md_metadata_contrib CASCADE;

-- drop sequence for ims_md_metadata_contrib_entity table
DROP sequence ims_md_metadata_contrib_entity_seq;

DROP table ims_md_metadata_contrib_entity;

--DROP sequence for ims_md_metadata_scheme table
DROP sequence ims_md_metadata_scheme_seq;

DROP table ims_md_metadata_scheme;

-- Technical

DROP table ims_md_technical;

-- drop sequence for ims_md_technical_format table
DROP sequence ims_md_technical_format_seq;

-- drop ims_md_technical_format
DROP table ims_md_technical_format;

-- drop sequence for ims_md_technical_location table
DROP sequence ims_md_technical_location_seq;

-- drop ims_md_technical_location
DROP table ims_md_technical_location;

-- drop sequence for ims_md_technical_requirement table
DROP sequence ims_md_technical_requirement_seq;

-- drop ims_md_technical_requirement
DROP table ims_md_technical_requirement;

-- Educational begins

DROP table ims_md_educational;

-- drop seq from ims_md_educational_lrt table
DROP sequence ims_md_educational_lrt_seq;

-- drop ims_md_educational_lrt
DROP table ims_md_educational_lrt;

-- drop seq from ims_md_educational_ieur table
DROP sequence ims_md_educational_ieur_seq;

-- drop ims_md_educational_ieur
DROP table ims_md_educational_ieur;

-- drop seq from ims_md_educational_context table
DROP sequence ims_md_educational_context_seq;

-- drop ims_md_educational_context
DROP table ims_md_educational_context;

-- drop seq from ims_md_educational_tar table
DROP sequence ims_md_educational_tar_seq;

-- drop ims_md_educational_tar
DROP table ims_md_educational_tar;

-- drop seq from ims_md_educational_lang table
DROP sequence ims_md_educational_lang_seq;

-- drop ims_md_educational_lang
DROP table ims_md_educational_lang;

-- drop seq from ims_md_educational_lrt table
DROP sequence ims_md_educational_descrip_seq;

-- drop ims_md_educational_descrip
DROP table ims_md_educational_descrip;

-- Rights

DROP table ims_md_rights;

-- Relation

-- drop seq for ims_md_relation table
DROP sequence ims_md_relation_seq;

-- drop ims_md_relation
DROP table ims_md_relation CASCADE;

-- drop seq for ims_md_relation_resource table
DROP sequence ims_md_relation_resource_seq;

-- drop ims_md_relation_resource
DROP table ims_md_relation_resource CASCADE;

-- drop seq for ims_md_relation_resource_catalog table
DROP sequence ims_md_relation_resource_catalog_seq;

-- drop ims_md_relation_resource_catalog
DROP table ims_md_relation_resource_catalog;

-- Annotation

-- drop seq for ims_md_annotation table
DROP sequence ims_md_annotation_seq;

-- drop ims_md_annotation
DROP table ims_md_annotation CASCADE;

-- drop seq for ims_md_annotation_descrip table
DROP sequence ims_md_annotation_descrip_seq;

-- drop ims_md_annotation_descrip
DROP table ims_md_annotation_descrip;

-- Classification

-- drop seq for ims_md_classification table
DROP sequence ims_md_classification_seq;

-- drop ims_md_annotation
DROP table ims_md_classification CASCADE;

DROP sequence ims_md_classification_desc_seq;

-- drop ims_md_classification_descrip
DROP table ims_md_classification_descrip;

-- drop seq for ims_md_classification_taxpath table
DROP sequence ims_md_classification_taxpath_seq;

-- drop ims_md_classification_taxpath
DROP table ims_md_classification_taxpath CASCADE;

-- drop seq ims_md_classification_taxpath_taxon table
DROP sequence ims_md_classification_taxpath_taxon_seq;

-- drop ims_md_classification_taxpath_taxon
DROP table ims_md_classification_taxpath_taxon;

-- drop seq for ims_md_classification_keyword table
DROP sequence ims_md_classification_keyword_seq;

-- drop ims_md_classification_keyword
DROP table ims_md_classification_keyword;