ad_library {
    IMS Content Packaging functions

    @creation-date 2003-10-13
    @author Ernie Ghiglione (ErnieG@mm.st)
    @cvs-id $Id$

}

#
#  Copyright (C) 2004 Ernie Ghiglione
#
#  This package is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  It is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

namespace eval lors::imscp {}

## begin IMS CP XML extraction and processing

 # IMS CP XML extraction 

ad_proc -public lors::imscp::getItems {
    {tree} 
    {parent ""}
} {
    Extracts data from Items

    @option tree the XML node that contains the Items to get.
    @option parent parent item node (items can have subitems).
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    # set utf-8 system encoding
    encoding system utf-8

    set items ""
    set itemx [$tree child all item]

    if { ![empty_string_p $itemx] } {
        
        if {[empty_string_p $parent]} {
            set parent 0
        }

        foreach itemx  [$tree child all item] {

            set cc "{$parent}"
            # gets item identifier
            set cc [concat $cc "{[lors::imsmd::getAtt $itemx identifier]}"]

            # gets item identifierref
            set cc [concat $cc "{[lors::imsmd::getAtt $itemx identifierref]}"]

            # gets item isvisible ?
            set cc [concat $cc "{[lors::imsmd::getAtt $itemx isvisible]}"]

            # parameters
            set cc [concat $cc "{[lors::imsmd::getAtt $itemx parameters]}"]
            
            # gets item title
            set title [$itemx child all title]
            if {![empty_string_p $title]} {
                set cc [concat $cc "[lors::imsmd::getElement $title]"]
            } else {
                set cc [concat $cc "{}"]
            }

            # has metadata?
            if {[lors::imsmd::hasMetadata $itemx] == 1} {
                set cc [concat $cc [lors::imsmd::getMDNode $itemx]]
            } else {
                set cc [concat $cc 0]
            }
            #                set cc [concat $cc [lors::imsmd::hasMetadata $itemx]]

            ## SCORM Extensions
            # prerequisites
            set prerequisites [$itemx child all adlcp:prerequisites]
            if {![empty_string_p $prerequisites]} {
                set type [lors::imsmd::getAtt $prerequisites type]
                if {![empty_string_p $type]} {
                    set bb $type
                } else {
                    set bb "{}"
                }
                set cc [concat $cc "{ {$bb} {[lors::imsmd::getElement $prerequisites]}}"]
            } else {
                set cc [concat $cc "{{} {}}"]
            }

            # maxtimeallowed
            set maxtimeallowed [$itemx child all adlcp:maxtimeallowed]
            if {![empty_string_p $maxtimeallowed]} {
                set cc [concat $cc "{[lors::imsmd::getElement $maxtimeallowed]}"]
            } else {
                set cc [concat $cc "{}"]
            }

            # timelimitaction
            set timelimitaction [$itemx child all adlcp:timelimitaction]
            if {![empty_string_p $timelimitaction]} {
                set cc [concat $cc "{[lors::imsmd::getElement $timelimitaction]}"]
            } else {
                set cc [concat $cc "{}"]
            }

            # datafromlms
            set datafromlms [$itemx child all adlcp:datafromlms]
            if {![empty_string_p $datafromlms]} {
                set cc [concat $cc "{[lors::imsmd::getElement $datafromlms]}"]
            } else {
                set cc [concat $cc "{}"]
            }

            # masteryscore
            set masteryscore [$itemx child all adlcp:masteryscore]
            if {![empty_string_p $masteryscore]} {
                set cc [concat $cc "{[lors::imsmd::getElement $masteryscore]}"]
            } else {
                set cc [concat $cc "{}"]
            }

	    ## .LRN extensions
	    # I have added an extensions to IMS items as an attribute
	    # so we can define permission on different ims_items. The
	    # attribute is dotLRN:permission. 
	    # if it doesn't exists it keeps default
	    # permissions. Otherwise it takes the permission as sets
	    # it accordingly 

            # dotLRN:permission
            set dotlrn_permission [lors::imsmd::getAtt $itemx dotLRN:permission]

	    ns_log Notice "lorsm ims_item dotLRN:permission $dotlrn_permission"

            if {![empty_string_p $dotlrn_permission]} {
                set cc [concat $cc "$dotlrn_permission"]
            } else {
                set cc [concat $cc "{}"]
            }

            set itemxx [$itemx child all item]
            if { ![empty_string_p $itemxx] } {
                incr parent
                set cc [concat $cc [list [getItems $itemx $parent]]]
                incr parent -1
            }
            set items [concat $items [list $cc]]
        }
    }
    return $items
}

 # end IMS CP XML extraction 


ad_proc -public lors::imscp::countItems {
    {tree} 
} {
    Counts number of items.
    Returns an integer.

    @option tree the XML node that contains the Items to get.
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    return [llength [$tree getElementsByTagName item]]

}


 # IMS CP database transaction functions
ad_proc -public lors::imscp::manifest_add {
    {-man_id ""}
    {-identifier ""}
    {-course_name ""}
    {-version ""}
    {-orgs_default {}}
    {-hasmetadata ""}
    {-parent_man_id ""}
    {-isscorm ""}
    {-folder_id ""}
    {-fs_package_id ""}
    {-package_id ""}
    {-community_id ""}
    {-user_id ""}
    {-creation_ip ""}

} {
    Inserts a new manifest according to the imsmanifest.xml file.

    @option man_id manifest id to be inserted.
    @option course_name the actual name of the course (or resource).
    @option identifier intrinsic manifest identifier. 
    @option version version.
    @option orgs_default default organizations value.
    @option hasmetadata whether the manifest has metadata (boolean).
    @option parent_man_id parent manifest id (for manifest with submanifests).
    @option isscorm wheather the manifest is SCORM compliant
    @option folder_id the CR folder ID we created to put the manifest on.
    @option fs_package_id file-storage package id.
    @option package_id package_id for the instance of LORSm
    @option community_id Community ID
    @option user_id user that adds the category. [ad_conn user_id] used by default.
    @option creation_ip ip-address of the user that adds the category. [ad_conn peeraddr] used by default.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # set utf-8 system encoding
    encoding system utf-8

   if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    if {[empty_string_p $creation_ip]} {
        set creation_ip [ad_conn peeraddr]
    }
    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }
    if {[empty_string_p $parent_man_id]} {
        set parent_man_id 0
    }
    if {[empty_string_p $isscorm]} {
        set isscorm 0
    }

    set class_key [dotlrn_community::get_community_type_from_community_id $community_id]

    db_transaction {
        set manifest_id [db_exec_plsql new_manifest {
                select ims_manifest__new (
                                    :man_id,
                                    :course_name,
                                    :identifier,
                                    :version,
                                    :orgs_default,
                                    :hasmetadata,
                                    :parent_man_id,
                                    :isscorm,
                                    :folder_id,
                                    :fs_package_id,
                                    current_timestamp,
                                    :user_id,
                                    :creation_ip,
                                    :package_id,
                                    :community_id,
                                    :class_key
                                    );

        }
                        ]

    }
    return $manifest_id
}

ad_proc -public lors::imscp::manifest_delete {
    -man_id:required
} {
    Deletes a  manifest.

    @option man_id manifest id to be inserted.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    db_transaction {
        set ret [db_exec_plsql delete_manifest {
            select ims_manifest__delete (
                                         :man_id
                                         );

        }
                ]
    }
    return $ret
}

ad_proc -public lors::imscp::organization_add {
    {-org_id ""}
    -man_id:required
    {-identifier ""}
    {-structure ""}
    {-title ""}
    {-hasmetadata ""}
    {-package_id ""}
    {-user_id ""}
    {-creation_ip ""}

} {
    Inserts a new organizations according to the imsmanifest.xml file.

    @option org_id organization id to be inserted.
    @option man_id manifest_id the organization belogs to.
    @option identifier intrinsic organization identifier. 
    @option structure organization structure.
    @option title organization title.
    @option hasmetadata whether the organization has metadata (boolean).
    @option package_id Package id.
    @option user_id user that adds the category. [ad_conn user_id] used by default.
    @option creation_ip ip-address of the user that adds the category. [ad_conn peeraddr] used by default.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # set utf-8 system encoding
    encoding system utf-8

   if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    if {[empty_string_p $creation_ip]} {
        set creation_ip [ad_conn peeraddr]
    }
    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }

    db_transaction {
        set organization_id [db_exec_plsql new_organization {
                select ims_organization__new (
                                    :org_id,
                                    :man_id,
                                    :identifier,
                                    :structure,
                                    :title,
                                    :hasmetadata,
                                    current_timestamp,
                                    :user_id,
                                    :creation_ip,
                                    :package_id
                                    );

        }
                        ]

    }
    return $organization_id
}

ad_proc -public lors::imscp::organization_delete {
    -org_id:required
} {
    Deletes a Organization.

    @option org_id organization id to be inserted.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    db_transaction {
        set ret [db_exec_plsql delete_organization {
                select ims_organization__delete (
                                    :org_id
                                    );

        }
                ]

    }
    return $ret
}

ad_proc -public lors::imscp::item_add {
    {-item_id ""}
    -org_id:required
    {-identifier ""}
    {-identifierref ""}
    {-isvisible ""}
    {-parameters ""}
    {-title ""}
    {-parent_item ""}
    {-hasmetadata ""}
    {-prerequisites_t ""}
    {-prerequisites_s ""}
    {-type ""}
    {-maxtimeallowed ""}
    {-timelimitaction ""}
    {-datafromlms ""}
    {-masteryscore ""}
    {-dotlrn_permission ""}
    {-package_id ""}
    {-user_id ""}
    {-creation_ip ""}

} {
    Inserts a new item according to the info retrieved from the imsmanifest.xml file.

    @option item_id item id to be inserted.
    @option org_id organization_id the item belogs to.
    @option identifier intrinsic item identifier. 
    @option identifierref items indentifier reference (use to map with resources)
    @option isvisible is the item visible?.
    @option parameters items parameters
    @option title items title.
    @option parent_item for recursive items. Items can have subitems.
    @option hasmetadata whether the item has metadata (boolean).
    @option prerequisites_t items prerequisites type (SCORM extension).
    @option prerequisites_s items prerequisites string (SCORM extension).
    @option type items type (SCORM extension).
    @option maxtimeallowed items maximum time allowed (SCORM extension).
    @option timelimitaction items time limit action (SCORM extension).
    @option datafromlms items data from LMS (SCORM extension).
    @option masteryscore items mastery score (SCORM extension).
    @option dotlrn_permission dotlrn extension to incoporate permissions.
    @option package_id Package id.
    @option user_id user that adds the category. [ad_conn user_id] used by default.
    @option creation_ip ip-address of the user that adds the category. [ad_conn peeraddr] used by default.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # set utf-8 system encoding
    encoding system utf-8

   if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    if {[empty_string_p $creation_ip]} {
        set creation_ip [ad_conn peeraddr]
    }
    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }
    if {[empty_string_p $isvisible]} {
        set isvisible 1
    }
    if {$parent_item == 0} {
        set parent_item $org_id
    }
    if {[empty_string_p $title]} {
        set title "No Title"
    }

    db_transaction {
        set item_id [db_exec_plsql new_item {
                select ims_item__new (
                                    :item_id,
                                    :org_id,
                                    :identifier,
                                    :identifierref,
                                    :isvisible,
                                    :parameters,
                                    :title,
                                    :parent_item,
                                    :hasmetadata,
                                    :prerequisites_t,
                                    :prerequisites_s,
                                    :type,
                                    :maxtimeallowed,
                                    :timelimitaction,
                                    :datafromlms,
                                    :masteryscore,
                                    current_timestamp,
                                    :user_id,
                                    :creation_ip,
                                    :package_id
                                    );

        }
                        ]

    }

    if {![empty_string_p $dotlrn_permission]} {
	
	permission::toggle_inherit -object_id $item_id


	set community_id [dotlrn_community::get_community_id]

	# Set read permissions for community/class dotlrn_admin_rel

	set party_id_admin [db_string party_id {select segment_id from rel_segments \
						     where group_id = :community_id \
						     and rel_type = 'dotlrn_admin_rel'}]

	permission::grant -party_id $party_id_admin -object_id $item_id -privilege read
	

	# Set read permissions for *all* other professors  within .LRN
	# (so they can see the content)

        set party_id_professor [db_string party_id {select segment_id from rel_segments \
                                                     where rel_type = 'dotlrn_professor_profile_rel'}]

	permission::grant -party_id $party_id_professor -object_id $item_id -privilege read

	# Set read permissions for *all* other admins within .LRN
	# (so they can see the content)

        set party_id_admins [db_string party_id {select segment_id from rel_segments \
                                                     where rel_type = 'dotlrn_admin_profile_rel'}]

	permission::grant -party_id $party_id_admins -object_id $item_id -privilege read

	ns_log Notice "ims_item_id ($item_id)  read permissions granted for community admins"


    }

    return $item_id
}

ad_proc -public lors::imscp::item_delete {
    -item_id:required
} {
    Deletes a Item.

    @option item_id item id to be removed.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    db_transaction {
        set ret [db_exec_plsql delete_item {
                select ims_item__delete (
                                    :item_id
                                    );

        }
                ]

    }
    return $ret
}

ad_proc -public lors::imscp::addItems {
    {-org_id:required}
    {itemlist} 
    {parent ""}
    {tmp_dir ""}
} {
    Bulk addition of items. 
    Returns a list with the item_id and the identifierref of each item.

    @option org_id Organization Id that the item belongs to. 
    @option itemlist list of items to be uploaded
    @option parent parent item node (items can have subitems).
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    # set utf-8 system encoding
    encoding system utf-8

    set retlist ""

    foreach item $itemlist {
        set p_org_id $org_id
        set p_parent_item $parent
        set p_identifier [lindex $item 1]
        set p_identifierref [lindex $item 2]
        set p_isvisible [lindex $item 3]
        set p_parameters [lindex $item 4]
        set p_title [lindex $item 5]
        set p_hasmetadata [lindex $item 6]
        set p_prerequisites [lindex $item 7]
        set p_prerequisites_type [lindex $p_prerequisites 0]
        set p_prerequisites_string [lindex $p_prerequisites 1]
        set p_maxtimeallowed [lindex $item 8]
        set p_timelimitaction [lindex $item 9]
        set p_datafromlms [lindex $item 10]
        set p_masteryscore [lindex $item 11]
	set p_dotlrn_permission [lindex $item 12]

        if {$p_hasmetadata != 0} {
            set md_node $p_hasmetadata
            set p_hasmetadata 1
        }
        
        set item_id [lors::imscp::item_add \
                         -org_id $p_org_id \
                         -parent_item $p_parent_item \
                         -identifier $p_identifier \
                         -identifierref $p_identifierref \
                         -isvisible $p_isvisible \
                         -title $p_title \
                         -hasmetadata $p_hasmetadata \
                         -prerequisites_t $p_prerequisites_type \
                         -prerequisites_s $p_prerequisites_string \
                         -maxtimeallowed $p_maxtimeallowed \
                         -timelimitaction $p_timelimitaction \
                         -datafromlms $p_datafromlms \
                         -masteryscore $p_masteryscore \
			 -dotlrn_permission $p_dotlrn_permission]

        if {$p_hasmetadata == 1} {
            set aa [lors::imsmd::addMetadata \
                        -acs_object $item_id \
                        -node $md_node \
                        -dir $tmp_dir]
        }

        lappend retlist [list $item_id $p_identifierref]

        if { [llength $item] > 13} {
            set subitem [lors::imscp::addItems -org_id $p_org_id [lindex $item 13] $item_id $tmp_dir]
            set retlist [concat $retlist $subitem]
        }
    }
    return $retlist
}


ad_proc -public lors::imscp::resource_add {
    {-res_id ""}
    -man_id:required
    {-identifier ""}
    {-type ""}
    {-href ""}
    {-scorm_type ""}
    {-hasmetadata ""}
    {-package_id ""}
    {-user_id ""}
    {-creation_ip ""}

} {
    Inserts a new resource according to the imsmanifest.xml file.

    @option res_id resource id to be inserted.
    @option man_id manifest the resource belogs to (required).
    @option identifier intrinsic item identifier.
    @option type item type.
    @option href location or references to item location.
    @option scorm_type SCORM item type (SCORM extension).
    @option hasmetadata whether the item has metadata (boolean).
    @option package_id Package id.
    @option user_id user that adds the category. [ad_conn user_id] used by default.
    @option creation_ip ip-address of the user that adds the category. [ad_conn peeraddr] used by default.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # set utf-8 system encoding
    encoding system utf-8

   if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    if {[empty_string_p $creation_ip]} {
        set creation_ip [ad_conn peeraddr]
    }
    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }

    db_transaction {
        set resource_id [db_exec_plsql new_resource {
                select ims_resource__new (
                                    :res_id,
                                    :man_id,
                                    :identifier,
                                    :type,
                                    :href,
                                    :scorm_type,
                                    :hasmetadata,
                                    current_timestamp,
                                    :user_id,
                                    :creation_ip,
                                    :package_id
                                    );

        }
                        ]

    }
    return $resource_id
}

ad_proc -public lors::imscp::resource_delete {
    -res_id:required
} {
    Deletes a Resource.

    @option res_id resource id to be removed.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    db_transaction {
        set ret [db_exec_plsql delete_resource {
                select ims_resource__delete (
                                    :res_id
                                    );

        }
                ]
    }
    return $ret
}

ad_proc -public lors::imscp::item_to_resource_add {
    -item_id:required
    -res_id:required
} {
    Adds a relationship btw items and resources

    @option item_id the item_id to relate to the resource
    @option res_id the resource id
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    db_transaction {
        set item_to_resource [db_exec_plsql item_to_resources_add {
            select  ims_cp_item_to_resource__new (
                                         :item_id,
                                         :res_id
                                         );
        }
                       ]
    }
    return $item_to_resource
}


ad_proc -public lors::imscp::dependency_add {
    -res_id:required
    -identifierref:required
} {
    Adds a resource dependency

    @option res_id the resource id that the dependency belongs to.
    @option identifier dependency identifier.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    db_transaction {
        set dep_id [db_nextval ims_cp_dependencies_seq]
        set dependency [db_exec_plsql dependency_add {
            select  ims_dependency__new (
                                         :dep_id,
                                         :res_id,
                                         :identifierref
                                         );
        }
                       ]
    }
    return $dep_id
}

ad_proc -public lors::imscp::dependency_delete {
    -dep_id:required
} {
    Deletes a dependency

    @option dep_id dependency id to be removed.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    db_transaction {
        set ret [db_exec_plsql delete_resource {
                select ims_dependency__delete (
                                    :dep_id
                                    );

        }
                ]
    }
    return $ret
}


ad_proc -public lors::imscp::file_add {
    -file_id:required
    -res_id:required
    -pathtofile:required
    -filename:required
    {-hasmetadata ""}
} {
    Adds a files to ims_cp_files table (Note: we are not adding files to the respository here).

    @option file_id file_id for file (cr_revision).
    @option res_id the resource id.
    @option pathtofile original path to file as described on the imsmanifest.xml.
    @option filename file name.
    @option hasmetadata file metadata (boolean).
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
   if {[empty_string_p $hasmetadata]} {
        set hasmetadata 0
    }

    # At times, and for some strange reason, Blackboard and Reload
    # incorrectly add repeted <files> under resources. So we need to
    # catch that before we try to insert them again under the same
    # resource

    set file_exists [db_0or1row file_ex "select file_id from ims_cp_files where file_id = :file_id and res_id = :res_id"]

    ns_log Notice "Fernando $file_exists"

    if {$file_exists == 0} {
	db_transaction {
	    set file [db_exec_plsql file_add {
            	select  ims_file__new (
                                         :file_id,
                                         :res_id,
                                         :pathtofile,
                                         :filename,
                                         :hasmetadata
                                         );
	    }
		     ]
	}
    }
    return $file_id
}


 # end IMS CP database transaction functions

## end IMS CP XML extraction and processing


### CP procedures that deal with file processing

ad_proc -public lors::imscp::open {} {

    Installing IMS/SCORM Service Contracts

} {
    return "this thing is open now"

}

ad_proc -public lors::imscp::expand_file {
    upload_file
    tmpfile
    {dest_dir_base "extract"}
} {
    Given an uploaded file in file tmpfile with original name upload_file
    extract the archive and put in a tmp directory which is the return value
    of the function
    
    @param upload_file path to the uploaded file
    @param tmpfile temporary file name
    @option dest_dir_base name of the directory where the files will be extracted to
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    set tmp_dir [file join [file dirname $tmpfile] [ns_mktemp "$dest_dir_base-XXXXXX"]]
    if [catch { ns_mkdir $tmp_dir } errMsg ] {
	ns_log Notice "LORS::imscp::expand_file: Error creating directory $tmp_dir: $errMsg"
	return -code error "LORS::imscp::expand_file: Error creating directory $tmp_dir: $errMsg"
    }

    set upload_file [string trim [string tolower $upload_file]]
    
    if {[regexp {(.tar.gz|.tgz)$} $upload_file]} {
	set type tgz
    } elseif {[regexp {.tar.z$} $upload_file]} {
	set type tgZ
    } elseif {[regexp {.tar$} $upload_file]} {
	set type tar
    } elseif {[regexp {(.tar.bz2|.tbz2)$} $upload_file]} {
	set type tbz2
    } elseif {[regexp {.zip$} $upload_file]} {
	set type zip
    } else {
	set type "Uknown type"
    }
    
    switch $type {
	tar {
	    set errp [ catch { exec tar --directory $tmp_dir -xvf $tmpfile } errMsg]
	}
	tgZ {
	    set errp [ catch { exec tar --directory $tmp_dir -xZvf $tmpfile } errMsg]
	}
	tgz {
	    set errp [ catch { exec tar --directory $tmp_dir -xzvf $tmpfile } errMsg]
	}
	tbz2 {
	    set errp [ catch { exec tar --directory $tmp_dir -xjvf $tmpfile } errMsg]
	}
	zip {
	    set errp [ catch { exec unzip -d $tmp_dir $tmpfile } errMsg]
	}
	default {
	    set errp 1
	    set errMsg "dont know how to extract $upload_file"
	}
    }
    
    if {$errp} {
	file delete -force $tmp_dir
	ns_log Notice "lors::imscp::expand_file: extract type $type failed $errMsg"
	return -code error "lors::imscp::expand_file: extract type $type failed $errMsg"
    }
    return $tmp_dir
}

ad_proc -public lors::imscp::dir_walk {
    dir
} {
    Walk starting at a given directory and return a list
    of all the plain files found

    @param dir Directory to walk thru
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    set files [list]
    foreach f [glob -nocomplain [file join $dir *]] {
	set type [file type $f]
	switch $type {
	    directory {
		set files [concat $files [lors::imscp::dir_walk $f]]
	    }
	    file {
		lappend files $f
	    }
	    default {
		# Goofy file types -- just ignore them
	    }
	}
    }
    return $files
}


ad_proc -public lors::imscp::findmanifest {
    tmp_dir
    file
} {
    Find the manifest file or other file that contains
    the information about the course.
    if it finds it, then it returns the file location. Otherwise it 
    returns 0

    @param tmp_dir Temporary directory where the course is located
    @param file Manifest file
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    if {[file exist $tmp_dir/$file]} {
	return "$tmp_dir/$file"
    } else {
	return 0
    }
}


ad_proc -public lors::imscp::deltmpdir {
    tmp_dir
} {
    Deletes the course from the file system once it has been dealt with

    @option tmp_dir temporary directory to be deleted.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    #Now that we are done working on the upload we delete the tmp directory and files
    if [info exists tmp_dir] {
	ns_log Notice "lors::imscp: Deleting $tmp_dir"
	file delete -force $tmp_dir
    }
}

ad_proc -public lors::imscp::isSCORM {
    -node:required
} {
    Checks it the node past has SCORM Content Packaging extension.

    @option node XML node to analyze.
    @author Ernie Ghiglione (ErnieG@mm.st).
} {
    # Checks the manifest attribute

    set man_attribute [$node hasAttribute xmlns:adlcp]

    #  Checks manifest metadata schema
    set metadata [$node child all metadata]

    if {![empty_string_p $metadata]} {
        set MetadataSchema [lindex [lindex [lors::imsmd::getMDSchema $metadata] 0] 0]
        set man_scorm_metadataschema [regexp -nocase scorm $MetadataSchema]
    } else {
        return 0
    }

    if {$man_attribute == 1 || $man_scorm_metadataschema == 1} {
        # It's a SCORM CP
        return 1
    } else {
        return 0
    }

}
