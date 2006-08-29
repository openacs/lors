<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="lors::imscp::manifest_new.new_manifest">
	<querytext>
	begin
		:1 := ims_manifest.new (
			course_name => 	:course_name,
			identifier => :identifier,
			version => :version,
			orgs_default => :orgs_default,
			hasmetadata => :hasmetadata,
			parent_man_id => :parent_man_id,
			isscorm => :isscorm,
			folder_id => :content_folder_id,
			fs_package_id => :fs_package_id,
			creation_date => sysdate,
			creation_user => :user_id,
			creation_ip => :creation_ip,
			package_id => :package_id,
			community_id => :community_id,
			class_key => :class_key,
			revision_id => :revision_id,
			isshared => :isshared,
			course_presentation_format => :course_presentation_format
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::organization_add.new_organization">
	<querytext>
	begin
		:1 := ims_organization.new (
			org_id => :org_id,
			man_id => :man_id,
			identifier => :identifier,
			structure => :structure,
			title => :title,
			hasmetadata => :hasmetadata,
			creation_date => sysdate,
			creation_user => :user_id,
			creation_ip => :creation_ip,
			package_id => :package_id,
			revision_id => :revision_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::organization_delete.delete_organization">
	<querytext>
	begin
		:1 := ims_organization.delete (
			org_id => :org_id
		);		
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_add.new_item">
	<querytext>
	begin
		:1 := ims_item.new (
			ims_item_id => :item_id,
			org_id => :org_id,
			identifier => :identifier,
			identifierref => :identifierref,
			isvisible => :isvisible,
			parameters => :parameters,
			item_title => :title,
			parent_item => :parent_item,
			hasmetadata => :hasmetadata,
			prerequisites_t => :prerequisites_t,
			prerequisites_s => :prerequisites_s,
			type => :type,
			maxtimeallowed => :maxtimeallowed,
			timelimitaction => :timelimitaction,
			datafromlms => :datafromlms,
			masteryscore => :masteryscore,
			creation_date => sysdate,
			creation_user => :user_id,
			creation_ip => :creation_ip,
			package_id => :package_id,
			revision_id => :revision_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_delete.delete_item">
	<querytext>
	begin
		:1 := function delete (
			ims_item_id => :item_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::resource_add.new_resource">
	<querytext>
	begin
		:1 := ims_resource.new (
			res_id => :res_id,
			man_id => :man_id,
			identifier => :identifier,
			type => :type,
			href => :href,
			scorm_type => :scorm_type,
			hasmetadata => :hasmetadata,
			creation_date => sysdate,
			creation_user =>:user_id,  
			creation_ip => :creation_ip,
			package_id => :package_id,
			revision_id => :revision_id 
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::resource_delete.delete_resource">
	<querytext>
	begin
		:1 := ims_resource.delete (
			res_id => :res_id
		);
	end;	
	</querytext>
</fullquery>

<fullquery name="lors::imscp::item_to_resource_add.item_to_resources_add">
	<querytext>
	begin
		:1 := ims_cp_item_to_resource.new (
			ims_item_id => :item_id,
			res_id => :res_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::dependency_add.dependency_add">
	<querytext>
	begin
		:1 := ims_dependency.new (
			dep_id => :dep_id,
			res_id => :res_id,
			identifierref => :identifierref
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::dependency_delete.delete_resource">
	<querytext>
	begin
		:1 := ims_dependency.delete (
			dep_id => :dep_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::imscp::file_add.file_add">
	<querytext>
	begin
		:1 := ims_file.add (
			file_id => :file_id,
			res_id => :res_id,
			pathtofile => :pathtofile,
			filename => :filename,
			hasmetadata => :hasmetadata
		);
	end;
	</querytext>
</fullquery>

</queryset>
