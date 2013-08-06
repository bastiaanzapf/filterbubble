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

--
-- Name: access_group; Type: TYPE; Schema: public; Owner: basti
--

CREATE TYPE access_group AS ENUM (
    'list',
    'hint',
    'other'
);


ALTER TYPE public.access_group OWNER TO basti;

--
-- Name: format_type; Type: TYPE; Schema: public; Owner: basti
--

CREATE TYPE format_type AS ENUM (
    'xslt',
    'xpath'
);


ALTER TYPE public.format_type OWNER TO basti;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accesses; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE accesses (
    meta_id integer,
    category_id integer,
    access_id integer NOT NULL,
    created_at timestamp without time zone,
    page integer
);


ALTER TABLE public.accesses OWNER TO basti;

--
-- Name: accesses_access_id_seq; Type: SEQUENCE; Schema: public; Owner: basti
--

CREATE SEQUENCE accesses_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.accesses_access_id_seq OWNER TO basti;

--
-- Name: accesses_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: basti
--

ALTER SEQUENCE accesses_access_id_seq OWNED BY accesses.access_id;


--
-- Name: categories_items; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE categories_items (
    item_id integer NOT NULL,
    meta_id integer NOT NULL,
    category_id integer NOT NULL,
    confidence double precision
);


ALTER TABLE public.categories_items OWNER TO basti;

--
-- Name: categories_items_old; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE categories_items_old (
    item_id integer,
    meta_id integer,
    category_id integer,
    confidence double precision
);


ALTER TABLE public.categories_items_old OWNER TO basti;

--
-- Name: category; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE category (
    category_id integer NOT NULL,
    meta_id integer,
    name text,
    description text,
    longdescription text
);


ALTER TABLE public.category OWNER TO basti;

--
-- Name: category_category_id_seq; Type: SEQUENCE; Schema: public; Owner: basti
--

CREATE SEQUENCE category_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.category_category_id_seq OWNER TO basti;

--
-- Name: category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: basti
--

ALTER SEQUENCE category_category_id_seq OWNED BY category.category_id;


--
-- Name: exceptions; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE exceptions (
    exception_id integer,
    message text,
    backtrace text
);


ALTER TABLE public.exceptions OWNER TO basti;

--
-- Name: feed; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE feed (
    feed_id integer NOT NULL,
    url text,
    active boolean DEFAULT true
);


ALTER TABLE public.feed OWNER TO basti;

--
-- Name: feed_feed_id_seq; Type: SEQUENCE; Schema: public; Owner: basti
--

CREATE SEQUENCE feed_feed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.feed_feed_id_seq OWNER TO basti;

--
-- Name: feed_feed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: basti
--

ALTER SEQUENCE feed_feed_id_seq OWNED BY feed.feed_id;


--
-- Name: feeds_formats; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE feeds_formats (
    format_id integer,
    feed_id integer
);


ALTER TABLE public.feeds_formats OWNER TO basti;

--
-- Name: format; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE format (
    format_id integer NOT NULL,
    algorithm format_type,
    parameter text
);


ALTER TABLE public.format OWNER TO basti;

--
-- Name: format_format_id_seq; Type: SEQUENCE; Schema: public; Owner: basti
--

CREATE SEQUENCE format_format_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.format_format_id_seq OWNER TO basti;

--
-- Name: format_format_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: basti
--

ALTER SEQUENCE format_format_id_seq OWNED BY format.format_id;


--
-- Name: hint; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE hint (
    item_id integer,
    meta_id integer,
    category_id integer,
    processed boolean NOT NULL,
    hint_id integer NOT NULL
);


ALTER TABLE public.hint OWNER TO basti;

--
-- Name: hint_hint_id_seq; Type: SEQUENCE; Schema: public; Owner: basti
--

CREATE SEQUENCE hint_hint_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.hint_hint_id_seq OWNER TO basti;

--
-- Name: hint_hint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: basti
--

ALTER SEQUENCE hint_hint_id_seq OWNED BY hint.hint_id;


--
-- Name: item; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE item (
    item_id integer NOT NULL,
    feed_id integer,
    link text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.item OWNER TO basti;

--
-- Name: item_item_id_seq; Type: SEQUENCE; Schema: public; Owner: basti
--

CREATE SEQUENCE item_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.item_item_id_seq OWNER TO basti;

--
-- Name: item_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: basti
--

ALTER SEQUENCE item_item_id_seq OWNED BY item.item_id;


--
-- Name: meta; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE meta (
    meta_id integer NOT NULL,
    description text,
    longdescription text
);


ALTER TABLE public.meta OWNER TO basti;

--
-- Name: meta_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: basti
--

CREATE SEQUENCE meta_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.meta_meta_id_seq OWNER TO basti;

--
-- Name: meta_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: basti
--

ALTER SEQUENCE meta_meta_id_seq OWNED BY meta.meta_id;


--
-- Name: titles; Type: TABLE; Schema: public; Owner: basti; Tablespace: 
--

CREATE TABLE titles (
    item_id integer,
    title text,
    title_id integer NOT NULL
);


ALTER TABLE public.titles OWNER TO basti;

--
-- Name: titles_title_id_seq; Type: SEQUENCE; Schema: public; Owner: basti
--

CREATE SEQUENCE titles_title_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.titles_title_id_seq OWNER TO basti;

--
-- Name: titles_title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: basti
--

ALTER SEQUENCE titles_title_id_seq OWNED BY titles.title_id;


--
-- Name: access_id; Type: DEFAULT; Schema: public; Owner: basti
--

ALTER TABLE ONLY accesses ALTER COLUMN access_id SET DEFAULT nextval('accesses_access_id_seq'::regclass);


--
-- Name: category_id; Type: DEFAULT; Schema: public; Owner: basti
--

ALTER TABLE ONLY category ALTER COLUMN category_id SET DEFAULT nextval('category_category_id_seq'::regclass);


--
-- Name: feed_id; Type: DEFAULT; Schema: public; Owner: basti
--

ALTER TABLE ONLY feed ALTER COLUMN feed_id SET DEFAULT nextval('feed_feed_id_seq'::regclass);


--
-- Name: format_id; Type: DEFAULT; Schema: public; Owner: basti
--

ALTER TABLE ONLY format ALTER COLUMN format_id SET DEFAULT nextval('format_format_id_seq'::regclass);


--
-- Name: hint_id; Type: DEFAULT; Schema: public; Owner: basti
--

ALTER TABLE ONLY hint ALTER COLUMN hint_id SET DEFAULT nextval('hint_hint_id_seq'::regclass);


--
-- Name: item_id; Type: DEFAULT; Schema: public; Owner: basti
--

ALTER TABLE ONLY item ALTER COLUMN item_id SET DEFAULT nextval('item_item_id_seq'::regclass);


--
-- Name: meta_id; Type: DEFAULT; Schema: public; Owner: basti
--

ALTER TABLE ONLY meta ALTER COLUMN meta_id SET DEFAULT nextval('meta_meta_id_seq'::regclass);


--
-- Name: title_id; Type: DEFAULT; Schema: public; Owner: basti
--

ALTER TABLE ONLY titles ALTER COLUMN title_id SET DEFAULT nextval('titles_title_id_seq'::regclass);


--
-- Name: categories_items_pkey; Type: CONSTRAINT; Schema: public; Owner: basti; Tablespace: 
--

ALTER TABLE ONLY categories_items
    ADD CONSTRAINT categories_items_pkey PRIMARY KEY (item_id, meta_id, category_id);


--
-- Name: format_format_id_key; Type: CONSTRAINT; Schema: public; Owner: basti; Tablespace: 
--

ALTER TABLE ONLY format
    ADD CONSTRAINT format_format_id_key UNIQUE (format_id);


--
-- Name: category_id_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE UNIQUE INDEX category_id_idx ON category USING btree (category_id);


--
-- Name: category_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE UNIQUE INDEX category_idx ON category USING btree (meta_id, category_id);


--
-- Name: category_name_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE INDEX category_name_idx ON category USING btree (((16)::name));


--
-- Name: created_at_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE INDEX created_at_idx ON item USING btree (created_at);


--
-- Name: feed_id_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE UNIQUE INDEX feed_id_idx ON feed USING btree (feed_id);


--
-- Name: item_id_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE UNIQUE INDEX item_id_idx ON item USING btree (item_id);


--
-- Name: item_link_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE UNIQUE INDEX item_link_idx ON item USING btree (link);


--
-- Name: meta_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE UNIQUE INDEX meta_idx ON meta USING btree (meta_id);


--
-- Name: processed_idx; Type: INDEX; Schema: public; Owner: basti; Tablespace: 
--

CREATE INDEX processed_idx ON hint USING btree (processed) WHERE (processed = false);


--
-- Name: category_meta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_meta_id_fkey FOREIGN KEY (meta_id) REFERENCES meta(meta_id);


--
-- Name: feed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY item
    ADD CONSTRAINT feed_id_fkey FOREIGN KEY (feed_id) REFERENCES feed(feed_id);


--
-- Name: format_feed_feed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY feeds_formats
    ADD CONSTRAINT format_feed_feed_id_fkey FOREIGN KEY (feed_id) REFERENCES feed(feed_id);


--
-- Name: format_feed_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY feeds_formats
    ADD CONSTRAINT format_feed_format_id_fkey FOREIGN KEY (format_id) REFERENCES format(format_id);


--
-- Name: hint_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY hint
    ADD CONSTRAINT hint_item_id_fkey FOREIGN KEY (item_id) REFERENCES item(item_id);


--
-- Name: hint_meta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY hint
    ADD CONSTRAINT hint_meta_id_fkey FOREIGN KEY (meta_id, category_id) REFERENCES category(meta_id, category_id);


--
-- Name: item_category_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY categories_items_old
    ADD CONSTRAINT item_category_item_id_fkey FOREIGN KEY (item_id) REFERENCES item(item_id);


--
-- Name: item_category_meta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY categories_items_old
    ADD CONSTRAINT item_category_meta_id_fkey FOREIGN KEY (meta_id, category_id) REFERENCES category(meta_id, category_id);


--
-- Name: titles_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: basti
--

ALTER TABLE ONLY titles
    ADD CONSTRAINT titles_item_id_fkey FOREIGN KEY (item_id) REFERENCES item(item_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

