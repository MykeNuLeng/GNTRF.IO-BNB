CREATE TABLE availability (
  id SERIAL PRIMARY KEY,
  space_id int NOT NULL REFERENCES spaces(id),
  availability_start DATE,
  availability_end DATE
);
