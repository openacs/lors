<?xml version="1.0"?>
<queryset>
<fullquery name="lors::cr::add_files.update_revi">      
	<querytext>
		update cr_revisions set content = '$cr_file', content_length = $file_size where revision_id = :version_id
	</querytext>
</fullquery>
