select current_timestamp + '1 hour';

CREATE TABLE genders
(
    id smallserial PRIMARY KEY,
    name text NOT NULL
);


CREATE TABLE guests
(
    id serial PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    city text NOT NULL,
    gender_id smallint NOT NULL,
    CONSTRAINT guests_first_name_format CHECK (trim(first_name) != '' AND upper(left(first_name, 1)) = left(first_name, 1)),
    CONSTRAINT guests_last_name_format CHECK (trim(last_name) != '' AND upper(left(last_name, 1)) = left(last_name, 1)),
    FOREIGN KEY (gender_id) REFERENCES genders(id) ON DELETE RESTRICT
);

CREATE TABLE tables
(
    id serial PRIMARY KEY,
    number_of_seats smallint NOT NULL,
    CONSTRAINT tables_number_of_seats_range CHECK (number_of_seats BETWEEN 1 AND 16)
);

CREATE TABLE bills
(
    id serial PRIMARY KEY,
    amount numeric NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    table_id int NULL,
    FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE SET NULL,
    CONSTRAINT bills_amount_minimum CHECK (amount > 0)
);

CREATE TABLE vouchers
(
    id serial PRIMARY KEY,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duration interval NOT NULL,
    code text NOT NULL UNIQUE,
    CONSTRAINT vouchers_duration_length_limit CHECK (duration <= '6 months'),
    CONSTRAINT vouchers_code_pattern CHECK (code ~ '^[a-z0-9]{6}$')
);

CREATE TABLE reservations
(
    id serial PRIMARY KEY,
    number_of_guests smallint NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at timestamp with time zone NOT NULL,
    duration interval NOT NULL,
    is_canceled bool NOT NULL DEFAULT FALSE,
    guest_id int NOT NULL,
    table_id int NULL,
    voucher_id int NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES guests(id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE SET NULL,
    FOREIGN KEY (voucher_id) REFERENCES tables(id) ON DELETE RESTRICT,
    CONSTRAINT reservations_number_of_guests_range CHECK (number_of_guests BETWEEN 1 AND 16),
    CONSTRAINT reservations_started_at_future CHECK (started_at > created_at AND started_at > created_at + '1 hour'),
    CONSTRAINT reservations_duration_stay CHECK (duration BETWEEN '30 minutes' AND '5 hours')
);

