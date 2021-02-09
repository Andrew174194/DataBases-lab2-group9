-- second task

\c dvdrental;

CREATE OR REPLACE VIEW StaffBigAmount AS SELECT * FROM payment WHERE amount > 8 AND staff_id in (select staff_id from staff);

SELECT * FROM StaffBigAmount LIMIT 5;

CREATE OR REPLACE VIEW DramaFilms AS select * from film where film_id in (select film_id from film_category where category_id in (SELECT category_id FROM category WHERE name='Drama'));

SELECT title FROM DramaFilms ORDER BY rating DESC LIMIT 5;

DROP TABLE IF EXISTS logs;

CREATE TABLE logs ("text" text, "time" timestamp without time zone);

CREATE OR REPLACE FUNCTION add_to_log() RETURNS TRIGGER AS $$
BEGIN
    IF    TG_OP = 'INSERT' THEN
        INSERT INTO logs(text, time) VALUES ('INSERT OPERATION', NOW());
    ELSIF TG_OP = 'UPDATE' THEN
    	INSERT INTO logs(text, time) VALUES ('UPDATE OPERATION', NOW());
    ELSIF TG_OP = 'DELETE' THEN
    	INSERT INTO logs(text, time) VALUES ('DELETE OPERATION', NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS nice ON payment;

CREATE TRIGGER nice before INSERT OR UPDATE OR DELETE on payment FOR EACH ROW EXECUTE PROCEDURE add_to_log ();

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date) VALUES (341, 2, 1720, 8.0, '2021-02-09 11:25:00.000000');

UPDATE payment SET (customer_id, staff_id, rental_id, amount, payment_date) = (342, 2, 1721, 8.9, '2021-02-09 11:25:00.000000') WHERE payment_date = '2021-02-09 11:25:00.000000';

DELETE FROM payment WHERE payment_date = '2021-02-09 11:25:00.000000';

SELECT * FROM logs;
