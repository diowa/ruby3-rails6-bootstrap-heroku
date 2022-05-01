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
-- Name: chronomodel_movies_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_movies_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    BEGIN
        _now := timezone('UTC', now());

        DELETE FROM history.movies
        WHERE id = old.id AND validity = tsrange(_now, NULL);

        UPDATE history.movies SET validity = tsrange(lower(validity), _now)
        WHERE id = old.id AND upper_inf(validity);

        DELETE FROM ONLY temporal.movies
        WHERE id = old.id;

        RETURN OLD;
    END;

$$;


--
-- Name: chronomodel_movies_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_movies_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.id IS NULL THEN
            NEW.id := nextval('temporal.movies_id_seq');
        END IF;

        INSERT INTO temporal.movies ( id, "name", "created_at", "updated_at" )
        VALUES ( NEW.id, NEW."name", NEW."created_at", NEW."updated_at" );

        INSERT INTO history.movies ( id, "name", "created_at", "updated_at", validity )
        VALUES ( NEW.id, NEW."name", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_movies_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_movies_update() RETURNS trigger
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
            UPDATE ONLY temporal.movies SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
            RETURN NEW;
        END IF;

        _now := timezone('UTC', now());
        _hid := NULL;

        SELECT hid INTO _hid FROM history.movies WHERE id = OLD.id AND lower(validity) = _now;

        IF _hid IS NOT NULL THEN
            UPDATE history.movies SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
        ELSE
            UPDATE history.movies SET validity = tsrange(lower(validity), _now)
            WHERE id = OLD.id AND upper_inf(validity);

            INSERT INTO history.movies ( id, "name", "created_at", "updated_at", validity )
                VALUES ( OLD.id, NEW."name", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
        END IF;

        UPDATE ONLY temporal.movies SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_songs_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_songs_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE _now timestamp;
    BEGIN
        _now := timezone('UTC', now());

        DELETE FROM history.songs
        WHERE id = old.id AND validity = tsrange(_now, NULL);

        UPDATE history.songs SET validity = tsrange(lower(validity), _now)
        WHERE id = old.id AND upper_inf(validity);

        DELETE FROM ONLY temporal.songs
        WHERE id = old.id;

        RETURN OLD;
    END;

$$;


--
-- Name: chronomodel_songs_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_songs_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO temporal.songs ( id, "name", "created_at", "updated_at" )
        VALUES ( NEW.id, NEW."name", NEW."created_at", NEW."updated_at" );

        INSERT INTO history.songs ( id, "name", "created_at", "updated_at", validity )
        VALUES ( NEW.id, NEW."name", NEW."created_at", NEW."updated_at", tsrange(timezone('UTC', now()), NULL) );

        RETURN NEW;
    END;

$$;


--
-- Name: chronomodel_songs_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.chronomodel_songs_update() RETURNS trigger
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
            UPDATE ONLY temporal.songs SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;
            RETURN NEW;
        END IF;

        _now := timezone('UTC', now());
        _hid := NULL;

        SELECT hid INTO _hid FROM history.songs WHERE id = OLD.id AND lower(validity) = _now;

        IF _hid IS NOT NULL THEN
            UPDATE history.songs SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE hid = _hid;
        ELSE
            UPDATE history.songs SET validity = tsrange(lower(validity), _now)
            WHERE id = OLD.id AND upper_inf(validity);

            INSERT INTO history.songs ( id, "name", "created_at", "updated_at", validity )
                VALUES ( OLD.id, NEW."name", NEW."created_at", NEW."updated_at", tsrange(_now, NULL) );
        END IF;

        UPDATE ONLY temporal.songs SET ( "name", "created_at", "updated_at" ) = ( NEW."name", NEW."created_at", NEW."updated_at" ) WHERE id = OLD.id;

        RETURN NEW;
    END;

$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: movies; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.movies (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: movies; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.movies (
    hid bigint NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.movies);


--
-- Name: movies_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.movies_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movies_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.movies_hid_seq OWNED BY history.movies.hid;


--
-- Name: songs; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE temporal.songs (
    id character varying NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: songs; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE history.songs (
    hid bigint NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.songs);


--
-- Name: songs_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE history.songs_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: songs_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE history.songs_hid_seq OWNED BY history.songs.hid;


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
-- Name: movies; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.movies AS
 SELECT movies.id,
    movies.name,
    movies.created_at,
    movies.updated_at
   FROM ONLY temporal.movies;


--
-- Name: VIEW movies; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.movies IS '{"temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: songs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.songs AS
 SELECT songs.id,
    songs.name,
    songs.created_at,
    songs.updated_at
   FROM ONLY temporal.songs;


--
-- Name: VIEW songs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.songs IS '{"id":"string","temporal":true,"chronomodel":"1.2.2"}';


--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE temporal.movies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE temporal.movies_id_seq OWNED BY temporal.movies.id;


--
-- Name: movies id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.movies ALTER COLUMN id SET DEFAULT nextval('temporal.movies_id_seq'::regclass);


--
-- Name: movies hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.movies ALTER COLUMN hid SET DEFAULT nextval('history.movies_hid_seq'::regclass);


--
-- Name: songs hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.songs ALTER COLUMN hid SET DEFAULT nextval('history.songs_hid_seq'::regclass);


--
-- Name: movies id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.movies ALTER COLUMN id SET DEFAULT nextval('temporal.movies_id_seq'::regclass);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (hid);


--
-- Name: movies movies_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.movies
    ADD CONSTRAINT movies_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (hid);


--
-- Name: songs songs_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY history.songs
    ADD CONSTRAINT songs_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


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
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY temporal.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: index_movies_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_movies_temporal_on_lower_validity ON history.movies USING btree (lower(validity));


--
-- Name: index_movies_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_movies_temporal_on_upper_validity ON history.movies USING btree (upper(validity));


--
-- Name: index_movies_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_movies_temporal_on_validity ON history.movies USING gist (validity);


--
-- Name: index_songs_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_songs_temporal_on_lower_validity ON history.songs USING btree (lower(validity));


--
-- Name: index_songs_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_songs_temporal_on_upper_validity ON history.songs USING btree (upper(validity));


--
-- Name: index_songs_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_songs_temporal_on_validity ON history.songs USING gist (validity);


--
-- Name: movies_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX movies_inherit_pkey ON history.movies USING btree (id);


--
-- Name: movies_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX movies_instance_history ON history.movies USING btree (id, recorded_at);


--
-- Name: movies_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX movies_recorded_at ON history.movies USING btree (recorded_at);


--
-- Name: songs_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX songs_inherit_pkey ON history.songs USING btree (id);


--
-- Name: songs_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX songs_instance_history ON history.songs USING btree (id, recorded_at);


--
-- Name: songs_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX songs_recorded_at ON history.songs USING btree (recorded_at);


--
-- Name: movies chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.movies FOR EACH ROW EXECUTE FUNCTION public.chronomodel_movies_delete();


--
-- Name: songs chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON public.songs FOR EACH ROW EXECUTE FUNCTION public.chronomodel_songs_delete();


--
-- Name: movies chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.movies FOR EACH ROW EXECUTE FUNCTION public.chronomodel_movies_insert();


--
-- Name: songs chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON public.songs FOR EACH ROW EXECUTE FUNCTION public.chronomodel_songs_insert();


--
-- Name: movies chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.movies FOR EACH ROW EXECUTE FUNCTION public.chronomodel_movies_update();


--
-- Name: songs chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON public.songs FOR EACH ROW EXECUTE FUNCTION public.chronomodel_songs_update();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210112191552'),
('20220320164521');


