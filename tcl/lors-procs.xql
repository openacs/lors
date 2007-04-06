<? xml version="1.0" ?>

<queryset>

<fullquery name="lors::items_select_options.get_items">
    <querytext>
        SELECT
                i.item_title as item_title,
		i.ims_item_id as item_id
        FROM 
		acs_objects o, ims_cp_items i, ims_cp_manifests m,
                ims_cp_organizations io,
		ims_cp_items_to_resources i2r,ims_cp_resources r left
		join acs_object_types ot on r.type=ot.object_type
	WHERE 
		o.object_type = 'ims_item_object'
           AND
		i.org_id = io.org_id
           AND  io.man_id = m.man_id
	   AND
		o.object_id = i.ims_item_id
           AND  r.res_id=i2r.res_id
           AND  i2r.ims_item_id=i.ims_item_id
           AND
                i.ims_item_id = (
                                select
                                        live_revision
                                from
                                        cr_items
                                where
                                        item_id = (
                                                  select
                                                         item_id
                                                  from
                                                         cr_revisions
                                                  where
                                                         revision_id = i.ims_item_id
                                                  )
                               )
           AND
                m.man_id = :man_id
        ORDER BY 
                 i.sort_order,o.tree_sortkey,o.object_id

    </querytext>
</fullquery>

</queryset>