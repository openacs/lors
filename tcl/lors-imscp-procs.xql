<?xml version="1.0"?>

<queryset>

    <fullquery name="lors::imscp::item_get_identifier.get_indentifier">
        <querytext>
            select r.identifier
            from ims_cp_resources r, ims_cp_items_to_resources i
            where i.ims_item_id = :ims_item_id
                and r.res_id = i.res_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_add.get_isshared">
        <querytext>
            select im.isshared
            from ims_cp_manifests im
            where im.man_id = ( select live_revision
                                from cr_items
                                where item_id = :version_id )
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_add.new_manifest">
        <querytext>
            select ims_manifest__new
                ( :course_name, :identifier, :version, :orgs_default, :hasmetadata,
                    :parent_man_id, :isscorm, :content_folder_id, :fs_package_id,
                    current_timestamp, :user_id, :creation_ip, :package_id,
                    :community_id, :revision_id, :isshared,
                    :course_presentation_format )
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::organization_add.new_organization">
        <querytext>
            select ims_organization__new
                ( :org_id, :man_id, :identifier, :structure, :title,
                    :hasmetadata, current_timestamp, :user_id, :creation_ip,
                    :package_id, :revision_id )
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::organization_delete.delete_organization">
        <querytext>
            select ims_organization__delete (:org_id)
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.get_files">
        <querytext>
            select item_id
            from cr_revisions cr, ims_cp_files f, ims_cp_resources r
            where f.res_id=r.res_id
                and r.man_id=:man_id
                and cr.revision_id=f.file_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.get_items">
        <querytext>
            select cr.item_id
            from cr_revisions cr, ims_cp_items i, ims_cp_items_to_resources ir, ims_cp_resources r
            where r.man_id=:man_id
                and r.res_id=ir.res_id
                and i.ims_item_id=ir.ims_item_id
                and cr.revision_id=i.ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.delete_map">
        <querytext>
            delete from ims_cp_items_map
            where ims_item_id in (select revision_id
                                    from cr_revisions
                                    where item_id=:item_id)
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.delete_map_2">
        <querytext>
            delete from ims_cp_items_map
            where org_id in (select revision_id
                                from cr_revisions
                                where item_id=:org_item_id)
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.delete_manifest_class">
        <querytext>
            delete
            from ims_cp_manifest_class
            where man_id=:man_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.delete_cmi">
        <querytext>
            delete
            from lorsm_cmi_core
            where man_id=:man_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.delete_track">
        <querytext>
            delete
            from lorsm_student_track
            where course_id = :man_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.get_org">
        <querytext>
            select item_id
            from cr_revisions, ims_cp_organizations
            where revision_id=org_id
                and man_id=:man_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::manifest_delete.get_res">
        <querytext>
            select item_id
            from cr_revisions, ims_cp_resources
            where revision_id=res_id
                and man_id=:man_id
        </querytext>
    </fullquery>


    <fullquery name="lors::imscp::item_add.new_item">
        <querytext>
            select ims_item__new
                ( :item_id, :org_id, :identifier, :identifierref,
                    :isvisible, :parameters, :title, :parent_item, :hasmetadata,
                    :prerequisites_t, :prerequisites_s, :type, :maxtimeallowed,
                    :timelimitaction, :datafromlms, :masteryscore, current_timestamp,
                    :user_id, :creation_ip, :package_id, :revision_id )
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::item_add.get_max">
        <querytext>
            select coalesce(max(sort_order)+1,1)
            from ims_cp_items
            where org_id=:org_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::item_add.set_sort_order">
        <querytext>
            update ims_cp_items
            set sort_order = :next_sort_order
            where ims_item_id = :item_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::item_delete.delete_item">
        <querytext>
            select ims_item__delete (:item_id)
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::resource_add.new_resource">
        <querytext>
            select ims_resource__new
                ( :res_id, :man_id, :identifier, :type, :href, :scorm_type,
                    :hasmetadata, current_timestamp, :user_id, :creation_ip,
                    :package_id, :revision_id )
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::resource_delete.delete_resource">
        <querytext>
            select ims_resource__delete (:res_id)
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::item_to_resource_add.item_to_resources_add">
        <querytext>
            select  ims_cp_item_to_resource__new (:item_id, :res_id)
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::dependency_add.dependency_add">
        <querytext>
            select  ims_dependency__new (:dep_id, :res_id, :identifierref )
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::dependency_delete.delete_resource">
        <querytext>
            select ims_dependency__delete (:dep_id)
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::file_add.file_ex">
        <querytext>
            select file_id
            from ims_cp_files
            where file_id = :file_id
                and res_id = :res_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::file_add.file_add">
        <querytext>
            select ims_file__new (:file_id, :res_id, :pathtofile, :filename, :hasmetadata)
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::item_add_from_object.get_object">
        <querytext>
            select object_type, title
            from acs_objects
            where object_id=:object_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::item_add_from_object.set_sort_order">
        <querytext>
            update ims_cp_items
            set sort_order = (  select coalesce(max(sort_order),0)
                                from ims_cp_items
                                where parent_item=:parent_item) + 1
            where ims_item_id=:item_id
        </querytext>
    </fullquery>

    <fullquery name="lors::imscp::resource_add_from_object.get_object">
        <querytext>
            select object_type, title
            from acs_objects
            where object_id=:object_id
        </querytext>
    </fullquery>

</queryset>
