<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="lors::cr::add_folder.folder_create">      
	<querytext>
	begin
	        :1 := lors.new_folder (
			p_name => :name,
			p_folder_name => :folder_name,
			p_parent_id => :parent_id,
			p_creation_user => :user_id,
			p_creation_ip => :creation_ip
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::cr::get_item_id.get_item_id">
	<querytext>
	begin
		:1:= content_item.get_id (
			item_path => :name,
			root_folder_id => :folder_id,
			resolve_index => 'f'
		);			
	end;
	</querytext>
</fullquery>

<fullquery name="lors::cr::add_files.set_file_content">      
	<querytext>
      update cr_revisions
      set filename = :cr_file,
      content_length = :file_size
      where revision_id = :version_id
	</querytext>
</fullquery>

</queryset>