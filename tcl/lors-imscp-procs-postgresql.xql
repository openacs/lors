<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="lors::imscp::manifest_new.ims_manifest__new">
        <querytext>
            select ims_manifest__new
                ( :man_id, :identifier, :version, :orgs_default, :hasmetadata,
                    :parent_man_id, current_timestamp, :user_id, :creation_ip,
                    :package_id )
        </querytext>
    </fullquery>
</queryset>
