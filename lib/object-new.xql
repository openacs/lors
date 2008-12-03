<?xml version="1.0"?>
<queryset>

    <fullquery name="get_assessments">
        <querytext>
            select o.title,a.assessment_id
            from as_assessments a, cr_items i, acs_objects o
            where o.object_id=a.assessment_id
                and i.latest_revision=a.assessment_id
                and o.package_id=:assessment_package_id
        </querytext>
    </fullquery>

    <fullquery name="get_org_id">
        <querytext>
            select org_id
            from ims_cp_organizations
            where man_id=:man_id
        </querytext>
    </fullquery>

    <fullquery name="get_folder_id">
        <querytext>
            select parent_id
            from cr_items
            where latest_revision=:org_id
        </querytext>
    </fullquery>

    <fullquery name="get_sections">
        <querytext>
            select a.item_id as section_item_id,a.name,a.title
            from cr_items ci, as_sectionsx a, as_assessment_section_map m
            where m.assessment_id=:existing_object
                and a.section_id=m.section_id
                and ci.latest_revision=m.assessment_id
        </querytext>
    </fullquery>

    <fullquery name="section_exists">
        <querytext>
            select res_id
            from ims_cp_resources
            where identifier=:section_item_id
                and man_id=:man_id
        </querytext>
    </fullquery>

    <fullquery name="item_exists">
        <querytext>
            select ims_item_id as item_id
            from ims_cp_items
            where org_id=:org_id
                and identifier='as_sections_' || :section_item_id
        </querytext>
    </fullquery>

    <fullquery name="res_exists">
        <querytext>
            select res_id
            from ims_cp_resources
            where identifier=:existing_object
                and man_id=:man_id
        </querytext>
    </fullquery>

    <fullquery name="item_exists_2">
        <querytext>
            select ims_item_id
            from ims_cp_items
            where org_id=:org_id
                and identifier='::xowiki::Page_' || :existing_object
        </querytext>
    </fullquery>

</queryset>
