ad_library {
    

    @creation-date 2003-10-13
    @author Ernie Ghiglione (ErnieG@mm.st)
    @cvs-id $Id$
}

#
#  Copyright (C) 2004 Ernie Ghiglione
#
#  This package is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  It is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

namespace eval lors::cr {}


ad_proc -public lors::cr::has_files {
    {-fs_dir:required}
} {
    Checks if the fs_dir has files. If that is the case,
    it returns the name of those files on a list.
    Note: this does not return directories! Use has_dirs for that

    @param fs_dir File System directory
} {
    set files [list]
     foreach f [glob -no complain [file join $fs_dir * ]] {
         set type [file type $f]
         switch $type {
             file {
                 lappend files $f
             }
         }
     }
    return $files
}


ad_proc -public lors::cr::has_dirs {
    {-fs_dir:required}
} {
    Checks if the fs_dir has directories. If that is the case,
    it returns the name of those dirs on a list.
    Note: this does not return file names! Use has_files for that

    @param fs_dir File System directory
} {
    set directories [list]
     foreach dir [glob -no complain [file join $fs_dir * ]] {
         set type [file type $dir]
         switch $type {
             directory {
                 lappend directories $dir
             }
         }
     }
    return $directories
}


ad_proc -public lors::cr::add_folder {
    {-folder_name:required}
    {-parent_id:required}
    {-strip_prefix {}}
} {
    Adds the folder to the CR

    @param folder_name Name of the folder
    @param parent_id Parent ID Folder where the folder will be created
    @param strip_prefix The prefix to remove from the filename (for expanded archives)
} {
    # pre-processing

    # strips the prefix
    if {![empty_string_p $strip_prefix]} {
        regsub "^$strip_prefix" $folder_name {} folder_name
    }

    # gets the user_id and IP
    set user_id [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]

    # strips out spaces from the name
    regsub -all { +} $folder_name {_} name
#    regsub -all { +} [string tolower $folder_name] {_} name

    #return [list $name $folder_name $parent_id $user_id $creation_ip]

    db_transaction {

        # create the folder

        set folder_id [db_exec_plsql folder_create {
            select lors__new_folder (:name, :folder_name, :parent_id, :user_id, :creation_ip);
            }]
	
    } on_error {
        ad_return_error "Error inserting folder" "The error was: $errmsg"
        ad_script_abort
    }
    return $folder_id
}

ad_proc -public lors::cr::add_files {
    {-parent_id:required}
    {-files:required}
    {-indb_p:required}
} {
    Adds a bunch of files to a folder in the CR
    Returns a list with full_path_to_file, mime-type, parent_id, 
    file_id, version_id, cr_file, file size.

    @param parent_id Folder's parent_id where the files will be put
    @param files All files for the parent_id folder come in one list
    @param indb_p Whether this file-storage instance (we are about to use) stores files in the file system or in the db
								     
} {

    # Get the user
    set user_id [ad_conn user_id]
    
    # Get the ip
    set creation_ip [ad_conn peeraddr]

    set retlist [list]
    foreach fle $files {

	regexp {[^//\\]+$} $fle filename
        # Get the filename part of the upload file
#        if { ![regexp {[^//\\]+$} $fle filename] } {
            # no match
#            set filename $fle
#        }
        
        # Get the title
        #if { [empty_string_p $title] } {
            set title $filename
        #}
    
        set mime_type [cr_filename_to_mime_type -create $fle]

        #return [list $filename $parent_id $user_id $creation_ip $mime_type]

        # insert file into the CR
        db_transaction {

            # create the file_id
#            set file_id [db_exec_plsql file_add {
#                select lors__new_lo (:filename, :parent_id, :user_id, :creation_ip);
#            }]
	    set description "uploaded using LORs"

	    # add file
	    set file_id [db_exec_plsql file_add {
            	    	select file_storage__new_file (
                   :title,                 -- title
                   :parent_id,             -- parent_id
                   :user_id,               -- creation_user
                   :creation_ip,           -- creation_ip
                    false                   -- indb_p
	                );	
		    }]

		# create the revision
		#            set version_id [db_exec_plsql new_version {
		#                select lors__new_lo_version (:filename, :filename, :mime_type, :file_id, :user_id, :creation_ip);
		#            }]

	    # add revision
	    set version_id [db_exec_plsql new_version {
			select file_storage__new_version (
                                :filename,              -- filename
                                :description,           -- description
                                :mime_type,             -- mime_type
                                :file_id,               -- item_id
                                :user_id,               -- creation_user
                                :creation_ip            -- creation_ip
                        );
            }]

	    # move the actual file into the CR
	    set cr_file [cr_create_content_file $file_id $version_id $fle]
	    # get the size
	    set file_size [cr_file_size $cr_file]
		
	    # update the file path in the CR and the size on cr_revisions
	    db_dml update_revi "update cr_revisions set content = '$cr_file', content_length = $file_size where revision_id = :version_id"

        }

        lappend retlist [list $fle $mime_type $parent_id $file_id $version_id $cr_file $file_size]
    }
    return $retlist
}