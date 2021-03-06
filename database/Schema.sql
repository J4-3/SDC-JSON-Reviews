DROP DATABASE IF EXISTS sdc;
CREATE DATABASE sdc;
\c sdc;

CREATE TABLE IF NOT EXISTS reviews (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  rating INT NOT NULL,
  date BIGINT,
  summary VARCHAR,
  body VARCHAR,
  recommend BOOLEAN,
  reported BOOLEAN,
  reviewer_name VARCHAR,
  reviewer_email VARCHAR,
  response VARCHAR,
  helpfulness INT NOT NULL
);

DROP TABLE IF EXISTS reviews_photos;
CREATE TABLE IF NOT EXISTS reviews_photos (
  id INT PRIMARY KEY,
  review_id INT NOT NULL,
  url VARCHAR,
  FOREIGN KEY (review_id)
    REFERENCES reviews (id)
);

CREATE TABLE IF NOT EXISTS characteristics (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  name VARCHAR
);

CREATE TABLE IF NOT EXISTS characteristic_reviews (
  id INT PRIMARY KEY,
  characteristic_id INT NOT NULL,
  review_id INT NOT NULL,
  value INT,
  FOREIGN KEY (characteristic_id)
    REFERENCES characteristics (id),
  FOREIGN KEY (review_id)
    REFERENCES reviews (id)
);

\copy reviews from '../data/reviews.csv' DELIMITER ',' CSV HEADER;
\copy reviews_photos from '../data/reviews_photos.csv' DELIMITER ',' CSV HEADER;
\copy characteristics from '../data/characteristics.csv' DELIMITER ',' CSV HEADER;
\copy characteristic_reviews from '../data/characteristic_reviews.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE recommend_meta AS (
  SELECT product_id, recommend, count(recommend) FROM reviews GROUP BY product_id, recommend
);

CREATE TABLE ratings_meta AS (
  SELECT product_id, rating, count(rating) FROM reviews GROUP BY product_id, rating
);

CREATE TABLE characteristic_meta AS (
  SELECT characteristics.product_id, characteristics.name, characteristics.id, avg (characteristic_reviews.value)
  FROM characteristics, characteristic_reviews
  WHERE characteristic_reviews.characteristic_id = characteristics.id
  GROUP BY characteristics.product_id, characteristics.name, characteristics.id
);
