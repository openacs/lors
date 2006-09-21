<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="_lors__lors_manifest.get_package">
	<querytext>
	select package_id
	from apm_packages
	where package_key='lorsm' and rownum = 1
	</querytext>
</fullquery>

<fullquery name="_lors__lors_manifest.get_community_id">      
	<querytext>
	select community_id 
	from dotlrn_communities_all 
	where rownum = 1
	</querytext>
</fullquery>

<fullquery name="_lors__lors_manifest.file">      
	<querytext>
	begin
		:1 := ims_file.new (
			file_id => :file_rev_id,
			res_id => :res_id,
			pathtofile => '__path_to_filename__',
			filename => '__filename__',
			hasmetadata => 'f'
		);
	end;
	</querytext>
</fullquery>

<fullquery name="_lors__lors_scorm_1_2.q2">      
	<querytext>
	begin
		:1 := content_item.get_root_folder(
			item_id => :folder_id
		);
	end;
	</querytext>
</fullquery>

<fullquery name="_lors__lors_scorm_1_2.get_format_id">      
	<querytext>
	select format_id 
	from lorsm_course_presentation_fmts 
	where rownum = 1
	</querytext>
</fullquery>

<fullquery name="_lors__lors_scorm_1_2.get_community_id">      
	<querytext>
	select community_id 
	from dotlrn_communities_all 
	where rownum = 1
	</querytext>
</fullquery>

</queryset>