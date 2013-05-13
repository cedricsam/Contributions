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
-- Name: dons; Type: TABLE; Schema: public; Owner: lp; Tablespace: 
--

CREATE TABLE dons (
    id character varying(32) NOT NULL,
    idrech integer,
    an integer,
    fkent integer,
    nom character varying(128),
    prenom character varying(128),
    montant_total numeric,
    nb_versements smallint,
    parti character varying(64),
    candidat character varying(64)
);


ALTER TABLE public.dons OWNER TO lp;

--
-- Name: dons_pkey; Type: CONSTRAINT; Schema: public; Owner: lp; Tablespace: 
--

ALTER TABLE ONLY dons
    ADD CONSTRAINT dons_pkey PRIMARY KEY (id);


--
-- Name: dons_an_idx; Type: INDEX; Schema: public; Owner: lp; Tablespace: 
--

CREATE INDEX dons_an_idx ON dons USING btree (an);


--
-- Name: dons_fkent_idx; Type: INDEX; Schema: public; Owner: lp; Tablespace: 
--

CREATE INDEX dons_fkent_idx ON dons USING btree (fkent);


--
-- Name: dons_idrech_idx; Type: INDEX; Schema: public; Owner: lp; Tablespace: 
--

CREATE INDEX dons_idrech_idx ON dons USING btree (idrech);


--
-- PostgreSQL database dump complete
--

