-- lors data model
--
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- @creation-date 6 Nov 2003
-- @cvs-id $Id$

--
--  Copyright (C) 2004 Ernie Ghiglione
--
--  This package is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  It is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--


-- Create Learning Object Content Type
select content_type__create_type (
       'learning_object',    -- content_type
       'content_revision',   -- supertype. 
       'Learning Object',    -- pretty_name
       'Learning Objects',   -- pretty_plural
       'lors_objects',       -- table_name
       'lo_id',	             -- id_column
       'lors__get_title'     -- name_method
);

-- Register attributes
-- lo_type: this could be: SCO/A, asset, etc
-- according to the scheme we use (SCORM, IMS, etc).
select content_type__create_attribute (
       'learning_object',    -- content_type
       'lo_type',            -- type of learning object
       'text',               -- data type
       'learning object type', -- pretty
       null,                 -- pretty plural
       null,                 -- sort order
       'file',               -- default 'f'
       'varchar(50)'         -- colum spec
);

-- If the learning object has metadata
-- Note: on the ims-md table we will record what the metadata
-- schema that we use. ie: IMS, Dublin Core, etc
select content_type__create_attribute (
       'learning_object',    -- content_type
       'has_metadata',       -- column name
       'boolean',            -- data type
       'has metadata',       -- pretty
       null,                 -- pretty plural
       null,                 -- sort order
       'f',                  -- default 'f'
       'boolean'             -- colum spec
);

-- Add a new LO function
create or replace function lors__new_lo(
       varchar,         -- cr_items.name%TYPE,
       integer,         -- cr_items.parent_id%TYPE,
       integer,         -- acs_objects.creation_user%TYPE,
       varchar         -- acs_objects.creation_ip%TYPE,
) returns integer as ' -- cr_items.item_id%TYPE
declare
        new_lo__title                 alias for $1;
        new_lo__folder_id             alias for $2;
        new_lo__user_id               alias for $3;
        new_lo__creation_ip           alias for $4;
        v_item_id                       integer;
begin

       v_item_id := content_item__new (
                    new_lo__title,            -- name
                    new_lo__folder_id,        -- parent_id
                    null,                     -- item_id (default)
                    null,                     -- locale (default)
                    now(),                    -- creation_date (default)
                    new_lo__user_id,          -- creation_user
                    new_lo__folder_id,        -- context_id
                    new_lo__creation_ip,      -- creation_ip
                    ''content_item'',         -- item_subtype (default)
                    ''learning_object'',      -- content_type 
                    null,                     -- title (default)
                    null,                     -- description
                    ''text/plain'',           -- mime_type (default)
                    null,                     -- nls_language (default)
                    null,                     -- text (default)
                    ''file''                  -- storage_type
                    );

        perform acs_object__update_last_modified(new_lo__folder_id,new_lo__user_id,new_lo__creation_ip);

        return v_item_id;

end;' language 'plpgsql';

-- Adds a new LO revision
create or replace function lors__new_lo_version (
       --
       -- Create a new version of a learning object
       -- Wrapper for content_revision__new
       --
       varchar,         -- cr_revisions.title%TYPE,
       varchar,         -- cr_revisions.description%TYPE,
       varchar,         -- cr_revisions.mime_type%TYPE,
       integer,         -- cr_items.item_id%TYPE,
       integer,         -- acs_objects.creation_user%TYPE,
       varchar          -- acs_objects.creation_ip%TYPE
) returns integer as '  -- cr_revisions.revision_id
declare
        new_version__filename           alias for $1;
        new_version__description        alias for $2;
        new_version__mime_type          alias for $3;
        new_version__item_id            alias for $4;
        new_version__creation_user      alias for $5;
        new_version__creation_ip        alias for $6;
        v_revision_id                   cr_revisions.revision_id%TYPE;
        v_folder_id                     cr_items.parent_id%TYPE;
begin
        -- Create a revision
        v_revision_id := content_revision__new (
                          new_version__filename,        -- title
                          new_version__description,     -- description
                          now(),                        -- publish_date
                          new_version__mime_type,       -- mime_type
                          null,                         -- nls_language
                          null,                         -- data (default)
                          new_version__item_id,         -- item_id
                          null,                         -- revision_id
                          now(),                        -- creation_date
                          new_version__creation_user,   -- creation_user
                          new_version__creation_ip      -- creation_ip
                          );

        -- Make live the newly created revision
        perform content_item__set_live_revision(v_revision_id);

        select cr_items.parent_id
        into v_folder_id
        from cr_items
        where cr_items.item_id = new_version__item_id;

        perform acs_object__update_last_modified(v_folder_id,new_version__creation_user,new_version__creation_ip);

        return v_revision_id;

end;' language 'plpgsql';


-- Delete a LO
create or replace function lors__delete_lo (
       integer          -- cr_items.item_id%TYPE
) returns integer as '
declare
        delete_lo__lo_id    alias for $1;
begin

        return content_item__delete(delete_lo__lo_id);

end;' language 'plpgsql';

-- Creates a folder to store LOs
create or replace function lors__new_folder(
       --

       --
       varchar,         -- cr_items.name%TYPE,
       varchar,         -- cr_folders.label%TYPE,
       integer,         -- cr_items.parent_id%TYPE,
       integer,         -- acs_objects.creation_user%TYPE,
       varchar          -- acs_objects.creation_ip%TYPE
) returns integer as '  -- cr_folders.folder_id%TYPE
declare
        new_folder__name              alias for $1;
        new_folder__folder_name       alias for $2;
        new_folder__parent_id         alias for $3;
        new_folder__creation_user     alias for $4;
        new_folder__creation_ip       alias for $5;
        v_folder_id                   cr_folders.folder_id%TYPE;
begin

        -- Create a new folder
        v_folder_id := content_folder__new (
                            new_folder__name,           -- name
                            new_folder__folder_name,    -- label
                            null,                       -- description
                            new_folder__parent_id,      -- parent_id
                            null,                       -- context_id (default)
                            null,                       -- folder_id (default)
                            now(),                      -- creation_date
                            new_folder__creation_user,  -- creation_user
                            new_folder__creation_ip     -- creation_ip
                            );

        -- register the standard content types
        -- JS: Note that we need to set include_subtypes
        -- JS: to true since we created a new subtype.
        PERFORM content_folder__register_content_type(
                        v_folder_id,            -- folder_id
                        ''content_revision'',   -- content_type
                        ''t'');                 -- include_subtypes (default)

        PERFORM content_folder__register_content_type(
                        v_folder_id,            -- folder_id
                        ''content_folder'',     -- content_type
                        ''t''                   -- include_subtypes (default)
                        );

        PERFORM content_folder__register_content_type(
                v_folder_id,            -- folder_id
                ''content_extlink'',    -- content_types
                ''t''                   -- include_subtypes
                );

        PERFORM content_folder__register_content_type(
                v_folder_id,            -- folder_id
                ''content_symlink'',    -- content_types
                ''t''                   -- include_subtypes
                );

        -- Give the creator admin privileges on the folder
        PERFORM acs_permission__grant_permission (
                     v_folder_id,                -- object_id
                     new_folder__creation_user,  -- grantee_id
                     ''admin''                   -- privilege
                     );

        return v_folder_id;

end;' language 'plpgsql';

-- Deletes folder
create or replace function lors__delete_folder(
       integer          -- cr_folders.folder_id%TYPE
) returns integer as '  -- 0 for success
declare
        delete_folder__folder_id        alias for $1;
begin
        return content_folder__delete(
                    delete_folder__folder_id  -- folder_id
                    );

end;' language 'plpgsql';


-- loads IMS Metadata Data Model
\i lors-imsmd-create.sql
\i lors-imscp-create.sql
\i lors-imscp-package-create.sql