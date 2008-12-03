
<table class="list" cellpadding="3" cellspacing="1" width="90%">
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">#lorsm.Course_Information#</th>
    </tr>

    <tr class="list-odd">
        <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%;" >#lorsm.Course_Name#</td>
        <td class="list" valign="top" style="background-color: #f0f0f0; font-weight: bold;">
            @course_name;noquote@(@identifier@)#lorsm.Course_Versions#<br />
            <a href="@rename_url@">#lors.Rename_Course#</a>
        </td>
    </tr>

    <tr class="list-even">
        <td class="list"  style="background-color: #e0e0e0; font-weight: bold; width:20%" >
            <a href="javascript:void(0)" onClick="document.getElementById('lors-advanced-course-structure').style.display='';">More Info</a>
        </td>
        <td class="list">&nbsp;</td>
    </tr>
</table>

<div id="lors-advanced-course-structure" style="display:none;">
    <table class="list" cellpadding="3" cellspacing="1" width="90%">
        <tr class="list-even">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%">#lorsm.Metadata#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0">
                <if @man_metadata@ eq "Yes">
                    <if @lorsm_p@><a href="md/?ims_md_id=@man_id@">#lorsm.Yes#</a></if>
                    <else>#lorsm.Yes#</else>
                </if>
                <else>#lorsm.No#</else>
            </td>
        </tr>

        <tr class="list-odd">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%">#lorsm.Is_SCORM#</td>
            <td <if @isscorm@ eq "Yes">#lorsm.lt_classlist_stylefont-w#</if>
                <else>class="list"</else>
                valign="top" align="left">@isscorm;noquote@
            </td>
        </tr>

        <tr class="list-even">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%">#lorsm.Storage_Folder#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0; width:80%;"><a href="@folder@">@instance@</a></td>
        </tr>

        <tr class="list-odd">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%;">#lorsm.Created_By#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0; width:80%;">@created_by@</td>
        </tr>

        <tr class="list-even">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%;">#lorsm.Date#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0; width:80%;">@creation_date;noquote@</td>
        </tr>

        <tr class="list-odd">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%;">#lorsm.Submanifests#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0; width:80%;">@submanifests@</td>
        </tr>

        <tr class="list-even">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%;">#lorsm.Status#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0; width:80%;">
                <if @isenabled@ eq t><b>#lorsm.Enabled#</b></if>
                <else><b style="color:red;">#lorsm.Disabled#</b></else>
                <div style="float: right;"><a href="@enabler_url@" class="button">#lorsm.Change#</a></div>
            </td>
        </tr>

        <tr class="list-odd">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">#lorsm.Trackable#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0">
                <if @istrackable@ eq t><b>#lorsm.Yes#</b>( <a href="tracking/?man_id=@man_id@">#lorsm.lt_Track_Students_Progre#</a> )</if>
                <else><b>#lorsm.No#</b></else>
                <div style="float: right;"><a href="@tracker_url@" class="button">#lorsm.Change#</a></div>
            </td>
        </tr>

        <tr class="list-even">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold; width:20%;">#lorsm.Is_shared#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0; width:80%;">
                <if @isshared@ eq t><b style="color:green;">#lorsm.Shared#</b></if>
                <else><b style="color:red;">#lorsm.Not_Shared#</b></else>
                <div style="float: right;"><a href="@sharer_url@" class="button">#lorsm.Change#</a></div>
            </td>
        </tr>

        <tr class="list-odd last">
            <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">#lorsm.Course#</td>
            <td class="list" valign="top" style="background-color: #f0f0f0">
                <b>@format_pretty_name@</b>
                <div style="float: right;"><a href="@formater_url@" class="button">#lorsm.Change#</a></div>
            </td>
        </tr>
    </table>
</div>

<if @extra_admin_html@ not nil>@extra_admin_html;noquote@</if>
<hr>
@orgs_list;noquote@
<listtemplate name="items"></listtemplate>
