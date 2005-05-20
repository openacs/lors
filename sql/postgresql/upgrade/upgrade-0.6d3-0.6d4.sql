ALTER TABLE ims_cp_manifest_class DROP CONSTRAINT ims_cp_manifest_class_pkey;
ALTER TABLE ims_cp_items ADD sort_order integer;
ALTER TABLE ims_cp_files DROP CONSTRAINT ims_cp_files_file_if_fk;
ALTER TABLE ims_cp_files ADD CONSTRAINT ims_cp_files_file_if_fk FOREIGN KEY (file_id) REFERENCES cr_revisions(revision_id) ON DELETE CASCADE;
