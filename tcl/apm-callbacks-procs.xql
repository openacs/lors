<?xml version="1.0"?>
<queryset>

    <fullquery name="lors::apm_callback::upgrade_code.get_all_manifests">
        <querytext>
            select *
            from ims_cp_manifests_copy
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.get_folder_info">
        <querytext>
            select name as cr_dir, parent_id
            from cr_items
            where item_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_new_manifest">
        <querytext>
            update ims_cp_manifests
            set course_name   = :course_name,
                identifier    = :man_identifier,
                version       = :version,
                orgs_default  = :orgs_default,
                hasmetadata   = :hasmetadata,
                parent_man_id = :parent_man_id,
                isscorm       = :isscorm,
                folder_id     = :folder_id,
                fs_package_id = :fs_package_id,
                isshared      = :isshared
            where man_id = :new_man_revision_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_manifest_class">
        <querytext>
            update ims_cp_manifest_class_copy
            set man_id = :new_man_revision_id
            where man_id = :original_man_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.insert_manifest_class">
        <querytext>
            insert into ims_cp_manifest_class
                ( man_id, lorsm_instance_id, community_id, isenabled,istrackable)
                select *
                from ims_cp_manifest_class_copy
                where man_id = :new_man_revision_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.get_resources">
        <querytext>
            select *
            from ims_cp_resources_copy
            where man_id = :original_man_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_new_resource">
        <querytext>
            update ims_cp_resources
            set man_id      = :man_id,
                identifier  = :res_identifier,
                type        = :type,
                href        = :href,
                hasmetadata = :hasmetadata,
                scorm_type  = :scorm_type
            where res_id = :new_res_revision_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_ims_item_to_resources_copy_res">
        <querytext>
            update ims_cp_items_to_resources_copy
            set new_res_id = :new_res_revision_id
            where res_id   = :original_res_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_ims_cp_files_copy">
        <querytext>
            update ims_cp_files_copy
            set res_id = :new_res_revision_id
            where res_id = :original_res_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.insert_ims_cp_files">
        <querytext>
            insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
                select cr.live_revision as file_id, if.res_id,
                    if.pathtofile, if.filename,if.hasmetadata
                from ims_cp_files_copy if, cr_items cr
                where if.res_id = :new_res_revision_id
                    and if.file_id = cr.item_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.get_organizations">
        <querytext>
            select *
            from ims_cp_organizations_copy
            where man_id = :original_man_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_new_organization">
        <querytext>
            update ims_cp_organizations
            set man_id      = :org_man_id,
                identifier  = :org_identifier,
                structure   = :structure,
                org_title   = :org_title,
                hasmetadata = :hasmetadata,
                isshared    = :isshared
            where org_id = :new_org_revision_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.get_items">
        <querytext>
            select *
            from ims_cp_items_copy
            where org_id = :original_org_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_new_ims_item">
        <querytext>
            update ims_cp_items
            set org_id           = :new_org_revision_id,
                identifier       = :item_identifier,
                identifierref    = :identifierref,
                isvisible        = :isvisible,
                parameters       = :parameters,
                ims_item_title   = :ims_item_title,
                parent_item      = :parent_item,
                hasmetadata      = :hasmetadata,
                prerequisites_t  = :prerequisites_t,
                prerequisites_s  = :prerequisites_s,
                type             = :type,
                maxtimeallowed   = :maxtimeallowed,
                timelimitaction  = :timelimitaction,
                datafromlms      = :datafromlms,
                masteryscore     = :masteryscore,
                isshared         = :isshared,
                sort_order       = :sort_order
            where ims_item_id = :new_ims_revision_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_ims_item_to_resources_copy">
        <querytext>
            update ims_cp_items_to_resources_copy
            set new_ims_item_id = :new_ims_revision_id
            where item_id   = :original_item_id
        </querytext>
    </fullquery>

    <fullquery name="lors::apm_callback::upgrade_code.update_ims_cp_itr">
        <querytext>
            insert into ims_cp_items_to_resources (ims_item_id, res_id)
                select new_ims_item_id as ims_item_id, new_res_id as res_id
                from ims_cp_items_to_resources_copy
        </querytext>
    </fullquery>

</queryset>
