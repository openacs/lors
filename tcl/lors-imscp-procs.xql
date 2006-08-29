<?xml version="1.0"?>

<queryset>

<fullquery name="lors::imscp::manifest_add.get_isshared">
      <querytext>
	select im.isshared 
	from ims_cp_manifests im 
	where im.man_id = (select live_revision from cr_items where item_id = :version_id)
      </querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.get_files">
	<querytext>
	select item_id 
	from cr_revisions cr, ims_cp_files f, ims_cp_resources r 
	where f.res_id=r.res_id and r.man_id=:man_id and cr.revision_id=f.file_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.get_items">
	<querytext>
o	select cr.item_id 
	from cr_revisions cr, ims_cp_items i, ims_cp_items_to_resources ir, ims_cp_resources r 
	where r.man_id=:man_id
	and r.res_id=ir.res_id
	and i.ims_item_id=ir.ims_item_id
	and cr.revision_id=i.ims_item_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.delete_map">
	<querytext>
	delete from ims_cp_items_map 
	where ims_item_id in (select revision_id from cr_revisions where item_id=:item_id)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.get_res">
	<querytext>
	select item_id 
	from cr_revisions, ims_cp_resources
	where revision_id=res_id and man_id=:man_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.delete_cmi">
	<querytext>
	delete from lorsm_cmi_core 
	where man_id=:man_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.delete_track">
	<querytext>
	delete from lorsm_student_track 
	where course_id = :man_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.get_org">
	<querytext>
	select item_id 
	from cr_revisions, ims_cp_organizations 
	where revision_id=org_id and man_id=:man_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.delete_map_org_item_id">
	<querytext>
	delete from ims_cp_items_map 
	where org_id in (select revision_id from cr_revisions where item_id=:org_item_id)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::manifest_delete.delete_manifest_class">
	<querytext>
	delete from ims_cp_manifest_class where man_id=:man_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::file_add.file_ex">
	<querytext>
	select file_id 
	from ims_cp_files 
	where file_id = :file_id and res_id = :res_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_add_from_object.get_object">
	<querytext>
	select object_type, title 
	from acs_objects 
	where object_id=:object_id
	</querytext>
</fullquery>

<fullquery name="lors::imscp::resource_add_from_object.get_object">
	<querytext>
	select object_type, title 
	from acs_objects 
	where object_id=:object_id
	</querytext>
</fullquery>
</queryset>