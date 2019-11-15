ad_library {

    IMS Content Packaging functions
    for Blackboard 6

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

namespace eval lors::imscp::bb6 {}

ad_proc -public lors::imscp::bb6::isBlackboard6 {
    -tmp_dir:required
} {
    Checks whether the IMS CP package is a a Blackboard 6 package (or
    has Blackboard6 extensions)

    Blackboard6 exports add a .bb-package-info file that contain
    technical details of the Blackboard installation. Therefore, we
    will check if the package comes with this file. If it does. we
    return 1, otherwise 0.

    @param tmp_dir temporary directory
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    return [file exists $tmp_dir/.bb-package-info]
}


ad_proc -public lors::imscp::bb6::getItems {
    {tree}
    {parent ""}
} {
    Extracts data from Items

    @option tree the XML node that contains the Items to get.
    @option parent parent item node (items can have subitems).
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    set items ""
    set itemx [$tree child all item]

    if { ![empty_string_p $itemx] } {
        if {[empty_string_p $parent]} {
            set parent 0
        }

        set it_list ""
        foreach itemx  [$tree child all item] {
            set cc ""

            # gets item identifier
            set cc "[lors::imsmd::getAtt $itemx identifier]"

            # gets item identifierref
            set cc [concat $cc "[lors::imsmd::getAtt $itemx identifierref]"]

            # gets xml node
            lappend cc {*}$itemx
            set it_list [concat $it_list [list $cc]]

            set itemxx [$itemx child all item]
            if { ![empty_string_p $itemxx] } {
                set it_list [concat $it_list [getItems $itemx]]
            }
            lappend items {*}$cc
        }
    }
    return $it_list
}


ad_proc -public lors::imscp::bb6::getTitle {
    -node:required
} {
    Gets the title for a Blackboard course

    @option node XML node
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    set title_node [$node child all TITLE]
    if {![empty_string_p title_node]} {
        set title [lors::imsmd::getAtt $title_node value]
        return $title
    } else {
        return ""
    }
}


ad_proc -public lors::imscp::bb6::getDescription {
    -node:required
} {
    Gets the description for a Blackboard course

    @option node XML node
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    set desc_node [$node child all DESCRIPTION]
    if {![empty_string_p desc_node]} {
        set desc [lors::imsmd::getElement $desc_node]
        return $desc
    } else {
        return ""
    }
}

ad_proc -public lors::imscp::bb6::getDates {
    -node:required
} {
    Gets the dates for a Blackboard course

    @option node XML node
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    set dates_node [$node child all DATES]
    if {![empty_string_p dates_node]} {
        set created [$dates_node child all CREATED]
        set updated [$dates_node child all UPDATED]
        return [list \
                [lors::imsmd::getAtt $created value] [lors::imsmd::getAtt $updated value]]
    } else {
        return ""
    }
}

ad_proc -public lors::imscp::bb6::content_getFlags {
    -name:required
    -node:required
} {
    Gets the flags for a Blackboard course

    @option name Name of the attribute to get
    @option node XML node
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    set flags_node [$node child all FLAGS]
    if {![empty_string_p flags_node]} {
        set getname [$flags_node child all [string toupper $name]]

        if {![empty_string_p getname]} {
            return [lors::imsmd::getAtt $getname value]
        } else {
            return ""
        }
    } else {
        return ""
    }
}

ad_proc -public lors::imscp::bb6::content_getItemAttributes {
    -node:required
} {
    Gets the Navigation items for a Blackboard course

    @option name Name of the attribute to get
    @option node XML node

    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    set navigation [$node child all [string toupper NAVIGATION]]
    if {![empty_string_p flags_node]} {

        set items [$navigation child all ITEM]
        set item_list [list]

        foreach item $items {
            set item_value [lors::imsmd::getAtt $item value]
            set item_label [lors::imsmd::getAtt $item label]
            set item_issecure [lors::imsmd::getAtt $item issecure]
            set item_isavailable [lors::imsmd::getAtt $item isavailable]

            lappend item_list [list $item_value $item_label $item_issecure $item_isavailable]
        }
        return $item_list
    } else {
        return ""
    }
}

ad_proc -public lors::imscp::bb6::get_coursetoc {
    -file:required
} {
    Gets content from Blackboard's course/x-bb-coursetoc elements

    @option file filename
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # open xml file
    set doc [dom parse [::tdom::xmlReadFile $file]]
    # coursetoc
    set coursetoc [$doc documentElement]

    set list_items  [list]

    # gets coursetoc elements and values
    lappend list_items {id} [lors::imsmd::getAtt $coursetoc id]
    lappend list_items {LABEL} [lors::imsmd::getAtt [$coursetoc getElementsByTagName LABEL] value]
    lappend list_items {URL} [lors::imsmd::getAtt [$coursetoc getElementsByTagName URL] value]
    lappend list_items {TARGETTYPE} [lors::imsmd::getAtt [$coursetoc getElementsByTagName TARGETTYPE] value]
    lappend list_items {INTERNALHANDLE} [lors::imsmd::getAtt [$coursetoc getElementsByTagName INTERNALHANDLE ] value]
    lappend list_items {LAUNCHINNEWWINDOW} [lors::imsmd::getAtt [$coursetoc getElementsByTagName LAUNCHINNEWWINDOW] value]
    lappend list_items {ISENABLED} [lors::imsmd::getAtt [$coursetoc getElementsByTagName ISENABLED] value]
    lappend list_items {ISENTYRPOINT} [lors::imsmd::getAtt [$coursetoc getElementsByTagName ISENTYRPOINT] value]
    lappend list_items {ALLOWOBSERVERS} [lors::imsmd::getAtt [$coursetoc getElementsByTagName ALLOWOBSERVERS] value]
    lappend list_items {ALLOWGUESTS} [lors::imsmd::getAtt [$coursetoc getElementsByTagName ALLOWGUESTS] value]

    # deletes the dom
    $doc delete

    # return list
    return $list_items
}


ad_proc -public lors::imscp::bb6::get_bb_doc {
    -file:required
} {
    Gets content from Blackboard's resource/x-bb-document elements

    @option file filename
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # open xml file
    set doc [dom parse [::tdom::xmlReadFile $file]]

    # content
    set content [$doc documentElement]
    set list_items  [list]

    # gets content elements and values
    lappend list_items {id} [lors::imsmd::getAtt $content id]
    lappend list_items {TITLE} [lors::imsmd::getAtt [$content getElementsByTagName TITLE] value]
    lappend list_items {TITLECOLOR} [lors::imsmd::getAtt [$content getElementsByTagName TITLECOLOR] value]
    lappend list_items {TEXT} [lors::imsmd::getElement [$content getElementsByTagName TEXT]]
    lappend list_items {TYPE} [lors::imsmd::getAtt [$content getElementsByTagName TYPE] value]
    lappend list_items {CREATED} [lors::imsmd::getAtt [$content selectNodes /CONTENT/DATES/CREATED] value]
    lappend list_items {UPDATED} [lors::imsmd::getAtt [$content selectNodes /CONTENT/DATES/UPDATED] value]
    lappend list_items {START} [lors::imsmd::getAtt [$content getElementsByTagName START] value]
    lappend list_items {ISAVAILABLE} [lors::imsmd::getAtt [$content getElementsByTagName ISAVAILABLE] value]
    lappend list_items {ISFROMCARTRIDGE} [lors::imsmd::getAtt [$content getElementsByTagName ISFROMCARTRIDGE] value]
    lappend list_items {ISFOLDER} [lors::imsmd::getAtt [$content getElementsByTagName ISFOLDER] value]
    lappend list_items {ISDESCRIBED} [lors::imsmd::getAtt [$content getElementsByTagName ISDESCRIBED] value]
    lappend list_items {ISTRACKED} [lors::imsmd::getAtt [$content getElementsByTagName ISTRACKED] value]
    lappend list_items {ISLESSON} [lors::imsmd::getAtt [$content getElementsByTagName ISLESSON] value]
    lappend list_items {ISSEQUENTIAL} [lors::imsmd::getAtt [$content getElementsByTagName ISSEQUENTIAL] value]
    lappend list_items {ALLOWGUESTS} [lors::imsmd::getAtt [$content getElementsByTagName ALLOWGUESTS] value]
    lappend list_items {ALLOWOBSERVERS} [lors::imsmd::getAtt [$content getElementsByTagName ALLOWOBSERVERS] value]
    lappend list_items {LAUNCHINNEWWINDOW} [lors::imsmd::getAtt [$content getElementsByTagName LAUNCHINNEWWINDOW] value]
    lappend list_items {CONTENTHANDLER} [lors::imsmd::getAtt [$content getElementsByTagName CONTENTHANDLER] value]
    lappend list_items {RENDERTYPE} [lors::imsmd::getAtt [$content getElementsByTagName RENDERTYPE] value]
    lappend list_items {URL} [lors::imsmd::getAtt [$content getElementsByTagName URL] value]

    set files [list]
    foreach file [[$content selectNodes /CONTENT/FILES] childNodes] {
        set file_list [list]
        lappend file_list {file_id} [lors::imsmd::getAtt $file id]
        lappend file_list {NAME} [lors::imsmd::getElement [$file getElementsByTagName NAME]]
        lappend file_list {FILEACTION} [lors::imsmd::getAtt [$file getElementsByTagName FILEACTION] value]
        lappend file_list {LINKNAME} [lors::imsmd::getAtt [$file getElementsByTagName LINKNAME] value]
        lappend file_list {SIZE} [lors::imsmd::getAtt [$file getElementsByTagName SIZE] value]
        lappend file_list {CREATED} [lors::imsmd::getAtt [$file getElementsByTagName CREATED] value]
        lappend file_list {UPDATED} [lors::imsmd::getAtt [$file getElementsByTagName UPDATED] value]

        foreach registryentry [[$file getElementsByTagName REGISTRY] childNodes] {
            if {[$registryentry getAttribute key] == "entry_point"} {
                lappend file_list {REGISTRY_ENTRY_POINT} [lors::imsmd::getAtt $registryentry value]
            }
        }

        lappend files $file_list
    }

    lappend list_items {FILES} $files

    # deletes the dom
    $doc delete

    # return list
    return $list_items

}


ad_proc -public lors::imscp::bb6::txt_to_html {
    -txt:required
    -filename:required
} {
    Creates an HTML file from TXT

    @option txt Text to transform into HTML
    @option filename directory and filename where we are putting the file
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # get directory info
    set dirname [file dirname $filename]

    # check if directory exists
    if { ![file exists $dirname] } {
        file mkdir $dirname
    }

    # transforms text into html
    if {[lors::imscp::bb6::looks_like_html_p -text $txt]}  {
    #   set txt [ad_text_to_html -includes_html $txt]
    } else {
        set txt [ad_text_to_html -includes_html $txt]
    #   set txt [ad_html_text_convert -from "text/plain" -to "text/html" $txt]
    }

    # saves it on a new html file
    set f_handler [open $filename w+]
    fconfigure $f_handler -encoding utf-8
    puts -nonewline $f_handler "<!-- Generated by LORS importing from
        Blackboard --> \ $txt \<!-- Finish importing -->"
    close $f_handler

    # returns what is is an href for resources
    return $filename
}


ad_proc -public lors::imscp::bb6::looks_like_html_p {
    -text:required
} {
    Creates an HTML file from TXT.
    This one expands ad_looks_like_html_p

    @param txt text to check for html tags
    @return 1 if it looks like html, 0 if not.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {

    if { [regexp -nocase {<p>} $text] || [regexp -nocase {<br>} $text] || \
        [regexp -nocase {</a} $text] || [regexp -nocase {</p>} $text] || \
        [regexp -nocase {</html>} $text] } {
        return 1
    } else {
        return 0
    }

}


ad_proc -public lors::imscp::bb6::get_announcement {
    -file:required
} {
    Gets content from Blackboard's resource/x-bb-announcement elements

    @option file filename
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # open xml file
    set doc [dom parse [::tdom::xmlReadFile $file]]
    # content
    set announcement [$doc documentElement]
    set list_items  [list]

    # gets announcement  elements and values
    lappend list_items {id} [lors::imsmd::getAtt $announcement id]
    lappend list_items {TITLE} [lors::imsmd::getAtt [$announcement getElementsByTagName TITLE] value]
    lappend list_items {DESCRIPTION} [lors::imsmd::getElement [$announcement getElementsByTagName TEXT]]
    lappend list_items {ISHTML} [lors::imsmd::getAtt [$announcement getElementsByTagName ISHTML] value]
    lappend list_items {ISPERMANENT} [lors::imsmd::getAtt [$announcement getElementsByTagName ISPERMANENT] value]
    lappend list_items {USERID} [lors::imsmd::getAtt [$announcement getElementsByTagName USERID] value]
    lappend list_items {CREATED} [lors::imsmd::getAtt [$announcement getElementsByTagName CREATED] value]
    lappend list_items {UPDATED} [lors::imsmd::getAtt [$announcement getElementsByTagName CREATED] value]
    lappend list_items {RESTRICTSTART} [lors::imsmd::getAtt [$announcement getElementsByTagName RESTRICTSTART] value]
    lappend list_items {RESTRICTEND} [lors::imsmd::getAtt [$announcement getElementsByTagName RESTRICTEND] value]


    # deletes the dom
    $doc delete

    # return list
    return $list_items

}

ad_proc -public lors::imscp::bb6::has_packages {
    -resource_files:required
} {
    Checks whether this resource has a file in the form of a package.
    Returns 1 if that's the case. 0 otherwise.

    @param resource_files the resource we need to check
    @author Ernie Ghgilione (ErnieG@mm.st)
} {

    if {[lsearch -exact [lindex $resource_files 0] PACKAGE] == -1} {
        return 0
    } else {
        return 1
    }
}

ad_proc -private lors::imscp::bb6::process_package {
    -tmp_dir:required
    -zipfile:required
    -res_identifier:required
    -resource:required
    -entry_point:required
} {
    Process the BB Packages: makes it IMS CP
    compliant (rather than BB's weird interpretation
    of IMS CP).

    @param tmp_dir the temp dir
    @param zipfile package zipped file name
    @param res_identifier Identifier for the resource
    @param resource the actual resource we are fixing
    @param entry_point the actual file within the package to link to
    @author Ernie Ghgilione (ErnieG@mm.st)
} {

    # If it has a
    # "Package" then
    # we have to unzip the zipped file
    # (contained in the
    # file name), then collect all the
    # unzipped file and
    # add them as files in the resource.

    # additionally, we need to change the
    # resource to
    # point out to the entry_point on the
    # package.
    set path "$tmp_dir/$res_identifier"

    ns_log Notice "WE GOTTA PACKAGE PATH: $path FILE: $zipfile"

    ##
    ## Unzip file and add those to the
    # resource and point the href to
    # the entry_point
    ##

    # Now we unzip the package file
    # into the exact directory where
    # the resource
    set errp [catch { exec unzip -jd $path $path/$zipfile } errmsg]

    # catch any errors
    if {$errp} {
        ns_log Notice "lors::imscp::bb6::extract_html doc_bb: package zip error ($errmsg)"
        return -code error "lors::imscp::bb6::extract_html doc_bb: package zip error ($errmsg)"
    }

    # Now we delete the zip file as we
    # don't need it any more
    exec rm -fr $path/$zipfile

    # Also we remove the actual file
    # children for the resource as
    # they exist in the BB XMl file as
    # we are going to replace them now
    $resource removeChild [$resource firstChild]

    # now we get all the files in the
    # directory.
    set all_packaged_files [lors::imscp::dir_walk $path]

    foreach filex $all_packaged_files {
        # we add the files to the
        # resource

        # create the file XML node
        set file_doc [dom createDocument file]
        set file_nodex [$file_doc documentElement]

        # we get rid of the /tmp/xyz
        # part of the path and only
        # put the relative href
        regsub $tmp_dir $filex {} filex

        # set the href to the file node
        $file_nodex setAttribute href $filex

        # append the file node as child
        # for the resource

        $resource appendChild $file_nodex
    }

    # now let's reference the resource
    # to point to the BB entry_point

    $resource setAttribute href "/$res_identifier/$entry_point"

}



ad_proc -public lors::imscp::bb6::get_forum {
    -file:required
} {
    Gets content from Blackboard's resource/x-bb-discussionboard elements

    @option file filename
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # open xml file
    set doc [dom parse [::tdom::xmlReadFile $file]]
    # content
    set forum [$doc documentElement]

    set list_items  [list]

    # gets forum elements and values
    lappend list_items {id} [lors::imsmd::getAtt $forum id]
    lappend list_items {TITLE} [lors::imsmd::getAtt [$forum getElementsByTagName TITLE] value]
    lappend list_items {DESCRIPTION} [lindex [lors::imsmd::getElement [$forum getElementsByTagName TEXT]] 0]
    lappend list_items {ISHTML} [lors::imsmd::getAtt [$forum getElementsByTagName ISHTML] value]
    lappend list_items {CREATED} [lors::imsmd::getAtt [$forum getElementsByTagName CREATED] value]
    lappend list_items {UPDATED} [lors::imsmd::getAtt [$forum getElementsByTagName CREATED] value]

    # deletes the dom
    $doc delete

    # return list
    return $list_items
}


### Cleanup Functions

ad_proc -public lors::imscp::bb6::create_MD {
    -tmp_dir:required
    -file:required
} {
    Blackboard 6 by default does not create manifest metadata.
    However, it does have some sort of metadata in the res00001.dat
    file, so we extract that information and create a LOM metadata record

    @param tmp_dir temporary directory where the imsmanifest.xml is located.
    @option file filename
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # open manifest file with tDOM
    set doc [dom parse [::tdom::xmlReadFile $tmp_dir/$file]]
    # gets the manifest tree
    set manifest [$doc documentElement]
    # we add the xml namespace for dotLRN
    $manifest setAttributeNS  {} xmlns:dotLRN http://dotlrn.org/content-packaging

    # Check if it has a metadata node for the manifest
    # If it doesn't let's create one with the description we get from
    # res00001.dat

    set metadata [$manifest child all metadata]

    if {[empty_string_p $metadata]} {

        set filex res00001.dat
        set docx [dom parse [::tdom::xmlReadFile $tmp_dir/$filex]]
        # gets BB's course info
        set course [$docx documentElement]

        set title [lors::imsmd::getAtt [$course selectNodes /COURSE/TITLE] value]
        set description [lindex [lors::imsmd::getElement [$course selectNodes /COURSE/DESCRIPTION]] 0]

        $docx delete

        # create a metadata node
        set docx [dom createDocument metadata]
        set metadata [$docx documentElement]


        set general_node [lors::imsmd::create::lom_general \
                            -owner $metadata \
                            -title [list en $title] \
                            -description [list en $description]]

        set lom_node [lors::imsmd::create::lom \
                        -owner $metadata \
                        -general $general_node]

        set md [lors::imsmd::create::md \
                    -owner $metadata \
                    -schema "IMS Content" \
                    -schemaversion "1.1.2" \
                    -lom $lom_node]

        $manifest insertBefore $md [$manifest child all organizations]

        set f_handler [open /tmp/imsmanifest.xml w+]
        puts -nonewline $f_handler [$manifest asXML -indent 1 -escapeNonASCII]
        close $f_handler

        $doc delete

        file copy -force /tmp/imsmanifest.xml $tmp_dir/$file
    }

}


ad_proc -public lors::imscp::bb6::clean_items {
    -tmp_dir:required
    -file:required
} {
    This function cleans up a lot of the unused and empty ims_items that Blackboard has when exporting their courses. Apparently Blackboard exports all their application information and sets the availability of these applications within the .dat files. This function looks into some of the Blackboard specific resource types and based on their availability or data, we adapt it to a purer IMS CP standards.

    @param tmp_dir temporary directory where the imsmanifest.xml is located.
    @option file filename
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # open xml file
    set doc [dom parse [::tdom::xmlReadFile $tmp_dir/$file]]

    # gets the manifest tree
    set manifest [$doc documentElement]

    # Gets the organizations

    set organizations [$manifest child all organizations]

    if { ![empty_string_p $organizations] } {
        set num_organizations [$organizations child all organization]

        set items 0

        set items_list [list]
        foreach organization $num_organizations {
            set items_list [lors::imscp::bb6::getItems $organization]
        }
    }


    # gets the resources
    set resources [$manifest child all resources]

    # Complain if there's no resources
    if {[empty_string_p $resources]} {
        ad_return_complaint 1 "The package you are trying to upload
            doesn't have resources. Please check the $file and try again"
        ad_script_abort
    }

    set resourcex [$resources child all resource]
    set resources_list [list]
    foreach resource $resourcex {
        set res_identifier [lors::imsmd::getResource -node $resource -att identifier]
        set res_type [lors::imsmd::getResource -node $resource -att type]
        set res_href [lors::imsmd::getResource -node $resource -att href]
        set res_dependencies [lors::imsmd::getResource -node $resource -att dependencies]
        set res_hasmetadata [lors::imsmd::hasMetadata $resource]
        set res_files [lors::imsmd::getResource -node $resource -att files]
        set res_scormtype [lors::imsmd::getAtt $resource adlcp:scormtype]

        switch $res_type {
            "course/x-bb-coursetoc" {
                set file [lors::imsmd::getAtt $resource bb:file]
                array set ernie [lors::imscp::bb6::get_coursetoc -file $tmp_dir/$file]
                set enabled_p $ernie(ISENABLED)

            } "resource/x-bb-document" {
                set file [lors::imsmd::getAtt $resource bb:file]
                array set ernie [lors::imscp::bb6::get_bb_doc -file $tmp_dir/$file]
                set enabled_p $ernie(ISAVAILABLE)

            } default {
                set enabled_p "no_type"
            }
        }

        lappend resources_list [list [lors::imsmd::getAtt $resource identifier] \
            [lors::imsmd::getAtt $resource type] $resource $enabled_p]
    }

#    ns_log Notice "HERE IS THE LIST OF ITEMS: ([llength $items_list]) $items_list \nResource list ([llength $resources_list]) $resources_list"

    ns_log Notice "\n\n"

    foreach item $items_list {
        ns_log Notice "\n------Begin-----\nItem identifier [lindex $item 0]\n"
        ns_log Notice "Item resource reference: [lindex $item 1]\n"
        ns_log Notice "Lsearch result: [lsearch -regexp $resources_list [lindex $item 1]]\n"

        set resource [lindex $resources_list [lsearch -regexp $resources_list [lindex $item 1]]]

        ns_log Notice "is Resource enabled?: [lindex $resource 3]\n"

        if {[lindex $resource 3] == "false"} {
            switch [lindex $resource 1] {
                "resource/x-bb-document" {
                    # if the resource is a document and also is false or
                    # disable, that means (according to my interpretation
                    # of Blackboard XML files, that these documents are
                    # only to be rendered to admins, but not to students.

                    # Since IMS doesn't have anything to support
                    # permissions within their own items, then we added an
                    # attribute as an extension: dotLRN:permission.

                    ns_log Notice "\tDocument Type\n"
                    ns_log Notice "\tAdding attribute to [lindex $item 2] \n"
                    [lindex $item 2] setAttributeNS dotLRN dotLRN:permission admin
                } "course/x-bb-coursetoc" {

                    ns_log Notice "\Coursetoc Type \n"
                    ns_log Notice "\tAdding attribute to [lindex $item 2] \n"
                    if {![empty_string_p [[lindex $item 2] child all item]]} {
                        [lindex $item 2] setAttributeNS dotLRN dotLRN:permission admin
                    } else {
                        ns_log Notice "\tdeleting [lindex $item 0] - [lindex $item 2] as it is false\n"
                        ns_log Notice  "\tdeleting node [lindex $item 2]  \n"

                        [lindex $item 2] delete

                        ns_log Notice "\tand its corresponding resource [lindex $resource 2]\n"
                        ns_log Notice "\tDeleting files from FS: [lors::imsmd::getResource -node [lindex $resource 2] -att files]\n"
                        ns_log Notice "\tDeleting dat file: [lors::imsmd::getAtt [lindex $resource 2] bb:file]\n"
                        exec rm -fr $tmp_dir/[lors::imsmd::getAtt [lindex $resource 2] bb:file]
                        [lindex $resource 2] delete
                    }

                } default {

                    if {[empty_string_p [[lindex $item 2] child all item]]} {
                        ns_log Notice "\tdeleting [lindex $item 0] - [lindex $item 2] as it is false\n"
                        ns_log Notice  "\tdeleting node [lindex $item 2]  \n"

                        [lindex $item 2] delete

                        ns_log Notice "\tand its corresponding resource [lindex $resource 2]\n"
                        ns_log Notice "\tDeleting files from FS: [lors::imsmd::getResource -node [lindex $resource 2] -att files]\n"
                        ns_log Notice "\tDeleting dat file: [lors::imsmd::getAtt [lindex $resource 2] bb:file]\n"
                        exec rm -fr $tmp_dir/[lors::imsmd::getAtt [lindex $resource 2] bb:file]
                        [lindex $resource 2] delete
                    }
                }
            }
        } else {
            ns_log Notice "\tResource is enabled... therefore nothing to do here\n"
            switch [lindex $resource 1] {
                "course/x-bb-coursetoc" {
                    ns_log Notice "Item: [lindex $item 0] [lindex $item 1]
                        ([lindex $item 2]) has [llength [[lindex $item 2]
                        child all item]]] items"
                    if {[empty_string_p [[lindex $item 2] child all item]]} {
                        # this corsetoc item is childless,
                        # therefore we nuke it (as it is an
                        # empty folder
                        ns_log Notice "Therefore [lindex $item 0] [lindex $item 1] ([lindex $item 2]) we delete it.."

                        [lindex $item 2] delete

                        ns_log Notice "\tand its corresponding resource [lindex $resource 2]\n"
                        ns_log Notice "\tDeleting files from FS: [lors::imsmd::getResource -node
                            [lindex $resource 2] -att files]\n"
                        ns_log Notice "\tDeleting dat file: [lors::imsmd::getAtt [lindex $resource 2] bb:file]\n"
                        exec rm -fr $tmp_dir/[lors::imsmd::getAtt [lindex $resource 2] bb:file]
                        [lindex $resource 2] delete
                    }

                } default {
                    # this item has good content
                    ns_log Notice "\t we can't delete [lindex $item 0] - [lindex $item 2] as it has child items -- [[lindex $item 2] child all item]\n"
                }
            }
        }
        ns_log Notice "------End------\n"
    }

    set f_handler [open /tmp/imsmanifest.xml w+]
    puts -nonewline $f_handler [$manifest asXML -indent 1 -escapeNonASCII]
    close $f_handler

    $doc delete

    file copy -force /tmp/imsmanifest.xml $tmp_dir/imsmanifest.xml
}


ad_proc -public lors::imscp::bb6::extract_html {
    -tmp_dir:required
    -file:required
} {
    This is a massive function that does a lot of things.
    It extracts the HTML from Blackboard's proprietary .dat files
    Cleans ups a lot of unused application data and resources.
    (this should be customizable in a different functions)

    Now it also handles BB packages (a weird way of zipping files)
    that suppose to be declared in the imsmanifest, but of course
    they are not. Thanks Blackboard for making interoperability
    possible (NOT!)

    @param tmp_dir temporary directory where the imsmanifest.xml is located.
    @option file filename
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    ## Opens imsmanifest.xml
    # open manifest file with tDOM
    set doc [dom parse [::tdom::xmlReadFile $tmp_dir/$file]]
    # gets the manifest tree
    set manifest [$doc documentElement]

    # Gets the organizations

    set organizations [$manifest child all organizations]
    if { ![empty_string_p $organizations] } {
        set num_organizations [$organizations child all organization]
        set items 0

        foreach organization $num_organizations {
            set items  [expr $items + [lors::imscp::countItems $organization]]
        }
    }

    # gets the resources
    set resources [$manifest child all resources]

    # Complain if there's no resources
    if {[empty_string_p $resources]} {
        ad_return_complaint 1 "The package you are trying to upload doesn't
            have resources. Please check the $file and try again"
        ad_script_abort
    }

    set resourcex [$resources child all resource]

    foreach resource $resourcex {
        set res_identifier [lors::imsmd::getResource \
                                -node $resource \
                                -att identifier]
        set res_type [lors::imsmd::getResource -node $resource -att type]
        set res_href [lors::imsmd::getResource -node $resource -att href]
        set res_dependencies [lors::imsmd::getResource \
                                -node $resource \
                                -att dependencies]
        set res_hasmetadata [lors::imsmd::hasMetadata $resource]
        set res_files [lors::imsmd::getResource -node $resource -att files]
        set res_scormtype [lors::imsmd::getAtt $resource adlcp:scormtype]

        switch $res_type {
            "course/x-bb-coursetoc" {

                set file [lors::imsmd::getAtt $resource bb:file]
                array set resourcext [lors::imscp::bb6::get_coursetoc -file $tmp_dir/$file]

                ns_log Notice  "\n\n$file ($resourcext(ISENABLED)) $resourcext(LABEL)\n"

                # set content folder to be the appropriate IMS webcontent
                # type instead of "couse/x-bb-coursetoc" BB's proprietary type
                $resource removeAttribute type
                $resource removeAttribute bb:file
                $resource removeAttribute bb:title
                $resource setAttribute type webcontent

            } "resource/x-bb-document" {
                set file [lors::imsmd::getAtt $resource bb:file]
                array set resourcext [lors::imscp::bb6::get_bb_doc -file $tmp_dir/$file]

                ns_log Notice  "\n--resource document Begin\n"
                ns_log Notice  "   ISFOLDER: $resourcext(ISFOLDER)"
                ns_log Notice  "\n\n   $file [llength $resourcext(FILES)] $resourcext(FILES)"

                # change the resources type from proprietary BB's
                # "resource/x-bb-document" to webcontent as defined by IMS
                $resource removeAttribute type
                $resource removeAttribute bb:title
                $resource setAttribute type webcontent


                if { $resourcext(ISFOLDER) == "true" } {
                    if {$resourcext(TEXT) != "{}"} {
                        ns_log Notice  "\n   it has text"
                        set folder [lors::imsmd::getAtt $resource identifier]
                        set filename $resourcext(id).html
                        set res_href [lors::imscp::bb6::txt_to_html \
                                        -txt [lindex $resourcext(TEXT) 0] \
                                        -filename $tmp_dir/$folder/$filename]

                        regsub $tmp_dir $res_href {} res_href
                        ns_log Notice  " \n   And we set up the attribute to: href $res_href\n"

                        $resource setAttribute href $res_href

                    } else {
                        ns_log Notice  "\n   doesn't have text\n"
                    }

                } else {
                    # if it ain't a folder

                    # check if the content of TEXT tag is HTML or not
                    # If it is, then we need to assume that TEXT has
                    # embedded HTML code that references to the files
                    # under the FILES tag (this could be a bit tricky, but
                    # there's not much we can do for now)

                    ns_log Notice  "\nlist of files: [lindex $resourcext(FILES) 0]\n"

                    if { $resourcext(TYPE) == "H" } {
                        if {$resourcext(TEXT) != "{}"} {
                            ns_log Notice  "\n   it has text"
                            set content [lindex $resourcext(TEXT) 0]

                            # we transform the text into HTML if required
                            if {![lors::imscp::bb6::looks_like_html_p \
                                -text [lindex $resourcext(TEXT) 0]]} {
                                set content [ad_html_text_convert \
                                    -from "text/plain" \
                                    -to "text/html" [lindex $resourcext(TEXT) 0]]
                            } else {
                                set content [lindex $resourcext(TEXT) 0]
                            }

                            set folder [lors::imsmd::getAtt $resource identifier]

                            set filename $resourcext(id).html

                            set counter 0
                            set files_lister ""
                            set has_packages [lors::imscp::bb6::has_packages \
                                                -resource_files $resourcext(FILES)]

                            foreach file $resourcext(FILES) {
                                ns_log Notice  "\n\t We gotta file: $file\n "

                                # We need to find out whether this
                                # file is a package or just a file to
                                # be added to the end of the HTML
                                # TODO

                                # Here's where we handle BB packages. BB packages
                                # are a painful thing that BB engineers use to
                                # complicate the life of other people
                                # -like me- to get access to their
                                # files

                                # A BB package is a zip file that
                                # contains a bunch of other file
                                # within it. There's really *no*
                                # reason for the BB people to package
                                # them, but I guess it's just to make
                                # it more difficult for to inter
                                # exchange content with other systems.

                                # Does it have a package?

                                if {$has_packages != 0}  {
                                    lors::imscp::bb6::process_package \
                                        -tmp_dir $tmp_dir \
                                        -zipfile [lindex $file 3] \
                                        -res_identifier $res_identifier \
                                        -resource $resource \
                                        -entry_point [lindex $file 15]

                                } else {

                                    # if this is not a package, then
                                    # it checks whether the files are
                                    # referenced in the content and
                                    # otherwise it adds them

                                    if {[regexp [lindex $file 3] $content]} {
                                        ns_log Notice  "\t [lindex $file 7]: [lindex $file 3] is referenced\n"
                                    } else {
                                        if {$counter == 0} {
                                            append files_lister "<p>Files: <ul>\n"
                                        }
                                        append files_lister "\t<li><a href=\"[lindex $file 3]\">[lindex $file 7]</a></li>\n"
                                        incr counter
                                        ns_log Notice  "\t [lindex $file 7]: [lindex $file 3] ISN'T referenced\n"
                                    }
                                }
                            }

                            # if has_packages != 0 then there was at
                            # least one file was declared as a package
                            # Therefore we ignore $content
                            # This is an assumption as I haven't seen
                            # files AND packages within the same resource.

                            if {$has_packages == 0} {
                                if {$counter > 0} {
                                    append files_lister "</ul>\n</body>\n"
                                    regsub -nocase "</body>" $content $files_lister content
                                }

                                set res_href [lors::imscp::bb6::txt_to_html \
                                    -txt $content -filename $tmp_dir/$folder/$filename]

                                regsub $tmp_dir $res_href {} res_href
                                ns_log Notice  " \n   And we set up the attribute to: href $res_href\n"

                                $resource setAttribute href $res_href
                            }
                        }
                    } else {

                        if {![empty_string_p [lindex $resourcext(FILES) 0]]} {
                            array set file_href [lindex $resourcext(FILES) 0]

                            if {$file_href(FILEACTION) == "PACKAGE"} {
                                lors::imscp::bb6::process_package \
                                    -tmp_dir $tmp_dir \
                                    -zipfile $file_href(NAME) \
                                    -res_identifier $res_identifier \
                                    -resource $resource \
                                    -entry_point $file_href(REGISTRY_ENTRY_POINT)
                            } else {
                                ns_log Notice  "\n    the HREF for this file should
                                    be /$res_identifier/$file_href(NAME)\n"
                                set res_href "/$res_identifier/$file_href(NAME)"
                                $resource setAttribute href $res_href
                            }
                        } else {
                            set folder [lors::imsmd::getAtt $resource identifier]
                            set filename $resourcext(id).html

                            # in the case this is type "S" and also
                            # the resource CONTENTHANDLER =
                            # resource/x-bb-externallink and
                            # RENDERTYPE = URL, then we add this link
                            # to the TEXT (if any) as part of the
                            # content

                            set partial_content [lindex $resourcext(TEXT) 0]

                            if {$resourcext(CONTENTHANDLER) == "resource/x-bb-externallink" \
                                && $resourcext(RENDERTYPE) == "URL"} {
                                append partial_content "\n<p>\n\t<a href=\"$resourcext(URL)\"
                                    target=\"_new\">$resourcext(TITLE)</a>\n</p>"
                            }

                            set res_href [lors::imscp::bb6::txt_to_html \
                                            -txt $partial_content \
                                            -filename $tmp_dir/$folder/$filename]

                            regsub $tmp_dir $res_href {} res_href
                            ns_log Notice  " \n   And we set up the attribute to: href $res_href\n"

                            $resource setAttribute href $res_href
                        }
                    }
                }

                exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
                ns_log Notice  "\n--DELETED FILE $tmp_dir/[lors::imsmd::getAtt $resource bb:file]--\n"
                $resource removeAttribute bb:file
                ns_log Notice  "\n--resource document END--\n"

            } "assessment/x-bb-qti-survey" {
                # if it's not content, then we delete the resource and the
                # dat file.
                ns_log Notice  "\n--resource qti-survey:  [lors::imsmd::getAtt $resource bb:file]  deleted\n"
                exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
                ns_log Notice "Deleting qti-survey resource $resource"
                $resource delete

            } "resource/x-bb-announcement" {
                ns_log Notice  "\n--resource ANNOUNCEMENT \n"
                exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
                $resource delete
                ns_log Notice "Deleting Announcement resource $resource"
                ns_log Notice "Deleting Announcement resource $resource"

            } "resource/x-bb-discussionboard" {
                ns_log Notice  "\n--resource FORUM POSTING \n"
                exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
                $resource delete

            } "course/x-bb-gradebook" {
                ns_log Notice  "\n--resource gradebook:  [lors::imsmd::getAtt $resource bb:file]  deleted\n"
                exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
                $resource delete

            } "course/x-bb-coursenavsetting" {
                ns_log Notice  "\n--resource navsettings:  [lors::imsmd::getAtt $resource bb:file]  deleted\n"
                exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
                $resource delete
            } "course/x-bb-courseappsetting" {
                ns_log Notice  "\n--resource courseappsetting:  [lors::imsmd::getAtt $resource bb:file]  deleted\n"
                exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
                $resource delete

            } "course/x-bb-coursesetting" {
                ns_log Notice  "\n--resource coursesetting:  [lors::imsmd::getAtt $resource bb:file]  deleted\n"
                exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
                $resource delete

            } "resource/x-bb-conference" {

            ns_log Notice  "\n--resource conference:  [lors::imsmd::getAtt $resource bb:file]  deleted\n"
            exec rm -fr $tmp_dir/[lors::imsmd::getAtt $resource bb:file]
            $resource delete

            }
        }
    }

    set f_handler [open /tmp/imsmanifest.xml w+]
    puts -nonewline $f_handler [$manifest asXML -indent 1 -escapeNonASCII]
    close $f_handler

    $doc delete
    file copy -force /tmp/imsmanifest.xml $tmp_dir/imsmanifest.xml
}
