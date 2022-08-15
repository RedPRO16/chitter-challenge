CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email text,
  password text,
  name text,
  username text
);

INSERT INTO users (email, password, name, username) VALUES
('David@gmail.com', 'dvd123', 'David', '@dd'),
('Anna@gmail.com', 'ann321', 'Anna', '@aa');


CREATE TABLE peeps (
  id SERIAL PRIMARY KEY,
  content text,
  timestamp timestamp,
  username text,

  user_id int,
    constraint fk_user foreign key(user_id)
      references users(id)
      on delete cascade
);

INSERT INTO peeps (content, timestamp, username, user_id) VALUES
('Hello world', '2022-06-08 09:00:00', '@dd', 1),
('Today is very hot day!', '2022-08-03 12:00:00', '@dd', 1),
('When are you going to holiday?', '2022-07-17 17:00:00', '@aa', 2);