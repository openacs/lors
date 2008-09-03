<?xml version="1.0"?>

<queryset>
  <fullquery name="lors::imscp::item_get_identifier.get_indentifier">
    <querytext>
      select r.identifier 
      from ims_cp_resources r, ims_cp_items_to_resources i
      where i.ims_item_id = :ims_item_id
      and r.res_id = i.res_id
    </querytext>
  </fullquery>
</queryset>