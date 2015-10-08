--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: contribs2015; Type: TABLE; Schema: public; Owner: lp; Tablespace: 
--

CREATE TABLE contribs2015 (
    id_row integer NOT NULL,
    id_client integer NOT NULL,
    returntype smallint NOT NULL,
    name character varying(256),
    entity character varying(1024),
    dt date,
    class character varying(64),
    transferred character varying(64),
    monetary numeric,
    nonmonetary numeric,
    city character varying(64),
    province character varying(32),
    postalcode character varying(32)
);


ALTER TABLE public.contribs2015 OWNER TO lp;

--
-- Name: contribs2015_contributions; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_contributions AS
 SELECT contribs2015.id_row,
    contribs2015.id_client,
    contribs2015.returntype,
    contribs2015.name,
    contribs2015.dt,
    contribs2015.transferred,
    contribs2015.monetary,
    contribs2015.nonmonetary
   FROM contribs2015;


ALTER TABLE public.contribs2015_contributions OWNER TO lp;

--
-- Name: contribs2015_contributors; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_contributors AS
 SELECT contribs2015.id_row,
    contribs2015.returntype,
    contribs2015.city,
    contribs2015.province,
    contribs2015.postalcode
   FROM contribs2015;


ALTER TABLE public.contribs2015_contributors OWNER TO lp;

--
-- Name: contribs2015_entities; Type: TABLE; Schema: public; Owner: lp; Tablespace: 
--

CREATE TABLE contribs2015_entities (
    section character varying(3),
    id_party smallint,
    id_client integer NOT NULL
);


ALTER TABLE public.contribs2015_entities OWNER TO lp;

--
-- Name: contribs2015_parties; Type: TABLE; Schema: public; Owner: lp; Tablespace: 
--

CREATE TABLE contribs2015_parties (
    id_party smallint,
    party_fr character varying(128),
    party_en character varying(128),
    ft_icon character varying(32)
);


ALTER TABLE public.contribs2015_parties OWNER TO lp;

--
-- Name: contribs2015_entitiesparties; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_entitiesparties AS
 SELECT foo.id_client,
    foo.section,
    p.party_fr,
    p.party_en,
    p.id_party,
    foo.entity,
    p.ft_icon
   FROM (( SELECT c.id_client,
            e.id_party,
            c.entity,
            e.section
           FROM (contribs2015 c
             LEFT JOIN contribs2015_entities e ON ((c.id_client = e.id_client)))
          GROUP BY c.id_client, e.id_party, c.entity, e.section) foo
     LEFT JOIN contribs2015_parties p ON ((foo.id_party = p.id_party)));


ALTER TABLE public.contribs2015_entitiesparties OWNER TO lp;

--
-- Name: contribs2015_geo; Type: TABLE; Schema: public; Owner: lp; Tablespace: 
--

CREATE TABLE contribs2015_geo (
    id character varying(256) NOT NULL,
    lat numeric,
    lng numeric,
    location_type character varying(32),
    formatted_address character varying(256),
    types character varying(128),
    ids_reference character varying(256)[]
);


ALTER TABLE public.contribs2015_geo OWNER TO lp;

--
-- Name: contribs2015_geo_validate; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_geo_validate AS
 SELECT geo.id,
    geo.lat,
    geo.lng,
    geo.location_type,
    geo.formatted_address,
    geo.types,
    c.cityprov
   FROM (contribs2015_geo geo
     LEFT JOIN ( SELECT c_1.postalcode,
            string_agg(DISTINCT (((c_1.city)::text || '~'::text) || (c_1.province)::text), '|'::text) AS cityprov
           FROM contribs2015 c_1
          GROUP BY c_1.postalcode) c ON (((geo.id)::text = btrim((c.postalcode)::text, ' '::text))))
  WHERE ((((geo.types)::text ~~ 'postal_code%'::text) AND (((length((geo.id)::text) < 6) OR ((length((geo.id)::text) = 6) AND ((geo.id)::text !~* '[A-Z][0-9O][A-Z][0-9O][A-Z][0-9O]'::text))) OR ((length((geo.id)::text) = 7) AND ((geo.id)::text !~* '[A-Z][0-9O][A-Z][ -][0-9O][A-Z][0-9O]'::text)))) OR ((geo.types)::text !~~ 'postal_code%'::text));


ALTER TABLE public.contribs2015_geo_validate OWNER TO lp;

--
-- Name: contribs2015_joined; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_joined AS
 SELECT e.section,
    p.party_fr,
    p.party_en,
    p.id_party,
    c.id_row,
    c.id_client,
    c.returntype,
    c.name,
    c.entity,
    c.dt,
    c.class,
    c.transferred,
    c.monetary,
    c.nonmonetary,
    c.city,
    c.province,
    c.postalcode,
    p.ft_icon
   FROM ((contribs2015 c
     LEFT JOIN contribs2015_entities e ON ((c.id_client = e.id_client)))
     LEFT JOIN contribs2015_parties p ON ((e.id_party = p.id_party)));


ALTER TABLE public.contribs2015_joined OWNER TO lp;

--
-- Name: contribs2015_mapids; Type: TABLE; Schema: public; Owner: lp; Tablespace: 
--

CREATE TABLE contribs2015_mapids (
    id integer NOT NULL,
    lat numeric NOT NULL,
    lng numeric NOT NULL,
    ids_row text
);


ALTER TABLE public.contribs2015_mapids OWNER TO lp;

--
-- Name: contribs2015_unique; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_unique AS
 SELECT c.id_row,
    c.returntype,
    c.id_client,
    c.name,
    c.dt,
    c.class,
    c.transferred,
    c.monetary,
    c.nonmonetary,
    c.city,
    c.province,
    c.postalcode
   FROM (( SELECT contribs2015.id_row,
            max(contribs2015.returntype) AS returntype
           FROM contribs2015
          GROUP BY contribs2015.id_row) foo
     LEFT JOIN contribs2015 c ON (((foo.id_row = c.id_row) AND (foo.returntype = c.returntype))));


ALTER TABLE public.contribs2015_unique OWNER TO lp;

--
-- Name: contribs2015_unique_entitiesparties; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_unique_entitiesparties AS
 SELECT e.section,
    u.id_row,
    u.returntype,
    u.id_client,
    u.name,
    u.dt,
    replace(split_part((u.class)::text, ' / '::text, 2), 'Part '::text, ''::text) AS class,
    u.transferred,
    replace(((u.monetary)::character varying)::text, '.00'::text, ''::text) AS monetary,
    replace(((u.nonmonetary)::character varying)::text, '.00'::text, ''::text) AS nonmonetary,
    u.city,
    u.province,
    u.postalcode,
    replace((e.entity)::text, ' / '::text, '|'::text) AS entity,
    e.id_party,
    e.ft_icon
   FROM (contribs2015_unique u
     LEFT JOIN contribs2015_entitiesparties e ON ((u.id_client = e.id_client)));


ALTER TABLE public.contribs2015_unique_entitiesparties OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                          WHERE (c.transferred IS NULL)
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE ((c_1.id_row IS NOT NULL) AND (c_1.transferred IS NULL))) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE ((c_1.id_row IS NOT NULL) AND (c_1.transferred IS NULL))) c) foo_2) foo_1
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation OWNER TO lp;

--
-- Name: contribs2015_unique_entitiesparties_geo; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_unique_entitiesparties_geo AS
 SELECT count(*) AS count,
    foo.lat,
    foo.lng,
    max((foo.id)::text) AS max_id,
    min((foo.id)::text) AS min_id,
    (('~'::text || string_agg(DISTINCT (foo.id)::text, '~'::text)) || '~'::text) AS postalcodes,
    ((','::text || string_agg(DISTINCT ((foo.id_row)::character varying)::text, ','::text)) || ','::text) AS ids_row,
    ((','::text || string_agg(DISTINCT ((foo.id_client)::character varying)::text, ','::text)) || ','::text) AS ids_client,
    ((','::text || string_agg(DISTINCT ((foo.id_party)::character varying)::text, ','::text)) || ','::text) AS ids_party,
    ((','::text || string_agg(DISTINCT (foo.name)::text, ','::text)) || ','::text) AS names,
    ((','::text || string_agg(DISTINCT (foo.city)::text, ','::text)) || ','::text) AS cities,
    ((','::text || string_agg(DISTINCT (foo.province)::text, ','::text)) || ','::text) AS provinces
   FROM ( SELECT c_1.section,
            c_1.id_row,
            c_1.returntype,
            c_1.id_client,
            c_1.name,
            c_1.dt,
            c_1.class,
            c_1.transferred,
            c_1.monetary,
            c_1.nonmonetary,
            c_1.city,
            c_1.province,
            c_1.postalcode,
            c_1.entity,
            c_1.id_party,
            c_1.ft_icon,
            g_1.id,
            g_1.lat,
            g_1.lng
           FROM (( SELECT c.postalcode,
                    c.id_actual,
                    c.id,
                    c.lat,
                    c.lng
                   FROM (( SELECT u.postalcode,
                            g_2.id_actual,
                            g_2.id,
                            g_2.lat,
                            g_2.lng
                           FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
                                    contribs2015_geo.id AS id_actual,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_2
                             LEFT JOIN contribs2015_unique u ON (((g_2.id)::text = ('ROW:'::text || u.id_row))))
                          WHERE ((g_2.id)::text ~~ 'ROW:%'::text)) c
                     LEFT JOIN contribs2015_geo g ON (((c.postalcode)::text = (g.id)::text)))
                  WHERE ((g.id IS NULL) OR (g.ids_reference IS NOT NULL))) g_1
             LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g_1.id)::text = ('ROW:'::text || c_1.id_row))))
        UNION
         SELECT c.section,
            c.id_row,
            c.returntype,
            c.id_client,
            c.name,
            c.dt,
            c.class,
            c.transferred,
            c.monetary,
            c.nonmonetary,
            c.city,
            c.province,
            c.postalcode,
            c.entity,
            c.id_party,
            c.ft_icon,
            g.id,
            g.lat,
            g.lng
           FROM (contribs2015_unique_entitiesparties c
             LEFT JOIN ( SELECT contribs2015_geo.id,
                    contribs2015_geo.lat,
                    contribs2015_geo.lng
                   FROM contribs2015_geo
                  WHERE (contribs2015_geo.ids_reference IS NULL)
                UNION
                 SELECT unnest(contribs2015_geo.ids_reference) AS id,
                    contribs2015_geo.lat,
                    contribs2015_geo.lng
                   FROM contribs2015_geo
                  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
          WHERE (g.id IS NOT NULL)) foo
  GROUP BY foo.lat, foo.lng
  ORDER BY count(*) DESC;


ALTER TABLE public.contribs2015_unique_entitiesparties_geo OWNER TO lp;

--
-- Name: contribs2015_mapping; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_mapping AS
 SELECT g.count,
    g.lat,
    g.lng,
    g.max_id,
    g.min_id,
    g.postalcodes,
    g.ids_row,
    g.ids_client,
    g.ids_party,
    g.names,
    g.cities,
    g.provinces,
    p.id_party AS dominant_party_id,
    p.dt_newest AS dominant_party_dt_newest,
    p.dt_oldest AS dominant_party_dt_oldest,
    p.monetary AS dominant_party_monetary,
    p.nonmonetary AS dominant_party_nonmonetary,
    p.total_donations AS dominant_party_total_donations,
    pp.party_fr AS dominant_party_fr,
    pp.party_en AS dominant_party_en,
    pp.ft_icon AS dominant_party_ft_icon
   FROM ((contribs2015_unique_entitiesparties_geo g
     LEFT JOIN ( SELECT contribs2015_partymoneylocation.id_party,
            contribs2015_partymoneylocation.lat,
            contribs2015_partymoneylocation.lng,
            contribs2015_partymoneylocation.dt_newest,
            contribs2015_partymoneylocation.dt_oldest,
            contribs2015_partymoneylocation.monetary,
            contribs2015_partymoneylocation.nonmonetary,
            contribs2015_partymoneylocation.total_donations,
            contribs2015_partymoneylocation.r
           FROM contribs2015_partymoneylocation
          WHERE (contribs2015_partymoneylocation.r = 1)) p ON (((g.lat = p.lat) AND (g.lng = p.lng))))
     LEFT JOIN contribs2015_parties pp ON ((p.id_party = pp.id_party)))
  ORDER BY p.total_donations DESC;


ALTER TABLE public.contribs2015_mapping OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2007; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2007 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2007)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2007 OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2008; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2008 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2008)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2008 OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2009; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2009 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2009)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2009 OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2010; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2010 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2010)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2010 OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2011; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2011 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2011)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2011 OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2012; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2012 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2012)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2012 OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2013; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2013 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2013)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2013 OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2014; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2014 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2014)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2014 OWNER TO lp;

--
-- Name: contribs2015_partymoneylocation_2015; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_partymoneylocation_2015 AS
 SELECT foo.id_party,
    foo.lat,
    foo.lng,
    foo.dt_newest,
    foo.dt_oldest,
    foo.monetary,
    foo.nonmonetary,
    foo.total_donations,
    rank() OVER (PARTITION BY foo.lat, foo.lng ORDER BY foo.total_donations DESC, foo.monetary DESC, foo.number_donations DESC, foo.dt_newest DESC, foo.dt_oldest DESC, foo.id_party) AS r
   FROM ( SELECT foo_1.id_party,
            foo_1.lat,
            foo_1.lng,
            count(*) AS number_donations,
            max(foo_1.dt) AS dt_newest,
            min(foo_1.dt) AS dt_oldest,
            sum(foo_1.monetary) AS monetary,
            sum(foo_1.nonmonetary) AS nonmonetary,
            (sum(foo_1.monetary) + sum(foo_1.nonmonetary)) AS total_donations
           FROM ( SELECT foo_2.id_party,
                    foo_2.dt,
                    foo_2.monetary,
                    foo_2.nonmonetary,
                    foo_2.id_row,
                    foo_2.ft_icon,
                    foo_2.lat,
                    foo_2.lng
                   FROM ( SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            g.lat,
                            g.lng
                           FROM (contribs2015_unique_entitiesparties c
                             LEFT JOIN ( SELECT contribs2015_geo.id,
                                    contribs2015_geo.lat,
                                    contribs2015_geo.lng,
                                    contribs2015_geo.location_type,
                                    contribs2015_geo.formatted_address,
                                    contribs2015_geo.types,
                                    contribs2015_geo.ids_reference
                                   FROM contribs2015_geo
                                  WHERE (contribs2015_geo.ids_reference IS NULL)) g ON ((btrim((c.postalcode)::text, ' '::text) = (g.id)::text)))
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT unnest(contribs2015_geo.ids_reference) AS id,
    contribs2015_geo.lat,
    contribs2015_geo.lng
   FROM contribs2015_geo
  WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON ((btrim((c_1.postalcode)::text, ' '::text) = (g.id)::text)))
                                  WHERE (c_1.id_row IS NOT NULL)) c
                        UNION
                         SELECT c.id_party,
                            c.dt,
                            COALESCE((c.monetary)::numeric, (0)::numeric) AS monetary,
                            COALESCE((c.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
                            c.id_row,
                            c.ft_icon,
                            c.lat,
                            c.lng
                           FROM ( SELECT g.id,
                                    g.lat,
                                    g.lng,
                                    c_1.section,
                                    c_1.id_row,
                                    c_1.returntype,
                                    c_1.id_client,
                                    c_1.name,
                                    c_1.dt,
                                    c_1.class,
                                    c_1.transferred,
                                    c_1.monetary,
                                    c_1.nonmonetary,
                                    c_1.city,
                                    c_1.province,
                                    c_1.postalcode,
                                    c_1.entity,
                                    c_1.id_party,
                                    c_1.ft_icon
                                   FROM (( SELECT g_1.id,
    g_1.lat,
    g_1.lng
   FROM ( SELECT unnest(contribs2015_geo.ids_reference) AS id,
      contribs2015_geo.lat,
      contribs2015_geo.lng
     FROM contribs2015_geo
    WHERE (contribs2015_geo.ids_reference IS NOT NULL)) g_1
  WHERE ((g_1.id)::text ~~ 'ROW:%'::text)) g
                                     LEFT JOIN contribs2015_unique_entitiesparties c_1 ON (((g.id)::text = ('ROW:'::text || (c_1.id_row)::text))))
                                  WHERE (c_1.id_row IS NOT NULL)) c) foo_2) foo_1
          WHERE (date_part('year'::text, foo_1.dt) = (2015)::double precision)
          GROUP BY foo_1.id_party, foo_1.lat, foo_1.lng) foo;


ALTER TABLE public.contribs2015_partymoneylocation_2015 OWNER TO lp;

--
-- Name: contribs2015_unique_entitiesparties_mapids; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_unique_entitiesparties_mapids AS
 SELECT ue.section,
    ue.id_row,
    m.id_map,
    ue.returntype,
    ue.id_client,
    ue.name,
    ue.dt,
    ue.class,
    ue.transferred,
    ue.monetary,
    ue.nonmonetary,
    ue.city,
    ue.province,
    ue.postalcode,
    ue.entity,
    ue.id_party,
    ue.ft_icon
   FROM (contribs2015_unique_entitiesparties ue
     JOIN ( SELECT (regexp_split_to_table(contribs2015_mapids.ids_row, ','::text))::integer AS id_row,
            contribs2015_mapids.id AS id_map
           FROM contribs2015_mapids) m ON ((ue.id_row = m.id_row)));


ALTER TABLE public.contribs2015_unique_entitiesparties_mapids OWNER TO lp;

--
-- Name: contribs2015_unique_entitiesparties_validpostalcodes; Type: VIEW; Schema: public; Owner: lp
--

CREATE VIEW contribs2015_unique_entitiesparties_validpostalcodes AS
 SELECT foo.id_row,
    foo.returntype,
    foo.name,
    substr(foo.pc, 1, 3) AS rta,
    COALESCE((foo.monetary)::numeric, (0)::numeric) AS monetary,
    COALESCE((foo.nonmonetary)::numeric, (0)::numeric) AS nonmonetary,
    foo.dt,
    date_part('year'::text, foo.dt) AS yyyy,
    date_part('month'::text, foo.dt) AS mm,
    date_part('isoyear'::text, foo.dt) AS iso_year,
    date_part('week'::text, foo.dt) AS iso_week,
    foo.id_client,
    foo.entity,
    foo.id_party,
    foo.province,
    foo.city,
    foo.postalcode
   FROM ( SELECT contribs2015_unique_entitiesparties.section,
            contribs2015_unique_entitiesparties.id_row,
            contribs2015_unique_entitiesparties.returntype,
            contribs2015_unique_entitiesparties.id_client,
            contribs2015_unique_entitiesparties.name,
            contribs2015_unique_entitiesparties.dt,
            contribs2015_unique_entitiesparties.class,
            contribs2015_unique_entitiesparties.transferred,
            contribs2015_unique_entitiesparties.monetary,
            contribs2015_unique_entitiesparties.nonmonetary,
            contribs2015_unique_entitiesparties.city,
            contribs2015_unique_entitiesparties.province,
            contribs2015_unique_entitiesparties.postalcode,
            contribs2015_unique_entitiesparties.entity,
            contribs2015_unique_entitiesparties.id_party,
            contribs2015_unique_entitiesparties.ft_icon,
            regexp_replace(upper((contribs2015_unique_entitiesparties.postalcode)::text), '[ ` -]+'::text, ''::text) AS pc
           FROM contribs2015_unique_entitiesparties
          WHERE ((contribs2015_unique_entitiesparties.transferred IS NULL) AND (contribs2015_unique_entitiesparties.postalcode IS NOT NULL))) foo
  WHERE (foo.pc ~ '^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$'::text);


ALTER TABLE public.contribs2015_unique_entitiesparties_validpostalcodes OWNER TO lp;

--
-- Name: contribs2015_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: lp; Tablespace: 
--

ALTER TABLE ONLY contribs2015_entities
    ADD CONSTRAINT contribs2015_entities_pkey PRIMARY KEY (id_client);


--
-- Name: contribs2015_geo_pkey; Type: CONSTRAINT; Schema: public; Owner: lp; Tablespace: 
--

ALTER TABLE ONLY contribs2015_geo
    ADD CONSTRAINT contribs2015_geo_pkey PRIMARY KEY (id);


--
-- Name: contribs2015_mapids_pkey; Type: CONSTRAINT; Schema: public; Owner: lp; Tablespace: 
--

ALTER TABLE ONLY contribs2015_mapids
    ADD CONSTRAINT contribs2015_mapids_pkey PRIMARY KEY (id, lat, lng);


--
-- Name: contribs2015_pkey; Type: CONSTRAINT; Schema: public; Owner: lp; Tablespace: 
--

ALTER TABLE ONLY contribs2015
    ADD CONSTRAINT contribs2015_pkey PRIMARY KEY (id_row, returntype);


--
-- Name: contribs2015_id_client_idx; Type: INDEX; Schema: public; Owner: lp; Tablespace: 
--

CREATE INDEX contribs2015_id_client_idx ON contribs2015 USING btree (id_client);


--
-- PostgreSQL database dump complete
--

