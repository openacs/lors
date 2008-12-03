<?xml version="1.0"?>
<queryset>

    <fullquery name="callback::getGeneralInfo::impl::lorsm.my_query">
        <querytext>
            select count(1) as result
            from (
                select distinct l.course_id
                from lorsm_student_track l
                where l.community_id=:comm_id
                group by l.course_id) as t
        </querytext>
    </fullquery>

</queryset>
