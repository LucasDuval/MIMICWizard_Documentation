DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TABLE public.cohort (
	cohort_id float8 NULL,
	subject_id float8 NULL,
	hadm_id float8 NULL,
	stay_id float8 NULL
);

CREATE TABLE public.customevents (
	subject_id float8 NULL,
	hadm_id float8 NULL,
	stay_id float8 NULL,
	itemid float8 NULL,
	value float8 NULL,
	charttime timestamptz NULL,
	valueuom text NULL
);

CREATE SEQUENCE public.d_cohorts_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

	CREATE SEQUENCE public.d_customevents_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 10000
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE public.users_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

CREATE TABLE public.d_cohorts (
	cohort_id int4 DEFAULT nextval('d_cohorts_seq'::regclass) NOT NULL,
	cohort_name varchar NULL,
	cohort_description text NULL
);

CREATE TABLE public.d_customevents (
	itemid int4 DEFAULT nextval('d_customevents_seq'::regclass) NOT NULL,
	"label" varchar NULL,
	abbreviation varchar NULL,
	author varchar NULL,
	total_row numeric NULL
);

CREATE TABLE public.users (
	user_id int4 DEFAULT nextval('users_seq'::regclass) NOT NULL,
	user_name varchar NULL,
	user_description varchar NULL,
	user_itemids varchar NULL,
	user_cohorts varchar NULL
);


-- public.events_summary source

CREATE MATERIALIZED VIEW public.events_summary
TABLESPACE pg_default
AS SELECT "...1".itemid,
    "...1".label,
    "...1".evt_cnt,
    "...2".stay_cnt,
    "...3".hadm_cnt,
    "...4".patient_cnt
   FROM ( SELECT q01.itemid,
            q01.label,
            count(*) AS evt_cnt
           FROM ( SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT procedureevents.subject_id,
                            procedureevents.hadm_id,
                            procedureevents.stay_id,
                            procedureevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            procedureevents.value,
                            procedureevents.valueuom,
                            procedureevents.starttime,
                            procedureevents.endtime
                           FROM mimiciv_icu.procedureevents
                             JOIN mimiciv_icu.d_items ON procedureevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT ingredientevents.subject_id,
                            ingredientevents.hadm_id,
                            ingredientevents.stay_id,
                            ingredientevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            ingredientevents.amount AS value,
                            ingredientevents.amountuom AS valueuom,
                            ingredientevents.starttime,
                            ingredientevents.endtime
                           FROM mimiciv_icu.ingredientevents
                             JOIN mimiciv_icu.d_items ON ingredientevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT inputevents.subject_id,
                            inputevents.hadm_id,
                            inputevents.stay_id,
                            inputevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            inputevents.amount AS value,
                            inputevents.amountuom AS valueuom,
                            inputevents.starttime,
                            inputevents.endtime
                           FROM mimiciv_icu.inputevents
                             JOIN mimiciv_icu.d_items ON inputevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime::timestamp without time zone AS starttime,
                    NULL::timestamp without time zone AS endtime
                   FROM ( SELECT outputevents.subject_id,
                            outputevents.hadm_id,
                            outputevents.stay_id,
                            outputevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            outputevents.value,
                            outputevents.valueuom,
                            outputevents.charttime AS starttime
                           FROM mimiciv_icu.outputevents
                             JOIN mimiciv_icu.d_items ON outputevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    NULL::double precision AS value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT q01_2.subject_id,
                            q01_2.hadm_id,
                            q01_2.stay_id,
                            q01_2.itemid,
                            q01_2.label,
                            q01_2.abbreviation,
                            q01_2.linksto,
                            q01_2.category,
                            q01_2.unitname,
                            q01_2.param_type,
                            q01_2.lownormalvalue,
                            q01_2.highnormalvalue,
                            q01_2.valueuom,
                            q01_2.starttime,
                            NULL::timestamp without time zone AS endtime
                           FROM ( SELECT datetimeevents.subject_id,
                                    datetimeevents.hadm_id,
                                    datetimeevents.stay_id,
                                    datetimeevents.itemid,
                                    d_items.label,
                                    d_items.abbreviation,
                                    d_items.linksto,
                                    d_items.category,
                                    d_items.unitname,
                                    d_items.param_type,
                                    d_items.lownormalvalue,
                                    d_items.highnormalvalue,
                                    datetimeevents.value,
                                    datetimeevents.valueuom,
                                    datetimeevents.charttime AS starttime
                                   FROM mimiciv_icu.datetimeevents
                                     JOIN mimiciv_icu.d_items ON datetimeevents.itemid = d_items.itemid) q01_2) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    NULL::timestamp without time zone AS endtime
                   FROM ( SELECT chartevents.subject_id,
                            chartevents.hadm_id,
                            chartevents.stay_id,
                            chartevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            chartevents.valuenum AS value,
                            chartevents.valueuom,
                            chartevents.charttime AS starttime
                           FROM mimiciv_icu.chartevents
                             JOIN mimiciv_icu.d_items ON chartevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    NULL::integer AS stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    NULL::character varying AS abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    NULL::character varying AS unitname,
                    q01_1.param_type,
                    NULL::double precision AS lownormalvalue,
                    NULL::double precision AS highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT q01_2.subject_id,
                            q01_2.hadm_id,
                            q01_2.itemid,
                            q01_2.label,
                            'labevents'::text AS linksto,
                            q01_2.category,
                            q01_2.fluid AS param_type,
                            q01_2.valuenum AS value,
                            q01_2.valueuom,
                            q01_2.charttime::timestamp without time zone AS starttime,
                            NULL::timestamp without time zone AS endtime
                           FROM ( SELECT labevents.labevent_id,
                                    labevents.subject_id,
                                    labevents.hadm_id,
                                    labevents.specimen_id,
                                    labevents.itemid,
                                    labevents.order_provider_id,
                                    labevents.charttime,
                                    labevents.storetime,
                                    labevents.value,
                                    labevents.valuenum,
                                    labevents.valueuom,
                                    labevents.ref_range_lower,
                                    labevents.ref_range_upper,
                                    labevents.flag,
                                    labevents.priority,
                                    labevents.comments,
                                    d_labitems.label,
                                    d_labitems.fluid,
                                    d_labitems.category
                                   FROM mimiciv_hosp.labevents
                                     JOIN mimiciv_hosp.d_labitems ON labevents.itemid = d_labitems.itemid) q01_2) q01_1) q01
          GROUP BY q01.itemid, q01.label) "...1"
     JOIN ( SELECT q01.itemid,
            q01.label,
            count(DISTINCT q01.stay_id) AS stay_cnt
           FROM ( SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT procedureevents.subject_id,
                            procedureevents.hadm_id,
                            procedureevents.stay_id,
                            procedureevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            procedureevents.value,
                            procedureevents.valueuom,
                            procedureevents.starttime,
                            procedureevents.endtime
                           FROM mimiciv_icu.procedureevents
                             JOIN mimiciv_icu.d_items ON procedureevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT ingredientevents.subject_id,
                            ingredientevents.hadm_id,
                            ingredientevents.stay_id,
                            ingredientevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            ingredientevents.amount AS value,
                            ingredientevents.amountuom AS valueuom,
                            ingredientevents.starttime,
                            ingredientevents.endtime
                           FROM mimiciv_icu.ingredientevents
                             JOIN mimiciv_icu.d_items ON ingredientevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT inputevents.subject_id,
                            inputevents.hadm_id,
                            inputevents.stay_id,
                            inputevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            inputevents.amount AS value,
                            inputevents.amountuom AS valueuom,
                            inputevents.starttime,
                            inputevents.endtime
                           FROM mimiciv_icu.inputevents
                             JOIN mimiciv_icu.d_items ON inputevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime::timestamp without time zone AS starttime,
                    NULL::timestamp without time zone AS endtime
                   FROM ( SELECT outputevents.subject_id,
                            outputevents.hadm_id,
                            outputevents.stay_id,
                            outputevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            outputevents.value,
                            outputevents.valueuom,
                            outputevents.charttime AS starttime
                           FROM mimiciv_icu.outputevents
                             JOIN mimiciv_icu.d_items ON outputevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    NULL::double precision AS value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT q01_2.subject_id,
                            q01_2.hadm_id,
                            q01_2.stay_id,
                            q01_2.itemid,
                            q01_2.label,
                            q01_2.abbreviation,
                            q01_2.linksto,
                            q01_2.category,
                            q01_2.unitname,
                            q01_2.param_type,
                            q01_2.lownormalvalue,
                            q01_2.highnormalvalue,
                            q01_2.valueuom,
                            q01_2.starttime,
                            NULL::timestamp without time zone AS endtime
                           FROM ( SELECT datetimeevents.subject_id,
                                    datetimeevents.hadm_id,
                                    datetimeevents.stay_id,
                                    datetimeevents.itemid,
                                    d_items.label,
                                    d_items.abbreviation,
                                    d_items.linksto,
                                    d_items.category,
                                    d_items.unitname,
                                    d_items.param_type,
                                    d_items.lownormalvalue,
                                    d_items.highnormalvalue,
                                    datetimeevents.value,
                                    datetimeevents.valueuom,
                                    datetimeevents.charttime AS starttime
                                   FROM mimiciv_icu.datetimeevents
                                     JOIN mimiciv_icu.d_items ON datetimeevents.itemid = d_items.itemid) q01_2) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    NULL::timestamp without time zone AS endtime
                   FROM ( SELECT chartevents.subject_id,
                            chartevents.hadm_id,
                            chartevents.stay_id,
                            chartevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            chartevents.valuenum AS value,
                            chartevents.valueuom,
                            chartevents.charttime AS starttime
                           FROM mimiciv_icu.chartevents
                             JOIN mimiciv_icu.d_items ON chartevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    NULL::integer AS stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    NULL::character varying AS abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    NULL::character varying AS unitname,
                    q01_1.param_type,
                    NULL::double precision AS lownormalvalue,
                    NULL::double precision AS highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT q01_2.subject_id,
                            q01_2.hadm_id,
                            q01_2.itemid,
                            q01_2.label,
                            'labevents'::text AS linksto,
                            q01_2.category,
                            q01_2.fluid AS param_type,
                            q01_2.valuenum AS value,
                            q01_2.valueuom,
                            q01_2.charttime::timestamp without time zone AS starttime,
                            NULL::timestamp without time zone AS endtime
                           FROM ( SELECT labevents.labevent_id,
                                    labevents.subject_id,
                                    labevents.hadm_id,
                                    labevents.specimen_id,
                                    labevents.itemid,
                                    labevents.order_provider_id,
                                    labevents.charttime,
                                    labevents.storetime,
                                    labevents.value,
                                    labevents.valuenum,
                                    labevents.valueuom,
                                    labevents.ref_range_lower,
                                    labevents.ref_range_upper,
                                    labevents.flag,
                                    labevents.priority,
                                    labevents.comments,
                                    d_labitems.label,
                                    d_labitems.fluid,
                                    d_labitems.category
                                   FROM mimiciv_hosp.labevents
                                     JOIN mimiciv_hosp.d_labitems ON labevents.itemid = d_labitems.itemid) q01_2) q01_1) q01
          GROUP BY q01.itemid, q01.label) "...2" ON "...1".itemid = "...2".itemid AND "...1".label::text = "...2".label::text
     JOIN ( SELECT q01.itemid,
            q01.label,
            count(DISTINCT q01.hadm_id) AS hadm_cnt
           FROM ( SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT procedureevents.subject_id,
                            procedureevents.hadm_id,
                            procedureevents.stay_id,
                            procedureevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            procedureevents.value,
                            procedureevents.valueuom,
                            procedureevents.starttime,
                            procedureevents.endtime
                           FROM mimiciv_icu.procedureevents
                             JOIN mimiciv_icu.d_items ON procedureevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT ingredientevents.subject_id,
                            ingredientevents.hadm_id,
                            ingredientevents.stay_id,
                            ingredientevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            ingredientevents.amount AS value,
                            ingredientevents.amountuom AS valueuom,
                            ingredientevents.starttime,
                            ingredientevents.endtime
                           FROM mimiciv_icu.ingredientevents
                             JOIN mimiciv_icu.d_items ON ingredientevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT inputevents.subject_id,
                            inputevents.hadm_id,
                            inputevents.stay_id,
                            inputevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            inputevents.amount AS value,
                            inputevents.amountuom AS valueuom,
                            inputevents.starttime,
                            inputevents.endtime
                           FROM mimiciv_icu.inputevents
                             JOIN mimiciv_icu.d_items ON inputevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime::timestamp without time zone AS starttime,
                    NULL::timestamp without time zone AS endtime
                   FROM ( SELECT outputevents.subject_id,
                            outputevents.hadm_id,
                            outputevents.stay_id,
                            outputevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            outputevents.value,
                            outputevents.valueuom,
                            outputevents.charttime AS starttime
                           FROM mimiciv_icu.outputevents
                             JOIN mimiciv_icu.d_items ON outputevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    NULL::double precision AS value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT q01_2.subject_id,
                            q01_2.hadm_id,
                            q01_2.stay_id,
                            q01_2.itemid,
                            q01_2.label,
                            q01_2.abbreviation,
                            q01_2.linksto,
                            q01_2.category,
                            q01_2.unitname,
                            q01_2.param_type,
                            q01_2.lownormalvalue,
                            q01_2.highnormalvalue,
                            q01_2.valueuom,
                            q01_2.starttime,
                            NULL::timestamp without time zone AS endtime
                           FROM ( SELECT datetimeevents.subject_id,
                                    datetimeevents.hadm_id,
                                    datetimeevents.stay_id,
                                    datetimeevents.itemid,
                                    d_items.label,
                                    d_items.abbreviation,
                                    d_items.linksto,
                                    d_items.category,
                                    d_items.unitname,
                                    d_items.param_type,
                                    d_items.lownormalvalue,
                                    d_items.highnormalvalue,
                                    datetimeevents.value,
                                    datetimeevents.valueuom,
                                    datetimeevents.charttime AS starttime
                                   FROM mimiciv_icu.datetimeevents
                                     JOIN mimiciv_icu.d_items ON datetimeevents.itemid = d_items.itemid) q01_2) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    NULL::timestamp without time zone AS endtime
                   FROM ( SELECT chartevents.subject_id,
                            chartevents.hadm_id,
                            chartevents.stay_id,
                            chartevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            chartevents.valuenum AS value,
                            chartevents.valueuom,
                            chartevents.charttime AS starttime
                           FROM mimiciv_icu.chartevents
                             JOIN mimiciv_icu.d_items ON chartevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    NULL::integer AS stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    NULL::character varying AS abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    NULL::character varying AS unitname,
                    q01_1.param_type,
                    NULL::double precision AS lownormalvalue,
                    NULL::double precision AS highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT q01_2.subject_id,
                            q01_2.hadm_id,
                            q01_2.itemid,
                            q01_2.label,
                            'labevents'::text AS linksto,
                            q01_2.category,
                            q01_2.fluid AS param_type,
                            q01_2.valuenum AS value,
                            q01_2.valueuom,
                            q01_2.charttime::timestamp without time zone AS starttime,
                            NULL::timestamp without time zone AS endtime
                           FROM ( SELECT labevents.labevent_id,
                                    labevents.subject_id,
                                    labevents.hadm_id,
                                    labevents.specimen_id,
                                    labevents.itemid,
                                    labevents.order_provider_id,
                                    labevents.charttime,
                                    labevents.storetime,
                                    labevents.value,
                                    labevents.valuenum,
                                    labevents.valueuom,
                                    labevents.ref_range_lower,
                                    labevents.ref_range_upper,
                                    labevents.flag,
                                    labevents.priority,
                                    labevents.comments,
                                    d_labitems.label,
                                    d_labitems.fluid,
                                    d_labitems.category
                                   FROM mimiciv_hosp.labevents
                                     JOIN mimiciv_hosp.d_labitems ON labevents.itemid = d_labitems.itemid) q01_2) q01_1) q01
          GROUP BY q01.itemid, q01.label) "...3" ON "...1".itemid = "...3".itemid AND "...1".label::text = "...3".label::text
     JOIN ( SELECT q01.itemid,
            q01.label,
            count(DISTINCT q01.subject_id) AS patient_cnt
           FROM ( SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT procedureevents.subject_id,
                            procedureevents.hadm_id,
                            procedureevents.stay_id,
                            procedureevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            procedureevents.value,
                            procedureevents.valueuom,
                            procedureevents.starttime,
                            procedureevents.endtime
                           FROM mimiciv_icu.procedureevents
                             JOIN mimiciv_icu.d_items ON procedureevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT ingredientevents.subject_id,
                            ingredientevents.hadm_id,
                            ingredientevents.stay_id,
                            ingredientevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            ingredientevents.amount AS value,
                            ingredientevents.amountuom AS valueuom,
                            ingredientevents.starttime,
                            ingredientevents.endtime
                           FROM mimiciv_icu.ingredientevents
                             JOIN mimiciv_icu.d_items ON ingredientevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT inputevents.subject_id,
                            inputevents.hadm_id,
                            inputevents.stay_id,
                            inputevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            inputevents.amount AS value,
                            inputevents.amountuom AS valueuom,
                            inputevents.starttime,
                            inputevents.endtime
                           FROM mimiciv_icu.inputevents
                             JOIN mimiciv_icu.d_items ON inputevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime::timestamp without time zone AS starttime,
                    NULL::timestamp without time zone AS endtime
                   FROM ( SELECT outputevents.subject_id,
                            outputevents.hadm_id,
                            outputevents.stay_id,
                            outputevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            outputevents.value,
                            outputevents.valueuom,
                            outputevents.charttime AS starttime
                           FROM mimiciv_icu.outputevents
                             JOIN mimiciv_icu.d_items ON outputevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    NULL::double precision AS value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT q01_2.subject_id,
                            q01_2.hadm_id,
                            q01_2.stay_id,
                            q01_2.itemid,
                            q01_2.label,
                            q01_2.abbreviation,
                            q01_2.linksto,
                            q01_2.category,
                            q01_2.unitname,
                            q01_2.param_type,
                            q01_2.lownormalvalue,
                            q01_2.highnormalvalue,
                            q01_2.valueuom,
                            q01_2.starttime,
                            NULL::timestamp without time zone AS endtime
                           FROM ( SELECT datetimeevents.subject_id,
                                    datetimeevents.hadm_id,
                                    datetimeevents.stay_id,
                                    datetimeevents.itemid,
                                    d_items.label,
                                    d_items.abbreviation,
                                    d_items.linksto,
                                    d_items.category,
                                    d_items.unitname,
                                    d_items.param_type,
                                    d_items.lownormalvalue,
                                    d_items.highnormalvalue,
                                    datetimeevents.value,
                                    datetimeevents.valueuom,
                                    datetimeevents.charttime AS starttime
                                   FROM mimiciv_icu.datetimeevents
                                     JOIN mimiciv_icu.d_items ON datetimeevents.itemid = d_items.itemid) q01_2) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    q01_1.stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    q01_1.abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    q01_1.unitname,
                    q01_1.param_type,
                    q01_1.lownormalvalue,
                    q01_1.highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    NULL::timestamp without time zone AS endtime
                   FROM ( SELECT chartevents.subject_id,
                            chartevents.hadm_id,
                            chartevents.stay_id,
                            chartevents.itemid,
                            d_items.label,
                            d_items.abbreviation,
                            d_items.linksto,
                            d_items.category,
                            d_items.unitname,
                            d_items.param_type,
                            d_items.lownormalvalue,
                            d_items.highnormalvalue,
                            chartevents.valuenum AS value,
                            chartevents.valueuom,
                            chartevents.charttime AS starttime
                           FROM mimiciv_icu.chartevents
                             JOIN mimiciv_icu.d_items ON chartevents.itemid = d_items.itemid) q01_1
                UNION ALL
                 SELECT q01_1.subject_id,
                    q01_1.hadm_id,
                    NULL::integer AS stay_id,
                    q01_1.itemid,
                    q01_1.label,
                    NULL::character varying AS abbreviation,
                    q01_1.linksto,
                    q01_1.category,
                    NULL::character varying AS unitname,
                    q01_1.param_type,
                    NULL::double precision AS lownormalvalue,
                    NULL::double precision AS highnormalvalue,
                    q01_1.value,
                    q01_1.valueuom,
                    q01_1.starttime,
                    q01_1.endtime
                   FROM ( SELECT q01_2.subject_id,
                            q01_2.hadm_id,
                            q01_2.itemid,
                            q01_2.label,
                            'labevents'::text AS linksto,
                            q01_2.category,
                            q01_2.fluid AS param_type,
                            q01_2.valuenum AS value,
                            q01_2.valueuom,
                            q01_2.charttime::timestamp without time zone AS starttime,
                            NULL::timestamp without time zone AS endtime
                           FROM ( SELECT labevents.labevent_id,
                                    labevents.subject_id,
                                    labevents.hadm_id,
                                    labevents.specimen_id,
                                    labevents.itemid,
                                    labevents.order_provider_id,
                                    labevents.charttime,
                                    labevents.storetime,
                                    labevents.value,
                                    labevents.valuenum,
                                    labevents.valueuom,
                                    labevents.ref_range_lower,
                                    labevents.ref_range_upper,
                                    labevents.flag,
                                    labevents.priority,
                                    labevents.comments,
                                    d_labitems.label,
                                    d_labitems.fluid,
                                    d_labitems.category
                                   FROM mimiciv_hosp.labevents
                                     JOIN mimiciv_hosp.d_labitems ON labevents.itemid = d_labitems.itemid) q01_2) q01_1) q01
          GROUP BY q01.itemid, q01.label) "...4" ON "...1".itemid = "...4".itemid AND "...1".label::text = "...4".label::text
WITH DATA;

-- public.uid_list source

CREATE MATERIALIZED VIEW public.uid_list
TABLESPACE pg_default
AS SELECT DISTINCT q01.type,
    q01.uid
   FROM ( SELECT 'subject_id'::text AS type,
            q01_1.subject_id AS uid
           FROM ( SELECT patients.subject_id,
                    admissions.hadm_id,
                    icustays.stay_id
                   FROM mimiciv_hosp.patients
                     LEFT JOIN mimiciv_hosp.admissions ON patients.subject_id = admissions.subject_id
                     LEFT JOIN mimiciv_icu.icustays ON patients.subject_id = icustays.subject_id AND admissions.hadm_id = icustays.hadm_id) q01_1
        UNION ALL
         SELECT 'hadm_id'::text AS type,
            q01_1.hadm_id AS uid
           FROM ( SELECT patients.subject_id,
                    admissions.hadm_id,
                    icustays.stay_id
                   FROM mimiciv_hosp.patients
                     LEFT JOIN mimiciv_hosp.admissions ON patients.subject_id = admissions.subject_id
                     LEFT JOIN mimiciv_icu.icustays ON patients.subject_id = icustays.subject_id AND admissions.hadm_id = icustays.hadm_id) q01_1
        UNION ALL
         SELECT 'stay_id'::text AS type,
            q01_1.stay_id AS uid
           FROM ( SELECT patients.subject_id,
                    admissions.hadm_id,
                    icustays.stay_id
                   FROM mimiciv_hosp.patients
                     LEFT JOIN mimiciv_hosp.admissions ON patients.subject_id = admissions.subject_id
                     LEFT JOIN mimiciv_icu.icustays ON patients.subject_id = icustays.subject_id AND admissions.hadm_id = icustays.hadm_id) q01_1) q01
  WHERE q01.uid IS NOT NULL
  ORDER BY q01.uid
WITH DATA;




-- public.microbiologyresultsevents source

CREATE MATERIALIZED VIEW public.microbiologyresultsevents
TABLESPACE pg_default
AS SELECT m.subject_id,
    m.hadm_id,
    NULL::integer AS stay_id,
    m.test_itemid AS itemid,
    'microbiologyevents'::text AS linksto,
        CASE
            WHEN m.charttime IS NOT NULL THEN m.charttime
            ELSE m.chartdate
        END AS charttime,
    m.spec_type_desc,
    m.test_name AS label,
    m.org_name AS value,
        CASE
            WHEN m.org_name::text ~~ 'NEGATIVE%'::text OR m.org_name::text = 'CANCELLED'::text THEN 0
            ELSE 1
        END AS valuenum,
    m.microevent_id,
    ''::character varying(20) AS valueuom
   FROM mimiciv_hosp.microbiologyevents m
  WHERE m.org_name IS NOT NULL
UNION
 SELECT m.subject_id,
    m.hadm_id,
    NULL::integer AS stay_id,
    m.test_itemid AS itemid,
    'microbiologyevents'::text AS linksto,
        CASE
            WHEN m.charttime IS NOT NULL THEN m.charttime
            ELSE m.chartdate
        END AS charttime,
    m.spec_type_desc,
    m.test_name AS label,
    m.comments AS value,
        CASE
            WHEN m.comments ~~ 'POSITIVE%'::text THEN 1
            ELSE 0
        END AS valuenum,
    m.microevent_id,
    ''::character varying(20) AS valueuom
   FROM mimiciv_hosp.microbiologyevents m
  WHERE m.org_name IS NULL AND (upper(m.comments) ~~ 'POSITIVE%'::text OR upper(m.comments) ~~ 'NEGATIVE%'::text)
WITH DATA;

-- public.d_prescriptions source

CREATE MATERIALIZED VIEW public.d_prescriptions
TABLESPACE pg_default
AS SELECT 1000000 + row_number() OVER (ORDER BY q01.drug) AS itemid,
    q01.drug
   FROM ( SELECT DISTINCT prescriptions.drug
           FROM mimiciv_hosp.prescriptions
          ORDER BY prescriptions.drug) q01
WITH DATA;

-- public.static_distinct_events source

CREATE MATERIALIZED VIEW public.static_distinct_events
TABLESPACE pg_default
AS SELECT cq.itemid,
    cq.label,
    cq.category,
    cq.linksto,
    cq.param_type
   FROM ( SELECT DISTINCT d_items.itemid,
            d_items.label,
            d_items.linksto,
            d_items.category,
            d_items.param_type
           FROM mimiciv_icu.d_items
          WHERE d_items.linksto::text = 'procedureevents'::text
        UNION ALL
         SELECT DISTINCT d_items.itemid,
            d_items.label,
            d_items.linksto,
            d_items.category,
            d_items.param_type
           FROM mimiciv_icu.d_items
          WHERE d_items.linksto::text = 'ingredientevents'::text
        UNION ALL
         SELECT DISTINCT d_items.itemid,
            d_items.label,
            d_items.linksto,
            d_items.category,
            d_items.param_type
           FROM mimiciv_icu.d_items
          WHERE d_items.linksto::text = 'inputevents'::text
        UNION ALL
         SELECT DISTINCT d_items.itemid,
            d_items.label,
            d_items.linksto,
            d_items.category,
            d_items.param_type
           FROM mimiciv_icu.d_items
          WHERE d_items.linksto::text = 'outputevents'::text
        UNION ALL
         SELECT DISTINCT d_items.itemid,
            d_items.label,
            d_items.linksto,
            d_items.category,
            d_items.param_type
           FROM mimiciv_icu.d_items
          WHERE d_items.linksto::text = 'datetimeevents'::text
        UNION ALL
         SELECT DISTINCT d_items.itemid,
            d_items.label,
            d_items.linksto,
            d_items.category,
            d_items.param_type
           FROM mimiciv_icu.d_items
          WHERE d_items.linksto::text = 'chartevents'::text
        UNION ALL
         SELECT DISTINCT d_labitems.itemid,
            d_labitems.label,
            'labevents'::text AS linksto,
            d_labitems.category,
            d_labitems.fluid AS param_type
           FROM mimiciv_hosp.d_labitems
        UNION ALL
         SELECT DISTINCT microbiologyresultsevents.itemid,
            microbiologyresultsevents.label,
            'microbiologyresultsevents'::text AS linksto,
            'Microbiology'::text AS category,
            NULL::character(1) AS param_type
           FROM microbiologyresultsevents
        UNION ALL
         SELECT DISTINCT d_prescriptions.itemid,
            d_prescriptions.drug AS label,
            'prescriptions'::text AS linksto,
            'Prescriptions'::text AS category,
            NULL::character(1) AS param_type
           FROM d_prescriptions) cq
WITH DATA;

-- public.distinct_events source

CREATE OR REPLACE VIEW public.distinct_events
AS SELECT sde.itemid,
    sde.label,
    sde.category,
    sde.linksto,
    sde.param_type
   FROM static_distinct_events sde
UNION ALL
 SELECT dc.itemid,
    dc.label,
    'User imported'::character varying AS category,
    'customevents'::character varying AS linksto,
    dc.author AS param_type
   FROM d_customevents dc;