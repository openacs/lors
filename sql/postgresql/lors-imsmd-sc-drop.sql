-- This is LORS IMS Metadata implementation of the FtsContentProvider
-- service contract


-- for manifests metadata
select acs_sc_impl__delete (
	'FtsContentProvider',		-- impl_contract_name
	'ims_manifest'			-- impl_name
);

select acs_sc_impl_alias__delete (
              'FtsContentProvider',	-- impl_contract_name	
              'ims_manifest',		-- impl_name
              'datasource'		-- impl_operation_name
);

select acs_sc_impl_alias__delete (
              'FtsContentProvider',	-- impl_contract_name	
              'ims_manifest',		-- impl_name
              'url'			-- impl_operation_name
);


DROP function ims_md_record__itrg () CASCADE;
DROP function ims_md_record__dtrg () CASCADE;
DROP function ims_md_record__utrg () CASCADE;
-- DROP trigger lors_imsmd__itrg on ims_md;
-- DROP trigger lors_imsmd__dtrg on ims_md;
-- DROP trigger pinds_blog_entries__utrg on ims_md;

-- Remove the binding
select acs_sc_binding__delete (
                    'FtsContentProvider',
                    'ims_manifest'
);

-- for organization's metadata
select acs_sc_impl__delete (
	'FtsContentProvider',		-- impl_contract_name
	'ims_organization'		-- impl_name
);

select acs_sc_impl_alias__delete (
              'FtsContentProvider',	-- impl_contract_name	
              'ims_organization',	-- impl_name
              'datasource'		-- impl_operation_name
);

select acs_sc_impl_alias__delete (
              'FtsContentProvider',	-- impl_contract_name	
              'ims_organization',	-- impl_name
              'url'			-- impl_operation_name
);


-- Remove the binding

select acs_sc_binding__delete (
    'FtsContentProvider',
    'ims_organization'
);


-- for item's metadata
select acs_sc_impl__delete (
	'FtsContentProvider',		-- impl_contract_name
	'ims_item'			-- impl_name
);

select acs_sc_impl_alias__delete (
              'FtsContentProvider',	-- impl_contract_name	
              'ims_item',		-- impl_name
              'datasource'		-- impl_operation_name
);

select acs_sc_impl_alias__delete (
              'FtsContentProvider',	-- impl_contract_name	
              'ims_item',		-- impl_name
              'url'			-- impl_operation_name
);


-- Remove the binding

select acs_sc_binding__delete (
    'FtsContentProvider',
    'ims_item'
);


-- for resource's metadata
select acs_sc_impl__delete (
	'FtsContentProvider',		-- impl_contract_name
	'ims_resource'			-- impl_name
);

select acs_sc_impl_alias__delete (
              'FtsContentProvider',	-- impl_contract_name	
              'ims_resource',		-- impl_name
              'datasource'		-- impl_operation_name
);

select acs_sc_impl_alias__delete (
              'FtsContentProvider',	-- impl_contract_name	
              'ims_resource',		-- impl_name
              'url'			-- impl_operation_name
);

-- Remove the binding

select acs_sc_binding__delete (
    'FtsContentProvider',
    'ims_resource'
);
