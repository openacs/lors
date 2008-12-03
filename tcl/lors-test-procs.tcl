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
                [db_exec_plsql man {}]

            # create organization
            set org_id [db_exec_plsql org {}]

            # create some resources
            set res_id [db_exec_plsql res {}]

            # create some items
            set item_id [db_exec_plsql item {}]

            # create some files
            set file_id \
                [package_exec_plsql \
                     -var_list [list \
                                    [list name "__content_item_name__"] \
                                    [list parent_id $folder_id] \
                                    [list content_type "file_storage_object"] \
                                    [list title "__title__"]] \
                    content_item new]

            db_exec_plsql file {}

            # create item_to_resource mapping
            db_dml i_to_r {}

            # create student_tracking

            # create cmi_core (whatever that is)

            # create some metadata

            # try to delete the whole couse
            lors::imscp::manifest_delete -man_id $man_id -delete_all t
        }
    aa_false "Manifest $man_id deleted" [db_0or1row get_man {}]
}
