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


#Callbacks for application-track

ad_proc -callback application-track::getApplicationName -impl lorsm {} { 
        callback implementation 
    } {
        return "lorsm"
    }    
    
ad_proc -callback application-track::getGeneralInfo -impl lorsm {} { 
        callback implementation 
    } {
	db_1row my_query {
    		select count(1) as result
			from (
				select distinct l.course_id
					from lorsm_student_track l
		    			where l.community_id=:comm_id	
		    			group by l.course_id) as t
	}
	
	return "$result"
    }
ad_proc -callback application-track::getSpecificInfo -impl lorsm {} { 
        callback implementation 
    } {
   	
	upvar $query_name my_query
	upvar $elements_name my_elements

	set my_query {
		select d.id,i.course_name,l.start_time,l.end_time
			from lorsm_student_track l, dotlrn_users d, ims_cp_manifests i
			where l.course_id IN
			 (
				select distinct l.course_id
					from lorsm_student_track l
		    			where l.community_id=:class_instance_id	
		    			group by l.course_id)
 			and l.user_id = d.user_id
 			and l.course_id = i.man_id
	}
		
	set my_elements ""

        return "OK"
    }
    