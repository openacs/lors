-- IMS Content Packaging Package
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

-- And

-- SCORM 1.2 Specs
DROP FUNCTION ims_manifest__new(int4, varchar, varchar, varchar, varchar, bool, int4, bool, int4, int4, timestamptz, int4, varchar, int4, int4, varchar);
DROP FUNCTION ims_item__new(int4, int4, varchar, varchar, bool, varchar, varchar, int4, bool, varchar, varchar, varchar, varchar, varchar, varchar, varchar, timestamptz, int4, varchar, int4);
DROP FUNCTION ims_organization__new(int4, int4, varchar, varchar, varchar, bool, timestamptz, int4, varchar, int4);
DROP FUNCTION ims_resource__new(int4, int4, varchar, varchar, varchar, varchar, bool, timestamptz, int4, varchar, int4);

DROP FUNCTION ims_manifest__delete(int4);
DROP FUNCTION ims_organization__delete(int4);
DROP FUNCTION ims_item__delete(int4);
DROP FUNCTION ims_resource__delete(int4);

-- ims_cp_item_to_resource table
DROP FUNCTION ims_cp_item_to_resource__new(int4, int4);
DROP FUNCTION ims_dependency__new(int4, int4, varchar);
DROP FUNCTION ims_dependency__delete(int4);
DROP FUNCTION ims_file__new(int4, int4, varchar, varchar, bool);


-- function name
DROP FUNCTION ims_item__name(int4);

-- Remove entry from acs_object_types
delete from acs_object_types where object_type = 'ims_item';

