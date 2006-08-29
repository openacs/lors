<?xml version="1.0"?>

<queryset>

<fullquery name="lors::imsmd::sc::mdrecord__datasource.title">
	<querytext>
	select title_l, title_s 
	from ims_md_general_title 
	where ims_md_id = :ims_md_id
      </querytext>
</fullquery>

<fullquery name="lors::imsmd::sc::mdrecord__datasource.description">
	<querytext>
	select descrip_l, descrip_s 
	from ims_md_general_desc 
	where ims_md_id = :ims_md_id
      </querytext>
</fullquery>

<fullquery name="lors::imsmd::sc::mdrecord__datasource.keyword">
	<querytext>
	select keyword_l, keyword_s 
	from ims_md_general_key 
	where ims_md_id = :ims_md_id
      </querytext>
</fullquery>

</queryset>