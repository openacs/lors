<?xml version="1.0"?>
<queryset>

    <fullquery name="lors::cr::add_folder.folder_create">
        <querytext>
            select lors__new_folder (:name,
                :folder_name, :parent_id, :user_id, :creation_ip);
        </querytext>
    </fullquery>

    <fullquery name="lors::cr::add_files.update_revi">
        <querytext>
            update cr_revisions set content = '$cr_file',
            content_length = $file_size where revision_id = :version_id
        </querytext>
    </fullquery>

    <fullquery name="lors::cr::get_item_id.get_item_id">
        <querytext>
            select content_item__get_id ( :name, :folder_id, 'f' )
        </querytext>
    </fullquery>

</queryset>
