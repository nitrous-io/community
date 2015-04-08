CREATE TABLE tutorials (
  id bigserial PRIMARY KEY NOT NULL,
  user_id bigint REFERENCES users(id) NOT NULL,
  title varchar(255) NOT NULL UNIQUE,
  post text NOT NULL UNIQUE,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);
