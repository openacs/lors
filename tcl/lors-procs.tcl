# packages/lors/tcl/lors-procs.tcl

ad_library {

    Helper procedures for LORS

    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2006-06-06
    @cvs-id $Id$
}

namespace eval lors:: {}

# DRB: All of this community cruft is due to the fact that the datamodel for
# courses stupidly ties them to groups (originally limited to .LRN communities),
# in addition to the appropriate package id.  It should be totally rewritten.

ad_proc lors::get_community_node_id {
    -community_id:required
} {
    return [site_node::get_node_id_from_object_id \
               -object_id [application_group::package_id_from_group_id -group_id $community_id]]
}

ad_proc lors::get_community_element {
    {-node_id ""}
    -element:required
} {
    Return an element from the application group array (site node + group_id)
} {
    if { $node_id eq "" } {
        set node_id [ad_conn node_id]
    }
    return [application_group::closest_ancestor_element \
               -include_self \
               -node_id $node_id \
               -element $element]
}
ad_proc lors::get_community_id {
    {-node_id ""}
} {
    return [lors::get_community_element -node_id $node_id -element application_group_id]
}

ad_proc lors::get_community_url {
    {-node_id ""}
} {
    return [lors::get_community_element -node_id $node_id -element url]
}

ad_proc lors::get_community_package_id {
    {-node_id ""}
} {
    return [lors::get_community_element -node_id $node_id -element package_id]
}

ad_proc lors::get_community_name {
    {-node_id ""}
} {
    return [lors::get_community_element -node_id $node_id -element instance_name]
}

ad_proc -public lors::object_url {
    -object_id
    {-man_id ""}
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
        set object_type [content::item::get_content_type -item_id $object_id]
    }
    ns_log notice "lors::object_Url object_id='${object_id}'"
    switch $url {
        admin {
            switch $object_type {
                as_sections {
                    # FIXME either 1) make this magically work
                    # or 2) find the assessment_id and use
                    # page anchor
                    set assessment_id ""
                    set sort_order ""
                    db_0or1row get_assessment_id {}

                    return [export_vars \
                                -base questions \
                                {man_id assessment_id}]\
                                    [ad_decode {$sort_order eq ""} 0 "\#${sort_order}" ""]
                } "::xowiki::Page" {
                    set url [::xowiki::Package get_url_from_id \
                                -item_id $object_id]

                    set page [::xowiki::Package instantiate_page_from_id \
                                -item_id $object_id]

                    if {[catch {set url [[$page set package_id] make_link \
                                    -privilege public \
                                    -link $url $page edit ""]} errmsg]} {
                        set url [$page make_link \
                                    -privilege public \
                                    -url $url $page edit ""]
                    }
                    return "${url}&return_url=[ad_urlencode [ad_return_url]]"

                } default {
                    set item_id [content::revision::item_id \
                                    -revision_id $object_id]
                    return [export_vars \
                                -base "item-add-edit" \
                                {man_id item_id {return_url [ad_return_url]}}]
                }
            }

        } default {
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
