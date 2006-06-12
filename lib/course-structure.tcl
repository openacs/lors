# packages/lorsm/www/course_structure.tcl

ad_page_contract {
    
    View Manifest Course Structure
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-03-31
    @arch-tag 208f2801-d110-45d3-9401-d5eae1f72c93
    @cvs-id  $Id$

    @param man_id manifest id of course
}
set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]

ad_proc -public getFolderKey {
    {-object_id:required}
} {
    Gets the Folderkey for a file-storage folder_id

    @option object_id Folder_id for file-storage folder
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    return [db_string select_folder_key "select key from fs_folders where object_id = :object_id"]
}

# set context & title
set context [list "[_ lorsm.Course_Structure]"]
set title "[_ lorsm.Course_Structure]"


if {[db_0or1row manifest { }]} {

    # Sets the variable for display. 
    set display 1
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_course_Name]"
    } 

    # Version
    set version [db_string get_versions { } -default 0]

    if {[string equal $version "0"]} {
	set version_msg "[_ lorsm.No_version_Available]"
    } 
    
    if { ![empty_string_p $fs_package_id] } {
	# Folder
	set folder [apm_package_url_from_id $fs_package_id]?[export_vars folder_id]
	# Instance
	set instance [apm_package_key_from_id $fs_package_id]
    } else {
	set fs_package_id [site_node_apm_integration::get_child_package_id \
			       -package_id [dotlrn_community::get_package_id $community_id] \
			       -package_key "file-storage"]
	# Instance
	set instance [lorsm::get_course_name -manifest_id $man_id]
	# Folder
#	set root_folder [lorsm::get_root_folder_id]

#	set folder_id [db_string get_folder_id { }]
	set folder [apm_package_url_from_id $fs_package_id]?[export_vars folder_id]
    }

    # Created By
    set created_by [person::name -person_id $creation_user]

    # Creation Date
    set creation_date [lc_time_fmt $creation_date "%x %X"]

    # Check for submanifests
    if {[db_0or1row submans { }]} {
    } else {
	set submanifests 0
    }


} else {

    set display 0
    
}


append orgs_list "<table class=\"list\" cellpadding=\"3\" cellspacing=\"1\" width=\"100%\">"
append orgs_list "<tr class=\"list-header\">
        <th colspan=\"3\" class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">[_ lorsm.Items]</th>
    </tr>
"
db_multirow organizations organizations { } { }
template::multirow foreach organizations {

    set total_items [db_string items_count {select count(*) from ims_cp_items where org_id=:org_id} -default 0]
    # We get the indent of the items in this org_id
    set indent_list [lorsm::get_items_indent -org_id $org_id]
    template::util::list_of_lists_to_array $indent_list indent_array

    append orgs_list "<tr class=\"list-even\">"
    #"<td valign=\"top\" width=\"20%\">$org_title</td><td valign=\"top\" align=\"center\" width=\"5%\">$hasmetadata</td><td>"

    set indent [expr $indent +1]
    set missing_text "[_ lorsm.Nothing_here]"
    set return_url [export_vars -base [ns_conn url] man_id]
    set table_extra_html { width="100%" }
    set table_extra_vars {return_url indent_array lorsm_p}
    set table_def {
	{ title "\#lorsm.Item_Name\#" "no_sort" "<td>
           [set indent  \"\"
                      for { set i 0 } { $i < [expr $indent_array($item_id)-1]} { incr i } {
                      append indent \"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"
                      }
            if {$type eq \"webcontent\" && ![string equal $identifierref {}]} {set href \"$indent<a href='[apm_package_url_from_id_mem $fs_package_id]view/[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/[lorsm::fix_url -url $identifierref]'>$item_title</a>\"} else {set href \"<a href='[lors::object_url -url admin -object_id $res_identifier]'>$item_title</a>\"}]</td>" }
	{ type   "\#lorsm.Type\#" "no_sort" "<td align=\"center\">$type</td>" }
        { delete "\#acs-kernel.common_Delete\#" "no_sort" "<td><a href=\"[export_vars -base object-delete {item_id return_url}]\">Delete</a></td>" }
        { move_up "Move Up" "no_sort" "<td><a href=\"[export_vars -base reorder-items {item_id return_url {dir up}}]\">Move Up</a></td>" }
        { move_down "Move Down" "no_sort" "<td><a href=\"[export_vars -base reorder-items {item_id return_url {dir down}}]\">Move Down</a></td>" }
    }

    set table_item [ad_table -Tmissing_text $missing_text -Textra_vars $table_extra_vars -Theader_row_extra "style=\"background-color: #e0e0e0; font-weight: bold;\" class=\"list-header\"" -Ttable_extra_html $table_extra_html blah { } $table_def]

    append orgs_list "$table_item"


    append orgs_list "</td></tr>"

} if_no_rows {
    append orgs_list "<tr class=\"list-odd\"><td></td></tr>"
}

append orgs_list "</table>"

set enabler_url [export_vars -base enabler {man_id}]
set tracker_url [export_vars -base tracker {man_id}]
set sharer_url  [export_vars -base sharer {man_id folder_id return_url}]
set formater_url  [export_vars -base formater {man_id return_url}]

set add_type_options [list [list Questions assessment] [list  Content wiki]]
ad_form -name add-new -action object-new -export {man_id} -form {
    {add_type:text(select) {label ""} {options $add_type_options}}
    {add_new:text(submit) {label {[_ acs-kernel.common_Add]}}}    
}