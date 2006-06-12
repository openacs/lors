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
    switch $url {
        admin {
            
            switch $object_type {
                as_sections {
                    # FIXME either 1) make this magically work
                    # or 2) find the assessment_id and use 
                    # page anchor
		    set assessment_id [db_string get_assessment_id "select ci.item_id, m.assessment_id from cr_items ci, cr_revisions cr, as_assessment_section_map m where cr.item_id=:object_id and cr.revision_id=m.section_id and ci.latest_revision=assessment_id"]
                    return [export_vars \
                                -base ../assessment/asm-admin/one-a \
                                {assessment_id}]
                }
                "::xowiki::Page" {
                    return [export_vars \
                                -base /wiki/edit \
                                {{item_id $object_id}}]
                }
            }
                
        }
        default {
            return "/o/${object_id}"
        }

    }
}
