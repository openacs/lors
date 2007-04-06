# packages/lors/tcl/lors-procs.tcl

ad_library {
    
    Helper procedures for LORS
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2006-06-06
    @cvs-id $Id$
}

namespace eval lors:: {}

ad_proc -public lors::object_url {
    -object_id
    
    {-url "view"}
} {
     Generate a URL for an acs_object as a learning object
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2006-06-06
    
    @param object_id

    @param url

    @return 
    
    @error 
} {

    #view is easy
    set object_type [acs_object_type $object_id]
    if {$object_type eq "content_item"} {
        set object_type [content::item::content_type -item_id $object_id]
    }
    ns_log notice "lors::object_Url object_id='${object_id}'"
    switch $url {
        admin {
            
            switch $object_type {
                as_sections {
                    # FIXME either 1) make this magically work
                    # or 2) find the assessment_id and use 
                    # page anchor
		    db_1row get_assessment_id "select ci.item_id as assessment_id, sort_order from cr_items ci, cr_revisions cr, as_assessment_section_map m where cr.item_id=:object_id and cr.revision_id=m.section_id and ci.latest_revision=assessment_id"

                    return [export_vars \
                                -base ../../assessment/asm-admin/questions \
                                {assessment_id}]\#${sort_order}
                }
                "::xowiki::Page" {
		    set url [::xowiki::Package get_url_from_id -item_id $object_id]
	            set page [::xowiki::Package instantiate_page_from_id -item_id $object_id]
		    if {[catch {set url [[$page set package_id] make_link -privilege public -url $url $page edit ""]} errmsg]} {
                        set url [$page make_link -privilege public -url $url $page edit ""]
                    }

		    return "${url}&return_url=[ad_urlencode [ad_return_url]]"
                }
            }
                
        }
        default {
            return "/o/${object_id}"
        }

    }
}

ad_proc lors::items_select_options {
    -man_id
} {
    Generate a list of lists of names and ims_item_ids of 
    items in one course

    @param man_id Manifst id for one course
} {
    return [db_list_of_lists get_items ""]
}