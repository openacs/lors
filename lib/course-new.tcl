ad_page_contract {
    Includable form to create a new empty LORS course

    @param package_id (optional) optional package to create the course under, probably lorsm or lors-central
    @param folder_id root folder to store stuff in
    @param return_url (defaults to ad_return_url)
    @param return_url_base (if you want to redirect to return_url_base?man_id={man_id} use this
}

# ad_form requires man_id NOT to be set if its new

if {![info exists community_id]} {
    set community_id [dotlrn_community::get_community_id]
}

if {![info exists package_id]} {
    set package_id [ad_conn package_id]
}

ad_form \
    -name course-new \
    -export {return_url package_id folder_id} \
    -form {
        man_id:key
        {name:text(text)
            {label "Course Name"} {size 50}}

    } -new_data {
        # FIXME only works with dotlrn, lame, should just create a lors
        # folder as a child of the package_id of the manifest object

        set new_parent_id [lors::cr::add_folder \
                            -parent_id $folder_id \
                            -folder_name $name]
        set new_items_parent_id [lors::cr::add_folder \
                                    -parent_id $folder_id \
                                    -folder_name "${name}_items"]

        lors::imscp::manifest_add \
            -man_id $man_id \
            -course_name $name \
            -identifier [util_text_to_url -text $name] \
            -hasmetadata f \
            -isscorm f \
            -package_id $package_id \
            -community_id $community_id \
            -folder_id $new_items_parent_id \
            -content_folder_id $new_parent_id

        lors::imscp::organization_add \
            -man_id $man_id \
            -identifier [util_text_to_url -text $name] \
            -org_folder_id $new_items_parent_id

        if {[info exists return_url_base] && $return_url_base ne ""} {
            set return_url [export_vars -base $return_url_base {man_id}]
        }

        if {![info exists return_url] || $return_url eq ""} {
            set return_url [export_vars -base course-structure {man_id}]
        }

        ad_returnredirect -message "[_ lors.Course_created]" $return_url
    }
