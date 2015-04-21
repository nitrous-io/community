CREATE TABLE tutorials (
  id bigserial PRIMARY KEY NOT NULL,
  user_id bigint NOT NULL,
  author character varying(255) NOT NULL,
  pretty_url character varying(255) NOT NULL UNIQUE,
  title character varying(255) NOT NULL,
  post_markdown text NOT NULL,
  post_html text,
  tags character varying(255)[] DEFAULT '{}',
  approved bool NOT NULL,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);
