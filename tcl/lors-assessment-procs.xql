<?xml version="1.0"?>
<queryset>

<fullquery name="lors::assessment::ims_qti_register_assessment.get_assessment_package_id">      
	<querytext>
	select dotlrn_community_applets.package_id 
	from dotlrn_community_applets dca, apm_packages ap
	where dca.package_id=ap.package_id
	community_id = :community_id and package_key='assessment'
	</querytext>
</fullquery>

</queryset>