<?xml version="1.0"?>

<queryset>

<fullquery name="_lors__lors_manifest.get_man_id">
      <querytext>
	select man_id 
	from ims_cp_manifests
	where course_name='__test_course__'
      </querytext>
</fullquery>

<fullquery name="_lors__lors_manifest.get_folder_id">
	<querytext>
	select folder_id 
	from cr_folders 
	where label='__lors_test__'
	</querytext>
</fullquery>

<fullquery name="_lors__lors_manifest.i_to_r">
      <querytext>
	insert into ims_cp_items_to_resources (ims_item_id,res_id) 
	values 
	(:item_id,:res_id)"
      </querytext>
</fullquery>

<fullquery name="_lors__lors_manifest.get_man">
      <querytext>
	select man_id 
	from ims_cp_manifests 
	where man_id=:man_id
      </querytext>
</fullquery>

<fullquery name="_lors__lors_scorm_1_2.q">
      <querytext>
	select parent_id
	from cr_items 
	where item_id=:folder_id
      </querytext>
</fullquery>

<fullquery name="_lors__lors_scorm_1_2.get_contents">
      <querytext>
	select name 
	from cr_items 
	where parent_id=:folder_id
      </querytext>
</fullquery>

</queryset>