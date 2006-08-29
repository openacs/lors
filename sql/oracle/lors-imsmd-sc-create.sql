-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 08/08/2006
-- @cvs-id $Id$

-- This is LORS IMS Metadata implementation of the FtsContentProvider
-- service contract


-- for manifests metadata
declare 
	v_impl_id acs_sc_impls.impl_id%TYPE;
	v_impl_alias_id acs_sc_impl_aliases.impl_id%TYPE;
begin

v_impl_id := acs_sc_impl.new(
	impl_contract_name =>  'FtsContentProvider',
	impl_name => 'ims_manifest',
	impl_owner_name => 'lors'    
);

v_impl_alias_id := acs_sc_impl_alias.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_manifest',
	impl_operation_name => 'datasource',
	impl_alias => 'lors::imsmd::sc::mdrecord__datasource',
	impl_pl => 'TCL'
);

v_impl_alias_id := acs_sc_impl_alias.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_manifest',
	impl_operation_name => 'url',
	impl_alias => 'lors::imsmd::sc::mdrecord__url',
	impl_pl => 'TCL'
);

end;
/

--CREATE TRIGGERS TO IMS_MD TABLE

create or replace trigger lors_imsmd__itrg after insert on ims_md
for each row 
begin
	search_observer.enqueue(:new.ims_md_id,'INSERT');
end;
/

create or replace trigger lors_imsmd__dtrg after delete on ims_md
for each row
begin
	search_observer.enqueue(:old.ims_md_id,'DELETE');
end;
/

create or replace trigger pinds_blog_entries__utrg after update on ims_md
for each row
begin
	search_observer.enqueue(:old.ims_md_id,'DELETE');
	search_observer.enqueue(:old.ims_md_id,'UPDATE');
end;
/

declare 
	v_impl_id acs_sc_impls.impl_id%TYPE;
	v_impl_alias_id acs_sc_impl_aliases.impl_id%TYPE;
begin

-- Add the binding

acs_sc_binding.new (
	contract_name => 'FtsContentProvider',
	impl_name => 'ims_manifest'
);


-- for organization's metadata
v_impl_id := acs_sc_impl.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_organization',
	impl_owner_name => 'lors'
);

v_impl_alias_id := acs_sc_impl_alias.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_organization',
	impl_operation_name => 'datasource',
	impl_alias => 'lors::imsmd::sc::mdrecord__datasource',
	impl_pl => 'TCL'
);

v_impl_alias_id := acs_sc_impl_alias.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_organization',
	impl_operation_name => 'url',
	impl_alias => 'lors::imsmd::sc::mdrecord__url',
	impl_pl => 'TCL'
);

-- Add the binding

acs_sc_binding.new (
	contract_name => 'FtsContentProvider',
	impl_name => 'ims_organization'
);


-- for item's metadata

v_impl_id := acs_sc_impl.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_item',
	impl_owner_name => 'lors'
);

v_impl_alias_id := acs_sc_impl_alias.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_item',
	impl_operation_name => 'datasource',
	impl_alias => 'lors::imsmd::sc::mdrecord__datasource',
	impl_pl => 'TCL'
);

v_impl_alias_id := acs_sc_impl_alias.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_item',
	impl_operation_name => 'url',
	impl_alias => 'lors::imsmd::sc::mdrecord__url',
	impl_pl => 'TCL'
);

-- Add the binding

acs_sc_binding.new (
	contract_name => 'FtsContentProvider',
	impl_name => 'ims_item'
);


-- for resource's metadata

v_impl_id := acs_sc_impl.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_resource',
	impl_owner_name => 'lors'
);

v_impl_alias_id := acs_sc_impl_alias.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_resource',
	impl_operation_name => 'datasource',
	impl_alias => 'lors::imsmd::sc::mdrecord__datasource',
	impl_pl => 'TCL'
);

v_impl_alias_id := acs_sc_impl_alias.new(
	impl_contract_name => 'FtsContentProvider',
	impl_name => 'ims_resource',
	impl_operation_name => 'url',
	impl_alias => 'lors::imsmd::sc::mdrecord__url',
	impl_pl => 'TCL'
);

-- Add the binding

acs_sc_binding.new (
	contract_name => 'FtsContentProvider',
	impl_name => 'ims_resource'
);

end;
/
