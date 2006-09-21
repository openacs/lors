<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="_lors__lors_manifest.get_package">
	<querytext>
	select package_id
	from apm_packages
	where package_key='lorsm' limit 1
	</querytext>
</fullquery>

<fullquery name="_lors__lors_manifest.get_community_id">      
	<querytext>
	select community_id 
	from dotlrn_communities_all limit 1
	</querytext>
</fullquery>

<fullquery name="_lors__lors_manifest.file">      
	<querytext>
	select ims_file__new (
			:file_rev_id,
			:res_id,
			'__path_to_filename__',
			'__filename__',
			false --hasmetadata
	)
	</querytext>
</fullquery>

<fullquery name="_lors__lors_scorm_1_2.q2">      
	<querytext>
	select content_item__get_root_folder(
			:folder_id
	)
	</querytext>
</fullquery>

<fullquery name="_lors__lors_scorm_1_2.get_format_id">      
	<querytext>
	select format_id 
	from lorsm_course_presentation_fmts limit 1
	</querytext>
</fullquery>

<fullquery name="_lors__lors_scorm_1_2.get_community_id">      
	<querytext>
	select community_id 
	from dotlrn_communities_all limit 1
	</querytext>
</fullquery>


</queryset>