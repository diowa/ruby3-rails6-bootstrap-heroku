SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: history; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS history;


--
-- Name: temporal; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS temporal;


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: chronomodel_projects_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_projects_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              DECLARE _now timestamp;
              BEGIN
                _now := timezone('UTC', now());

                DELETE FROM history.projects
                WHERE id = old.id AND validity = tsrange(_now, NULL);

                UPDATE history.projects SET validity = tsrange(lower(validity), _now)
                WHERE id = old.id AND upper_inf(validity);

                DELETE FROM ONLY temporal.projects
                WHERE id = old.id;

                RETURN OLD;
              END;
            $$;


--
-- Name: chronomodel_projects_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_projects_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              BEGIN
                IF NEW.id IS NULL THEN
                  NEW.id := nextval('temporal.projects_id_seq');
                END IF;

                INSERT INTO temporal.projects ( id, "name", "user_id", "created_at", "updated_at" )
                VALUES ( NEW.id, NEW."name", NEW."user_id", NEW."created_at", NEW."updated_at" );

                INSERT INTO history.projects ( id, "name", "user_id", "created_at", "updated_at", validity )
                VALUES ( NEW.id, NEW."name", NEW."user_id", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

                RETURN NEW;
              END;
            $$;


--
-- Name: chronomodel_projects_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_projects_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              DECLARE _now timestamp;
              DECLARE _hid integer;
              DECLARE _old record;
              DECLARE _new record;
              BEGIN
                IF OLD IS NOT DISTINCT FROM NEW THEN
                  RETURN NULL;
                END IF;

                _old := row(OLD."name", OLD."user_id", OLD."created_at");
                _new := row(NEW."name", NEW."user_id", NEW."created_at");

                IF _old IS NOT DISTINCT FROM _new THEN
                  UPDATE ONLY temporal.projects SET ( "name", "user_id", "created_at", "updated_at" ) = ( NEW."name", NEW."user_id", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
                  RETURN NEW;
                END IF;

                _now := timezone('UTC', now());
                _hid := NULL;

                SELECT hid INTO _hid FROM history.projects WHERE id = OLD.id AND lower(validity) = _now;

                IF _hid IS NOT NULL THEN
                  UPDATE history.projects SET ( "name", "user_id", "created_at", "updated_at" ) = ( NEW."name", NEW."user_id", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
                ELSE
                  UPDATE history.projects SET validity = tsrange(lower(validity), _now)
                  WHERE id = OLD.id AND upper_inf(validity);

                  INSERT INTO history.projects ( id, "name", "user_id", "created_at", "updated_at", validity )
                       VALUES ( OLD.id, NEW."name", NEW."user_id", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
                END IF;

                UPDATE ONLY temporal.projects SET ( "name", "user_id", "created_at", "updated_at" ) = ( NEW."name", NEW."user_id", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

                RETURN NEW;
              END;
            $$;


--
-- Name: chronomodel_units_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_units_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              DECLARE _now timestamp;
              BEGIN
                _now := timezone('UTC', now());

                DELETE FROM history.units
                WHERE id = old.id AND validity = tsrange(_now, NULL);

                UPDATE history.units SET validity = tsrange(lower(validity), _now)
                WHERE id = old.id AND upper_inf(validity);

                DELETE FROM ONLY temporal.units
                WHERE id = old.id;

                RETURN OLD;
              END;
            $$;


--
-- Name: chronomodel_units_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_units_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              BEGIN
                IF NEW.id IS NULL THEN
                  NEW.id := nextval('temporal.units_id_seq');
                END IF;

                INSERT INTO temporal.units ( id, "name", "project_id", "created_at", "updated_at" )
                VALUES ( NEW.id, NEW."name", NEW."project_id", NEW."created_at", NEW."updated_at" );

                INSERT INTO history.units ( id, "name", "project_id", "created_at", "updated_at", validity )
                VALUES ( NEW.id, NEW."name", NEW."project_id", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

                RETURN NEW;
              END;
            $$;


--
-- Name: chronomodel_units_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_units_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              DECLARE _now timestamp;
              DECLARE _hid integer;
              DECLARE _old record;
              DECLARE _new record;
              BEGIN
                IF OLD IS NOT DISTINCT FROM NEW THEN
                  RETURN NULL;
                END IF;

                _old := row(OLD."name", OLD."project_id", OLD."created_at");
                _new := row(NEW."name", NEW."project_id", NEW."created_at");

                IF _old IS NOT DISTINCT FROM _new THEN
                  UPDATE ONLY temporal.units SET ( "name", "project_id", "created_at", "updated_at" ) = ( NEW."name", NEW."project_id", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
                  RETURN NEW;
                END IF;

                _now := timezone('UTC', now());
                _hid := NULL;

                SELECT hid INTO _hid FROM history.units WHERE id = OLD.id AND lower(validity) = _now;

                IF _hid IS NOT NULL THEN
                  UPDATE history.units SET ( "name", "project_id", "created_at", "updated_at" ) = ( NEW."name", NEW."project_id", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
                ELSE
                  UPDATE history.units SET validity = tsrange(lower(validity), _now)
                  WHERE id = OLD.id AND upper_inf(validity);

                  INSERT INTO history.units ( id, "name", "project_id", "created_at", "updated_at", validity )
                       VALUES ( OLD.id, NEW."name", NEW."project_id", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
                END IF;

                UPDATE ONLY temporal.units SET ( "name", "project_id", "created_at", "updated_at" ) = ( NEW."name", NEW."project_id", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

                RETURN NEW;
              END;
            $$;


--
-- Name: chronomodel_users_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_users_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              DECLARE _now timestamp;
              BEGIN
                _now := timezone('UTC', now());

                DELETE FROM history.users
                WHERE id = old.id AND validity = tsrange(_now, NULL);

                UPDATE history.users SET validity = tsrange(lower(validity), _now)
                WHERE id = old.id AND upper_inf(validity);

                DELETE FROM ONLY temporal.users
                WHERE id = old.id;

                RETURN OLD;
              END;
            $$;


--
-- Name: chronomodel_users_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_users_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              BEGIN
                IF NEW.id IS NULL THEN
                  NEW.id := nextval('temporal.users_id_seq');
                END IF;

                INSERT INTO temporal.users ( id, "name", "created_at", "updated_at" )
                VALUES ( NEW.id, NEW."name", NEW."created_at", NEW."updated_at" );

                INSERT INTO history.users ( id, "name", "created_at", "updated_at", validity )
                VALUES ( NEW.id, NEW."name", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

                RETURN NEW;
              END;
            $$;


--
-- Name: chronomodel_users_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_users_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
              DECLARE _now timestamp;
              DECLARE _hid integer;
              DECLARE _old record;
              DECLARE _new record;
              BEGIN
                IF OLD IS NOT DISTINCT FROM NEW THEN
                  RETURN NULL;
                END IF;

                _old := row(OLD."name", OLD."created_at");
                _new := row(NEW."name", NEW."created_at");

                IF _old IS NOT DISTINCT FROM _new THEN
                  UPDATE ONLY temporal.users SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
                  RETURN NEW;
                END IF;

                _now := timezone('UTC', now());
                _hid := NULL;

                SELECT hid INTO _hid FROM history.users WHERE id = OLD.id AND lower(validity) = _now;

                IF _hid IS NOT NULL THEN
                  UPDATE history.users SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
                ELSE
                  UPDATE history.users SET validity = tsrange(lower(validity), _now)
                  WHERE id = OLD.id AND upper_inf(validity);

                  INSERT INTO history.users ( id, "name", "created_at", "updated_at", validity )
                       VALUES ( OLD.id, NEW."name", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
                END IF;

                UPDATE ONLY temporal.users SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

                RETURN NEW;
              END;
            $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: projects; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.projects (
    id bigint NOT NULL,
    name character varying,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: projects; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.projects (
    hid integer NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.projects);


--
-- Name: projects_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.projects_hid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.projects_hid_seq OWNED BY history.projects.hid;


--
-- Name: units; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.units (
    id bigint NOT NULL,
    name character varying,
    project_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: units; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.units (
    hid integer NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.units);


--
-- Name: units_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.units_hid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.units_hid_seq OWNED BY history.units.hid;


--
-- Name: users; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.users (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.users (
    hid integer NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.users);


--
-- Name: users_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.users_hid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.users_hid_seq OWNED BY history.users.hid;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: projects; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.projects AS
 SELECT projects.id,
    projects.name,
    projects.user_id,
    projects.created_at,
    projects.updated_at
   FROM ONLY temporal.projects;


--
-- Name: VIEW projects; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.projects IS '{"temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: units; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.units AS
 SELECT units.id,
    units.name,
    units.project_id,
    units.created_at,
    units.updated_at
   FROM ONLY temporal.units;


--
-- Name: VIEW units; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.units IS '{"temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: users; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.users AS
 SELECT users.id,
    users.name,
    users.created_at,
    users.updated_at
   FROM ONLY temporal.users;


--
-- Name: VIEW users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.users IS '{"temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE temporal.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE temporal.projects_id_seq OWNED BY temporal.projects.id;


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE temporal.units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE temporal.units_id_seq OWNED BY temporal.units.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE temporal.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE temporal.users_id_seq OWNED BY temporal.users.id;


--
-- Name: projects id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.projects ALTER COLUMN id SET DEFAULT nextval('temporal.projects_id_seq'::regclass);


--
-- Name: projects hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.projects ALTER COLUMN hid SET DEFAULT nextval('history.projects_hid_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.units ALTER COLUMN id SET DEFAULT nextval('temporal.units_id_seq'::regclass);


--
-- Name: units hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.units ALTER COLUMN hid SET DEFAULT nextval('history.units_hid_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.users ALTER COLUMN id SET DEFAULT nextval('temporal.users_id_seq'::regclass);


--
-- Name: users hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.users ALTER COLUMN hid SET DEFAULT nextval('history.users_hid_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.projects ALTER COLUMN id SET DEFAULT nextval('temporal.projects_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.units ALTER COLUMN id SET DEFAULT nextval('temporal.units_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.users ALTER COLUMN id SET DEFAULT nextval('temporal.users_id_seq'::regclass);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (hid);


--
-- Name: projects projects_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.projects
    ADD CONSTRAINT projects_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (hid);


--
-- Name: units units_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.units
    ADD CONSTRAINT units_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (hid);


--
-- Name: users users_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.users
    ADD CONSTRAINT users_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_projects_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_projects_temporal_on_lower_validity ON history.projects USING btree (lower(validity));


--
-- Name: index_projects_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_projects_temporal_on_upper_validity ON history.projects USING btree (upper(validity));


--
-- Name: index_projects_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_projects_temporal_on_validity ON history.projects USING gist (validity);


--
-- Name: index_units_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_units_temporal_on_lower_validity ON history.units USING btree (lower(validity));


--
-- Name: index_units_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_units_temporal_on_upper_validity ON history.units USING btree (upper(validity));


--
-- Name: index_units_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_units_temporal_on_validity ON history.units USING gist (validity);


--
-- Name: index_users_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_users_temporal_on_lower_validity ON history.users USING btree (lower(validity));


--
-- Name: index_users_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_users_temporal_on_upper_validity ON history.users USING btree (upper(validity));


--
-- Name: index_users_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_users_temporal_on_validity ON history.users USING gist (validity);


--
-- Name: projects_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX projects_inherit_pkey ON history.projects USING btree (id);


--
-- Name: projects_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX projects_instance_history ON history.projects USING btree (id, recorded_at);


--
-- Name: projects_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX projects_recorded_at ON history.projects USING btree (recorded_at);


--
-- Name: units_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX units_inherit_pkey ON history.units USING btree (id);


--
-- Name: units_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX units_instance_history ON history.units USING btree (id, recorded_at);


--
-- Name: units_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX units_recorded_at ON history.units USING btree (recorded_at);


--
-- Name: users_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX users_inherit_pkey ON history.users USING btree (id);


--
-- Name: users_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX users_instance_history ON history.users USING btree (id, recorded_at);


--
-- Name: users_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX users_recorded_at ON history.users USING btree (recorded_at);


--
-- Name: index_projects_on_user_id; Type: INDEX; Schema: temporal; Owner: -
--

CREATE INDEX index_projects_on_user_id ON temporal.projects USING btree (user_id);


--
-- Name: index_units_on_project_id; Type: INDEX; Schema: temporal; Owner: -
--

CREATE INDEX index_units_on_project_id ON temporal.units USING btree (project_id);


--
-- Name: projects chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.projects FOR EACH ROW EXECUTE FUNCTION public.chronomodel_projects_delete();


--
-- Name: units chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.units FOR EACH ROW EXECUTE FUNCTION public.chronomodel_units_delete();


--
-- Name: users chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.users FOR EACH ROW EXECUTE FUNCTION public.chronomodel_users_delete();


--
-- Name: projects chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.projects FOR EACH ROW EXECUTE FUNCTION public.chronomodel_projects_insert();


--
-- Name: units chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.units FOR EACH ROW EXECUTE FUNCTION public.chronomodel_units_insert();


--
-- Name: users chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.chronomodel_users_insert();


--
-- Name: projects chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.projects FOR EACH ROW EXECUTE FUNCTION public.chronomodel_projects_update();


--
-- Name: units chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.units FOR EACH ROW EXECUTE FUNCTION public.chronomodel_units_update();


--
-- Name: users chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.chronomodel_users_update();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210112191552'),
('20210112191553'),
('20210112191554'),
('20210112191555');


