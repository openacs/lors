<?xml version="1.0"?>
<queryset>

    <fullquery name="manifest">
        <querytext>
            select cp.man_id, cp.course_name, cp.identifier,
                text 'Yes' as hello,

                case when hasmetadata = 't' then 'Yes'
                else 'No'
                end as man_metadata,

                case when isscorm = 't' then 'Yes'
                else 'No'
                end as isscorm,
                cp.fs_package_id,

                case when fs_package_id is null then 'f'
                else 't'
                end as lorsm_p,

                cp.folder_id, cp.isshared, acs.creation_user, acs.creation_date,
                acs.context_id, cpmc.isenabled, pf.format_pretty_name, cpmc.istrackable
            from ims_cp_manifests cp, acs_objects acs, ims_cp_manifest_class cpmc,
                lorsm_course_presentation_formats pf
            where cp.man_id = acs.object_id
                and cp.man_id = :man_id
                and cp.man_id = cpmc.man_id
                and cpmc.lorsm_instance_id = :package_id
                and cp.parent_man_id = 0
                and cp.course_presentation_format = pf.format_id
        </querytext>
    </fullquery>

    <fullquery name="get_versions">
        <querytext>
            select count(revision_id)
            from cr_revisions
            where item_id = ( select item_id
                                from cr_revisions
                                where revision_id = :man_id )
      </querytext>
    </fullquery>

    <fullquery name="get_folder_id">
        <querytext>
            select item_id
            from cr_items
            where name = :instance
                and parent_id = :root_folder
        </querytext>
    </fullquery>

    <fullquery name="submans">
        <querytext>
            select count(*) as submanifests
            from ims_cp_manifests
            where man_id = :man_id
                and parent_man_id = :man_id
        </querytext>
    </fullquery>


    <fullquery name="organizations">
        <querytext>
            select org.org_id,
                org.org_title as org_title,
                org.hasmetadata,
                tree_level(o.tree_sortkey) as indent
            from ims_cp_organizations org, acs_objects o
            where org.org_id = o.object_id
                and man_id = :man_id
            order by org_id
        </querytext>
    </fullquery>

    <fullquery name="get_items">
        <querytext>
            select '' as delete,
                '' as up,
                '' as down,
                o.object_id,
                repeat('&nbsp;', (tree_level(o.tree_sortkey) - :indent)* 3) as indent,
                i.ims_item_id as item_id,
                i.item_title as item_title,
                i.hasmetadata, i.org_id,

                case when i.isshared = 'f' then ('false')
                else 'true'
                end as isshared,

                r.href,
                r.identifier as res_identifier,

                case when i.identifierref <> '' then r.href
                else ''
                end as identifierref,

                case when i.identifierref <> ''
                then r.type else ''
                end as type,

                m.fs_package_id, m.folder_id, m.course_name
            from acs_objects o, ims_cp_items i, ims_cp_manifests m,
                ims_cp_items_to_resources i2r,
                ims_cp_resources r left join acs_object_types ot on r.type=ot.object_type
            where o.object_type = 'ims_item_object'
                and i.org_id = :org_id
                and o.object_id = i.ims_item_id
                and r.res_id=i2r.res_id
                and i2r.ims_item_id=i.ims_item_id
                and i.ims_item_id = ( select live_revision
                                        from cr_items
                                        where item_id = ( select item_id
                                                            from cr_revisions
                                                            where revision_id = i.ims_item_id ) )
                and m.man_id = :man_id
            $exclude_where
            order by i.sort_order,o.tree_sortkey,o.object_id
        </querytext>
    </fullquery>

    <fullquery name="items_count">
        <querytext>
            select count(*)
            from ims_cp_items i
            where org_id=:org_id $exclude_where
        </querytext>
    </fullquery>

    <fullquery name="select_folder_key">
        <querytext>
            select key
            from fs_folders
            where folder_id = :folder_id
        </querytext>
    </fullquery>

</queryset>
