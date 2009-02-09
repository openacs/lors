<?xml version="1.0"?>
<queryset>

    <fullquery name="get_package">
        <querytext>
            select package_id
            from apm_packages
            where package_key='lorsm'
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="man">
        <querytext>
            select ims_manifest__new (
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
                null) --presentation_format
        </querytext>
    </fullquery>

    <fullquery name="org">
        <querytext>
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
        </querytext>
    </fullquery>

    <fullquery name="res">
        <querytext>
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
        </querytext>
    </fullquery>

    <fullquery name="item">
        <querytext>
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
        </querytext>
    </fullquery>

    <fullquery name="file">
        <querytext>
            select ims_file__new (
                                    :file_id,
                                    :res_id,
                                    '__path_to_filename__',
                                    '__filename__',
                                    false --hasmetadata
                                )
        </querytext>
    </fullquery>

    <fullquery name="i_to_r">
        <querytext>
            insert into ims_cp_items_to_resources (item_id,res_id)
            values (:item_id,:res_id)
        </querytext>
    </fullquery>

    <fullquery name="get_man">
        <querytext>
            select man_id
            from ims_cp_manifests
            where man_id=:man_id
        </querytext>
    </fullquery>

</queryset>
