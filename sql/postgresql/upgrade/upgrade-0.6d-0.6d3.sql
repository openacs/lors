-- 
-- packages/lors/sql/postgresql/upgrade/upgrade-0.6d-0.7d.sql
-- 
-- @author jopezku@gmail.com
-- @cvs-id $Id$
--

-- Adds the option to show a course with different presentation formats 
--

-- delete unused table

drop table lors_available_presentation_formats;

-- Course presentation formats

create table lorsm_course_presentation_formats (
	format_id  			integer
						constraint lorsm_cpformats_pk
						primary key,
	format_pretty_name	varchar(200),
	format_name 		varchar(100),
	folder_name			varchar(100)
);

create index lorsm_cpformats__format_id_idx on lorsm_course_presentation_formats (format_id);

comment on table lorsm_course_presentation_formats is '
This table stores the available presentation formats for the courses. Its contains the pretty name
for the format, an id, and the folder in packages/lorsm/www/ where the presentation format is stored.
Currently just tree presentation formats exists, delivery, delivery-wihout-index and delivery-bottom-bar, 
which we store on creation';

--Change presentation_id to format_id.
alter table ims_cp_manifests rename column presentation_id to course_presentation_format;


-- Include new field in creation function
create or replace function ims_manifest__new (
    integer,   -- manifest_id
    varchar,   -- course_name
    varchar,   -- identifier
    varchar,   -- version
    varchar,   -- orgs_default
    boolean,   -- hasmetadata
    integer,   -- parent_man_id
    boolean,   -- isscorm 
    integer,   -- folder_id 
    integer,   -- fs_package_id
    timestamp with time zone, -- creation_date
    integer,   -- creation_user
    varchar,    -- creation_ip
    integer,    -- package_id
    integer,    -- community_id
    varchar,     -- class_key
	integer 	-- course_presentation_format
)
returns integer as '
declare
    p_man_id                		alias for $1;
    p_course_name           		alias for $2;
    p_identifier            		alias for $3;
    p_version               		alias for $4;
    p_orgs_default          		alias for $5;
    p_hasmetadata           		alias for $6;
    p_parent_man_id         		alias for $7;
    p_isscorm               		alias for $8;
    p_folder_id             		alias for $9;
    p_fs_package_id         		alias for $10;
    p_creation_date         		alias for $11;
    p_creation_user         		alias for $12;
    p_creation_ip           		alias for $13;
    p_package_id            		alias for $14;
    p_community_id          		alias for $15;
    p_class_key            	 		alias for $16;
	p_course_presentation_format	alias for $17;

    v_man_id       integer;
begin
        v_man_id := acs_object__new (
                p_man_id,               -- object_id
                ''ims_manifest'',       -- object_type
                p_creation_date,        -- creation_date
                p_creation_user,        -- creation_user
                p_creation_ip,          -- creation_ip
                p_package_id,           -- context_id
                ''t''                   -- security_inherit_p
        );

        insert into ims_cp_manifests
        (man_id, course_name, identifier, version, orgs_default, hasmetadata, parent_man_id, isscorm, folder_id, fs_package_id, course_presentation_format)
        values
        (v_man_id, p_course_name, p_identifier, p_version, p_orgs_default, p_hasmetadata, p_parent_man_id, p_isscorm, p_folder_id, p_fs_package_id, p_course_presentation_format);

	-- now we add it to the manifest_class relation table

	insert into ims_cp_manifest_class
	(man_id, lorsm_instance_id, community_id, class_key, isenabled, istrackable)
	values
	(v_man_id, p_package_id, p_community_id, p_class_key, ''t'', ''f'');


        return v_man_id;
end;
' language 'plpgsql';




