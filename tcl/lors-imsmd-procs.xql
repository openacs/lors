<?xml version="1.0"?>
<queryset>

    <fullquery name="lors::imsmd::addLOM.add_new_general">
        <querytext>
            insert into ims_md_general
                (ims_md_id, structure_s, structure_v, agg_level_s, agg_level_v)
            values
                (:p_ims_md_id, :structure_s, :structure_v, :agg_level_s, :agg_level_v)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_general_titles">
        <querytext>
            insert into ims_md_general_title
                (ims_md_ge_ti_id, ims_md_id, title_l, title_s)
            values
                (:p_ims_md_ge_ti_id, :p_ims_md_id, :p_title_l, :p_title_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_general_catalogentries">
        <querytext>
            insert into ims_md_general_cata
                (ims_md_ge_cata_id, ims_md_id, catalog, entry_l, entry_s)
            values
                (:p_ims_md_ge_cata_id, :p_ims_md_id, :p_catalog, :p_entry_l, :p_entry_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_general_language">
        <querytext>
            insert into ims_md_general_lang
                (ims_md_ge_lang_id, ims_md_id, language)
            values
                (:p_ims_md_ge_lang_id, :p_ims_md_id, :language)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_general_description">
        <querytext>
            insert into ims_md_general_desc
                (ims_md_ge_desc_id, ims_md_id, descrip_l, descrip_s)
            values
                (:p_ims_md_ge_desc_id, :p_ims_md_id, :p_descrip_l, :p_descrip_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_general_keyword">
        <querytext>
            insert into ims_md_general_key
                (ims_md_ge_key_id, ims_md_id, keyword_l, keyword_s)
            values
                (:p_ims_md_ge_key_id, :p_ims_md_id, :p_keyword_l, :p_keyword_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_general_coverage">
        <querytext>
            insert into ims_md_general_cover
                (ims_md_ge_cove_id, ims_md_id, cover_l, cover_s)
            values
                (:p_ims_md_ge_cove_id, :p_ims_md_id, :p_cover_l, :p_cover_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_lifecycle">
        <querytext>
            insert into ims_md_life_cycle
                (ims_md_id, version_l, version_s, status_s, status_v)
            values
                (:p_ims_md_id, :version_l, :version_s, :status_s, :status_v)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_lifecycle_contrib">
        <querytext>
            insert into ims_md_life_cycle_contrib
                (ims_md_lf_cont_id, ims_md_id, role_s, role_v,
                cont_date, cont_date_l, cont_date_s)
            values
                (:p_ims_md_lf_cont_id, :p_ims_md_id, :p_role_s, :p_role_v,
                :p_cont_date, :p_cont_date_l, :p_cont_date_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_lifecycle_contrib_entity">
        <querytext>
            insert into ims_md_life_cycle_contrib_entity
                (ims_md_lf_cont_enti_id, ims_md_lf_cont_id, entity)
            values
                (:p_ims_md_lf_cont_enti_id, :p_ims_md_lf_cont_id, :p_entity)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_metadata">
        <querytext>
            insert into ims_md_metadata
                (ims_md_id, language)
            values
                (:p_ims_md_id, :p_language)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_metadata_catalogentries">
        <querytext>
            insert into ims_md_metadata_cata
                (ims_md_md_cata_id, ims_md_id, catalog, entry_l, entry_s)
            values
                (:p_ims_md_md_cata_id, :p_ims_md_id, :p_catalog, :p_entry_l, :p_entry_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_metadata_contrib">
        <querytext>
            insert into ims_md_metadata_contrib
                (ims_md_md_cont_id, ims_md_id, role_s, role_v,
                cont_date, cont_date_l, cont_date_s)
            values
                (:p_ims_md_md_cont_id, :p_ims_md_id, :p_role_s, :p_role_v,
                :p_cont_date, :p_cont_date_l, :p_cont_date_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_metadata_contrib_entity">
        <querytext>
            insert into ims_md_metadata_contrib_entity
                (ims_md_md_cont_enti_id, ims_md_md_cont_id, entity)
            values
                (:p_ims_md_md_cont_enti_id, :p_ims_md_md_cont_id, :p_entity)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_metadata_metadatascheme">
        <querytext>
            insert into ims_md_metadata_scheme
                (ims_md_md_sch_id, ims_md_id, scheme)
            values
                (:p_ims_md_md_sch_id, :p_ims_md_id, :p_scheme)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_technical">
        <querytext>
            insert into ims_md_technical
                (ims_md_id, t_size, instl_rmrks_l, instl_rmrks_s,
                otr_plt_l, otr_plt_s, duration, duration_l, duration_s)
            values
                (:p_ims_md_id, :p_size, :p_instl_rmks_l, :p_instl_rmks_s,:p_otr_plt_l,
                :p_otr_plt_s, :p_duration, :p_duration_l, :p_duration_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_technical_format">
        <querytext>
            insert into ims_md_technical_format
                (ims_md_te_fo_id, ims_md_id, format)
            values
                (:p_ims_md_te_fo_id, :p_ims_md_id, :p_format)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_technical_location">
        <querytext>
            insert into ims_md_technical_location
                (ims_md_te_lo_id, ims_md_id, type, location)
            values
                (:p_ims_md_te_lo_id, :p_ims_md_id, :p_type, :p_location)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_technical_requirement">
        <querytext>
            insert into ims_md_technical_requirement
                (ims_md_te_rq_id, ims_md_id, type_s, type_v,
                name_s, name_v, min_version, max_version)
            values
                (:p_ims_md_te_rq_id, :p_ims_md_id, :p_type_s, :p_type_v,
                :p_name_s, :p_name_v, :p_min_version, :p_max_version)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_educational">
        <querytext>
            insert into ims_md_educational
                (ims_md_id, int_type_s, int_type_v, int_level_s,
                int_level_v, sem_density_s, sem_density_v, difficulty_s,
                difficulty_v, type_lrn_time, type_lrn_time_l, type_lrn_time_s)
            values
                (:p_ims_md_id, :p_int_type_s, :p_int_type_v, :p_int_level_s,
                :p_int_level_v, :p_sem_density_s, :p_sem_density_v, :p_difficulty_s,
                :p_difficulty_v, :p_type_lrn_time, :p_type_lrn_time_l, :p_type_lrn_time_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_descriptions">
        <querytext>
            insert into ims_md_educational_descrip
                (ims_md_ed_de_id, ims_md_id, descrip_l, descrip_s)
            values
                (:p_ims_md_ed_de_id, :p_ims_md_id, :p_descrip_l, :p_descrip_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_learningresourcetypes">
        <querytext>
            insert into ims_md_educational_lrt
                (ims_md_ed_lr_id, ims_md_id, lrt_s, lrt_v)
            values
                (:p_ims_md_ed_lr_id, :p_ims_md_id, :p_lrt_s, :p_lrt_v)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_intendedenduserroles">
        <querytext>
            insert into ims_md_educational_ieur
                (ims_md_ed_ie_id, ims_md_id, ieur_s, ieur_v)
            values
                (:p_ims_md_ed_ie_id, :p_ims_md_id, :p_ieur_s, :p_ieur_v)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_context">
        <querytext>
            insert into ims_md_educational_context
                (ims_md_ed_co_id, ims_md_id, context_s, context_v)
            values
                (:p_ims_md_ed_co_id, :p_ims_md_id, :p_context_s, :p_context_v)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_typicalagerange">
        <querytext>
            insert into ims_md_educational_tar
                (ims_md_ed_ta_id, ims_md_id, tar_l, tar_s)
            values
                (:p_ims_md_ed_ta_id, :p_ims_md_id, :p_tar_l, :p_tar_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_language">
        <querytext>
            insert into ims_md_educational_lang
                (ims_md_ed_la_id, ims_md_id, language)
            values
                (:p_ims_md_ed_la_id, :p_ims_md_id, :p_language)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_rights">
        <querytext>
            insert into ims_md_rights (ims_md_id, cost_s, cost_v, caor_s, caor_v, descrip_l, descrip_s)
            values (:p_ims_md_id, :p_cost_s, :p_cost_v, :p_caor_s, :p_caor_v, :p_descrip_l, :p_descrip_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_relation">
        <querytext>
            insert into ims_md_relation
                (ims_md_re_id, ims_md_id, kind_s, kind_v)
            values
                (:p_ims_md_re_id, :p_ims_md_id, :p_kind_s, :p_kind_v)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_relation_descrip">
        <querytext>
            insert into ims_md_relation_resource
                (ims_md_re_re_id, ims_md_re_id, identifier, descrip_l, descrip_s)
            values
                (:p_ims_md_re_re_id, :p_ims_md_re_id, null, :p_descrip_l, :p_descrip_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_catalogentry">
        <querytext>
            insert into ims_md_relation_resource_catalog
                (ims_md_re_re_ca_id, ims_md_re_re_id, catalog, entry_l, entry_s)
            values
                (:p_ims_md_re_re_ca_id, :p_ims_md_re_re_id, :p_catalog, :p_entry_l, :p_entry_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_annotation">
        <querytext>
            insert into ims_md_annotation
                (ims_md_an_id, ims_md_id, entity, date, date_l, date_s)
            values
                (:p_ims_md_an_id, :p_ims_md_id, :p_entity, :p_date, :p_date_l, :p_date_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_ann_descriptions">
        <querytext>
            insert into ims_md_annotation_descrip
                (ims_md_an_de_id, ims_md_an_id, descrip_l, descrip_s)
            values
                (:p_ims_md_an_de_id, :p_ims_md_an_id, :p_descrip_l, :p_descrip_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_classification">
        <querytext>
            insert into ims_md_classification
                (ims_md_cl_id, ims_md_id, purpose_s, purpose_v)
            values
                (:p_ims_md_cl_id, :p_ims_md_id, :p_purpose_s, :p_purpose_v)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_description">
        <querytext>
            insert into ims_md_classification_descrip
                (ims_md_cl_de_id, ims_md_cl_id, descrip_l, descrip_s)
            values
                (:p_ims_md_cl_de_id, :p_ims_md_cl_id, :p_descrip_l, :p_descrip_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_taxonpaths">
        <querytext>
            insert into ims_md_classification_taxpath
                (ims_md_cl_ta_id, ims_md_cl_id, source_l, source_v)
            values
                (:p_ims_md_cl_ta_id, :p_ims_md_cl_id, :p_source_l, :p_source_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_taxons">
        <querytext>
            insert into ims_md_classification_taxpath_taxon
                (ims_md_cl_ta_ta_id, ims_md_cl_ta_id, hierarchy,
                identifier, entry_l, entry_s)
            values
                (:p_ims_md_cl_ta_ta_id, :p_ims_md_cl_ta_id, :p_hierarchy,
                :p_identifier, :p_entry_l, :p_entry_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addLOM.add_new_keywords">
        <querytext>
            insert into ims_md_classification_keyword
                (ims_md_cl_ke_id, ims_md_cl_id, keyword_l, keyword_s)
            values
                (:p_ims_md_cl_ke_id, :p_ims_md_cl_id, :p_keyword_l, :p_keyword_s)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::addMDSchemaVersion.add_md">
        <querytext>
            insert into ims_md (ims_md_id, schema, schemaversion)
            values (:p_ims_md_id, :p_schema, :p_schemaversion)
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::delMD.add_md">
        <querytext>
            delete
            from ims_md
            where ims_md_id = :p_ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imsmd::mdExist.check_md_record">
        <querytext>
            select ims_md_id
            from ims_md
            where ims_md_id = :p_ims_md_id
        </querytext>
    </fullquery>

</queryset>
