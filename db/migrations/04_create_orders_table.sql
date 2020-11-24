CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  space_id int NOT NULL REFERENCES spaces(id),
  user_id int NOT NULL REFERENCES users(id),
  booking_start DATE,
  booking_end DATE,
  confirmed BOOLEAN DEFAULT false
);
