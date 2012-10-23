--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: contribassociations; Type: TABLE; Schema: public; Owner: canada; Tablespace: 
--

CREATE TABLE contribassociations (
    id_row integer DEFAULT 0 NOT NULL,
    id_client integer,
    name character varying(255),
    association character varying(512),
    riding character varying(128),
    party character varying(64),
    date character varying(64),
    type character varying(64),
    through character varying(64),
    monetary character varying(16),
    nonmonetary character varying(16),
    city character varying(64),
    prov character varying(32),
    postalcode character varying(16),
    year smallint
);


ALTER TABLE public.contribassociations OWNER TO canada;

--
-- Name: contribcombined; Type: TABLE; Schema: public; Owner: canada; Tablespace: 
--

CREATE TABLE contribcombined (
    id_row integer DEFAULT 0 NOT NULL,
    id_client integer,
    name character varying(255),
    party character varying(64),
    candidate character varying(64),
    association character varying(128),
    riding character varying(64),
    type character varying(16),
    endperiod character varying(16),
    date character varying(64),
    classpart character varying(64),
    through character varying(64),
    monetary character varying(16),
    nonmonetary character varying(16),
    city character varying(64),
    prov character varying(32),
    postalcode character varying(16),
    year smallint
);


ALTER TABLE public.contribcombined OWNER TO canada;

--
-- Name: contribelections; Type: TABLE; Schema: public; Owner: canada; Tablespace: 
--

CREATE TABLE contribelections (
    id_row integer DEFAULT 0 NOT NULL,
    id_client integer,
    name character varying(255),
    details character varying(512),
    date character varying(64),
    classpart character varying(64),
    through character varying(64),
    monetary character varying(16),
    nonmonetary character varying(16),
    city character varying(64),
    prov character varying(32),
    postalcode character varying(16),
    year smallint
);


ALTER TABLE public.contribelections OWNER TO canada;

--
-- Name: contribparties; Type: TABLE; Schema: public; Owner: canada; Tablespace: 
--

CREATE TABLE contribparties (
    id_row integer DEFAULT 0 NOT NULL,
    id_client integer,
    name character varying(255),
    details character varying(512),
    date character varying(64),
    classpart character varying(64),
    through character varying(64),
    monetary character varying(16),
    nonmonetary character varying(16),
    city character varying(64),
    prov character varying(32),
    postalcode character varying(16),
    year smallint,
    party character varying(64),
    type character varying(16),
    endperiod character varying(16)
);


ALTER TABLE public.contribparties OWNER TO canada;

--
-- Name: postalcodes; Type: TABLE; Schema: public; Owner: canada; Tablespace: 
--

CREATE TABLE postalcodes (
    postalcode character varying(16) NOT NULL,
    the_geom geometry,
    fed_num integer,
    pd_num integer,
    CONSTRAINT enforce_dims_the_geom CHECK ((ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((geometrytype(the_geom) = 'POINT'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((srid(the_geom) = 4326))
);


ALTER TABLE public.postalcodes OWNER TO canada;

--
-- Name: contribassociations_pkey; Type: CONSTRAINT; Schema: public; Owner: canada; Tablespace: 
--

ALTER TABLE ONLY contribassociations
    ADD CONSTRAINT contribassociations_pkey PRIMARY KEY (id_row);


--
-- Name: contribcombined_pkey; Type: CONSTRAINT; Schema: public; Owner: canada; Tablespace: 
--

ALTER TABLE ONLY contribcombined
    ADD CONSTRAINT contribcombined_pkey PRIMARY KEY (id_row);


--
-- Name: contribelections_pkey; Type: CONSTRAINT; Schema: public; Owner: canada; Tablespace: 
--

ALTER TABLE ONLY contribelections
    ADD CONSTRAINT contribelections_pkey PRIMARY KEY (id_row);


--
-- Name: contribparties_pkey; Type: CONSTRAINT; Schema: public; Owner: canada; Tablespace: 
--

ALTER TABLE ONLY contribparties
    ADD CONSTRAINT contribparties_pkey PRIMARY KEY (id_row);


--
-- Name: postalcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: canada; Tablespace: 
--

ALTER TABLE ONLY postalcodes
    ADD CONSTRAINT postalcodes_pkey PRIMARY KEY (postalcode);


--
-- PostgreSQL database dump complete
--

