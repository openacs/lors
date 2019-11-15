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

namespace eval lors::imscp::bb {}

ad_proc -public lors::imscp::bb::getTitle {
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

ad_proc -public lors::imscp::bb::getDescription {
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

ad_proc -public lors::imscp::bb::getDates {
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
                    [lors::imsmd::getAtt $created value] \
                    [lors::imsmd::getAtt $updated value]]
    } else {
        return ""
    }
}

ad_proc -public lors::imscp::bb::getFlags {
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

ad_proc -public lors::imscp::bb::getNavigationItems {
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

ad_proc -public lors::imscp::bb::getOriginInfo {
    -name:required
    -node:required
} {
    Gets the Blackboard Info from a Blackboard course

    @option name Name of the attribute to get
    @option node XML node
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    set flags_node [$node child all ORIGININFO]
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

ad_proc -public lors::imscp::bb::getUsers {
    -file:required
} {
    Gets the Blackboard users from the XML resource file where the user info is.
    Returns a list of user attributes

    @option file File and filepath to XML file
    @author Ernie Ghiglione (ErnieG@mm.st)
} {

    set docx [dom parse [::tdom::xmlReadFile $file]]
    set usersnode [$docx documentElement]

    set userlist [list]
    set emails [list]
    foreach user [$usersnode child all USER] {
        set user_id [$user getAttribute id]
        set login_id [[$user getElementsByTagName LOGINID] getAttribute value]
        set passphrase [[$user getElementsByTagName PASSPHRASE] getAttribute value]
        set last_names [[$user getElementsByTagName FAMILY] getAttribute value]
        set first_names [[$user getElementsByTagName GIVEN] getAttribute value]
        set email [[$user getElementsByTagName EMAIL] getAttribute value]

        # For testing purpose only... has to be removed later
        set email $login_id@box.com

        set creation_date [[$user getElementsByTagName CREATED] getAttribute value]
        set updated_date [[$user getElementsByTagName UPDATED] getAttribute value]
        set active [[$user getElementsByTagName ISAVAILABLE] getAttribute value]
        set role_value [string tolower [
            [$user getElementsByTagName ROLE] getAttribute value]]

        switch $role_value {
            instructor {
                set role "professor"
            } default {
                set role "student"
            }
        }

        set role_description [
            [$user getElementsByTagName ROLE] getAttribute description]

        lappend userlist [list  "user_id" $user_id \
                                "login_id" $login_id \
                                "passphrase" $passphrase \
                                "last_names" $last_names \
                                "first_names" $first_names \
                                "email" $email \
                                "creation_date" $creation_date \
                                "updated_date" $updated_date \
                                "active" $active \
                                "role" $role \
                                "role_description" $role_description]
    }
    return $userlist
}

