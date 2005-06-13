ad_library {
    Callback contract definitions for lors.

    @author Eduardo Pérez Ureta (eduardo.perez@uc3m.es)
    @creation-date 2005-05-16
    @cvs-id $Id$
}

ad_proc -public -callback lors::import {
    -res_type
    -res_href
    -tmp_dir
    -community_id
} {
    <p>Returns the relative url for the resource.</p>

    @return a list with one element, the relative url for the resource

    @author Eduardo Pérez Ureta (eduardo.perez@uc3m.es)
} -
