<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="lors::imscp::manifest_add.new_manifest">
      <querytext>
	select ims_manifest__new (
		:course_name,
		:identifier,
		:version,
		:orgs_default,
		:hasmetadata,
		:parent_man_id,
		:isscorm,
		:content_folder_id,
		:fs_package_id,
		current_timestamp,
		:user_id,
		:creation_ip,
		:package_id,
		:community_id,
		:class_key,
		:revision_id,
		:isshared,
		:course_presentation_format
	)
      </querytext>
</fullquery>

<fullquery name="lors::imscp::organization_add.new_organization">
	<querytext>
	select ims_organization__new (
			:org_id,
			:man_id,
			:identifier,
			:structure,
			:title,
			:hasmetadata,
			current_timestamp,
			:user_id,
			:creation_ip,
			:package_id,
			:revision_id
	)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::organization_delete.delete_organization">
	<querytext>
	select ims_organization__delete (
			:org_id
	)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_add.new_item">
	<querytext>
	select ims_item__new (
			:item_id,
			:org_id,
			:identifier,
			:identifierref,
			:isvisible,
			:parameters,
			:title,
			:parent_item,
			:hasmetadata,
			:prerequisites_t,
			:prerequisites_s,
			:type,
			:maxtimeallowed,
			:timelimitaction,
			:datafromlms,
			:masteryscore,
			current_timestamp,
			:user_id,
			:creation_ip,
			:package_id,
			:revision_id
	)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_delete.delete_item">
	<querytext>
	select ims_item__delete (
			:item_id
	)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::resource_add.new_resource">
	<querytext>
	select ims_resource__new (
			:res_id,
			:man_id,
			:identifier,
			:type,
			:href,
			:scorm_type,
			:hasmetadata,
			current_timestamp,
			:user_id,
			:creation_ip,
			:package_id,
			:revision_id
	)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::resource_delete.delete_resource">
	<querytext>
	select ims_resource__delete (
			:res_id
	)	
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_to_resource_add.item_to_resources_add">
	<querytext>
	select ims_cp_item_to_resource__new (
			:item_id,
			:res_id
	)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::dependency_add.dependency_add">
	<querytext>
	select  ims_dependency__new (
			:dep_id,
			:res_id,
			:identifierref
	)
	</querytext>
</fullquery>

<fullquery name="lors::imscp::dependency_delete.delete_resource">
	<querytext>
	select ims_dependency__delete (
			:dep_id
	)
	</querytext>
</fullquery>


<fullquery name="lors::imscp::file_add.file_add">
	<querytext>
	select  ims_file__new (
			:file_id,
			:res_id,
			:pathtofile,
			:filename,
			:hasmetadata
	)
	</querytext>
</fullquery>

</queryset>
