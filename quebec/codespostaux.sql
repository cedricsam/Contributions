--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: codespostaux; Type: TABLE; Schema: public; Owner: lp; Tablespace: 
--

CREATE TABLE codespostaux (
    codepostal character(7) NOT NULL,
    lat numeric,
    lng numeric
);


ALTER TABLE public.codespostaux OWNER TO lp;

--
-- Name: codespostaux_pkey; Type: CONSTRAINT; Schema: public; Owner: lp; Tablespace: 
--

ALTER TABLE ONLY codespostaux
    ADD CONSTRAINT codespostaux_pkey PRIMARY KEY (codepostal);


--
-- PostgreSQL database dump complete
--

