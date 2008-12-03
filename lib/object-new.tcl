ad_page_contract {
    create a new lors object
    @param man_id
}


switch $add_type {
    assessment {
        # get a list of assessment
        set dotlrn_package_id [dotlrn_community::get_community_id]
        set assessment_package_id [dotlrn_community::get_applet_package_id \
                                    -community_id $dotlrn_package_id \
                                    -applet_key dotlrn_assessment]
        set options [db_list_of_lists get_assessments {}]
    } wiki {
        # get a list of all the wiki pages
        # find xowiki package
        array set xowiki_node [site_node::get_from_url -url /wiki]

        # get the folder_id
        set folder_id [::xowiki::Page require_folder \
                        -package_id $xowiki_node(object_id) \
                        -name xowiki]

        set options [list]
        set order_clause "order by ci.name"

        db_foreach instance_select \
            [::xowiki::Page instance_select_query \
                -folder_id $folder_id \
                -with_subtypes t \
                -select_attributes [list title last_modified] \
                -order_clause $order_clause] \
            { lappend options [list $title $item_id] }

    } webcontent {
        ad_returnredirect [export_vars -base item-add-edit {man_id}]
        ad_script_abort
    }
}

set search_p 0

if {[llength options] > 10} {
    set search_p 1
}

set return_url [export_vars -base course-structure {man_id}]

# show available objects
set options [concat [list [list "-- Choose --" ""]] $options]

ad_form \
    -name choose \
    -export {man_id add_type} \
    -form {
        {existing_object:text(select)
            {label "[_ acs-kernel.common_Add]"}
            {options $options}}

    } -on_submit {
        # FIXME pretend we can only have one organization per course
        # this is fine since we are not supporting a user interface to
        # create more than one way to organize the items in one manifest
        set org_id [db_string get_org_id {}]
        set item_folder_id [db_string get_folder_id {} ]
        switch $add_type {
            assessment {
                # we want one lors item per section
                set sections [db_list_of_lists get_sections {}]

                foreach {section} $sections {
                    foreach {section_item_id section_name section_title} \
                        [lrange $section 0 2] {break}
                    # ad_return_complaint 1 "$section_name $section_title"
                    # make sure this section isn't already associated with this course
                    # we'll just let an admin add the assessment as many times
                    # as they like, if there a new sections they will get added

                    if {![db_0or1row section_exists {}]} {
                        set res_id [lors::imscp::resource_add_from_object \
                                        -man_id $man_id \
                                        -object_id $section_item_id \
                                        -folder_id $item_folder_id]
                    }

                    if {![db_0or1row item_exists {}]} {
                        set item_id [lors::imscp::item_add_from_object \
                                        -object_id $section_item_id \
                                        -org_id $org_id \
                                        -folder_id $item_folder_id \
                                        -title $section_title]
                        lors::imscp::item_to_resource_add \
                            -item_id $item_id \
                            -res_id $res_id
                    }

                    # FIXME see if anyone is using this resource
                    # already. objects should be # able to be resources
                    # without being tied to one manifest, # since you can use
                    # a resource in more than one course and # it doesn't make
                    # sense to have a seperate row every time # we reuse an
                    # object DAVEB 2070321 - of course, it adds complexity and
                    # special handling, and this works for now.
                }

            } wiki {
                set page [::Generic::CrItem instantiate \
                            -item_id $existing_object]
                $page instvar {title page_title} {name page_name}
                if {![db_0or1row res_exists {}]} {
                    set res_id [lors::imscp::resource_add_from_object \
                                    -man_id $man_id \
                                    -object_id $existing_object \
                                    -folder_id $item_folder_id]
                }

                if {![db_0or1row item_exists_2 {}]} {
                    set item_id [lors::imscp::item_add_from_object \
                                    -object_id $existing_object \
                                    -org_id $org_id \
                                    -folder_id $item_folder_id \
                                    -title $page_title]
                }
                # FIXME see if anyone is using this resource
                # already. objects should be # able to be resources
                # without being tied to one manifest, # since you can use
                # a resource in more than one course and # it doesn't make
                # sense to have a seperate row every time # we reuse an
                # object

                lors::imscp::item_to_resource_add \
                    -item_id $item_id \
                    -res_id $res_id
            }
        }

        ad_returnredirect $return_url
        ad_script_abort
    }


ad_form \
    -name new \
    -export {man_id add_type} \
    -form {
        {name:text(text) {label "Name"}}

    } -on_submit {
        switch $add_type {
            wiki {
                set url [export_vars -base /wiki/edit {name return_url}]

            } assessment {
                set url [export_vars -base ../assessment/asm-admin/assessment-form { name return_url}]
            }
        }
        ad_returnredirect $url
        ad_script_abort
    }
