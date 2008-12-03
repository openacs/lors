<? xml version="1.0" ?>

<queryset>

    <fullquery name="lors::object_url.get_assessment_id">
        <querytext>
            select ci.item_id as assessment_id, sort_order
            from cr_items ci, cr_revisions cr, as_assessment_section_map m
            where cr.item_id=:object_id
                and cr.revision_id=m.section_id
                and ci.latest_revision=assessment_id
        </querytext>
    </fullquery>


    <fullquery name="lors::items_select_options.get_items">
        <querytext>
            select i.item_title as item_title,
                i.ims_item_id as item_id
            from acs_objects o, ims_cp_items i, ims_cp_manifests m,
                ims_cp_organizations io,
                ims_cp_items_to_resources i2r,ims_cp_resources r
                left join acs_object_types ot on r.type=ot.object_type
            where o.object_type = 'ims_item_object'
                and i.org_id = io.org_id
                and io.man_id = m.man_id
                and o.object_id = i.ims_item_id
                and r.res_id=i2r.res_id
                and i2r.ims_item_id=i.ims_item_id
                and i.ims_item_id = (select live_revision
                                        from cr_items
                                        where item_id = ( select item_id
                                                            from cr_revisions
                                                            where revision_id = i.ims_item_id ) )
                and m.man_id = :man_id
            order by i.sort_order,o.tree_sortkey,o.object_id
        </querytext>
    </fullquery>

</queryset>
