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
-- Name: donateurs; Type: TABLE; Schema: public; Owner: lp; Tablespace: 
--

CREATE TABLE donateurs (
    id character varying(32) NOT NULL,
    idrech integer,
    an integer,
    fkent integer,
    nom character varying(128),
    prenom character varying(128),
    municipalite character varying(128),
    codepostal character varying(7),
    dateajout character varying(12)
);


ALTER TABLE public.donateurs OWNER TO lp;

--
-- Name: donateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: lp; Tablespace: 
--

ALTER TABLE ONLY donateurs
    ADD CONSTRAINT donateurs_pkey PRIMARY KEY (id);


--
-- Name: donateurs_an_idx; Type: INDEX; Schema: public; Owner: lp; Tablespace: 
--

CREATE INDEX donateurs_an_idx ON donateurs USING btree (an);


--
-- Name: donateurs_fkent_idx; Type: INDEX; Schema: public; Owner: lp; Tablespace: 
--

CREATE INDEX donateurs_fkent_idx ON donateurs USING btree (fkent);


--
-- Name: donateurs_idrech_idx; Type: INDEX; Schema: public; Owner: lp; Tablespace: 
--

CREATE INDEX donateurs_idrech_idx ON donateurs USING btree (idrech);


--
-- PostgreSQL database dump complete
--

