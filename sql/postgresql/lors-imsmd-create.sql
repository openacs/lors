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

-- create ims metadata table
create table ims_md (
    ims_md_id       integer 
                    constraint ims_md_if_fk
                    references acs_objects(object_id)
                    on delete cascade 
                    constraint ims_md_id_pk 
                    primary key,
    resource_type   varchar(100),
    schema          varchar(100),
    schemaversion   varchar(100)
);

-- General begins
create table ims_md_general (
    ims_md_id   integer
                constraint ims_md_general_ims_md_id_fk 
                references ims_md(ims_md_id)
                on delete cascade
                constraint ims_md_general_ims_md_id_pk 
                primary key,
    title_l     varchar(100),
    title_s     varchar(1000),
    structure_s varchar(1000),
    structure_v varchar(1000),
    agg_level_s varchar(1000),
    agg_level_v varchar(1000)
);

comment on table ims_md_general is '
Groups information describing learning object as a whole.';


comment on column ims_md_general.structure_s is '
Underlying organizational structure of the resource
Multiplicity single value
Domain: vocabulary: {Collection, Mixed, Linear, Hierarchical, Networked, Branched, Parceled, Atomic}
Type: Vocabulary
';

comment on column ims_md_general.agg_level_s is '
The functional size of the resource.
Multiplicity: single value
Type: Vocabulary
';

-- create a sequence for ims_md_general_title
create sequence ims_md_general_title_seq start 1;

create table ims_md_general_title (
    ims_md_ge_ti_id integer
                    constraint ims_md_ge_ti_id_pk
                    primary key,
    ims_md_id       integer
                    constraint ims_md_ge_title_fk
                    references ims_md(ims_md_id)
                    on delete cascade,
    title_l         varchar(100),
    title_s         varchar(1000)
);

-- create index for ims_md_general_title 
create index ims_md_ge_ti__imd_md_id_idx on ims_md_general_title (ims_md_id);

comment on table  ims_md_general_title is '
Learning objects name
Multiplicity: single valuekeywork_l
Type LangStringType (1000 char) ';


-- Create a sequence for ims_md-general_iden
create sequence ims_md_general_iden_seq start 1;

create table ims_md_general_iden (
    ims_md_ge_iden_id   integer
                        constraint ims_md_ge_iden_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ge_iden_ims_md_id_fk 
                         references ims_md(ims_md_id)
                        on delete cascade,
    identifier  varchar(1000)
);

-- create index for ims_md_general_iden
create index ims_md_ge_iden__imd_md_id_idx on ims_md_general_iden (ims_md_id);

comment on table ims_md_general_iden is '
Globally unique label for learning object.
';

-- to ensure better performance we create a sequence for ims_md-general_iden
create sequence ims_md_general_cata_seq start 1;

create table ims_md_general_cata (
    ims_md_ge_cata_id   integer
                        constraint ims_md_ge_cata_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ge_cata_ims_md_id_fk 
                         references ims_md(ims_md_id)
                        on delete cascade,
    catalog     varchar(1000),
    entry_l     varchar(100),
    entry_s     varchar(1000)
);

-- create index for ims_md_general_cata
create index ims_md_ge_cata__imd_md_id_idx on ims_md_general_cata (ims_md_id);

comment on table ims_md_general_cata is '
Describes the name of the catalog 
';

-- sequence ims_md_general_lang_seq
create sequence ims_md_general_lang_seq start 1;

create table ims_md_general_lang (
    ims_md_ge_lang_id   integer
                        constraint ims_md_ge_lang_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ge_lang_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    language            varchar(100)
);

-- create index for ims_md_general_lang
create index ims_md_ge_lang__imd_md_id_idx on ims_md_general_lang (ims_md_id);

comment on column ims_md_general_lang.language is '
Learning objects language (can be Language without Country subcode; implies intended language of target audience). "None" is also acceptable.
Multiplicity: unordered list, smallest permitted maximum: 10 items; ISO 639-ISO 3166, see also xml:lang (RFC1766)
Domain: LanguageID = Langcode(-Subcode)*, with Langcode a two-letter language code as defined by ISO639 and Subcode a country code from ISO3166.
Type: String (100 char)
';

-- create seq for ims_md_general_desc table
create sequence ims_md_general_desc_seq start 1;

create table ims_md_general_desc (
    ims_md_ge_desc_id   integer
                        constraint ims_md_ge_desc_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ge_desc_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    descrip_l           varchar(100),
    descrip_s           varchar(2000)
);

-- create index for ims_md_general_desc
create index ims_md_ge_desc__imd_md_id_idx on ims_md_general_desc (ims_md_id);

comment on column ims_md_general_desc.descrip_l is '
Describes learning objects content.
Multiplicity: unordered list, smallest permitted maximum: 10 items
Type: LangStringType (2000 char)
';

-- create seq for ims_md_general_key table

create sequence ims_md_general_key_seq start 1;

create table ims_md_general_key (
    ims_md_ge_key_id    integer
                        constraint ims_md_ge_key_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ge_key_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    keyword_l           varchar(100),
    keyword_s           varchar(1000)
);

-- create index for ims_md_general_key
create index ims_md_ge_key__imd_md_id_idx on ims_md_general_key (ims_md_id);

comment on column ims_md_general_key.keyword_l is '
Contains keyword description of the resource.
Multiplicity: unordered list, smallest permitted maximum: 10 items
Type: LangStringType (1000 char)
';

--create seq for ims_md_general_cover
create sequence ims_md_general_cover_seq start 1;

create table ims_md_general_cover (
    ims_md_ge_cove_id   integer
                        constraint ims_md_ge_cove_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ge_key_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    cover_l             varchar(100),
    cover_s             varchar(1000)
);

-- create index for ims_md_general_cover
create index ims_md_ge_cover__imd_md_id_idx on ims_md_general_cover (ims_md_id);

comment on column ims_md_general_cover.cover_l is '
Temporal / spatial characteristics of content (e.g., historical context).
Multiplicity: unordered list, smallest permitted maximum: 10 items
Type: LangStringType (1000 char)
';

-- Life Cycle begins

create table ims_md_life_cycle (
    ims_md_id   integer
                constraint ims_md_life_cycle_ims_md_id_fk 
                references ims_md(ims_md_id)
                on delete cascade
                constraint ims_md_life_cycle_ims_md_id_pk 
                primary key,
    version_l   varchar(100),
    version_s   varchar(50),
    status_s    varchar(1000),
    status_v    varchar(1000)
);

comment on table ims_md_life_cycle is '
History and current state of resource.
Multiplicity: single instance
';

comment on column ims_md_life_cycle.version_l is '
The edition of the learning object.
Multiplicity: single value
LangStringType (50 char)
';

comment on column ims_md_life_cycle.status_s is '
Learning objects editorial condition.
Multiplicity: single value
Domain: vocabulary: {Draft, Final, Revised, Unavailable}
Type: Vocabulary
';

-- for life cycle contributors we have to create a sequence since 
-- otherwise the primary key get out of control and also the reference 
-- to life cycle contributores entities is just not right

create sequence ims_md_life_cycle_contrib_seq start 1;

create table ims_md_life_cycle_contrib (
    ims_md_lf_cont_id   integer -- from sequence
                        constraint ims_md_lc_cont_ims_md_lf_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_lc_contrib_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    role_s              varchar(1000),
    role_v              varchar(1000),
    cont_date           varchar(200),
    cont_date_l         varchar(100),
    cont_date_s         varchar(1000)
);

-- create index for ims_md_life_cycle_contrib
create index ims_md_lf_cont__imd_md_id_idx on ims_md_life_cycle_contrib (ims_md_id);

comment on table ims_md_life_cycle_contrib is '
Persons or organizations contributing to the resource (includes creation, edits, and publication).
Multiplicity: unordered list; smallest permitted maximum items: 30
';

comment on column ims_md_life_cycle_contrib.role_s is '
Kind of contribution.
Multiplicity: single value
Domain: vocabulary: {Author, Publisher, Unknown, Initiator, Terminator, Validator, Editor, Graphical Designer, Technical Implementer, Content Provider, Technical Validator, Educational Validator, Script Writer, Instructional Designer}
Type: Vocab
';

comment on column ims_md_life_cycle_contrib.cont_date is '
Date of contribution.
Multiplicity: single value
Type: DateType
';

-- create sequence for ims_md_life_cycle_contrib_enty table
create sequence ims_md_lf_c_contrib_enty_seq start 1;

create table ims_md_life_cycle_contrib_enty (
    ims_md_lf_cont_enti_id  integer
                            constraint ims_md_lf_cont_enti_id_pk
                            primary key,
    ims_md_lf_cont_id            integer
                            constraint ims_md_lf_cont_ent_fk
                            references ims_md_life_cycle_contrib(ims_md_lf_cont_id)
                            on delete cascade, 
    entity                  varchar(1000)
);

comment on table ims_md_life_cycle_contrib_enty is '
Entity or entities involved, most relevant first.
Multiplicity: ordered list; smallest permitted maximum items: 40; vCard
Domain: vCard <http://www.imc.org/pdi/>
Type: String (1000 chars)
';

-- Metadata begins

create table ims_md_metadata (
    ims_md_id   integer
                constraint ims_md_metadata_ims_md_id_fk 
                references ims_md(ims_md_id)
                on delete cascade
                constraint ims_md_metadata_ims_md_id_pk 
                primary key,
    language    varchar(100)
);

comment on table ims_md_metadata is '
Features of the description rather than the resource.
Multiplicity: single instance
';

comment on column ims_md_metadata.language is '
Language of the meta-data instance. This is the default language for all LangString values.
Multiplicity: single value
Type: String (100 char)
';

-- create seq for ims_md_metadata_cata
create sequence ims_md_metadata_cata_seq start 1;

create table ims_md_metadata_cata (
    ims_md_md_cata_id   integer
                        constraint ims_md_md_cata_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_md_cata_ims_md_id_fk
                        references ims_md (ims_md_id)
                        on delete cascade,
    catalog             varchar(1000),
    entry_l             varchar(100),
    entry_s             varchar(1000)
);

-- create index for ims_md_metadata_cata
create index ims_md_md_cata__imd_md_id_idx on ims_md_metadata_cata (ims_md_id);

comment on table ims_md_metadata_cata is '
A unique label for the meta-data.
single value
';

comment on column ims_md_metadata_cata.catalog is '
Designation given to the meta-data instance. Source of following string value.
single value
String (1000 char)
';

-- create seq for ims_md_metadata_contrib
create sequence ims_md_metadata_contrib_seq start 1;

create table ims_md_metadata_contrib (
    ims_md_md_cont_id   integer -- from sequence
                        constraint ims_md_md_cont_ims_md_md_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_md_contrib_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    role_s              varchar(1000),
    role_v              varchar(1000),
    cont_date           varchar(200),
    cont_date_l         varchar(100),
    cont_date_s         varchar(1000)
);

-- create index for ims_md_metadata_cont
create index ims_md_md_cont__imd_md_id_idx on ims_md_metadata_contrib (ims_md_id);

comment on table ims_md_metadata_contrib is '
Persons or organizations contributing to the meta-data
Multiplicity: ordered list, smallest permitted maximum: 10 items
';

comment on column ims_md_metadata_contrib.role_s is '
Kind of contribution.
single value
Domain: vocabulary: {Creator, Validator}
';

comment on column ims_md_metadata_contrib.cont_date is '
Date of contribution.
single value
DateType
';

-- create sequence for ims_md_metadata_contrib_entity table
create sequence ims_md_meta_contrib_enty_seq start 1;

create table ims_md_metadata_contrib_entity (
    ims_md_md_cont_enti_id  integer
                            constraint ims_md_md_cont_enti_id_pk
                            primary key,
    ims_md_md_cont_id       integer
                            constraint ims_md_lf_cont_ent_fk
                            references ims_md_metadata_contrib(ims_md_md_cont_id)
                            on delete cascade, 
    entity                  varchar(1000)
);

comment on column  ims_md_metadata_contrib_entity.entity is '
Entity or entities involved, most relevant first.
Multiplicity: ordered list as vCard; smallest permitted maximum: 10 items
Domain: vCard <http://www.imc.org/pdi/>
String (1000 char)
';

--create sequence for ims_md_metadata_scheme table
create sequence ims_md_metadata_scheme_seq start 1;

create table ims_md_metadata_scheme (
    ims_md_md_sch_id    integer
			constraint ims_md_md_sch_id_pk
			primary key,
    ims_md_id           integer
                        constraint ims_md_ms_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    scheme              varchar(30)
);

comment on table ims_md_metadata_scheme is '
Names the structure of the meta-data (this includes version).
unordered list; smallest permitted maximum: 10 items
String (30 char)
';


-- Technical begins

create table ims_md_technical (
    ims_md_id       integer
                    constraint ims_md_te_ims_md_id_fk
                    references ims_md(ims_md_id)
                    on delete cascade
                    constraint ims_md_te_ims_md_id_pk 
                    primary key,
    t_size          varchar(30),
    instl_rmrks_l   varchar(100),
    instl_rmrks_s   varchar(1000),
    otr_plt_l       varchar(100),
    otr_plt_s       varchar(1000),
    duration        varchar(200),
    duration_l      varchar(100),
    duration_s      varchar(1000)
);

comment on table ims_md_technical is '
Technical features of the learning object.
single instance
';

comment on column ims_md_technical.t_size is '
The size of the digital resource in bytes. Only the digits "0" - "9" should be used; the unit is bytes, not MBytes, GB, etc.
single value
String (30 char)
';

comment on column ims_md_technical.instl_rmrks_l is '
Description on how to install the resource.
single value
Type: LangStringType (1000 char)
';

comment on column ims_md_technical.otr_plt_l is '
Information about other software and hardware requirements.
single value
Type: LangStringType (1000 char)
';

comment on column ims_md_technical.duration is '
Time a continuous learning object takes when played at intended speed, in seconds.
Multiplicity: single value
Domain: ISO8601
Type: DateType
';

-- create sequence for ims_md_technical_format table
create sequence ims_md_technical_format_seq start 1;

create table ims_md_technical_format (
    ims_md_te_fo_id     integer
                        constraint ims_md_te_fo_id_pk
                        primary key, 
    ims_md_id           integer
                        constraint ims_md_te_fo_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    format              varchar(500)
);

-- create index for ims_md_technical_format
create index ims_md_te_format__imd_md_id_idx on ims_md_technical_format (ims_md_id);

comment on column ims_md_technical_format.format is '
Technical data type of the resource.
Multiplicity: unordered list, smallest permitted maximum: 40 items
Domain: restricted: MIME type or "non-digital"
Type: String (500 char)
';

-- create sequence for ims_md_technical_location table
create sequence ims_md_technical_location_seq start 1;

create table ims_md_technical_location (
    ims_md_te_lo_id     integer
                        constraint ims_md_te_lo_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_te_lo_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    type                varchar(100),
    location            varchar(1000)
);

-- create index for ims_md_technical_location
create index ims_md_te_loc_imd_md_id_idx on ims_md_technical_location (ims_md_id);

comment on column ims_md_technical_location.type is '
Values permitted: TEXT or URI
Reference where the location is
';

comment on column ims_md_technical_location.location is '
A location or a method that resolves to a location of the resource. Preferable Location first.
Multiplicity: ordered list; smallest permitted maximum: 10 items
Type: String (1000 char)
';

-- create sequence for ims_md_technical_requirement table
create sequence ims_md_tech_requirement_seq start 1;

create table ims_md_technical_requirement (
    ims_md_te_rq_id     integer
                        constraint ims_md_te_rq_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_te_rq_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    type_s              varchar(1000),
    type_v              varchar(1000),
    name_s              varchar(1000),
    name_v              varchar(1000),
    min_version         varchar(30),
    max_version         varchar(30)
);

-- create index for ims_md_technical_requirement
create index ims_md_te_req__imd_md_id_idx on ims_md_technical_requirement (ims_md_id);

comment on table ims_md_technical_requirement is '
Needs in order to access the resource. If there are multiple requirements, then the logical connector is AND.
multiple unordered instances; smallest permitted maximum: 40 items
';

comment on column ims_md_technical_requirement.type_s is '
Type of requirement.
Multiplicity: single value
Domain: vocabulary: {Operating System, Browser} 
';

comment on column ims_md_technical_requirement.name_s is '
Name of the required item.
Multiplicity: single value
Domain: if Type="Operating System", then vocabulary: {PC-DOS, MS- Windows, MacOS, Unix, Multi-OS, Other, None} if Type="Browser" then vocabulary: {Any, Netscape Communicator, Microsoft Internet Explorer, Opera} if other type, then open vocabulary
';

comment on column ims_md_technical_requirement.min_version is '
Lowest version of the required item.
single value
String (30 char)
';

comment on column ims_md_technical_requirement.max_version is '
Highest version of the required item.
single value
String (30 char)
';

-- Educational begins

create table ims_md_educational (
    ims_md_id       integer
                    constraint ims_md_ed_ims_md_id_fk
                    references ims_md(ims_md_id)
                    on delete cascade
                    constraint ims_md_ed_ims_md_id_pk 
                    primary key,
    int_type_s      varchar(1000),
    int_type_v      varchar(1000),
    int_level_s     varchar(1000),
    int_level_v     varchar(1000),
    sem_density_s   varchar(1000),
    sem_density_v   varchar(1000),
    difficulty_s    varchar(1000),
    difficulty_v    varchar(1000),
    type_lrn_time   varchar(200),
    type_lrn_time_l varchar(100),
    type_lrn_time_s varchar(1000)
);

comment on table ims_md_educational is '
Educational or pedagogic features of the learning object.
single instance
';

comment on column ims_md_educational.int_type_s is '
The type of interactivity supported by the learning object.
single value
vocabulary: {Active, Expositive, Mixed, Undefined}
';

comment on column ims_md_educational.int_level_s is '
Level of interactivity between an end user and the learning object.
Domain: vocabulary: {very low, low, medium, high, very high}
';

comment on column ims_md_educational.sem_density_s is '
Subjective measure of the learning objects usefulness as compared to its size or duration.
Domain: vocabulary: {very low, low, medium, high, very high}
';

comment on column ims_md_educational.difficulty_s is '
How hard it is to work through the learning object for the typical target audience.
single value
vocabulary: {very easy, easy, medium, difficult, very difficult}
';

comment on column ims_md_educational.type_lrn_time is '
Approximate or typical time it takes to work with the resource.
single value
Domain: ISO8601
Type: DateType
';


-- create seq from ims_md_educational_lrt table
create sequence ims_md_educational_lrt_seq start 1;

create table ims_md_educational_lrt (
    ims_md_ed_lr_id     integer
                        constraint ims_md_ed_lr_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ed_lr_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    lrt_s               varchar(1000),
    lrt_v               varchar(1000)
);

-- create index for ims_md_educational_lrt
create index ims_md_ed_lrt__imd_md_id_idx on ims_md_educational_lrt (ims_md_id);

comment on table ims_md_educational_lrt is '
learningresourcetype (Specific kind of resource, most dominant kind first)
ordered list; smallest permitted maximum: 10 items
vocabulary: {Exercise, Simulation, Questionnaire, Diagram, Figure, Graph, Index, Slide, Table, Narrative Text, Exam, Experiment, ProblemStatement, SelfAssesment}
';

-- create seq from ims_md_educational_ieur table
create sequence ims_md_educational_ieur_seq start 1;

create table ims_md_educational_ieur (
    ims_md_ed_ie_id     integer
                        constraint ims_md_ed_ie_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ed_ie_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    ieur_s              varchar(1000),
    ieur_v              varchar(1000)
);

-- create index for ims_md_educational_ieur
create index ims_md_ed_ieur__imd_md_id_idx on ims_md_educational_ieur (ims_md_id);

comment on table ims_md_educational_ieur is '
intendedenduserrole (Normal user of the learning object, most dominant first)
Multiplicity: ordered list, smallest permitted maximum:10 items
Domain: vocabulary: {Teacher, Author, Learner, Manager}
';

-- create seq from ims_md_educational_context table
create sequence ims_md_educational_context_seq start 1;

create table ims_md_educational_context (
    ims_md_ed_co_id     integer
                        constraint ims_md_ed_co_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ed_co_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    context_s           varchar(1000),
    context_v           varchar(1000)
);

-- create index for ims_md_educational_context
create index ims_md_ed_cont__imd_md_id_idx on ims_md_educational_context (ims_md_id);

comment on table ims_md_educational_context is '
The typical learning environment where use of learning object is intended to take place.
Multiplicity: unordered list; smallest permitted maximum: 4 items;
Domain: vocabulary: {Primary Education, Secondary Education, Higher Education, University First Cycle, University Second Cycle, University Postgrade, Technical School First Cycle, Technical School Second Cycle, Professional Formation, Continuous Formation, Vocational Training}
';

-- create seq from ims_md_educational_tar table
create sequence ims_md_educational_tar_seq start 1;

create table ims_md_educational_tar (
    ims_md_ed_ta_id     integer
                        constraint ims_md_ed_ta_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ed_ta_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    tar_l               varchar(100),
    tar_s               varchar(1000)
);

-- create index for ims_md_educational_tar
create index ims_md_ed_tar__imd_md_id_idx on ims_md_educational_tar (ims_md_id);

comment on table ims_md_educational_tar is '
typicalagerange (Age of the typical intended user)
Multiplicity: unordered list; smallest permitted maximum: 5 items
';

-- create seq from ims_md_educational_lang table
create sequence ims_md_educational_lang_seq start 1;

create table ims_md_educational_lang (
    ims_md_ed_la_id     integer
                        constraint ims_md_ed_la_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ed_la_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    language            varchar(100)
);

-- create index for ims_md_educational_lang
create index ims_md_ed_lang__imd_md_id_idx on ims_md_educational_lang (ims_md_id);

comment on table ims_md_educational_lang is '
Users natural language.
smallest permitted maximum: 10 items
';

-- create seq from ims_md_educational_lrt table
create sequence ims_md_educational_descrip_seq start 1;

create table ims_md_educational_descrip (
    ims_md_ed_de_id     integer
                        constraint ims_md_ed_de_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_ed_de_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    descrip_l           varchar(100),
    descrip_s           varchar(1000)
);

-- create index for ims_md_educational_descrip
create index ims_md_ed_desc_imd_md_id_idx on ims_md_educational_descrip (ims_md_id);

comment on table ims_md_educational_descrip is '
Comments on how the learning object is to be used.
single value
Type: LangStringType (1000 char)
';


-- Rights begins

create table ims_md_rights (
    ims_md_id       integer
                    constraint ims_md_ri_ims_md_id_fk
                    references ims_md(ims_md_id)
                    on delete cascade
                    constraint ims_md_ri_ims_md_id_pk 
                    primary key,
    cost_s          varchar(1000),
    cost_v          varchar(1000),
    caor_s          varchar(1000),
    caor_v          varchar(1000),
    descrip_l       varchar(100),
    descrip_s       varchar(1000)
);

comment on table ims_md_rights is '
Conditions of use of the resource.
single instance
';

comment on column ims_md_rights.cost_s is '
Whether use of the resource requires payment.
single value
vocabulary: {yes, no}
';

comment on column ims_md_rights.caor_s is '
copyrightandotherrestrictions
Whether copyright or other restrictions apply
single instance
vocabulary: {yes, no}
';

comment on column ims_md_rights.descrip_l is '
Description (Comments on the conditions of use of the resource)
single value
LangStringType (1000 char)
';

-- Relation begins

-- create seq for ims_md_relation table
create sequence ims_md_relation_seq start 1;

create table ims_md_relation (
    ims_md_re_id    integer
                    constraint ims_md_re_id_pk
                    primary key,
    ims_md_id       integer
                    constraint ims_md_re_ims_md_id_fk
                    references ims_md(ims_md_id)
                    on delete cascade,
    kind_s          varchar(1000),
    kind_v          varchar(1000)
);

-- create index for ims_md_relation
create index ims_md_re__imd_md_id_idx on ims_md_relation (ims_md_id);

comment on table ims_md_relation is '
Features of the resource in relationship to other learning objects.
Multiplicity: unordered list; smallest permitted maximum: 100 items
';

comment on column ims_md_relation.kind_s is '
Nature of the relationship between the resource being described and the one identified by Resource
single value
vocabulary list from Dublin Core: {IsPartOf, HasPart, IsVersionOf, HasVersion, IsFormatOf, HasFormat, References, IsReferencedBy, IsBasedOn, IsBasisFor, Requires, IsRequiredBy}
';

--create seq for ims_md_relation_resource table
create sequence ims_md_relation_resource_seq start 1;

create table ims_md_relation_resource (
    ims_md_re_re_id     integer
                        constraint ims_md_re_re_id_pk
                        primary key,
    ims_md_re_id        integer
                        constraint ims_md_re_re_rel_id_fk
                        references ims_md_relation(ims_md_re_id)
                        on delete cascade,
    identifier          varchar(1000),
    descrip_l           varchar(100),
    descrip_s           varchar(1000)
);

-- create index for ims_md_relation_resource
create index ims_md_re_res__imd_md_re_id_idx on ims_md_relation_resource (ims_md_re_id);

comment on table ims_md_relation_resource is '
Resource the relationship holds for.
single instance
';

comment on column ims_md_relation_resource.identifier is '
Unique Identifier of the other resource
single value
';

comment on column ims_md_relation_resource.descrip_l is '
Description of the other resource.
single value
LangStringType (1000 char)
';

--create seq for ims_md_rel_resource_catalog table
create sequence ims_md_rel_resource_cat_seq start 1;

create table ims_md_rel_resource_catalog (
    ims_md_re_re_ca_id  integer
                        constraint ims_md_re_re_ca_id_pk
                        primary key,
    ims_md_re_re_id     integer
                        constraint ims_md_re_re_ca_fk
                        references ims_md_relation_resource(ims_md_re_re_id)
                        on delete cascade,
    catalog             varchar(1000),
    entry_l             varchar(100),
    entry_s             varchar(1000)
);

-- create index for ims_md_rel_resource_catalog
create index ims_md_re__md_re_re_id_idx on ims_md_rel_resource_catalog (ims_md_re_re_id);

comment on table ims_md_rel_resource_catalog is '
Description of the other resource.
unordered list; smallest permitted maximum: 10 items
';

comment on column ims_md_rel_resource_catalog.catalog is '
Source of following string value
single value
String (1000 char)
';

comment on column ims_md_rel_resource_catalog.entry_l is '
Actual value
single value
LangStringType (1000 char)
';

-- Annotation begins

-- create seq for ims_md_annotation table
create sequence ims_md_annotation_seq start 1;

create table ims_md_annotation (
    ims_md_an_id        integer
                        constraint ims_md_an_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_an_ims_md_id_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    entity              varchar(1000),
    annotation_date     varchar(200),
    date_l              varchar(100),
    date_s              varchar(1000)
);

-- create index for ims_md_annotation
create index ims_md_an__imd_md_id_idx on ims_md_annotation (ims_md_id);

comment on table ims_md_annotation is '
Comments on the educational use of the learning object.
unordered list; smallest permitted maximum: 30 items
';

-- create seq for ims_md_annotation_descrip table
create sequence ims_md_annotation_descrip_seq start 1;

create table ims_md_annotation_descrip (
    ims_md_an_de_id     integer
                        constraint ims_md_an_de_id_pk
                        primary key,
    ims_md_an_id        integer
                        constraint ims_md_an_de_id_fk
                        references ims_md_annotation(ims_md_an_id)
                        on delete cascade,
    descrip_l           varchar(100),
    descrip_s           varchar(1000)
);

-- create index for ims_md_annotation_descrip
create index ims_md_an_desc_md_an_id_idx on ims_md_annotation_descrip (ims_md_an_id);

comment on table ims_md_annotation_descrip is '
Annotation descriptions. It can have descriptions in several languages
according to the langstrings.
';


-- Classification begins

-- create seq for ims_md_classification table
create sequence ims_md_classification_seq start 1;

create table ims_md_classification (
    ims_md_cl_id        integer
                        constraint ims_md_cl_id_pk
                        primary key,
    ims_md_id           integer
                        constraint ims_md_cl_id_imsmdid_fk
                        references ims_md(ims_md_id)
                        on delete cascade,
    purpose_s           varchar(1000),
    purpose_v           varchar(1000)
);

-- create index for ims_md_annotation
create index ims_md_cl__imd_md_id_idx on ims_md_classification (ims_md_id);

comment on table ims_md_classification is '
Description of a characteristic of the resource by entries in classifications.
unordered list; smallest permitted maximum: 40 items
';

comment on column ims_md_classification.purpose_s is '
Characteristics of the resource described by this classification entry.
single value
vocabulary: {Discipline, Idea, Prerequisite, Educational Objective, Accessibility Restrictions, Educational Level, Skill Level, Security Level}
';

create sequence ims_md_classification_desc_seq start 1;

create table ims_md_classification_descrip (
    ims_md_cl_de_id     integer
                        constraint ims_md_cl_ed_id_pk
                        primary key,
    ims_md_cl_id        integer
                        constraint imd_md_cl_ed_id_fk
                        references ims_md_classification(ims_md_cl_id)
                        on delete cascade,
    descrip_l           varchar(100),
    descrip_s           varchar(1000)
);

-- create index for ims_md_classification_descrip
create index ims_md_cl_desc_md_cl_id_idx on ims_md_classification_descrip (ims_md_cl_id);

comment on table ims_md_classification_descrip is '
A textual description of learning object relative to its stated purpose.
single value. However, it can have several langstrings
';

--create seq for ims_md_classification_taxpath table
create sequence ims_md_classif_taxpath_seq start 1;

create table ims_md_classification_taxpath (
    ims_md_cl_ta_id     integer
                        constraint ims_md_cl_ta_id_pk
                        primary key, 
    ims_md_cl_id        integer
                        constraint ims_md_cl_ta_fk
                        references ims_md_classification(ims_md_cl_id)
                        on delete cascade,
    source_l            varchar(100),
    source_v            varchar(1000)
);

-- create index for ims_md_classification_taxpath
create index ims_md_cl_tax__imd_md_cl_id_idx on ims_md_classification_taxpath (ims_md_cl_id);

comment on table ims_md_classification_taxpath is '
A taxonomic path in a specific classification.
unordered instance; smallest permitted maximum: 15 items
';

comment on column ims_md_classification_taxpath.source_l is '
A specific classification.
single value
';

--create seq ims_md_classif_taxpath_taxon table
create sequence ims_md_classif_tpath_taxon_seq start 1;

create table ims_md_classif_taxpath_taxon (
    ims_md_cl_ta_ta_id  integer
                        constraint ims_md_cl_ta_ta_id_pk
                        primary key,
    ims_md_cl_ta_id     integer
                        constraint ims_md_cl_ta_ta_fk
                        references ims_md_classification_taxpath(ims_md_cl_ta_id)
                        on delete cascade,
    -- hierarchy is a column I inserted to show the hiearchy of the terms presented
    -- ie:
    -- hierarchy  | taxon entry
    --	0 	Information Science
    --	 1	 Information Processing
    --	  2	  Metadata 
    --ims_md_classif_taxpath_taxon
    -- The hierarchy to be inserted by the SCORM package
    hierarchy           varchar(10),
    identifier          varchar(100),
    entry_l             varchar(100),
    entry_s             varchar(500)
);

-- create index for ims_md_classif_taxpath_taxon
create index ims_md_cl_t_t__md_cl_ta_id_idx on ims_md_classif_taxpath_taxon (ims_md_cl_ta_id);

comment on table ims_md_classif_taxpath_taxon is '
An entry in a classification. An ordered list of Taxons creates a taxonomic path, i.e. "taxonomic stairway": this is a path from a more general to more specific entry in a classification.
ordered list; smallest permitted maximum: 15 items
';

--create seq for ims_md_classification_keyword table
create sequence ims_md_classif_keyword_seq start 1;

create table ims_md_classification_keyword (
    ims_md_cl_ke_id     integer
                        constraint ims_md_cl_ke_id_pk
                        primary key,
    ims_md_cl_id        integer
                        constraint ims_md_cl_ke_ims_md_cl_id_fk
                        references ims_md_classification(ims_md_cl_id)
                        on delete cascade,
    keyword_l           varchar(100),
    keyword_s           varchar(1000)
);

-- create index for ims_md_classification_keyword
create index ims_md_cl_key__imd_md_cl_id_idx on ims_md_classification_keyword (ims_md_cl_id);

comment on table ims_md_classification_keyword is '
Contains keyword description of learning objective relative to its stated purpose.
ordered list smallest permitted maximum: 40 items
';
