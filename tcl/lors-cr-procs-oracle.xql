<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="views::record_view.record_view">      
	<querytext>
	begin
	        :1 := lors.new_folder (
			name => :name,
			folder_name => :folder_name,
			parent_id => :parent_id,
			user_id => :user_id,
			creation_ip => :creation_ip
		);
	end;
	</querytext>
</fullquery>

<fullquery name="lors::cr::get_item_id.get_item_id">
	<querytext>
	begin
		:1:= content_item.get_id (
			name => :name,
			root_folder_id => :folder_id,
			resolve_index => 'f'
		);			
	end;
	</querytext>
</fullquery>

</queryset>