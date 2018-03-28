ad_library {

    Procedures to upgrade lors
    @author Miguel Marin (miguelmarin@viaro.net)

}

namespace eval lors::apm_callback {}

ad_proc -public lors::apm_callback::upgrade {
    -from_version_name:required
    -to_version_name:required
} {
    Makes the upgrade of lors-central package
} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            0.6d3 0.6d4 {
            lors::apm_callback::upgrade_code
        }
    }
}

ad_proc -public lors::apm_callback::upgrade_code {
} {
    set user_id [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]

    # We get all manifest from copy table so we can create a new cr_item and revision for each one of them
    set manifests_list [db_list_of_lists get_all_manifests {}]

    foreach man_info $manifests_list {
        set original_man_id [lindex $man_info 0]
        set course_name     [lindex $man_info 1]
        set man_identifier  [lindex $man_info 2]
        set version         [lindex $man_info 3]
        set orgs_default    [lindex $man_info 4]
        set hasmetadata     [lindex $man_info 5]
        set parent_man_id   [lindex $man_info 6]
        set isscorm         [lindex $man_info 7]
        set folder_id       [lindex $man_info 8]
        set fs_package_id   [lindex $man_info 9]
        set isshared        [lindex $man_info 10]
        set package_id      [lindex $man_info 11]

        # First we create the folder that will hold all new cr_items
        db_1row get_folder_info {}

        set items_parent_id [lors::cr::add_folder \
                                -parent_id $parent_id \
                                -folder_name "${cr_dir}_items"]

        # Now we have to create a new cr_item and revision for the man_id
        set new_man_item_id [content::item::new \
                                -name $man_identifier \
                                -content_type "ims_manifest_object" \
                                -parent_id $items_parent_id \
                                -creation_date [dt_sysdate] \
                                -creation_user $user_id \
                                -creation_ip $creation_ip \
                                -context_id $package_id]

        set new_man_revision_id [content::revision::new \
                                     -item_id $new_man_item_id \
                                     -title $man_identifier \
                                    -description "Upgraded using lors" \
                                    -creation_date [dt_sysdate] \
                                    -creation_ip $creation_ip \
                                    -creation_user $user_id \
                                    -is_live "t"]

        # We Update the extra information
        db_dml update_new_manifest {}

        # We are going to associate the new manifest to classes
        db_dml update_manifest_class {}

        db_dml insert_manifest_class {}

        # Now we want to do the same thing for resources but we need to keep the references to the original man_id
        set resources_list [db_list_of_lists get_resources {}]
        foreach res_info $resources_list {
            set original_res_id  [lindex $res_info 0]
            set man_id           $new_man_revision_id
            set res_identifier   [lindex $res_info 2]
            set type             [lindex $res_info 3]
            set href             [lindex $res_info 4]
            set hasmetadata      [lindex $res_info 5]
            set scorm_type       [lindex $res_info 6]


            # Now we have to create a new cr_item and revision for the res_id
            set new_res_item_id [content::item::new \
                                     -name $res_identifier \
                                     -content_type "ims_resource_object" \
                                     -parent_id $items_parent_id \
                                     -creation_date [dt_sysdate] \
                                     -creation_user $user_id \
                                     -creation_ip $creation_ip \
                                     -context_id $package_id]

            set new_res_revision_id [content::revision::new \
                                         -item_id $new_res_item_id \
                                         -title $res_identifier \
                                         -description "Upgraded using lors" \
                                         -creation_date [dt_sysdate] \
                                         -creation_ip $creation_ip \
                                         -creation_user $user_id \
                                         -is_live "t"]

            # We Update the extra information
            db_dml update_new_resource {}

            db_dml update_ims_item_to_resources_copy_res {}

            # Now we need to relate all files that are stored on the db
            db_dml update_ims_cp_files_copy {}

            db_dml insert_ims_cp_files {}
        }; # END foreach res_info

        # Now we want to do the same thing for organizations but we need to keep the references to the original man_id
        set organizations_list [db_list_of_lists get_organizations {}]
        foreach org_info $organizations_list {
            set original_org_id [lindex $org_info 0]
            set org_man_id      $new_man_revision_id
            set org_identifier  [lindex $org_info 2]
            set structure       [lindex $org_info 3]
            set org_title       [lindex $org_info 4]
            set hasmetadata     [lindex $org_info 5]
            set isshared        [lindex $org_info 6]

            # Now we have to create a new cr_item and revision for the org_id
            set new_org_item_id [content::item::new \
                                    -name $org_identifier \
                                    -content_type "ims_organization_object" \
                                    -parent_id $items_parent_id \
                                    -creation_date [dt_sysdate] \
                                    -creation_user $user_id \
                                    -creation_ip $creation_ip \
                                    -context_id $package_id]

            set new_org_revision_id [content::revision::new \
                                        -item_id $new_org_item_id \
                                        -title $org_identifier \
                                        -description "Upgraded using lors" \
                                        -creation_date [dt_sysdate] \
                                        -creation_ip $creation_ip \
                                        -creation_user $user_id \
                                        -is_live "t"]

            # We Update the extra information
            db_dml update_new_organization {}

            # Now we process the ims_items
            set items_list [db_list_of_lists get_items {}]
            set sort_order 0
            foreach item_info $items_list {
                set original_item_id [lindex $item_info 0]
                set org_id           $new_org_revision_id
                set item_identifier  [lindex $item_info 2]
                set identifierref    [lindex $item_info 3]
                set isvisible        [lindex $item_info 4]
                set parameters       [lindex $item_info 5]
                set ims_item_title   [lindex $item_info 6]
                set parent_item      [lindex $item_info 7]
                set hasmetadata      [lindex $item_info 8]
                set prerequisites_t  [lindex $item_info 9]
                set prerequisites_s  [lindex $item_info 10]
                set type             [lindex $item_info 11]
                set maxtimeallowed   [lindex $item_info 12]
                set timelimitaction  [lindex $item_info 13]
                set datafromlms      [lindex $item_info 14]
                set masteryscore     [lindex $item_info 15]
                set isshared         [lindex $item_info 16]
                incr sort_order

                # Now we have to create a new cr_item and revision for the ims_item_id
                set new_ims_item_id [content::item::new \
                                        -name $item_identifier \
                                        -content_type "ims_item_object" \
                                        -parent_id $items_parent_id \
                                        -creation_date [dt_sysdate] \
                                        -creation_user $user_id \
                                        -creation_ip $creation_ip \
                                        -context_id $package_id]

                set new_ims_revision_id [content::revision::new \
                                            -item_id $new_ims_item_id \
                                            -title $item_identifier \
                                            -description "Upgraded using lors" \
                                            -creation_date [dt_sysdate] \
                                            -creation_ip $creation_ip \
                                            -creation_user $user_id \
                                            -is_live "t"]

                # We Update the extra information
                db_dml update_new_ims_item {}

                db_dml update_ims_item_to_resources_copy {}
            }; # END foreach item_info
        }; # END foreach org_info
    }; # END foreach man_info

    # Now relate the new ims_item_id to the new res_id
    db_dml update_ims_cp_itr {}

    db_dml drop_tables {drop table ims_cp_items_to_resources_copy}

    db_dml drop_tables {drop table ims_cp_items_copy}

    db_dml drop_tables {drop table ims_cp_files_copy}

    db_dml drop_tables {drop table ims_cp_resources_copy}

    db_dml drop_tables {drop table ims_cp_organizations_copy}

    db_dml drop_tables {drop table ims_cp_manifest_class_copy}

    db_dml drop_tables {drop table ims_cp_manifests_copy}
}
