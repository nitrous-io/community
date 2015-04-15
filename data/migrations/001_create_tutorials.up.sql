CREATE TABLE tutorials (
  id bigserial PRIMARY KEY NOT NULL,
  user_id bigint NOT NULL,
  author character varying(255) NOT NULL,
  title character varying(255) NOT NULL,
  post text NOT NULL UNIQUE,
  approved bool NOT NULL,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);
