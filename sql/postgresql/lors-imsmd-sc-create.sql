-- This is LORS IMS Metadata implementation of the FtsContentProvider
-- service contract


-- for manifests metadata

select acs_sc_impl__new(
    'FtsContentProvider',	        -- impl_contract_name
    'ims_manifest',	                -- impl_name
    'lors'			        -- impl_owner_name
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		        -- impl_contract_name
    'ims_manifest',		                -- impl_name
    'datasource',			        -- impl_operation_name
    'lors::imsmd::sc::mdrecord__datasource',	-- impl_alias
    'TCL'				        -- impl_pl
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		    -- impl_contract_name
    'ims_manifest',	                    -- impl_name
    'url',				    -- impl_operation_name
    'lors::imsmd::sc::mdrecord__url',	    -- impl_alias
    'TCL'				    -- impl_pl
);


create function ims_md_record__itrg ()
returns opaque as '
begin
        perform search_observer__enqueue(new.ims_md_id,''INSERT'');
    return null;
end;' language 'plpgsql';

create function ims_md_record__dtrg ()
returns opaque as '
begin
    perform search_observer__enqueue(old.ims_md_id,''DELETE'');
    return old;
end;' language 'plpgsql';

create function ims_md_record__utrg ()
returns opaque as '
begin
        perform search_observer__enqueue(old.ims_md_id,''DELETE'');
        perform search_observer__enqueue(old.ims_md_id,''UPDATE'');
    return old;
end;' language 'plpgsql';


create trigger lors_imsmd__itrg after insert on ims_md
for each row execute procedure ims_md_record__itrg ();

create trigger lors_imsmd__dtrg after delete on ims_md
for each row execute procedure ims_md_record__dtrg ();

create trigger pinds_blog_entries__utrg after update on ims_md
for each row execute procedure ims_md_record__utrg ();

-- Add the binding

select acs_sc_binding__new (
    'FtsContentProvider',
    'ims_manifest'
);


-- for organization's metadata

select acs_sc_impl__new(
    'FtsContentProvider',	        -- impl_contract_name
    'ims_organization',	                -- impl_name
    'lors'			        -- impl_owner_name
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		        -- impl_contract_name
    'ims_organization',		                -- impl_name
    'datasource',			        -- impl_operation_name
    'lors::imsmd::sc::mdrecord__datasource',	-- impl_alias
    'TCL'				        -- impl_pl
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		    -- impl_contract_name
    'ims_organization',		            -- impl_name
    'url',				    -- impl_operation_name
    'lors::imsmd::sc::mdrecord__url',	    -- impl_alias
    'TCL'				    -- impl_pl
);

-- Add the binding

select acs_sc_binding__new (
    'FtsContentProvider',
    'ims_organization'
);


-- for item's metadata

select acs_sc_impl__new(
    'FtsContentProvider',	        -- impl_contract_name
    'ims_item',	                        -- impl_name
    'lors'			        -- impl_owner_name
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		        -- impl_contract_name
    'ims_item',		                        -- impl_name
    'datasource',			        -- impl_operation_name
    'lors::imsmd::sc::mdrecord__datasource',	-- impl_alias
    'TCL'				        -- impl_pl
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		    -- impl_contract_name
    'ims_item',		                    -- impl_name
    'url',				    -- impl_operation_name
    'lors::imsmd::sc::mdrecord__url',	    -- impl_alias
    'TCL'				    -- impl_pl
);

-- Add the binding

select acs_sc_binding__new (
    'FtsContentProvider',
    'ims_item'
);


-- for resource's metadata

select acs_sc_impl__new(
    'FtsContentProvider',	        -- impl_contract_name
    'ims_resource',	                -- impl_name
    'lors'			        -- impl_owner_name
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		        -- impl_contract_name
    'ims_resource',		                -- impl_name
    'datasource',			        -- impl_operation_name
    'lors::imsmd::sc::mdrecord__datasource',	-- impl_alias
    'TCL'				        -- impl_pl
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		    -- impl_contract_name
    'ims_resource',		            -- impl_name
    'url',				    -- impl_operation_name
    'lors::imsmd::sc::mdrecord__url',	    -- impl_alias
    'TCL'				    -- impl_pl
);

-- Add the binding

select acs_sc_binding__new (
    'FtsContentProvider',
    'ims_resource'
);
