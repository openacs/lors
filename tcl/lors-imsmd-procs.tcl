ad_library {

    IMS Metadata functions

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 13 Oct 2003
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

namespace eval lors::imsmd {

    ad_proc -public getAtt {doc attr_name} {
        getAtt Gets attributes for an specific element

        @param doc Document
        @param attr_name Attribute we want to fetch

    } {
        if {[$doc hasAttribute $attr_name] == 1} {
            $doc getAttribute $attr_name
        } else {
            return ""
        }
    }

    ad_proc -public HasPrefix {
        {tree}
    } {
        Checks if the XML node contains a namespace prefix
        returns prefix or returns "" if false.

        @param tree The node

    } {
        set prefix [$tree prefix]
        return $prefix
    }    
    
    ad_proc -public hasMetadata {
        {tree}
    } {
        Checks if the XML node contains a metadata element
        returns 1 if true; 0 if false.
        Later addition: checks also if the metadata record has 
        child nodes
    } {
        if { ![empty_string_p [$tree child all metadata]] } {
            if { [[$tree child all metadata] hasChildNodes] != 0 } {
                return 1
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    ad_proc -public getMDNode {
        {tree}
    } {
        Returns the metadata node

        @param tree The Node

    } {
        return [$tree child all metadata]
    }

    ad_proc -public getMDSchema {
        {tree}
    } {
        Gets the type of MD Schema used (if any)
        Returns 0 if not found or
        returns a list with 2 elements:
        \{Schema\} \{Schemaversion\}

        @param tree The Node

    } {
        if { [$tree hasChildNodes] == 1 } {
            set retlist [list]
            if { ![empty_string_p [$tree child all schema]] } {
                lappend retlist [getElement [$tree child all schema] asXML]
            }
            if { ![empty_string_p [$tree child all schemaversion]] } {
	    lappend retlist [getElement [$tree child all schemaversion]]
            }
            return $retlist
        } else {
            return [list 0 0]
        }
    }

    ad_proc -public getLOM {
        {tree}
        {dir}
    } {
        Gets the Node where LOM is and its prefix (if any)
        returns a list with two elements:
        \{LOM_Node\} \{prefix\}
        or if didn't find any, returns 0

        @param tree The Node.
        @param dir Directory where the course is.
        @author Ernie Ghiglione (ErnieG@mm.st).

    } {
        if { ![$tree hasChildNodes] == 0 } {
            if { ![empty_string_p [$tree child all lom]] } {
                set var_lom "lom"
                set prefix ""
                set lom [$tree child all $var_lom]
            } elseif { ![empty_string_p [$tree child all imsmd:lom]] } {
                set var_lom "imsmd:lom"
                set prefix  [[$tree child all imsmd:lom] prefix]
                set lom [$tree child all $var_lom]
            } elseif { ![empty_string_p [$tree child all record]] } {
                # used mostly for IMS Metadata 
                set var_lom "record"
                set prefix ""
                set lom [$tree child all $var_lom]
            } elseif { ![empty_string_p [$tree child all imsmd:record]] } {
                # used mostly for IMS Metadata 
                set var_lom "imsmd:record"
                set prefix [[$tree child all imsmd:record] prefix]
                set lom [$tree child all $var_lom]
            } elseif { ![empty_string_p [$tree child all adlcp:location]] } {
		dom parse [::tDOM::xmlReadFile $dir/[[$tree child all adlcp:location] text]] doc
		set lom [$doc documentElement]
                set prefix [$lom prefix]
            } else {
                set lom 0
                set prefix 0
            }
            return [list $lom $prefix]
        } else {
            return 0
        }
    }
    
    # xmlExtractor extras
    ad_proc -public xmlExtractor {
        {element}
        {tree}
        {prefix {}}
        {datatype 0}
        {att {}}
    } {
        XML Metadata extractor
        This is the key MD extractor.
        
        It uses some different datatypes to extract MD:

         datatype1 = langstrings
         datatype2 = source and values
         datatype3 = catalogentry
         datatype4 = date
         datatype5 = Vcards
         datatype6 = element + attributes
         datatype7 = element

        @param element
        @param tree
        @param prefix
        @param datatype 
        @param att
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { [empty_string_p $prefix] } {
            set md_g_title [$tree child all $element]
        } else {
            set md_g_title [$tree child all $prefix:$element]
        }
        if { ![empty_string_p $md_g_title] } {
            set retlist [list]
            if {$datatype == 1} {
                foreach one $md_g_title {
                    #gets langstrings
                    set retlist "$retlist [getLangStr $one $prefix]"
                }
                return $retlist
            } elseif {$datatype == 2} {
                foreach one $md_g_title {
                    #get sources and values
                    set retlist "$retlist [getSourceValue $one $prefix]"
                }
                return $retlist
            } elseif {$datatype == 3} {
                foreach one $md_g_title {
                    #get catalogentry
                    set retlist "$retlist  [getCatalogEntry $one $prefix]"
                }
                return $retlist
            } elseif {$datatype == 4} {
                foreach one $md_g_title {
                    #get date
                    set retlist "$retlist  [getDate $one $prefix]"
                }
                return $retlist
            } elseif {$datatype == 5} {
                foreach one $md_g_title {
                    #get person / Vcard
                    set retlist "$retlist [getVcard $one $prefix]"
                }
                return $retlist
            } elseif {$datatype == 6} {
                foreach one $md_g_title {
                    #get element attribute only.
                    set retlist "$retlist [getAtt $one $att]"
                }
                return $retlist
            } else {
                foreach one $md_g_title {
                    #get simple element
                    set retlist "$retlist [getElement $one $prefix $att]"
                }
                return $retlist
            }
        }
    
    }


    ### Datatypes ad_procedures
    
    ad_proc -public getLangStr {
        {tree}
        {prefix {}}
    } {
        Datatype LangString extractor

        @param tree Node
        @param prefix prefix (if any)
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set var "$prefix:langstring"
        } else {
            set var "langstring"
        }
        set aa [list]
        set ab [list]
        set mult 0
        foreach child [$tree child all $var] {
            #set aa "$aa | [$child localName] (xml:lang=[getAtt $child xml:lang])  [$child text]"
            # returns a list with lang and string (LangString)
            set aa [list [getAtt $child xml:lang] [$child text]]
            lappend ab $aa
            incr mult
        }
        if { $mult > 1} {
            return $ab
        } else {
            return $ab
        }
    }

    ad_proc -public getSourceValue {
        {tree}
        {prefix {}}
    } {
        Datatype Source&Value extractor

        @param tree Node
        @param prefix prefix (if any)
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set var_source "$prefix:source"
            set var_value  "$prefix:value"
        } else {
            set var_source "source"
            set var_value  "value"
        }
        set source [$tree child all $var_source]
        set sv [list]
        if { ![empty_string_p $source] } {
            #Gets all the langstrings
            set sv "$sv [getLangStr $source $prefix]"
        }
        set value [$tree child all $var_value]
        if { ![empty_string_p $value] } {
            #Gets all the langstrings
            set sv "$sv [getLangStr $value $prefix]"
        }
        return [list $sv]
    }


    ad_proc -public getCatalogEntry {
        {tree} 
        {prefix {}} 
    } {
        Datatype CatalogEntry extractor

        @param tree Node
        @param prefix prefix (if any)
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set var_catalog "$prefix:catalog"
            set var_entry  "$prefix:entry"
        } else {
            set var_catalog "catalog"
            set var_entry  "entry"
        }
        set catalog [$tree child all $var_catalog]
        set ce [list]
        if { ![empty_string_p $catalog] } {
            #Gets all the langstrings
            set ce "$ce [getElement $catalog $prefix]"
        }
        set entry [$tree child all $var_entry]
        if { ![empty_string_p $entry] } {
            #Gets all the langstrings
            set ce "$ce [lors::imsmd::getLangStr $entry $prefix]"
        }
        return [list $ce]
    }

    ad_proc -public getDate {
        {tree} 
        {prefix {}} 
    } {
        Datatype Date

        @param tree Node
        @param prefix prefix (if any)
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set var_datetime "$prefix:datetime"
            set var_description  "$prefix:description"
        } else {
            set var_datetime "datetime"
            set var_description  "description"
        }
        set datetime [$tree descendant all $var_datetime]
        set dt ""
        if { ![empty_string_p $datetime] } {
            #Gets all the langstrings
            set dt [getElement $datetime $prefix]
        }
        set description [$tree descendant all $var_description]
        if { ![empty_string_p $description] } {
            #Gets all the langstrings
            set dt "$dt [getLangStr $description $prefix]"
        }
        return $dt
    }



    ad_proc -public getElement {
        {tree} 
        {prefix {}} 
        {att {}} 
    } {
        Datatype Element extractor

        @param tree Node
        @param prefix prefix (if any)
        @param att Attribute
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $att] } {
            return [list "{[$tree text]} {[getAtt $tree $att]}"]
        } else {
            return [list [$tree text]]
        }
    }


    ad_proc -public getVcard {
        {tree}
        {prefix {}}
    } {
        Datatype Vcard

        @param tree Node
        @param prefix prefix (if any)
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set var_vcard "$prefix:vcard"
        } else {
            set var_vcard "vcard"
        }
        
        foreach child [$tree child all $var_vcard] {
            set aa "[$child text]"
        }
        return [list $aa]
    }
    
    ## Special Datatypes ad_procedures
    ad_proc -public getTaxon {
        {tree}
        {prefix {}}
    } {
        Special extraction of Taxonomies

        @param tree Node
        @param prefix prefix (if any)
        @author Ernie Ghiglione (ErnieG@mm.st)
    } {
        if { ![empty_string_p $prefix] } {
            set var_taxon $prefix:taxon
            
        } else {
            set var_taxon taxon
        }
        
        set taxon [$tree child all $var_taxon]
        
        if { ![empty_string_p $taxon]} {
            set taxons $taxon
            foreach one $taxon {
                if { ![empty_string_p [$one descendant all $var_taxon]] } {
                    set taxons "$taxons [getTaxon $one $prefix]"
                } 
                return $taxons
            }
        }
    }


    ad_proc -public getContribute {
        {tree} 
        {prefix {}} 
    } {
        Special extraction of Contributors

        @param tree Node
        @param prefix prefix (if any)
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set var_contribute "$prefix:contribute"
            set var_role  "$prefix:role"
            set var_centity "$prefix:centity"
            set var_date "$prefix:date"
        } else {
            set var_contribute "contribute"
            set var_role  "role"
            set var_centity "centity"
            set var_date "date"
        }
        set lom_lc_contribute [$tree child all $var_contribute]
        if { ![empty_string_p $lom_lc_contribute] } {
            set cont_list [list]
            foreach contribute [$tree child all $var_contribute] {
                set role [$contribute child all $var_role]
                if { ![empty_string_p $role] } {
                    set cont_x [xmlExtractor role $contribute $prefix 2]
                }
                set centity [$contribute child all $var_centity]
                if { ![empty_string_p $centity] } {
                    set cc [list]
                    foreach cent $centity {
                        set cc "$cc [xmlExtractor vcard $cent $prefix ]"
                    }
                    set cont_x "$cont_x [list $cc]"
                }
                set date [$contribute child all $var_date]
                if { ![empty_string_p $date] } {
                    set cont_x  "$cont_x [list [xmlExtractor date $contribute $prefix 4]]"
                }
                lappend cont_list $cont_x
            }
            return $cont_list
        }
    }

    ad_proc -public getRequirement {
        {tree} 
        {prefix {}} 
    } {
        Gets requirements

        @param tree Node
        @param prefix prefix (if any)
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set var_requirement "$prefix:requirement"
        } else {
            set var_requirement "requirement"
        }
        
        set lom_te_req [$tree child all $var_requirement]
        if { ![empty_string_p $lom_te_req] } {
            # there could be multiple req
            set ret_list [list]
            foreach req [$tree child all $var_requirement] {
                set tmpvar [xmlExtractor type $req $prefix 2]
                set tmpvar "$tmpvar [xmlExtractor name $req $prefix 2]"
                set tmpvar "$tmpvar [xmlExtractor minimumversion $req $prefix]"
                set tmpvar "$tmpvar [xmlExtractor maximumversion $req $prefix]"
                lappend ret_list $tmpvar
            }
            return $ret_list
        }
    }

    ad_proc -public namechild {
        {a}
    } {
        Gets the node names for the children of a particular node
        For testing and debugging purposes only
    } {
        set lix {}
        foreach node $a {
            foreach child [$node child all] {lappend lix [$child localName] [$child prefix]}
        }
        return $lix
    }


    ## Metadata extractor function


    ad_proc -public mdGeneral {
        {-element:required}
        {-node:required}
        {-prefix {}}
        {-att {}}
    } { 
        General Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param element element to retrieve
        @param node Node 
        @param prefix Prefix
        @param att Attribute
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set lom_g [$node child all $prefix:general]
        } else {
            set lom_g [$node child all general]
        }
        if { ![empty_string_p $lom_g] } {
            set retlist [list]
            switch $element {
                title {
                    #gets title
                    set retlist [xmlExtractor title $lom_g $prefix 1]
                }
                catalogentry {
                    #gets catalogentry
                    set retlist [xmlExtractor catalogentry $lom_g $prefix 3]
                }
                language {
                    #gets language
                    set retlist [xmlExtractor language $lom_g $prefix]
                }
                description {
                    #gets description
                    set retlist [xmlExtractor description $lom_g $prefix 1]
                }
                keyword {
                    #gets keyword
                    set retlist [xmlExtractor keyword $lom_g $prefix 1]
                }
                coverage {
                    #gets coverage
                    set retlist [xmlExtractor coverage $lom_g $prefix 1]
                }
                structure {
                    #gets structure
                    set retlist [xmlExtractor structure $lom_g $prefix 2]
                }
                aggregationlevel {
                    #gets aggregationlevel
                    set retlist [xmlExtractor aggregationlevel $lom_g $prefix 2]
                }
                default {
                    return 0
                }
            }
            return $retlist
        }
        return 0
    }

    ad_proc -public mdLifeCycle {
        {-element:required}
        {-node:required}
        {-prefix {}}
        {-att {}}
    } { 
        Life Cycle Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param element element to retrieve
        @param node Node 
        @param prefix Prefix
        @param att Attribute
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set lom_lc [$node child all $prefix:lifecycle]
        } else {
            set lom_lc [$node child all lifecycle]
        }
        if { ![empty_string_p $lom_lc] } {
            set retlist [list]
            switch $element {
                version {
                    #gets version
                    set retlist [xmlExtractor version $lom_lc $prefix 1]
                }
                status {
                    #gets status
                    set retlist [xmlExtractor status $lom_lc $prefix 2]
                }
                contribute {
                    #gets contribute
                    set retlist [getContribute $lom_lc $prefix]
                }
                default {
                    return 0
                }
            }
            return $retlist
        }
        return 0
    }

    ad_proc -public mdMetadata {
        {-element:required}
        {-node:required}
        {-prefix {}}
        {-att {}}
    } { 
        Meta Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param element element to retrieve
        @param node Node 
        @param prefix Prefix
        @param att Attribute
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
	set lom_md [$node child all $prefix:metametadata]
        } else {
            set lom_md [$node child all metametadata]
        }
        if { ![empty_string_p $lom_md] } {
            set retlist [list]
            switch $element {
                contribute {
                    #gets contribute
                    set retlist [getContribute $lom_md $prefix]
                }
                catalogentry {
                    #get catalogentry
                    set retlist [xmlExtractor catalogentry $lom_md $prefix 3]
                }
                metadatascheme {
                    #get metadatascheme
                    set retlist [xmlExtractor metadatascheme $lom_md $prefix]
                }
                language {
                    #get language
                    set retlist [xmlExtractor language $lom_md $prefix]
                }
            }
            return $retlist
        }
        return 0
    }


    ad_proc -public mdTechnical {
        {-element:required}
        {-node:required}
        {-prefix {}}
        {-att {}}
    } { 
        Technical Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param element element to retrieve
        @param node Node 
        @param prefix Prefix
        @param att Attribute
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set lom_te [$node child all $prefix:technical]
        } else {
            set lom_te [$node child all technical]
        }
        if { ![empty_string_p $lom_te] } {
            set retlist [list]
            switch $element {
                format {
                    #gets format
                    set retlist [xmlExtractor format $lom_te $prefix]
                }
                location {
                    #gets location
                    set retlist [xmlExtractor location $lom_te $prefix 0 type]
                }
                requirement {
                    #gets requiremets
                    set retlist [getRequirement $lom_te $prefix]
                }
                size {
                    #gets size
                    set retlist [xmlExtractor size $lom_te $prefix 0]
                }
                installationremarks {
                    #gets installationremarks
                    set retlist [xmlExtractor installationremarks $lom_te $prefix 1]
                }
                otherplatformrequirements {
                    #gets otherplatformrequirements
                    set retlist [xmlExtractor otherplatformrequirements $lom_te $prefix 1]
                }
                duration {
                    #gets duration
                    set retlist [xmlExtractor duration $lom_te $prefix 4]
                }
                default {
                    return 0
                }
            }
            return $retlist
        }
        return 0
    }


    ad_proc -public mdEducational {
        {-element:required}
        {-node:required}
        {-prefix {}}
        {-att {}}
    } { 
        Educational Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param element element to retrieve
        @param node Node 
        @param prefix Prefix
        @param att Attribute
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set lom_ed [$node child all $prefix:educational]
        } else {
            set lom_ed [$node child all educational]
        }
        if { ![empty_string_p $lom_ed] } {
            set retlist [list]
            switch $element {
                interactivitytype {
                    #gets format
                    set retlist [xmlExtractor interactivitytype $lom_ed $prefix 2]
                }
                learningresourcetype {
                    #gets learningresourcetype
                    set retlist [xmlExtractor learningresourcetype $lom_ed $prefix 2]
                }
                interactivitylevel {
                    #gets interactivitylevel
                    set retlist [xmlExtractor interactivitylevel $lom_ed $prefix 2]
                }
                semanticdensity {
                    #gets semanticdensity
                    set retlist [xmlExtractor semanticdensity $lom_ed $prefix 2]
                }
                intendedenduserrole {
                    #gets intendedenduserrole
                    set retlist [xmlExtractor intendedenduserrole $lom_ed $prefix 2]
                }
                context {
                    #gets context
                    set retlist [xmlExtractor context $lom_ed $prefix 2]
                }
                typicalagerange {
                    #gets typicalagerange
                    set retlist [xmlExtractor typicalagerange $lom_ed $prefix 1]
                }
                difficulty {
                    #gets difficulty
                    set retlist [xmlExtractor difficulty $lom_ed $prefix 2]
                }
                typicallearningtime {
                    #gets typicallearningtime
                    set retlist [xmlExtractor typicallearningtime $lom_ed $prefix 4]
                }
                description {
                    #gets description
                    set retlist [xmlExtractor description $lom_ed $prefix 1]
                }
                language {
                    #gets language
                    set retlist [xmlExtractor language $lom_ed $prefix]
                }
                default {
                    return 0
                }
            }
            return $retlist
        }
        return 0
    }
    

    ad_proc -public mdRights {
        {-element:required}
        {-node:required}
        {-prefix {}}
        {-att {}}
    } { 
        Rights Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param element element to retrieve
        @param node Node 
        @param prefix Prefix
        @param att Attribute
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set lom_ri [$node child all $prefix:rights]
        } else {
            set lom_ri [$node child all rights]
        }
        if { ![empty_string_p $lom_ri] } {
            set retlist [list]
            switch $element {
                cost {
                    #gets cost
                    set retlist [xmlExtractor cost $lom_ri $prefix 2]
                }
                copyrightandotherrestrictions {
                    #gets copyrightandotherrestrictions
                    set retlist [xmlExtractor copyrightandotherrestrictions $lom_ri $prefix 2]
                }
                description {
                    #gets description
                    set retlist [xmlExtractor description $lom_ri $prefix 1]
                }
                default {
                    return 0
                }
            }
            return $retlist
        }
        return 0
    }
    

    ad_proc -public mdRelation {
        {-node:required}
        {-prefix {}}
    } { 
        Relation Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param node Node 
        @param prefix Prefix
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set lom_re [$node child all $prefix:relation]
        } else {
            set lom_re [$node child all relation]
        }
        if { ![empty_string_p $lom_re] } {
            set retlist [list]
            foreach relation $lom_re {
                # Relation can happen 0 to 100 times
                #gets kind
                set aa "{[lors::imsmd::xmlExtractor kind $relation $prefix 2]}"
                #gets resource
                if { ![empty_string_p $prefix] } {
                    set resource [$relation child all $prefix:resource]
                } else {
                    set resource [$relation child all resource]
                }
                #printx "Resource ([llength $resource]) " $resource
                foreach res $resource {
                    # gets resource description
                    set aa "$aa {[lors::imsmd::xmlExtractor description $res $prefix 1]}"
                    # gets resource catalogentry
                    set aa "$aa {[lors::imsmd::xmlExtractor catalogentry $res $prefix 3]}"
                }
                lappend retlist $aa
            }
            return $retlist 
        }
        return 0
    }


    ad_proc -public mdAnnotation {
        {-node:required}
        {-prefix {}}
    } { 
        Annotation Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param node Node 
        @param prefix Prefix
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set lom_an [$node child all $prefix:annotation]
        } else {
            set lom_an [$node child all annotation]
        }
        if { ![empty_string_p $lom_an] } {
            set retlist [list]
            foreach annotation $lom_an {
                #gets person
                set aa "{[lors::imsmd::xmlExtractor person $annotation $prefix 5]}"
                #date
                set aa "$aa {[lors::imsmd::xmlExtractor date $annotation $prefix 4]}"
                #description
                set aa "$aa {[lors::imsmd::xmlExtractor description $annotation $prefix 1]}"
                lappend retlist $aa
            }
            return $retlist 
        }
        return 0
    }
    

    ad_proc -public mdClassification {
        {-node:required}
        {-prefix {}}
    } { 
        Classification Metadata extractor
        returns a list with the attributes and elements
        if it doesn't exists returns 0

        @param node Node 
        @param prefix Prefix
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        if { ![empty_string_p $prefix] } {
            set lom_cl [$node child all $prefix:classification]
        } else {
            set lom_cl [$node child all classification]
        }
        if { ![empty_string_p $lom_cl] } {
            set retlist [list]
            set bbcc [list]
            foreach classification $lom_cl {
                #gets purpose
                set aa "{[lors::imsmd::xmlExtractor purpose $classification $prefix 2]}"
                
                #gets description
                set aa "$aa {[lors::imsmd::xmlExtractor description $classification $prefix 1]}"
                
                #gets taxonpath
                if { ![empty_string_p $prefix] } {
                    set tax [$classification child all $prefix:taxonpath]
                } else {
                    set tax [$classification child all taxonpath]
                }
                foreach taxonpath $tax {
                    # gets source
                    set bb [lors::imsmd::xmlExtractor source $taxonpath $prefix 1]
                    
                    # gets taxons
                    if { ![empty_string_p  [lors::imsmd::getTaxon $taxonpath $prefix]] } {
                        set hierarchy 0
                        set cc ""
                        foreach taxon [lors::imsmd::getTaxon $taxonpath $prefix] {
                            set cc "$cc {"
                            set cc "$cc [incr hierarchy]"
                            set cc "$cc {[lindex [lors::imsmd::xmlExtractor id $taxon $prefix] 0]}"
                            set cc "$cc {[lindex [lors::imsmd::xmlExtractor entry $taxon $prefix 1] 0]}"
                            set cc "$cc }"
                        }
                    }
                    lappend bbcc [list $bb $cc]
                }
                # gets keywords
                set dd "{[lors::imsmd::xmlExtractor keyword $classification $prefix 1]}"
                
                lappend retlist "{$aa [list $bbcc] $dd}"
            }
            return $retlist 
        }
        return 0
    }



    ad_proc -public getResource {
        {-node:required}
        {-att:required}
    } {
        Extract data from a resource
        -node the XML node
        -att the attribute to be extracted

        @param node Node 
        @param att Attribute
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        switch $att {
            scormtype {
                # gets the type of resource
                return [string tolower [lors::imsmd::getAtt $node adlcp:scormtype]]
            }
            identifier {
                # gets identifier
                return [lors::imsmd::getAtt $node identifier]
            }
            type {
                # gets type
                return [lors::imsmd::getAtt $node type]
            }
            href {
                # gets href
                return [lors::imsmd::getAtt $node href]
            }
            files {
                set files [list]
                # gets files
                set filex [$node child all file]
                if { ![empty_string_p $filex] } {
                    foreach file $filex {
                        # checks for file metadata
                        set file_hasmetadata [lors::imsmd::hasMetadata $file]
                        if {$file_hasmetadata == 1} {
                            #if it hasmetadata, then pass the node
                            set file_hasmetadata [lors::imsmd::getMDNode $file]
                        } else {
                            #otherwise, just pass 0 (No metadata found)
                            set file_hasmetadata 0
                        }
                        lappend files [list [lors::imsmd::getAtt $file href] $file_hasmetadata]
                    }
                }
                return $files
            }
            dependencies {
                set dependencies [list]
                # gets dependencies
                set depende [$node child all dependency]
                if { ![empty_string_p $depende] } {
                    foreach dependex [$node child all dependency] {
                        lappend dependencies [lors::imsmd::getAtt $dependex identifierref]
                    }
                }
                return $dependencies
            }
            default {
                return [lors::imsmd::getAtt $node $att]
            }
        }
    }
    
    
    
    ad_proc -public getItem {
        {tree} 
    } {
        Extracts data from resource\item

        @param tree Node 
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {
        set itemx [$tree child all item]
        
        if { ![empty_string_p $itemx] } {
            set items [list]
            foreach itemx  [$tree child all item] {
                
                # gets item identifier
                printx "item identifier: " [getAtt $itemx identifier]
                
                # gets item identifierref
                printx "item identifierref: " [getAtt $itemx identifierref]
                
                # gets item isvisible ?
                printx "item isvisible: " [getAtt $itemx isvisible]
                
                # gets item title
                printx "item title: " [getElement [$itemx child all title]]
                
                set itemxx [$itemx child all item]
                if { ![empty_string_p $itemxx] } {
                    printx "<blockquote>" " "
                    getItem $itemx
                    printx "</blockquote>" ""
                }
            }
        }
    }


    ad_proc -public addLOM {
	{-lom:required}
	{-prefix}
	{-acs_object:required}
	{-dir {}}
    } {
	Adds LOM metadata for a learning resource.
	This is the master function for adding metadata. 
        This is the MD mama function for entering LOM into the db.

	@param lom the LOM node (XML) for the learning resource
	@param acs_object acs object for resource (element) that contains metadata
        @param dir dir directory where the imsmanifest.xml file is located. This is use in the case the metadata is in a different file location (adlcp:location).
	@author Ernie Ghiglione (ErnieG@mm.st)

    } {

	set p_ims_md_id $acs_object
	set path_to_file $dir

	db_transaction {
            # General

		# Title
		set titles [lors::imsmd::mdGeneral -element title -node $lom -prefix $prefix]

		# Structure
		set structure_s [lindex [lindex [lindex [lors::imsmd::mdGeneral -element structure -node $lom -prefix $prefix] 0] 0] 1]
		set structure_v [lindex [lindex [lindex [lors::imsmd::mdGeneral -element structure -node $lom -prefix $prefix] 0] 1] 1]

		# Aggregation level
		set agg_level_s [lindex [lindex [lindex [lors::imsmd::mdGeneral -element aggregationlevel -node $lom -prefix $prefix] 0] 0] 1]
		set agg_level_v [lindex [lindex [lindex [lors::imsmd::mdGeneral -element aggregationlevel  -node $lom -prefix $prefix] 0] 1] 1]

		# Catalogentry
		set catalogentries [lors::imsmd::mdGeneral -element catalogentry -node $lom -prefix $prefix]

		# Languages
		set languages [lors::imsmd::mdGeneral -element language -node $lom -prefix $prefix]
		
		# Descriptions
		set descriptions [lors::imsmd::mdGeneral -element description -node $lom -prefix $prefix]

		# Keywords
		set keywords [lors::imsmd::mdGeneral -element keyword -node $lom -prefix $prefix]

		# Coverages
		set coverages [lors::imsmd::mdGeneral -element coverage -node $lom -prefix $prefix]

		# Now we insert the values into the DB
		db_dml add_new_general {
		    insert into ims_md_general (ims_md_id, structure_s, structure_v, agg_level_s, agg_level_v)
		    values
		    (:p_ims_md_id, :structure_s, :structure_v, :agg_level_s, :agg_level_v)
		}


		# Adds General Titles

		foreach title $titles {
		    set p_ims_md_ge_ti_id [db_nextval ims_md_general_title_seq]
		    set p_title_l [lindex $title 0]
		    set p_title_s [lindex $title 1]
		    
		    db_dml add_new_general_titles {
			insert into ims_md_general_title (ims_md_ge_ti_id, ims_md_id, title_l, title_s)
			values
			(:p_ims_md_ge_ti_id, :p_ims_md_id, :p_title_l, :p_title_s)
		    }

		}

		# Adds General Catalog Entries
		foreach catalogentry $catalogentries {
		    set p_ims_md_ge_cata_id [db_nextval ims_md_general_cata_seq]
		    set p_catalog [lindex $catalogentry 0]
		    set p_entry_l [lindex [lindex $catalogentry 1] 0]
		    set p_entry_s [lindex [lindex $catalogentry 1] 1]
		    
		    db_dml add_new_general_catalogentries {
			
			insert into ims_md_general_cata (ims_md_ge_cata_id, ims_md_id, catalog, entry_l, entry_s)
			values
			(:p_ims_md_ge_cata_id, :p_ims_md_id, :p_catalog, :p_entry_l, :p_entry_s)
		    }
		}

		# Adds General Languages
		foreach language $languages {
		    set p_ims_md_ge_lang_id [db_nextval ims_md_general_lang_seq]

		    db_dml add_new_general_language {
			insert into ims_md_general_lang (ims_md_ge_lang_id, ims_md_id, language)
			values
			(:p_ims_md_ge_lang_id, :p_ims_md_id, :language)
		    }
		}

		# Adds General Description
		foreach description $descriptions {
		    set p_ims_md_ge_desc_id [db_nextval ims_md_general_desc_seq]
		    set p_descrip_l [lindex $description 0]
		    set p_descrip_s [lindex $description 1]
		    
		    db_dml add_new_general_description {
			insert into ims_md_general_desc (ims_md_ge_desc_id, ims_md_id, descrip_l, descrip_s)
			values
			(:p_ims_md_ge_desc_id, :p_ims_md_id, :p_descrip_l, :p_descrip_s)
		    }
		}
		
		# Adds General Keywords
		foreach keyword $keywords {
		    set p_ims_md_ge_key_id [db_nextval ims_md_general_key_seq]
		    set p_keyword_l [lindex $keyword 0]
		    set p_keyword_s [lindex $keyword 1]
		    
		    db_dml add_new_general_keyword {
			insert into ims_md_general_key (ims_md_ge_key_id, ims_md_id, keyword_l, keyword_s)
			values
			(:p_ims_md_ge_key_id, :p_ims_md_id, :p_keyword_l, :p_keyword_s)
		    }
		}

		# Adds General Coverage
		foreach coverage $coverages {
		    set p_ims_md_ge_cove_id [db_nextval ims_md_general_cover_seq]
		    set p_cover_l [lindex $coverage 0]
		    set p_cover_s [lindex $coverage 1]
		    
		    db_dml add_new_general_coverage {
			insert into ims_md_general_cover (ims_md_ge_cove_id, ims_md_id, cover_l, cover_s)
			values
			(:p_ims_md_ge_cove_id, :p_ims_md_id, :p_cover_l, :p_cover_s)
		    }
		}

		# Lifecycle

		# Version
		set version [lors::imsmd::mdLifeCycle -element version -node $lom -prefix $prefix]
		set version_l [lindex [lindex $version 0] 0]
		set version_s [lindex [lindex $version 0] 1]
		
		# Status
		set status [lors::imsmd::mdLifeCycle -element status -node $lom -prefix $prefix]
		set status_s [lindex [lindex [lindex $status 0] 0] 1]
		set status_v [lindex [lindex [lindex $status 0] 1] 1]
		
		# Contribute
		set contributes [lors::imsmd::mdLifeCycle -element contribute -node $lom -prefix $prefix]
		
		# Adds Lifecycle Version and Status
		db_dml add_new_lifecycle {
		    insert into ims_md_life_cycle (ims_md_id, version_l, version_s, status_s, status_v)
		    values
		    (:p_ims_md_id, :version_l, :version_s, :status_s, :status_v)
		}

		# Adds Lifecycle Contributes
		foreach contribute $contributes {
		    set p_ims_md_lf_cont_id [db_nextval ims_md_life_cycle_contrib_seq]
		    set p_role_s [lindex [lindex [lindex $contribute 0] 0] 1]
		    set p_role_v [lindex [lindex [lindex $contribute 0] 1] 1]
		    set p_cont_date [lindex [lindex $contribute 2] 0]
		    set p_cont_date_l [lindex [lindex [lindex $contribute 2] 1] 0]
		    set p_cont_date_s [lindex [lindex [lindex $contribute 2] 1] 1]
		    
		    set p_entities [lindex $contribute 1]
		    
		    db_dml add_new_lifecycle_contrib {
			insert into ims_md_life_cycle_contrib (ims_md_lf_cont_id, ims_md_id, role_s, role_v, cont_date, cont_date_l, cont_date_s)
			values
			(:p_ims_md_lf_cont_id, :p_ims_md_id, :p_role_s, :p_role_v, :p_cont_date, :p_cont_date_l, :p_cont_date_s)
		    }


		    foreach entity $p_entities {
			set p_ims_md_lf_cont_enti_id [db_nextval ims_md_life_cycle_contrib_entity_seq]
			set p_entity $entity
			
			db_dml add_new_lifecycle_contrib_entity {
			    insert into ims_md_life_cycle_contrib_entity (ims_md_lf_cont_enti_id, ims_md_lf_cont_id, entity)
			    values
			    (:p_ims_md_lf_cont_enti_id, :p_ims_md_lf_cont_id, :p_entity)
			}
		    }
		    
		}
		
		# Metadata

		# Language
		set p_language [lors::imsmd::mdMetadata -element language -node $lom -prefix $prefix]
		
		# Catalogentry
		set catalogentries [lors::imsmd::mdMetadata -element catalogentry -node $lom -prefix $prefix]
		
		# Contribute
		set contributes [lors::imsmd::mdMetadata -element contribute -node $lom -prefix $prefix]
		
		# Metadatascheme
		set metadataschemes [lors::imsmd::mdMetadata -element metadatascheme -node $lom -prefix $prefix]

		# Adds Metadata Language
		db_dml add_new_metadata {
		    insert into ims_md_metadata (ims_md_id, language)
		    values
		    (:p_ims_md_id, :p_language)
		}

		# Adds Catalogentry
		foreach catalogentry $catalogentries {
		    set p_ims_md_md_cata_id [db_nextval ims_md_metadata_cata_seq]
		    set p_catalog [lindex $catalogentry 0]
		    set p_entry_l [lindex [lindex $catalogentry 1] 0]
		    set p_entry_s [lindex [lindex $catalogentry 1] 1]

		    db_dml add_new_metadata_catalogentries {
			insert into ims_md_metadata_cata (ims_md_md_cata_id, ims_md_id, catalog, entry_l, entry_s)
			values
			(:p_ims_md_md_cata_id, :p_ims_md_id, :p_catalog, :p_entry_l, :p_entry_s)
		    }
		}

		# Adds Lifecycle Contributes
		foreach contribute $contributes {
		    set p_ims_md_md_cont_id [db_nextval ims_md_metadata_contrib_seq]
		    set p_role_s [lindex [lindex [lindex $contribute 0] 0] 1]
		    set p_role_v [lindex [lindex [lindex $contribute 0] 1] 1]
		    set p_cont_date [lindex [lindex $contribute 2] 0]
		    set p_cont_date_l [lindex [lindex [lindex $contribute 2] 1] 0]
		    set p_cont_date_s [lindex [lindex [lindex $contribute 2] 1] 1]

		    set p_ims_md_md_cont_enti_id [db_nextval ims_md_metadata_contrib_entity_seq]
		    set p_entity [lindex [lindex $contribute 1] 0]

		    db_dml add_new_metadata_contrib {
			insert into ims_md_metadata_contrib (ims_md_md_cont_id, ims_md_id, role_s, role_v, cont_date, cont_date_l, cont_date_s)
			values
			(:p_ims_md_md_cont_id, :p_ims_md_id, :p_role_s, :p_role_v, :p_cont_date, :p_cont_date_l, :p_cont_date_s)
		    }

		    db_dml add_new_metadata_contrib_entity {
			insert into ims_md_metadata_contrib_entity (ims_md_md_cont_enti_id, ims_md_md_cont_id, entity)
			values
			(:p_ims_md_md_cont_enti_id, :p_ims_md_md_cont_id, :p_entity)
		    }

		}

		# Adds Metadata Schemes
		foreach metadatascheme $metadataschemes {
		    set p_ims_md_md_sch_id [db_nextval ims_md_metadata_scheme_seq]
		    set p_scheme $metadatascheme
		    
		    db_dml add_new_metadata_metadatascheme {
			insert into ims_md_metadata_scheme (ims_md_md_sch_id, ims_md_id, scheme)
			values
			(:p_ims_md_md_sch_id, :p_ims_md_id, :p_scheme)
		    }
		}

		# Technical

		# format
		set formats [lors::imsmd::mdTechnical -element format -node $lom -prefix $prefix]
		
		# location
		set locations [lors::imsmd::mdTechnical -element location -node $lom -prefix $prefix]

		# size, installation remarks, otherplatformrequirements, duration
		set p_size [lors::imsmd::mdTechnical -element size -node $lom -prefix $prefix]
		set p_instl_rmks [lors::imsmd::mdTechnical -element installationremarks -node $lom -prefix $prefix]
		set p_instl_rmks_l [lindex [lindex $p_instl_rmks 0] 0]
		set p_instl_rmks_s [lindex [lindex $p_instl_rmks 0] 1]
		set p_otr_plt [lors::imsmd::mdTechnical -element otherplatformrequirements -node $lom -prefix $prefix]
		set p_otr_plt_l [lindex [lindex $p_otr_plt 0] 0]
		set p_otr_plt_s [lindex [lindex $p_otr_plt 0] 1]
		set p_durat [lors::imsmd::mdTechnical -element duration -node $lom -prefix $prefix]
		set p_duration [lindex $p_durat 0]
		set p_duration_l [lindex [lindex $p_durat 1] 0]
		set p_duration_s [lindex [lindex $p_durat 1] 1]

		# requirement
		set requirements [lors::imsmd::mdTechnical -element requirement -node $lom -prefix $prefix]

		# Adds Technical size, installation remarks, otherplatformrequirements, duration
		db_dml add_new_technical {
		    insert into ims_md_technical (ims_md_id, t_size, instl_rmrks_l, instl_rmrks_s, otr_plt_l, otr_plt_s, duration, duration_l, duration_s)
		    values
		    (:p_ims_md_id, :p_size, :p_instl_rmks_l, :p_instl_rmks_s, :p_otr_plt_l, :p_otr_plt_s, :p_duration, :p_duration_l, :p_duration_s)
		}

		# Adds Technical Format

		foreach format $formats {
		    set p_ims_md_te_fo_id [db_nextval ims_md_technical_format_seq]
		    set p_format $format
		    
		    db_dml add_new_technical_format {
			insert into ims_md_technical_format (ims_md_te_fo_id, ims_md_id, format)
			values
			(:p_ims_md_te_fo_id, :p_ims_md_id, :p_format)
		    }
		}
		
		# Adds Technical Location
		
		foreach location $locations {
		    set p_ims_md_te_lo_id [db_nextval ims_md_technical_location_seq]
		    set p_type [lindex $location 1]
		    set p_location [lindex $location 0]

		    db_dml add_new_technical_location {
			insert into ims_md_technical_location (ims_md_te_lo_id, ims_md_id, type, location)
			values
			(:p_ims_md_te_lo_id, :p_ims_md_id, :p_type, :p_location)
		    }
		}

		# Adds Technical Requirements

		foreach requirement $requirements {
		    set p_ims_md_te_rq_id [db_nextval ims_md_technical_requirement_seq]
		    set p_type_s [lindex [lindex [lindex $requirement 0] 0] 1]
		    set p_type_v [lindex [lindex [lindex $requirement 0] 1] 1]
		    set p_name_s [lindex [lindex [lindex $requirement 1] 0] 1]
		    set p_name_v [lindex [lindex [lindex $requirement 1] 1] 1]
		    set p_min_version [lindex $requirement 2]
		    set p_max_version [lindex $requirement 3]

		    db_dml add_new_technical_requirement {
			insert into ims_md_technical_requirement (ims_md_te_rq_id, ims_md_id, type_s, type_v, name_s, name_v, min_version, max_version)
			values
			(:p_ims_md_te_rq_id, :p_ims_md_id, :p_type_s, :p_type_v, :p_name_s, :p_name_v, :p_min_version, :p_max_version)
		    }
		}


		# Educational

		# interactivitytype, interactivitylevel, semanticdensity, difficulty, typical_learning_time, description
		set p_int_type [lors::imsmd::mdEducational -element interactivitytype -node $lom -prefix $prefix]
		set p_int_type_s [lindex [lindex [lindex $p_int_type 0] 0] 1]
		set p_int_type_v [lindex [lindex [lindex $p_int_type 0] 1] 1]
		set p_int_level [lors::imsmd::mdEducational -element interactivitylevel -node $lom -prefix $prefix]
		set p_int_level_s [lindex [lindex [lindex $p_int_level 0] 0] 1]
		set p_int_level_v [lindex [lindex [lindex $p_int_level 0] 1] 1]
		set p_sem_density [lors::imsmd::mdEducational -element semanticdensity -node $lom -prefix $prefix]
		set p_sem_density_s [lindex [lindex [lindex $p_sem_density 0] 0] 1]
		set p_sem_density_v [lindex [lindex [lindex $p_sem_density 0] 1] 1]
		set p_difficulty [lors::imsmd::mdEducational -element difficulty -node $lom -prefix $prefix]
		set p_difficulty_s [lindex [lindex [lindex $p_difficulty 0] 0] 1]
		set p_difficulty_v [lindex [lindex [lindex $p_difficulty 0] 1] 1]
		set p_type_lrn_tim [lors::imsmd::mdEducational -element typicallearningtime -node $lom -prefix $prefix]
		set p_type_lrn_time [lindex $p_type_lrn_tim 0]
		set p_type_lrn_time_l [lindex [lindex $p_type_lrn_tim 1] 0]
		set p_type_lrn_time_s [lindex [lindex $p_type_lrn_tim 1] 1]
		set descrips [lors::imsmd::mdEducational -element description -node $lom -prefix $prefix]

		# learningresourcetype
		set learningresourcetypes [lors::imsmd::mdEducational -element learningresourcetype -node $lom -prefix $prefix]


		# intendedenduserrole
		set intendedenduserroles [lors::imsmd::mdEducational -element intendedenduserrole -node $lom -prefix $prefix]

		# context
		set contexts  [lors::imsmd::mdEducational -element context -node $lom -prefix $prefix]

		# typicalagerange
		set typicalageranges [lors::imsmd::mdEducational -element typicalagerange -node $lom -prefix $prefix]

		# language 
		set languages [lors::imsmd::mdEducational -element language -node $lom -prefix $prefix]


		# Adds Educational interactivitytype, interactivitylevel, semanticdensity, difficulty, typical_learning_time
		db_dml add_new_educational {
		    insert into ims_md_educational (ims_md_id, int_type_s, int_type_v, int_level_s, int_level_v, sem_density_s, sem_density_v, difficulty_s, difficulty_v, type_lrn_time, type_lrn_time_l, type_lrn_time_s)
		    values
		    (:p_ims_md_id, :p_int_type_s, :p_int_type_v, :p_int_level_s, :p_int_level_v, :p_sem_density_s, :p_sem_density_v, :p_difficulty_s, :p_difficulty_v, :p_type_lrn_time, :p_type_lrn_time_l, :p_type_lrn_time_s)
		}

		# Adds descriptions
		foreach descrip $descrips {
		    set p_ims_md_ed_de_id [db_nextval ims_md_educational_descrip_seq]
		    set p_descrip_l [lindex $descrip 0]
		    set p_descrip_s [lindex $descrip 1]

		    db_dml add_new_descriptions {
			insert into ims_md_educational_descrip (ims_md_ed_de_id, ims_md_id, descrip_l, descrip_s)
			values
			(:p_ims_md_ed_de_id, :p_ims_md_id, :p_descrip_l, :p_descrip_s)
		    }
		}

		# Adds learningresourcetype
		foreach lrt $learningresourcetypes {
		    set p_ims_md_ed_lr_id [db_nextval ims_md_educational_lrt_seq]
		    set p_lrt_s [lindex [lindex $lrt 0] 1]
		    set p_lrt_v [lindex [lindex $lrt 1] 1]
		    
		    db_dml add_new_learningresourcetypes {
			insert into ims_md_educational_lrt (ims_md_ed_lr_id, ims_md_id, lrt_s, lrt_v)
			values
			(:p_ims_md_ed_lr_id, :p_ims_md_id, :p_lrt_s, :p_lrt_v)
		    }
		}

		# Adds intendedenduserrole
		foreach ieur $intendedenduserroles {
		    set p_ims_md_ed_ie_id [db_nextval ims_md_educational_ieur_seq]
		    set p_ieur_s [lindex [lindex $ieur 0] 1]
		    set p_ieur_v [lindex [lindex $ieur 1] 1]

		    db_dml add_new_intendedenduserroles {
			insert into ims_md_educational_ieur (ims_md_ed_ie_id, ims_md_id, ieur_s, ieur_v)
			values
			(:p_ims_md_ed_ie_id, :p_ims_md_id, :p_ieur_s, :p_ieur_v)
		    }
		}

		# Adds context
		foreach context $contexts {
		    set p_ims_md_ed_co_id [db_nextval ims_md_educational_context_seq]
		    set p_context_s [lindex [lindex $context 0] 1]
		    set p_context_v [lindex [lindex $context 1] 1]
		    
		    db_dml add_new_context {
			insert into ims_md_educational_context (ims_md_ed_co_id, ims_md_id, context_s, context_v)
			values
			(:p_ims_md_ed_co_id, :p_ims_md_id, :p_context_s, :p_context_v)
		    }
		}

		# Adds typicalagerange
		foreach tar $typicalageranges {
		    set p_ims_md_ed_ta_id [db_nextval ims_md_educational_tar_seq]
		    set p_tar_l [lindex $tar 0]
		    set p_tar_s [lindex $tar 1]

		    db_dml add_new_typicalagerange {
			insert into ims_md_educational_tar (ims_md_ed_ta_id, ims_md_id, tar_l, tar_s)
			values
			(:p_ims_md_ed_ta_id, :p_ims_md_id, :p_tar_l, :p_tar_s)
		    }
		}

		#  Adds Languages
		foreach lang $languages {
		    set p_ims_md_ed_la_id [db_nextval ims_md_educational_lang_seq]
		    set p_language $lang
		    
		    db_dml add_new_language {
			insert into ims_md_educational_lang (ims_md_ed_la_id, ims_md_id, language)
			values
			(:p_ims_md_ed_la_id, :p_ims_md_id, :p_language)
		    }
		}

		# Rights
		# cost, copyrightsandotherrights, description
		set p_cost [lors::imsmd::mdRights -element cost -node $lom -prefix $prefix]
		set p_caor [lors::imsmd::mdRights -element copyrightandotherrestrictions -node $lom -prefix $prefix]
		set p_descrip [lors::imsmd::mdRights -element description -node $lom -prefix $prefix]
		
		set p_cost_s [lindex [lindex [lindex $p_cost 0] 0] 1]
		set p_cost_v [lindex [lindex [lindex $p_cost 0] 1] 1]

		set p_caor_s [lindex [lindex [lindex $p_caor 0] 0] 1]
		set p_caor_v [lindex [lindex [lindex $p_caor 0] 1] 1]

		set p_descrip_l [lindex [lindex $p_descrip 0] 0]
		set p_descrip_s [lindex [lindex $p_descrip 0] 1]

		db_dml add_new_rights {
		    insert into ims_md_rights (ims_md_id, cost_s, cost_v, caor_s, caor_v, descrip_l, descrip_s)
		    values
		    (:p_ims_md_id, :p_cost_s, :p_cost_v, :p_caor_s, :p_caor_v, :p_descrip_l, :p_descrip_s)
		}

		# Relation

		# Relation returns all in one large list
		set relations  [lors::imsmd::mdRelation -node $lom -prefix $prefix]
		
		foreach relation $relations {
		    
		    set p_ims_md_re_id [db_nextval ims_md_relation_seq]
		    set p_kind_s [lindex [lindex [lindex [lindex $relation 0] 0] 0] 1]
		    set p_kind_v [lindex [lindex [lindex [lindex $relation 0] 0] 1] 1]
		    
		    # Adds kind
		    db_dml add_new_relation {
			insert into ims_md_relation (ims_md_re_id, ims_md_id, kind_s, kind_v)
			values
			(:p_ims_md_re_id, :p_ims_md_id, :p_kind_s, :p_kind_v)
		    }
		    
		    set p_ims_md_re_re_id [db_nextval ims_md_relation_resource_seq]
		    set p_descrip_l [lindex [lindex [lindex $relation 1] 0] 0]
		    set p_descrip_s [lindex [lindex [lindex $relation 1] 0] 1]

		    # adds description to resource
		    db_dml add_new_relation_descrip {
			insert into ims_md_relation_resource (ims_md_re_re_id, ims_md_re_id, identifier, descrip_l, descrip_s)
			values
			(:p_ims_md_re_re_id, :p_ims_md_re_id, null, :p_descrip_l, :p_descrip_s)
		    }

		    # catalogentries
		    set catalogentries [lindex $relation 2]

		    # adds catalogentries
		    foreach catalogentry $catalogentries {

			set p_ims_md_re_re_ca_id [db_nextval ims_md_relation_resource_catalog_seq]
			set p_catalog [lindex $catalogentry 0]
			set p_entry_l [lindex [lindex $catalogentry 1] 0]
			set p_entry_s [lindex [lindex $catalogentry 1] 1]
			
			db_dml add_new_catalogentry {
			    
			    insert into ims_md_relation_resource_catalog (ims_md_re_re_ca_id, ims_md_re_re_id, catalog, entry_l, entry_s)
			    values
			    (:p_ims_md_re_re_ca_id, :p_ims_md_re_re_id, :p_catalog, :p_entry_l, :p_entry_s)
			}
		    }

		}

		# Annotation
		
		set annotations [lors::imsmd::mdAnnotation -node $lom -prefix $prefix]

		foreach annotation $annotations {
		    set p_ims_md_an_id [db_nextval ims_md_annotation_seq]
		    set p_entity [lindex [lindex $annotation 0] 0]
		    set p_date [lindex [lindex $annotation 1] 0]
		    set p_date_l [lindex [lindex [lindex $annotation 1] 1] 0]
		    set p_date_s [lindex [lindex [lindex $annotation 1] 1] 1]

		    set p_descriptions [lindex $annotation 2]

		    db_dml add_new_annotation {
			insert into ims_md_annotation (ims_md_an_id, ims_md_id, entity, date, date_l, date_s)
			values
			(:p_ims_md_an_id, :p_ims_md_id, :p_entity, :p_date, :p_date_l, :p_date_s)
		    }

		    foreach description $p_descriptions {

			set p_ims_md_an_de_id [db_nextval ims_md_annotation_descrip_seq]
			set p_descrip_l [lindex $description 0]
			set p_descrip_s [lindex $description 1]
			
			db_dml add_new_ann_descriptions {
			    insert into ims_md_annotation_descrip (ims_md_an_de_id, ims_md_an_id, descrip_l, descrip_s)
			    values
			    (:p_ims_md_an_de_id, :p_ims_md_an_id, :p_descrip_l, :p_descrip_s)
			}

		    }


		}

		# Classification

		set classifications [lors::imsmd::mdClassification -node $lom -prefix $prefix]

		foreach class $classifications {

		    # purpose
		    set p_ims_md_cl_id [db_nextval ims_md_classification_seq]
		    set p_purpose_s [lindex [lindex [lindex [lindex [lindex $class 0] 0] 0] 0] 1]
		    set p_purpose_v [lindex [lindex [lindex [lindex [lindex $class 0] 0] 0] 1] 1]
		    
		    db_dml add_new_classification {
			insert into ims_md_classification (ims_md_cl_id, ims_md_id, purpose_s, purpose_v)
			values
			(:p_ims_md_cl_id, :p_ims_md_id, :p_purpose_s, :p_purpose_v)
		    }

		    # description
		    set descriptions [lindex [lindex $class 0] 1]

		    foreach desc $descriptions {
			set p_ims_md_cl_de_id [db_nextval ims_md_classification_desc_seq]
			set p_descrip_l [lindex $desc 0]
			set p_descrip_s [lindex $desc 1]
			
			db_dml add_new_description {
			    insert into ims_md_classification_descrip (ims_md_cl_de_id, ims_md_cl_id, descrip_l, descrip_s)
			    values
			    (:p_ims_md_cl_de_id, :p_ims_md_cl_id, :p_descrip_l, :p_descrip_s)
			}
		    }

		    # taxonpath
		    set taxonpaths [lindex [lindex $class 0] 2]

		    foreach taxonpath $taxonpaths {
			
			set p_source [lindex $taxonpath 0]
			
			set p_source_l [lindex [lindex $p_source 0] 0]
			set p_source_s [lindex [lindex $p_source 0] 1]
			set p_ims_md_cl_ta_id [db_nextval ims_md_classification_taxpath_seq]

			set taxons [lindex $taxonpath 1]

			db_dml add_new_taxonpaths {
			    insert into ims_md_classification_taxpath (ims_md_cl_ta_id, ims_md_cl_id, source_l, source_v)
			    values
			    (:p_ims_md_cl_ta_id, :p_ims_md_cl_id, :p_source_l, :p_source_s)
			}

			foreach taxon $taxons {

			    set p_ims_md_cl_ta_ta_id [db_nextval ims_md_classification_taxpath_taxon_seq]
			    set p_hierarchy [lindex $taxon 0]
			    set p_identifier [lindex $taxon 1]
			    set p_entry_l  [lindex [lindex $taxon 2] 0]
			    set p_entry_s  [lindex [lindex $taxon 2] 1]
			    
			    db_dml add_new_taxons {
				insert into ims_md_classification_taxpath_taxon (ims_md_cl_ta_ta_id, ims_md_cl_ta_id, hierarchy, identifier, entry_l, entry_s)
				values
				(:p_ims_md_cl_ta_ta_id, :p_ims_md_cl_ta_id, :p_hierarchy, :p_identifier, :p_entry_l, :p_entry_s)
			    }

			}
		    }        

		    # keywords
		    set keywords [lindex [lindex $class 0] 3]
		    
		    foreach keyword $keywords {
			set p_ims_md_cl_ke_id [db_nextval  ims_md_classification_keyword_seq]
			set p_keyword_l [lindex $keyword 0]
			set p_keyword_s [lindex $keyword 1]
			
			db_dml add_new_keywords {
			    insert into ims_md_classification_keyword (ims_md_cl_ke_id, ims_md_cl_id, keyword_l, keyword_s)
			    values
			    (:p_ims_md_cl_ke_id, :p_ims_md_cl_id, :p_keyword_l, :p_keyword_s)
			}
		    }
		}
	    } on_error {
		ad_return_error "[_ lors.lt_Transaction_Error_in_]" "[_ lors._The] $errmsg"
	    }
 
    }


    ad_proc -public addMetadata {
	{-acs_object:required}
	{-node:required}
	{-dir {}}
    } {
	Adds metadata for a learning resource.
	
	@option acs_object acs object for resource (element) that contains metadata.
	@option node XML node that contains the metadata
	@option dir directory where the imsmanifest.xml file is located. This is use in the case the metadata is in a different file location (adlcp:location).
	@author Ernie Ghiglione (ErnieG@mm.st).

    } {
	set p_ims_md_id $acs_object
	set mdnode $node
	set path_to_file $dir
	#[lors::imsmd::getMDNode $manifest]
	
	set p_schema [lindex [lindex [lors::imsmd::getMDSchema $mdnode] 0] 0]
	set p_schemaversion [lindex [lors::imsmd::getMDSchema $mdnode] 1]

	set lom [lindex [lors::imsmd::getLOM $mdnode $path_to_file] 0]
	set prefix [lindex [lors::imsmd::getLOM $mdnode $path_to_file] 1]

    
	# inserts into db
	db_transaction {

	    # Checks if there's a LOM record
	    if {$lom != 0} {

		# Adds new MD record to ims_md
		
		lors::imsmd::addMDSchemaVersion -acs_object $p_ims_md_id -schema $p_schema -schemaversion $p_schemaversion

		lors::imsmd::addLOM -lom $lom -prefix $prefix -acs_object $p_ims_md_id -dir $path_to_file

	    }
        }  on_error {
	    ad_return_error "[_ lors.lt_Transaction_Error_whi]" "[_ lors.The_error_was] $errmsg"
	}
        return 1
    }
    

    ad_proc -public addMDSchemaVersion {
	{-acs_object:required}
	{-schema:required}
	{-schemaversion:required}

    } {
	Adds MD schema and schema version to db
	If the metedata record already exists, then it deletes it
	and creates a new one.

	@param acs_object acs object for resource (element) that contains metadata.
	@param schema MD schema used for the learning resource.
	@param schemaversion MD schemaversion used for the learning resource.
 	@author Ernie Ghiglione (ErnieG@mm.st)
    } {
	set p_ims_md_id $acs_object 
	set p_schema $schema
	set p_schemaversion $schemaversion

	# we check if the MD record we are about to insert already
	# exists. If that is the case, then we delete it first.
	# Yes, we are not versioning metadata (as I believe there's no
	# real point on doing so.

	lors::imsmd::delMD -acs_object $p_ims_md_id

	db_transaction {
            db_dml add_md {
                insert into ims_md (ims_md_id, schema, schemaversion)
                values
                (:p_ims_md_id, :p_schema, :p_schemaversion)
            }
	} on_error {
	    ad_return_error "[_ lors.lt_Transaction_Error_in__1] " " [_ lors._The] $errmsg"
	}
    }

    ad_proc -public delMD {
	{-acs_object:required}
    } {
	Deletes an MD record (deletes it ALL from the db).
	
	@param acs_object the acs object metadata we are deleting.
 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {
	set p_ims_md_id $acs_object 

	# if record exists...
	if {[db_0or1row check_md_record {select ims_md_id from ims_md where ims_md_id = :p_ims_md_id}]} {

	    # ... then delete it
	    db_transaction {
		db_dml add_md {
		    delete from ims_md where ims_md_id = :p_ims_md_id
		}
	    } on_error {
		ad_return_error "[_ lors.lt_Transaction_deleting_]" "[_ lors.The_error_was] $errmsg"
	    }
	} 

    }

    ad_proc -public mdExist {
	{-ims_md_id:required}
    } {
	Checks whether the acs_object (ims_md_id) does exist.
	Returns 1 if that's the case, 0 otherwise
	
	@param ims_md_id the acs object id 
 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {
	set p_ims_md_id $ims_md_id

	# if record exists... returns 1
	return [db_0or1row check_md_record {select ims_md_id from ims_md where ims_md_id = :p_ims_md_id}]

    }






    
} 



namespace eval lors::imsmd::xml {

### Generic XML creating tDOM functions 
# Created just to make the super-tedious XML creation with tDOM a bit
# easier

    ad_proc -public newElement {
	{-owner:required}
	{-name:required}
    } {
	Creates an XML element node
	
	@param owner owner node 
	@param name element name
 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {

	return [[$owner ownerDocument] createElement $name]

    }

    ad_proc -public newElementText {
	{-owner:required}
	{-name:required}
	{-text:required}
    } {
	Creates an XML element with a text node
	
	@param owner owner node 
	@param name element name
	@param text text
 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {
	
	set node_text [lors::imsmd::xml::newText -owner $owner -text $text]
	set node [lors::imsmd::xml::newElement -owner $owner -name $name]
	$node appendChild $node_text
    
	return $node

    }

    ad_proc -public newText {
	{-owner:required}
	{-text:required}
    } {
	Creates an XML Text node
	
	@param owner owner node 
	@param text text
 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {

	return [[$owner ownerDocument] createTextNode $text]

    }

    ad_proc -public newComment {
	{-owner:required}
	{-comment:required}
    } {
	Creates an XML Text node
	
	@param owner owner node 
	@param comment Comment
 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {

	return [[$owner ownerDocument] createComment $comment]

    }


### End Generic XML creating tDOM functions
}




namespace eval lors::imsmd::create {

### IMS MD XML creation


## LOM data types

# langstring

    ad_proc -public newLangString {
	{-owner:required}
	{-lang:required}
	{-string:required}
    } {
	Creates an LangString data type XML node
	
	@param owner owner node 
	@param lang language
	@param string String
 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {

	set ls_string [lors::imsmd::xml::newText -owner $owner -text $string]
	set lang_string_node [lors::imsmd::xml::newElement -owner $owner -name langstring]
	$lang_string_node setAttribute xml:lang $lang
	$lang_string_node appendChild $ls_string
	return $lang_string_node

    }


    ad_proc -public md {
	{-owner:required}
	{-schema:required}
	{-schemaversion:required}
	{-lom:required}
    } {
	Creates a metadata node. 

	@param owner Owner node
	@param schema schema
	@param schemaversion schemaversion
	@param lom lom node
 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {

	set metadata [lors::imsmd::xml::newElement -owner $owner -name metadata]

	$metadata appendChild [lors::imsmd::xml::newComment -owner $owner -comment "Generated by LORSm"]

	set schema [lors::imsmd::xml::newElementText -owner $owner -name schema -text $schema]
	set schemaversion [lors::imsmd::xml::newElementText -owner $owner -name schemaversion -text $schemaversion]

	$metadata appendChild $schema
	$metadata appendChild $schemaversion
	$metadata appendChild $lom
	
	return $metadata

    }


    ad_proc -public lom {
	{-owner:required}
	{-general {}}
	{-lifecycle {}}
	{-metametadata {}}
	{-technical {}}
	{-educational {}}
	{-rights {}}
	{-relation {}}
	{-annotation {}}
	{-classification {}}
    } {
	Creates a LOM node.
	It puts together all the nodes and returns a LOMs node.
	
	@param owner ownerDocument node 
	@param general General node
	@param lifecycle Lifecycle node
	@param metametadata Metametadata node
	@param technical Technical node
	@param educational Educational node
	@param rights Rights node
	@param relation Relation node
	@param annotation Annotation node
	@param classification Classification node

 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {

	set lom [lors::imsmd::xml::newElement -owner $owner -name lom]

	if {![empty_string_p $general]} {
	    $lom appendChild $general
	}

	if {![empty_string_p $lifecycle]} {
	    $lom appendChild $lifecycle
	}

	if {![empty_string_p $metametadata]} {
	    $lom appendChild $metametadata
	}

	if {![empty_string_p $technical]} {
	    $lom appendChild $technical
	}

	if {![empty_string_p $educational]} {
	    $lom appendChild $educational
	}

	if {![empty_string_p $rights]} {
	    $lom appendChild $rights
	}

	if {![empty_string_p $relation]} {
	    $lom appendChild $relation
	}
	
	if {![empty_string_p $annotation]} {
	    $lom appendChild $annotation
	}
	
	if {![empty_string_p $classification]} {
	    $lom appendChild $classification
	}

	return $lom
	

    }


    ad_proc -public lom_general {
	{-owner:required}
	{-identifier {}}
	{-title {}}
	{-catalogentry {}}
	{-language {}}
	{-description {}}
	{-keyword {}}
	{-coverage {}}
	{-structure {}}
	{-aggregationlevel {}}
    } {
	Creates a LOM general node.
	It puts together all the general nodes

	refer to http://www.imsglobal.org/metadata/imsmdv1p2p1/imsmd_bindv1p2p1.html
	for further details. 


	@param owner ownerDocument node 
	@param identifier identifier 
	@param title Name given to the learning object. element occurs 0 or 1 time within the <general> element.
	@param catalogentry This data element defines an entry within a catalog.  element occurs 0 or more times.
	@param language The primary human language or languages used within this learning object to communicate to the intended user.element occurs 0 or more times 
	@param description  A textual description of the content of this learning object.element occurs 0 or more times 
	@param keyword A collection of keywords or phrases describing this learning object. element occurs 0 or more times 
	@param coverage The span or extent of such things as time, culture, geography or region that applies to this learning object.element occurs 0 or more times 
	@param structure Underlying organizational structure element occur 0 or 1 time  
	@param aggregationlevel  The functional granularity. element occurs 0 or 1 time

 	@author Ernie Ghiglione (ErnieG@mm.st).
    } {


	set general [lors::imsmd::xml::newElement -owner $owner -name general]

	# identifier

	if {![empty_string_p $identifier]} {

	    set identifier_node [lors::imsmd::xml::newElementText \
				     -owner $owner \
				     -name indentifier \
				     -text $identifier]

	    $general appendChild $identifier_node
	}


	# title

	if {![empty_string_p $title]} {

	    set title_node [lors::imsmd::xml::newElement -owner $owner -name title]
	    
	    foreach {y z} $title {
		set langstring_node [lors::imsmd::create::newLangString \
					 -owner $owner \
					 -lang $y \
					 -string $z \
					]
		
		
		$title_node appendChild $langstring_node

	    }


	    $general appendChild $title_node
	}
	
	# description
	if {![empty_string_p $description]} {

	    set description_node [lors::imsmd::xml::newElement -owner $owner -name description]
	    
	    foreach {y z} $description {
		set langstring_node [lors::imsmd::create::newLangString \
					 -owner $owner \
					 -lang $y \
					 -string $z \
					]
		
		
		$description_node appendChild $langstring_node

	    }


	    $general appendChild $description_node
	}


	return $general

    }


}

