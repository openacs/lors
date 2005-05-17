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
\i lors-imsmd-sc-create.sql

