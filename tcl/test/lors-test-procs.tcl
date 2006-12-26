# 

ad_library {
    
    Test lorsm-manifest procs
    
    @author devopenacs5 (devopenacs5@www)
    @creation-date 2005-08-20
    @arch-tag: /usr/local/bin/bash: line 1: uuidgen: command not found
    @cvs-id $Id$
}

aa_register_case lors_manifest {
    lors ims manifest test
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
	    if {[set man_id [db_string get_man_id {} -default ""]] ne ""} {

		lors::imscp::manifest_delete -man_id $man_id -delete_all t
		set man_id ""
	    }
	    if {[set folder_id [db_string get_folder_id {} -default ""]] ne ""} {
		content::folder::delete -folder_id $folder_id
		set folder_id ""
	    }
            set folder_id [content::folder::new -name "__lors_test__"]
	    set resources_folder_id [content::folder::new -name "__lors_test_resources__"]
	    set orgs_folder_id [content::folder::new -name "__lors_test_orgs__"]
	    set items_folder_id [content::folder::new -name "__lors_test_items__"]
            content::folder::register_content_type \
                -folder_id $folder_id \
                -content_type content_revision \
                -include_subtypes t
            content::folder::register_content_type \
                -folder_id $items_folder_id \
                -content_type content_revision \
                -include_subtypes t
            content::folder::register_content_type \
                -folder_id $resources_folder_id \
                -content_type content_revision \
                -include_subtypes t
            content::folder::register_content_type \
                -folder_id $orgs_folder_id \
                -content_type content_revision \
                -include_subtypes t
	    aa_log "folder_id='${folder_id}'"
            # get fs_package_id (where?)
            set fs_package_id ""
            # get package_id
            set __package_id [db_string get_package {}]
            # get community_id
	    set community_id [db_string get_community_id {}]
            # create a new manifest
            set man_id \
		[lors::imscp::manifest_add \
		     -man_id "" \
		     -identifier "__identifier__" \
		     -course_name "__test_course__" \
		     -version "__version__" \
		     -orgs_default "__orgs_default__" \
		     -hasmetadata f \
		     -isscorm f \
		     -folder_id $folder_id \
		     -fs_package_id $fs_package_id \
		     -package_id $__package_id \
		     -community_id $community_id]
                

            # create organization
            set org_id \
		[lors::imscp::organization_add \
		     -man_id $man_id \
		     -identifier "__identifier__" \
		     -structure "__structure__" \
		     -title "__title__" \
		     -hasmetadata "f" \
		     -package_id $__package_id \
		     -org_folder_id $orgs_folder_id]

            # create some resources
            set res_id \
                [lors::imscp::resource_add \
		     -man_id $man_id \
		     -identifier "res__identifier__" \
		     -type "__type__" \
		     -href "__href__" \
		     -scorm_type "__scorm_type__" \
		     -hasmetadata f \
		     -package_id $__package_id \
		     -res_folder_id $resources_folder_id]
            
            # create some items
	    set item_id [lors::imscp::item_add \
		-org_id $org_id \
		-identifier "__identifier__" \
		-identifierref "__identifier_href__" \
		-isvisible t \
		-parameters "__parameters__" \
		-title "__title__" \
		-hasmetadata f \
		-prerequisites_t "__prereq_t__" \
		-prerequisites_s "__prereq_s__" \
		-type "__type__" \
		-maxtimeallowed "__maxtimeallowed__" \
		-timelimitaction "__timelimitaction__" \
		-datafromlms "__datafromlms__" \
		-masteryscore "__masteryscore__" \
		-package_id $__package_id \
			     -itm_folder_id $items_folder_id]

            # create some files
            set file_id \
                [package_exec_plsql \
                     -var_list [list \
                                    [list name "__content_item_name__"] \
                                    [list parent_id $folder_id] \
                                    [list content_type "file_storage_object"] \
                                    [list title "__title__"]] \
                    content_item new]
	    set file_rev_id [content::item::get_latest_revision -item_id $file_id]
            db_exec_plsql file {}

            # create item_to_resource mapping
            db_dml i_to_r {}

            # create student_tracking
            
            # create cmi_core (whatever that is)
            
            # create some metadata

            # try to delete the whole couse
            lors::imscp::manifest_delete -man_id $man_id -delete_all t
        }
    aa_false "Manifest $man_id deleted" [db_0or1row get_man {}]
}

aa_register_case lors_scorm_1_2 {
    lors ims manifest test
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
	    set folder_name [ns_mktemp lors_folderXXXXXX]
	    set folder_id [content::folder::new -name $folder_name]
	    aa_log "Created folder $folder_name '${folder_id}'"
	    aa_log "[db_string q {}]" 
	    aa_log "[db_exec_plsql q2 {}]"
            content::folder::register_content_type \
                -folder_id $folder_id \
                -content_type content_revision \
                -include_subtypes t	
            content::folder::register_content_type \
                -folder_id $folder_id \
                -content_type content_folder \
                -include_subtypes t	
	    set format_id [db_string get_format_id {} -default ""]
	    set root_dir [acs_root_dir]/packages/lors/tcl/test/Courses/
	    set course_id 1
	    set indp_p 0
	    set fs_package_id [site_node::instantiate_and_mount \
				   -node_name [ns_mktemp fs_nodeXXXXXX] \
				   -package_key file-storage]
	    aa_log "FS Package ID = '${fs_package_id}'"

	    set community_id [db_string get_community_id {}]
	    
	    foreach fname [list LMSTestCourse01 LMSTestCourse02] {
		set course_name [ns_mktemp lors_courseXXXXXX]
		set tmp_dir ${root_dir}/${course_name}
		file mkdir $tmp_dir
		exec /usr/bin/unzip ${root_dir}${fname}.zip -d ${tmp_dir}

		aa_true "Course ${fname} exists in filesystem" [file exists $tmp_dir]
		set vars [list folder_id $folder_id format_id $format_id tmp_dir $tmp_dir course_id $course_id course_name $course_name indb_p 0 fs_package_id $fs_package_id __test 1 community_id $community_id]
		set status [catch {template::adp_include /packages/lorsm/www/course-add-3 $vars} errmsg]
#		template::adp_include /packages/lorsm/www/course-add-3 $vars

		aa_false "Imported Course $fname" $status
		aa_log "Results $errmsg"
	    }
	    aa_log "Imported [db_list get_contents {}]"
	}
   
}

aa_register_case lors_scorm_check {
    Check if a manifest is scorm compliant
} {
    aa_run_with_teardown \
	-rollback \
	-test_code {
	    set xml {<?xml version = "1.0"?>
<manifest identifier="LMSTestCourse01_Manifest" version="1.2"
       xmlns="http://www.imsproject.org/xsd/imscp_rootv1p1p2"
       xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.imsproject.org/xsd/imscp_rootv1p1p2 imscp_rootv1p1p2.xsd
                           http://www.imsglobal.org/xsd/imsmd_rootv1p2p1 imsmd_rootv1p2p1.xsd
                           http://www.adlnet.org/xsd/adlcp_rootv1p2 adlcp_rootv1p2.xsd">

   <organizations default = "Course001">
      <organization identifier = "Course001">
         <title>LMS Test Suite - Course 1</title>
         <item identifier="I_LESSON01">
            <title>LMS Test Suite - Lesson 1</title>
            <item identifier="I_SCO1" identifierref="SCO01">
               <title>LMS Test Suite - SCO 1</title>
               <adlcp:datafromlms>SCO1LaunchData</adlcp:datafromlms>
            </item>
            <item identifier = "I_SCO2" identifierref="SCO02">
               <title>LMS Test Suite - SCO 2</title>
               <adlcp:prerequisites type = "aicc_script">I_SCO1</adlcp:prerequisites>
            </item>
            <item identifier = "I_SCO3" identifierref="SCO03">
               <title>LMS Test Suite - SCO 3</title>
               <adlcp:prerequisites type = "aicc_script">I_SCO2</adlcp:prerequisites>
            </item>
            <item identifier = "I_SCO4" identifierref="SCO04">
               <title>LMS Test Suite - SCO 4</title>
               <adlcp:prerequisites type = "aicc_script">I_SCO3</adlcp:prerequisites>
            </item>
            <item identifier = "I_SCO5" identifierref="SCO05">
               <title>LMS Test Suite - SCO 5</title>
               <adlcp:prerequisites type = "aicc_script">I_SCO4</adlcp:prerequisites>
               <adlcp:maxtimeallowed>00:00:05</adlcp:maxtimeallowed>
               <adlcp:timelimitaction>continue,message</adlcp:timelimitaction>
               <adlcp:masteryscore>80</adlcp:masteryscore>
            </item>
            <item identifier = "I_SCO6" identifierref="SCO06">
               <title>LMS Test Suite - SCO 6</title>
               <adlcp:prerequisites type = "aicc_script">I_SCO5</adlcp:prerequisites>
            </item>
            <item identifier = "I_SCO7" identifierref="SCO07">
               <title>LMS Test Suite - SCO 7</title>
               <adlcp:prerequisites type = "aicc_script">I_SCO6</adlcp:prerequisites>
            </item>
            <item identifier = "I_SCO8" identifierref="SCO08">
               <title>LMS Test Suite - SCO 8</title>
               <adlcp:prerequisites type = "aicc_script">I_SCO7</adlcp:prerequisites>
            </item>
            <item identifier = "I_SCO9" identifierref="SCO09">
               <title>LMS Test Suite - SCO 9</title>
               <adlcp:prerequisites type = "aicc_script">I_SCO8</adlcp:prerequisites>
               <adlcp:maxtimeallowed>02:00:00.00</adlcp:maxtimeallowed>
               <adlcp:timelimitaction>continue,message</adlcp:timelimitaction>
               <adlcp:datafromlms>SCORMTROOPERS</adlcp:datafromlms>
               <adlcp:masteryscore>80</adlcp:masteryscore>
            </item>
            <metadata>
               <schema>ADL SCORM</schema>
               <schemaversion>1.2</schemaversion>
               <adlcp:location>Lesson01/Lesson01.xml</adlcp:location>
            </metadata>
         </item>
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>LMSTestCourse01.xml</adlcp:location>
         </metadata>

      </organization>
   </organizations>
   <resources>

      <resource identifier="SCO01" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco01.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco01.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco01.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="SCO02" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco%2002.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco%2002.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco%2002.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="SCO03" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco03.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco03.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco03.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="SCO04" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco04.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco04.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco04.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="SCO05" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco05.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco05.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco05.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="SCO06" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco06.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco06.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco06.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="SCO07" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco07.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco07.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco07.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="SCO08" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco08.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco08.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco08.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="SCO09" type="webcontent"
                adlcp:scormtype="sco" href="Lesson01/Resources/sco09.htm">
         <metadata>
            <schema>ADL SCORM</schema>
            <schemaversion>1.2</schemaversion>
            <adlcp:location>Lesson01/Meta-data/sco09.xml</adlcp:location>
         </metadata>
         <file href="Lesson01/Resources/sco09.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="LMSTESTCOURSEJAR01"/>
      </resource>

      <resource identifier="LMSFNCTS01" type="webcontent"
                adlcp:scormtype="asset">
         <file href="Lesson01/Resources/lmsrtefunctions.js" />
      </resource>

      <resource identifier="LMSTESTCOURSEJAR01" type="webcontent"
                adlcp:scormtype="asset">
         <file href="Lesson01/Resources/LMSTestCourse.jar" />
      </resource>

   </resources>
</manifest>
	    }
	    

	    # open manifest file with tDOM
	    set doc [dom parse $xml]
	    # gets the manifest tree
	    set manifest [$doc documentElement]

	    set isSCORM [lors::imscp::isSCORM -node $manifest]
	    
	    aa_true "isscorm (${isSCORM})" $isSCORM

	    set metadata [lindex [$manifest getElementsByTagName metadata] 0]
	    aa_log "${metadata}"
	    set MetadataSchema ""
	    catch {set MetadataSchema [lindex [lindex [lors::imsmd::getMDSchema $metadata] 0] 0]} errmsg
	    aa_log "${MetadataSchema}"
	    aa_log [lors::imsmd::getMDSchema $metadata]
	}
}