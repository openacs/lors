-- 
-- packages/lors/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql
-- 
-- @author Jonatan Tierno (jonatan@int.it.uc3m.es)
-- @creation-date 2005-02-24
-- @arch-tag: c62faf32-6b47-4f29-80aa-ea606bd0112e
-- @cvs-id $Id$
--

-- Adds the option to show a course with different presentation formats 
--

--create table with available presentation formats.
create table lors_available_presentation_formats (
	presentation_name 	varchar(100),
	folder_name		varchar(100),
	presentation_id		integer
);

insert into lors_available_presentation_formats values ('Classic style','delivery_clasico',1);
insert into lors_available_presentation_formats values ('E-LANE style','delivery',2);

comment on table lors_available_presentation_formats is '
This table stores the available presentation formats for the courses. Its contains the pretty name
for the format, an id, and the folder in packages/lorsm/www/ where the presentation is stored
by now, just two presentations, which we store on creation';

--Add field presentation_id to table imscp_organizations.
alter table ims_cp_manifests add presentation_id integer;

