<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="lors::imscp::manifest_add.new_manifest">
	<querytext>
	begin
		:1 := ims_manifest.new (
			p_course_name => :course_name,
			p_identifier => :identifier,
			p_version => :version,
			p_orgs_default => :orgs_default,
			p_hasmetadata => :hasmetadata,
			p_parent_man_id => :parent_man_id,
			p_isscorm => :isscorm,
			p_folder_id => :content_folder_id,
			p_fs_package_id => :fs_package_id,
			p_creation_date => sysdate,
			p_creation_user => :user_id,
			p_creation_ip => :creation_ip,
			p_package_id => :package_id,
			p_community_id => :community_id,
			p_class_key => :class_key,
			p_revision_id => :revision_id,
			p_isshared => :isshared,
			p_course_presentation_fmt => :course_presentation_format
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::organization_add.new_organization">
	<querytext>
	begin
		:1 := ims_organization.new (
			p_org_id => :org_id,
			p_man_id => :man_id,
			p_identifier => :identifier,
			p_structure => :structure,
			p_title => :title,
			p_hasmetadata => :hasmetadata,
			p_creation_date => sysdate,
			p_creation_user => :user_id,
			p_creation_ip => :creation_ip,
			p_package_id => :package_id,
			p_revision_id => :revision_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::organization_delete.delete_organization">
	<querytext>
	begin
		:1 := ims_organization.delete (
			p_org_id => :org_id
		);		
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_add.new_item">
	<querytext>
	begin
		:1 := ims_item.new (
			p_ims_item_id => :item_id,
			p_org_id => :org_id,
			p_identifier => :identifier,
			p_identifierref => :identifierref,
			p_isvisible => :isvisible,
			p_parameters => :parameters,
			p_item_title => :title,
			p_parent_item => :parent_item,
			p_hasmetadata => :hasmetadata,
			p_prerequisites_t => :prerequisites_t,
			p_prerequisites_s => :prerequisites_s,
			p_type => :type,
			p_maxtimeallowed => :maxtimeallowed,
			p_timelimitaction => :timelimitaction,
			p_datafromlms => :datafromlms,
			p_masteryscore => :masteryscore,
			p_creation_date => sysdate,
			p_creation_user => :user_id,
			p_creation_ip => :creation_ip,
			p_package_id => :package_id,
			p_revision_id => :revision_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_delete.delete_item">
	<querytext>
	begin
		:1 := function delete (
			p_ims_item_id => :item_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::resource_add.new_resource">
	<querytext>
	begin
		:1 := ims_resource.new (
			p_res_id => :res_id,
			p_man_id => :man_id,
			p_identifier => :identifier,
			p_type => :type,
			p_href => :href,
			p_scorm_type => :scorm_type,
			p_hasmetadata => :hasmetadata,
			p_creation_date => sysdate,
			p_creation_user =>:user_id,  
			p_creation_ip => :creation_ip,
			p_package_id => :package_id,
			p_revision_id => :revision_id 
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::resource_delete.delete_resource">
	<querytext>
	begin
		:1 := ims_resource.delete (
			p_res_id => :res_id
		);
	end;	
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_to_resource_add.item_to_resources_add">
	<querytext>
	begin
		:1 := ims_cp_item_to_resource.new (
			p_ims_item_id => :item_id,
			p_res_id => :res_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::dependency_add.dependency_add">
	<querytext>
	begin
		:1 := ims_dependency.new (
			p_dep_id => :dep_id,
			p_res_id => :res_id,
			p_identifierref => :identifierref
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::dependency_delete.delete_resource">
	<querytext>
	begin
		:1 := ims_dependency.delete (
			p_dep_id => :dep_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::file_add.file_add">
	<querytext>
	begin
		:1 := ims_file.new (
			p_file_id => :file_id,
			p_res_id => :res_id,
			p_pathtofile => :pathtofile,
			p_filename => :filename,
			p_hasmetadata => :hasmetadata
		);
	end;
	</querytext>
</fullquery>

</queryset>
