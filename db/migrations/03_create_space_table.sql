CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  user_id int NOT NULL REFERENCES users(id),
  price int,
  headline VARCHAR(180),
  description VARCHAR
);
