ALTER TABLE guests ADD COLUMN email text;
ALTER TABLE guests ADD CONSTRAINT guests_email_simple_form CHECK (email LIKE '%@%');
