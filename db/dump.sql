START TRANSACTION;
INSERT INTO genders (name) VALUES
  ('female'),
  ('male'),
  ('other');

INSERT INTO guests (first_name, last_name, city, gender_id, email) VALUES
    ('Karel', 'Novak', 'Praha', 1, 'karel.novak@gmail.com'),
    ('Lucie', 'Mala', 'Brno', 2, 'lucicek@seznam.cz'),
    ('Karel', 'Novak', 'Praha', 1, 'karel.novak@Gmail.com'),
    ('Jana', 'Vichnarova', 'Praha', 3, 'vichyjanny@seznam.cz'),
    ('Roman', 'Prokes', 'praha', 1, 'prokesr@atlas.cz'),
    ('Francisco', 'Juarez', 'Madrid', 1, 'franciscoj494@hotmail.es'),
    ('Jana', 'Vichnarova', 'Liberec', 2, 'janickapusinka@email.cz');

INSERT INTO tables (number_of_seats) VALUES
    (2),
    (2),
    (2),
    (2),
    (4),
    (4),
    (2),
    (6),
    (2),
    (2),
    (4),
    (2),
    (2),
    (2),
    (8),
    (4);

INSERT INTO bills (amount, table_id) VALUES
    (5780, 4),
    (4900, 4),
    (10000, 15),
    (398, 1),
    (1290, 9),
    (999, 1),
    (298, 7),
    (49, 12),
    (8740, 16);

INSERT INTO vouchers (duration, code) VALUES
    ('1 year', 'a5k77c'),
    ('6 months', '2zl70q'),
    ('1 year', 'pm34bs');



INSERT INTO reservations (number_of_guests, started_at, duration, is_canceled, guest_id, table_id, voucher_id) VALUES
     (2, current_date + '1 day 14 hours'::interval, '2 hours', false, 1, 2, null);

INSERT INTO reservations (number_of_guests, started_at, duration, is_canceled, guest_id, table_id, voucher_id) VALUES
    (4, current_date + '2 days 20 hours'::interval, '3 hours',false, 2, 14, null);

INSERT INTO reservations (number_of_guests, started_at, duration, is_canceled, guest_id, table_id, voucher_id) VALUES
    (6, current_date + '2 days 20 hours'::interval, '3 hours',false, 3, 15, null),
    (4, current_date + '1 day 19.5 hours'::interval, '4 hours',false, 4, 14, null),
    (3, current_date + '7 days 13.5 hours'::interval, '1.5 hours',false, 2, 6, null),
    (4, current_date + '3 days 12 hours'::interval, '2 hours',false, 5, 11, null),
    (2, current_date + '15 days 18 hours'::interval, '0.5 hours',false, 6, 12, null),
    (2, current_date + '9 days 16 hours'::interval, '3.5 hours',true, 7, 9, 1);
COMMIT;


/* 1) How many guests use 'seznam' email?*/
select count(*) as num_of_guests_with_seznam
from guests
where email ilike '%seznam.__';


/* 2) Show me tables that have already reached the total sales CZK10000 */
select tables.id, sum(bills.amount) as total_sales
from tables
inner join bills on tables.id = bills.table_id
group by tables.id
having sum(bills.amount) > 9999;

/* 3) What is the average sales per person (round on 2 decimals)?*/
select round(bills.amount/reservations.number_of_guests::numeric, 2 ) as average_sales_per_person
from bills
LEFT JOIN tables on tables.id = bills.table_id
left join reservations on reservations.table_id = tables.id;


/*Are there any canceled reservation with valid voucher?*/
select *
from reservations
where is_canceled='true' and voucher_id is not null;

/*Check if there is some inconsistency between number of guests and number of available number of seats (it means: seats<guests)*/
select reservations.id as WRONG_reservation, reservations.number_of_guests as guests, tables.number_of_seats as seats_available
from reservations
inner join tables on tables.id = reservations.table_id
where tables.number_of_seats < reservations.number_of_guests;

/*Check the font size: Are there any duplicity of email address?*/
select lower(email), count(*)
from guests
group by lower(email);


/*When do the reservations start (in czech date format) and which tables are booked?*/
select to_char(reservations.started_at, 'dd-mm-yyyy') as date_cz, tables.id
from reservations
inner join tables on reservations.table_id = tables.id
order by date_cz, table_id;






