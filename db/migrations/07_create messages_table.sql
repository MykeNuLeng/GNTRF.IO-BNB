CREATE TABLE message (
  id SERIAL PRIMARY KEY,
  user_id_from int NOT NULL REFERENCES users(id),
  user_id_to int NOT NULL REFERENCES users(id),
  content VARCHAR(500),
  date DATE,
  time Time
);
