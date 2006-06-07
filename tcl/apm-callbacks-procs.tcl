ad_library {

    Procedures to upgrade lors
    @autor Miguel Marin (miguelmarin@viaro.net)

}

namespace eval lors::apm_callback {}

ad_proc -public lors::apm_callback::upgrade {
    -from_version_name:required
    -to_version_name:required
} {
    Makes the upgrade of lors-central package
} {
    apm_upgrade_logic \
	-from_version_name $from_version_name \
	-to_version_name $to_version_name \
	-spec {
	    0.6d3 0.6d4 {
		lors::apm_callback::upgrade_code
	    }
	}
}

ad_proc -public lors::apm_callback::upgrade_code { 
} {
    set user_id [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]
    
    # We get all manifest from copy table so we can create a new cr_item and revision for each one of them
    set manifests_list [db_list_of_lists get_all_manifests { select * from ims_cp_manifests_copy }]
    
    foreach man_info $manifests_list {
	set original_man_id [lindex $man_info 0]
	set course_name     [lindex $man_info 1]
	set man_identifier  [lindex $man_info 2]
	set version         [lindex $man_info 3]
	set orgs_default    [lindex $man_info 4]
	set hasmetadata     [lindex $man_info 5]
	set parent_man_id   [lindex $man_info 6]
	set isscorm         [lindex $man_info 7]
	set folder_id       [lindex $man_info 8]
	set fs_package_id   [lindex $man_info 9]
	set isshared        [lindex $man_info 10]
	set package_id      [lindex $man_info 11]
	
	# First we create the folder that will hold all new cr_items
	db_1row get_folder_info {	
	    select 
		name as cr_dir, 
		parent_id 
	    from 
		cr_items 
	    where 
		item_id = :folder_id
	}

	set items_parent_id [lors::cr::add_folder -parent_id $parent_id -folder_name "${cr_dir}_items"]
	
	# Now we have to create a new cr_item and revision for the man_id
	set new_man_item_id [content::item::new \
			    -name $man_identifier \
			    -content_type "ims_manifest_object" \
			    -parent_id $items_parent_id \
			    -creation_date [dt_sysdate] \
			    -creation_user $user_id \
			    -creation_ip $creation_ip \
			    -context_id $package_id]

	set new_man_revision_id [content::revision::new \
				     -item_id $new_man_item_id \
				     -title $man_identifier \
				     -description "Upgraded using lors" \
				     -creation_date [dt_sysdate] \
				     -creation_ip $creation_ip \
				     -creation_user $user_id \
				     -is_live "t"]
		
        # We Update the extra information		     
	db_dml update_new_manifest { 
	    update ims_cp_manifests 
	    set 
	        course_name   = :course_name, 
		identifier    = :man_identifier, 
		version       = :version, 
		orgs_default  = :orgs_default, 
		hasmetadata   = :hasmetadata, 
		parent_man_id = :parent_man_id, 
		isscorm       = :isscorm, 
		folder_id     = :folder_id, 
		fs_package_id = :fs_package_id, 
		isshared      = :isshared
	    where 
	        man_id = :new_man_revision_id
	}

	# We are going to associate the new manifest to classes
	db_dml update_manifest_class { 
	    update ims_cp_manifest_class_copy
	    set 
	        man_id = :new_man_revision_id
	    where
 	        man_id = :original_man_id
	}
	db_dml insert_manifest_class { 
	    insert into ims_cp_manifest_class(
		man_id,
		lorsm_instance_id,
		community_id,
		class_key,
		isenabled,
		istrackable
	    ) select * from ims_cp_manifest_class_copy where man_id = :new_man_revision_id
	}

	# Now we want to do the same thing for resources but we need to keep the references to the original man_id
	set resources_list [db_list_of_lists get_resources { select * from ims_cp_resources_copy where man_id = :original_man_id }]
	foreach res_info $resources_list {
	    set original_res_id  [lindex $res_info 0]
	    set man_id           $new_man_revision_id
	    set res_identifier   [lindex $res_info 2]
	    set type             [lindex $res_info 3]
	    set href             [lindex $res_info 4]
	    set hasmetadata      [lindex $res_info 5]
	    set scorm_type       [lindex $res_info 6]

	    
	    # Now we have to create a new cr_item and revision for the res_id
	    set new_res_item_id [content::item::new \
				     -name $res_identifier \
				     -content_type "ims_resource_object" \
				     -parent_id $items_parent_id \
				     -creation_date [dt_sysdate] \
				     -creation_user $user_id \
				     -creation_ip $creation_ip \
				     -context_id $package_id]
	    
	    set new_res_revision_id [content::revision::new \
					 -item_id $new_res_item_id \
					 -title $res_identifier \
					 -description "Upgraded using lors" \
					 -creation_date [dt_sysdate] \
					 -creation_ip $creation_ip \
					 -creation_user $user_id \
					 -is_live "t"]
	    
	    # We Update the extra information		     
	    db_dml update_new_resource { 
		update ims_cp_resources
		set 
    		    man_id      = :man_id,
		    identifier  = :res_identifier,
		    type        = :type,
	    	    href        = :href,
		    hasmetadata = :hasmetadata,
		    scorm_type  = :scorm_type
		where 
		    res_id = :new_res_revision_id
	    }

	    db_dml update_ims_item_to_resources_copy_res { 
		update ims_cp_items_to_resources_copy
		set 
		    new_res_id = :new_res_revision_id
		where 
		    res_id   = :original_res_id
	    }

	    # Now we need to relate all files that are stored on the db
	    db_dml update_ims_cp_files_copy { 
		update ims_cp_files_copy
		set
		    res_id = :new_res_revision_id
		where
		    res_id = :original_res_id
	    }
	    
	    db_dml insert_ims_cp_files {
		insert into ims_cp_files (
					  file_id,
					  res_id,
					  pathtofile,
					  filename,
					  hasmetadata
		) 
		select 
		   cr.live_revision as file_id,
		   if.res_id, 
		   if.pathtofile, 
		   if.filename, 
		   if.hasmetadata
		from 
		   ims_cp_files_copy if, 
		   cr_items cr 
		where 
		   if.res_id = :new_res_revision_id and
		   if.file_id = cr.item_id
	    }
	    
	# END foreach res_info
	}
	
	# Now we want to do the same thing for organizations but we need to keep the references to the original man_id
	set organizations_list [db_list_of_lists get_organizations { select * from ims_cp_organizations_copy where man_id = :original_man_id }]
	foreach org_info $organizations_list {
	    set original_org_id [lindex $org_info 0]
	    set org_man_id      $new_man_revision_id
	    set org_identifier  [lindex $org_info 2]
	    set structure       [lindex $org_info 3]
	    set org_title       [lindex $org_info 4]
	    set hasmetadata     [lindex $org_info 5]
	    set isshared        [lindex $org_info 6]

	    # Now we have to create a new cr_item and revision for the org_id
	    set new_org_item_id [content::item::new \
				     -name $org_identifier \
				     -content_type "ims_organization_object" \
				     -parent_id $items_parent_id \
				     -creation_date [dt_sysdate] \
				     -creation_user $user_id \
				     -creation_ip $creation_ip \
				     -context_id $package_id]
	    
	    set new_org_revision_id [content::revision::new \
					 -item_id $new_org_item_id \
					 -title $org_identifier \
					 -description "Upgraded using lors" \
					 -creation_date [dt_sysdate] \
					 -creation_ip $creation_ip \
					 -creation_user $user_id \
					 -is_live "t"]
	    
	    # We Update the extra information		     
	    db_dml update_new_organization { 
		update ims_cp_organizations
		set 
		    man_id      = :org_man_id,
		    identifier  = :org_identifier,
		    structure   = :structure,
		    org_title   = :org_title,
		    hasmetadata = :hasmetadata,
		    isshared    = :isshared
		where 
		    org_id = :new_org_revision_id
	    }

	    # Now we process the ims_items   
	    set items_list [db_list_of_lists get_items { select * from ims_cp_items_copy where org_id = :original_org_id }]
	    set sort_order 0
	    foreach item_info $items_list {
		set original_item_id [lindex $item_info 0]
		set org_id           $new_org_revision_id
		set item_identifier  [lindex $item_info 2]
		set identifierref    [lindex $item_info 3]
		set isvisible        [lindex $item_info 4]
		set parameters       [lindex $item_info 5]
		set ims_item_title   [lindex $item_info 6]
		set parent_item      [lindex $item_info 7]
		set hasmetadata      [lindex $item_info 8]
		set prerequisites_t  [lindex $item_info 9]
		set prerequisites_s  [lindex $item_info 10]
		set type             [lindex $item_info 11]
		set maxtimeallowed   [lindex $item_info 12]
		set timelimitaction  [lindex $item_info 13]
		set datafromlms      [lindex $item_info 14]
		set masteryscore     [lindex $item_info 15]
		set isshared         [lindex $item_info 16]
		incr sort_order

		# Now we have to create a new cr_item and revision for the ims_item_id
		set new_ims_item_id [content::item::new \
					 -name $item_identifier \
					 -content_type "ims_item_object" \
					 -parent_id $items_parent_id \
					 -creation_date [dt_sysdate] \
					 -creation_user $user_id \
					 -creation_ip $creation_ip \
					 -context_id $package_id]
		
		set new_ims_revision_id [content::revision::new \
					     -item_id $new_ims_item_id \
					     -title $item_identifier \
					     -description "Upgraded using lors" \
					     -creation_date [dt_sysdate] \
					     -creation_ip $creation_ip \
					     -creation_user $user_id \
					     -is_live "t"]
		
		# We Update the extra information		     
		db_dml update_new_ims_item { 
		    update ims_cp_items
		    set 
		        org_id           = :new_org_revision_id,
		        identifier       = :item_identifier,
		        identifierref    = :identifierref,
		        isvisible        = :isvisible,
		        parameters       = :parameters,
		        ims_item_title   = :ims_item_title,
        	        parent_item      = :parent_item,
		        hasmetadata      = :hasmetadata,
		        prerequisites_t  = :prerequisites_t,
		        prerequisites_s  = :prerequisites_s,
		        type             = :type,
		        maxtimeallowed   = :maxtimeallowed,
		        timelimitaction  = :timelimitaction,
		        datafromlms      = :datafromlms,
		        masteryscore     = :masteryscore,
		        isshared         = :isshared,
		        sort_order       = :sort_order
		    where
		        ims_item_id = :new_ims_revision_id
		}

		db_dml update_ims_item_to_resources_copy { 
		    update ims_cp_items_to_resources_copy
		    set 
		    new_ims_item_id = :new_ims_revision_id
		    where 
		    item_id   = :original_item_id
		}
		
	    # END foreach item_info
	    }
	# END foreach org_info
	}  
    # END foreach man_info
    }

    # Now relate the new ims_item_id to the new res_id
    db_dml update_ims_cp_itr { 
	insert 
	into ims_cp_items_to_resources ( 
					ims_item_id, 
					res_id 
	) select new_ims_item_id as ims_item_id, new_res_id as res_id from ims_cp_items_to_resources_copy
    }
    
    db_dml drop_tables {
 	drop table ims_cp_items_to_resources_copy
    }
    db_dml drop_tables {
	drop table ims_cp_items_copy
    }
    db_dml drop_tables {
	drop table ims_cp_files_copy
    }
    db_dml drop_tables {
	drop table ims_cp_resources_copy
    }
    db_dml drop_tables {
	drop table ims_cp_organizations_copy
    }
    db_dml drop_tables {
 	drop table ims_cp_manifest_class_copy
    }
    db_dml drop_tables {
	drop table ims_cp_manifests_copy
    }
    
# END ad_proc
}