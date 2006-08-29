# packages/lors/tcl/lors-assessment-procs.tcl

ad_library {
    
    
    
    @author Natalia Perez Perez (nperper@it.uc3m.es)
    @creation-date 2004-11-22
    @arch-tag: 7a9f1aab-7fad-4916-b9d0-2328b7cc7334
    @cvs-id $Id$
}
namespace eval lors::assessment {}


ad_proc -public lors::assessment::ims_qti_register_assessment {
    {-tmp_dir:required}
    {-community_id:required}
} {
    Relation with assessment    

} {
   
    # Generate a random directory name
    set tmpdirectory [ns_tmpnam]
    # Create a temporary directory
    file mkdir $tmpdirectory

    # UNZIP the zip file in the temporary directory
    catch { exec unzip ${tmp_dir} -d $tmpdirectory } outMsg

    # Save the current package_id to restore when the assessment is
    # imported
    set current_package_id [ad_conn package_id]
    # Get the assessment package_id associated with the current
    # community
    # FIXME this is a hack until I figure out how to get the
    # package_id of the assessment of the current community
    ad_conn -set package_id [db_string get_assessment_package_id {}]
    
    # Read the content of the temporary directory
    foreach file_i [ glob -directory $tmpdirectory *{.xml}  ] {
	set assessment_id [as::qti::parse_qti_xml $file_i]
    }

    # Delete the temporary directory
    file delete -force $tmpdirectory

    # Restore the package_id
    ad_conn -set package_id $current_package_id

    set url_assessment "/assessment/assessment?assessment_id=$assessment_id"
    
    return $url_assessment
}

 