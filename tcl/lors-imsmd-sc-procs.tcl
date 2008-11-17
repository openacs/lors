# packages/lors/tcl/lorsm-imsmd-sc-procs.tcl

ad_library {

    LORS metadata search procedures

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-21
    @arch-tag c74bf9d3-ec3b-423f-808b-fc41e6f32cc5
    @cvs-id $Id$
}


namespace eval lors::imsmd::sc {

    ad_proc mdrecord__datasource {
        {ims_md_id}
    } {
        @param ims_md_id Metadata Record Identifier
        @author Ernie Ghiglione (ErnieG@mm.st)
    } {

        # Get Object_id
        set object_id $ims_md_id


        # Get Titles
        # LOM General Title can have a bunch of titles in different
        # languages. We get them all here.
        set titles ""

        db_foreach title {
                select title_l, title_s
                from ims_md_general_title
                where ims_md_id = :ims_md_id} {

            if {![empty_string_p $title_l]} {
                append titles "$title_s ($title_l) "
            } else {
                append titles "$title_s "
            }
        }

        # Get content
        # we will pass LOM General description as content (we should
        # improve this a bit more in the future with feedback

        set descriptions ""

        db_foreach description {
                        select descrip_l, descrip_s
                        from ims_md_general_desc
                        where ims_md_id = :ims_md_id} {

            if {![empty_string_p $descrip_l]} {
                append descriptions "$descrip_s ($descrip_l) "
            } else {
                append descriptions "$descrip_s "
            }
        }

        # Get MIME
        # LOM is just text therefore..
        set mime "text/plain"

        # Get Keywords
        # LOM General Keywords

        set keywords ""
        db_foreach keyword {
                    select keyword_l, keyword_s
                    from ims_md_general_key
                    where ims_md_id = :ims_md_id} {
            if {![empty_string_p $keyword_l]} {
                append keywords "$keyword_s ($keyword_l) "
            } else {
                append keywords "$keyword_s "
            }
        }

        # Storage type
        set storage_type "text"

        # the contact of titles and descriptions is because the search
        # functionality only indexes content (for some reasons), so I
        # put the titles as well so they can be indexes too. Sames as
        # keywords, actually.

        set data_list [list object_id $object_id \
                            title $titles \
                            content [concat $titles $descriptions $keywords] \
                            mime $mime \
                            keywords $keywords \
                            storage_type $storage_type]
        array set datasource $data_list

        return [array get datasource]
    }

    ad_proc mdrecord__url {
        {ims_md_id}
    } {
        @param ims_md_id Metadata Record Identifier
        @author Ernie Ghiglione (ErnieG@mm.st)
    } {

        #   set url_stub [apm_package_url_from_id [apm_package_id_from_key "lorsm"]]
        #   set url "${url_stub}md/?ims_md_id=$ims_md_id"
        set url "/lorsm/md/?ims_md_id=$ims_md_id"

        return $url
    }
}


