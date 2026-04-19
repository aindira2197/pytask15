CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO users (name, email) VALUES ('Jane Doe', 'jane@example.com');

INSERT INTO posts (title, content, user_id) VALUES ('Hello World', 'This is my first post', 1);
INSERT INTO posts (title, content, user_id) VALUES ('Hello Again', 'This is my second post', 1);
INSERT INTO posts (title, content, user_id) VALUES ('Hello Jane', 'This is my first post', 2);

CREATE OR REPLACE FUNCTION iterator_posts()
RETURNS SETOF posts AS $$
DECLARE
  post posts%ROWTYPE;
BEGIN
  FOR post IN SELECT * FROM posts
  LOOP
    RETURN NEXT post;
  END LOOP;
  RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION iter_next(refcursor)
RETURNS SETOF posts AS $$
DECLARE
  post posts%ROWTYPE;
BEGIN
  FOR post IN SELECT * FROM refcursor
  LOOP
    RETURN NEXT post;
  END LOOP;
  RETURN;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  my_cursor REFCURSOR;
  post posts%ROWTYPE;
BEGIN
  my_cursor := 'my_cursor';
  OPEN my_cursor FOR SELECT * FROM posts;
  FETCH my_cursor INTO post;
  WHILE FOUND LOOP
    RAISE NOTICE '%', post;
    FETCH my_cursor INTO post;
  END LOOP;
  CLOSE my_cursor;
END $$;

SELECT * FROM iterator_posts();

CREATE OR REPLACE FUNCTION iter_start()
RETURNS REFCURSOR AS $$
DECLARE
  my_cursor REFCURSOR;
BEGIN
  my_cursor := 'my_cursor';
  OPEN my_cursor FOR SELECT * FROM posts;
  RETURN my_cursor;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION iter_finish(refcursor)
RETURNS VOID AS $$
BEGIN
  CLOSE refcursor;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  my_cursor REFCURSOR;
BEGIN
  my_cursor := iter_start();
  WHILE TRUE LOOP
    FETCH my_cursor INTO post;
    IF NOT FOUND THEN
      EXIT;
    END IF;
    RAISE NOTICE '%', post;
  END LOOP;
  iter_finish(my_cursor);
END $$;