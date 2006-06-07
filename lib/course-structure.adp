
<table class="list" cellpadding="3" cellspacing="1" width="70%">
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
        #lorsm.Course_Information#
        </th>
    </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Course_Name#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0; font-weight: bold;">
                <a href="@folder@">@course_name;noquote@</a>
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Version#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                  <if @version@ eq "0">
                       @version_msg;noquote@
                  </if>
                  <else>
                       @version;noquote@ Course Versions
                  </else>
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Metadata#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
         	<if @man_metadata@ eq "Yes">
                   <if @lorsm_p@>
	              <a href="md/?ims_md_id=@man_id@">#lorsm.Yes#</a>
                   </if>
                   <else>
                      #lorsm.Yes#
                   </else>
                </if>
	        <else>
                  #lorsm.No#
                </else>
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Identifier#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @identifier@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Is_SCORM#
              </td>
              <td 
         	<if @isscorm@ eq "Yes">
	           #lorsm.lt_classlist_stylefont-w#
                </if>
	        <else>
                   class="list"
                </else>
                valign="top" align="left">@isscorm;noquote@
                 </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Storage_Folder#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                <a href="@folder@">@instance@</a>
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Created_By#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @created_by@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Date#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @creation_date;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Submanifests#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @submanifests@
              </td>
          </tr>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Status#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                <if @isenabled@ eq t>
                 <b>#lorsm.Enabled#</b>
                </if>
                <else>
                 <font color="red"><b>#lorsm.Disabled#</b></font>
                </else>
                     <div style="float: right;">
	                  <a href="@enabler_url@" class="button">#lorsm.Change#</a>
                     </div>
              </td>
          </tr>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                #lorsm.Trackable#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                <if @istrackable@ eq t>
                 <b>#lorsm.Yes#</b>
                </if>
                <else>
                 <b>#lorsm.No#</b>
                </else>
                     <div style="float: right;">
	                  <a href="@tracker_url@" class="button">#lorsm.Change#</a>
                     </div>
              </td>
          </tr>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Is_shared#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                <if @isshared@ eq t>
	         <font color="green"><b>#lorsm.Shared#</b></font>
                </if>
                <else>
                 <font color="red"><b>#lorsm.Not_Shared#</b></font>
                </else>
                     <div style="float: right;">
	                  <a href="@sharer_url@" class="button">#lorsm.Change#</a>
                     </div>
              </td>
          </tr>
              <tr class="list-odd last">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                #lorsm.Course#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                 <b>@format_pretty_name@</b>
                 <div style="float: right;">
	             <a href="@formater_url@" class="button">#lorsm.Change#</a>
                 </div>
              </td>
          </tr>
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
         #lorsm.Organizations#
        </th>
    </tr>
              <tr class="list-odd">
              <td  valign="top" style="background-color: #f0f0f0; font-weight: bold;" colspan="2">

              </td>
          </tr>
              <tr class="list-odd">
              <td  valign="top" style="background-color: #f0f0f0;
          font-weight: bold;" colspan="2">
          <formtemplate style="inline" id="add-new"></formtemplate>
          @orgs_list;noquote@
              </td>
          </tr>
</table>




