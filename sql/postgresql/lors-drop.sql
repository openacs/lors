-- lors data model
--
-- @author Nima Mazloumi (mazloumi@uni-mannheim.de)
-- @creation-date 6 Jan 2004

--
--  Copyright (C) 2004 Nima Mazloumi
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

-- Removes the procs that creates folder to store LOs
DROP FUNCTION lors__new_folder(varchar, varchar, int4, int4, varchar);

-- Deletes folder
DROP FUNCTION lors__delete_folder(int4);

-- loads IMS Metadata Data Model
\i lors-imscp-package-drop.sql
\i lors-imsmd-sc-drop.sql
\i lors-imscp-drop.sql
\i lors-imsmd-drop.sql

