--
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- @creation-date 12-NOV-2003
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

-- IMS Metadata 1.2.1 Compliant
-- http://www.imsglobal.org/metadata/imsmdv1p2p1/imsmd_infov1p2p1.html

create or replace function ims_md_general__new (integer,varchar,varchar,varchar,varchar,varchar,varchar)
returns integer as '
declare
  p_ims_md_id               alias for $1;
  p_title_l                 alias for $5;
  p_title_s                 alias for $6;
  p_structure_s             alias for $7;
  p_structure_v             alias for $8;
  p_agg_level_s             alias for $9;
  p_agg_level_v             alias for $10;
begin
    -- inserts into 
	insert into ims_md_general
	  (ims_md_id, title_l, title_s, structure_s, structure_v, agg_level_s, agg_level_v)
	values
	  (p_ims_md_id, p_title_l, p_title_s, p_structure_s, p_structure_v, p_agg_level_s, p_agg_level_v);

	return p_ims_md_id;

end;' language 'plpgsql';
