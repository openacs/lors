# 

ad_library {
    
    Test lorsm-manifest procs
    
    @author devopenacs5 (devopenacs5@www)
    @creation-date 2005-08-20
    @arch-tag: /usr/local/bin/bash: line 1: uuidgen: command not found
    @cvs-id $Id$
}

aa_register_case lors_manifest {
    lors ims manifest test
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            # get folder_id (where?)
            set folder_id [content::folder::new -name "__lors_test__"]
            content::folder::register_content_type \
                -folder_id $folder_id \
                -content_type content_revision \
                -include_subtypes t

            # get fs_package_id (where?)
            set fs_package_id ""
            # get package_id
            set __package_id [db_string get_package {}]
            # get community_id
           
            # create a new manifest
            set man_id \
                [db_exec_plsql man {
                    select ims_manifest__new(
                                      null,
                                      '__test_course__',
                                      '__identifier__',
                                      '__version__',
                                      '__orgs_default__',
                                      false,
                                      null,
                                      false, -- is scorm, test true?
                                      :folder_id,
                                      :fs_package_id,
                                      now(),
                                      null,
                                      null,
                                      :__package_id,
                                      null, --community_id
                                      null, --class_key
                                      null) --presentation_format
                }]

            # create organization
            set org_id \
                [db_exec_plsql org {
                    select ims_organization__new (
                                           null, -- org_id,
                                           :man_id,
                                           '__identifier__',
                                           '__structure__',
                                           '__title__',
                                           false, -- hasmetadata,
                                           now(),
                                           null,
                                           null,
                                           :__package_id
                                           )
                }]
            
            # create some resources
            set res_id \
                [db_exec_plsql res {
                    select ims_resource__new (
                                       null,
                                       :man_id,
                                       '__indentifier__',
                                       '__type__',
                                       '__href__',
                                       '__scorm_type__',
                                       false, --hasmetadata
                                       now(),
                                       null,
                                       null,
                                       :__package_id
                                       )
                }]
            
            # create some items
            set item_id \
                [db_exec_plsql item {
                    select ims_item__new (
                                    null,
                                    :org_id,
                                    '__identifier__',
                                    '__identifier_href__',
                                    true,
                                    '__parameters__',
                                    '__title__',
                                    null, --parent_item
                                    false, --hasmetadata
                                    '__prereq_t__',
                                    '__prereq_s__',
                                    '__type__',
                                    '__maxtimeallowed__',
                                    '__timelimitaction__',
                                    '__datafromlms__',
                                    '__masteryscore__',
                                    now(),
                                    null,
                                    null,
                                    :__package_id
                                    )
                }]
            # create some files
            set file_id \
                [package_exec_plsql \
                     -var_list [list \
                                    [list name "__content_item_name__"] \
                                    [list parent_id $folder_id] \
                                    [list content_type "file_storage_object"] \
                                    [list title "__title__"]] \
                    content_item new]

            db_exec_plsql file {
                select ims_file__new (
                                      :file_id,
                                      :res_id,
                                      '__path_to_filename__',
                                      '__filename__',
                                      false --hasmetadata
                                      )
            }

            # create item_to_resource mapping
            db_dml i_to_r "insert into ims_cp_items_to_resources
        (item_id,res_id) values (:item_id,:res_id)"

            # create student_tracking
            
            # create cmi_core (whatever that is)
            
            # create some metadata

            # try to delete the whole couse
            lors::imscp::manifest_delete -man_id $man_id -delete_all t
        }
    aa_false "Manifest $man_id deleted" [db_0or1row get_man "select man_id from ims_cp_manifests where man_id=:man_id"]
}