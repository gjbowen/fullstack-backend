--------------------------------------------------------------------------------
-- core bio info
drop schema if exists biomgr_owner cascade;
create schema if not exists biomgr_owner;

drop table if exists biomgr_owner.patients cascade;
CREATE TABLE biomgr_owner.patients (patient_id SERIAL PRIMARY KEY,
                                    preferred_name VARCHAR(255),
                                    first_name VARCHAR(255),
                                    middle_name VARCHAR(255),
                                    last_name VARCHAR(255),
                                    dob DATE,
                                    gender char,
                                    created_by varchar(20) not null,
                                    created_date timestamp not null,
                                    updated_by varchar(20) not null,
                                    updated_date timestamp not null
);

CREATE OR REPLACE FUNCTION biomgr_owner.patients_biu()
    RETURNS trigger AS $$
BEGIN
    if TG_OP = 'INSERT' then
        NEW.created_by := current_user;
        NEW.created_date := now();
    end if;
    NEW.updated_by := current_user;
    NEW.updated_date := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER patients_biu
    BEFORE INSERT or UPDATE ON biomgr_owner.patients
    FOR EACH ROW
EXECUTE PROCEDURE biomgr_owner.patients_biu();

-- Phone
drop table if exists biomgr_owner.phone_type;
create table if not exists biomgr_owner.phone_type (code varchar(4) primary key,
                                                    description varchar(20)
);

insert into biomgr_owner.phone_type (code, description)
values ('H', 'Home'),
       ('W', 'Work'),
       ('M', 'Mobile'),
       ('O', 'Other');

drop table if exists biomgr_owner.phone;
CREATE TABLE if not exists biomgr_owner.phone (id SERIAL,
                                               patient_id INTEGER REFERENCES biomgr_owner.patients(patient_id),
                                               seq_id int not null,
                                               phone_number VARCHAR(12),
                                               type VARCHAR(50) references biomgr_owner.phone_type(code),
                                               effective_date timestamp not null,
                                               expiration_date timestamp,
                                               primary key (patient_id, seq_id)
);

CREATE OR REPLACE FUNCTION biomgr_owner.phone_biu()
    RETURNS trigger AS $$
BEGIN
    if TG_OP = 'INSERT' then
        NEW.seq_id := (select coalesce(max(seq_id),0) + 1 from biomgr_owner.phone where patient_id =NEW.patient_id);
        NEW.effective_date := now();
    end if;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER phone_biu
    BEFORE INSERT or UPDATE ON biomgr_owner.phone
    FOR EACH ROW
EXECUTE PROCEDURE biomgr_owner.phone_biu();

-- Email
drop table if exists biomgr_owner.email;
CREATE TABLE if not exists biomgr_owner.email (id SERIAL,
                                               patient_id INTEGER REFERENCES biomgr_owner.patients(patient_id),
                                               seq_id int not null,
                                               email VARCHAR(120),
                                               effective_date timestamp not null,
                                               expiration_date timestamp,
                                               primary key (patient_id, seq_id)
);

CREATE OR REPLACE FUNCTION biomgr_owner.email_biu()
    RETURNS trigger AS $$
BEGIN
    if TG_OP = 'INSERT' then
        NEW.seq_id := (select coalesce(max(seq_id),0) + 1 from biomgr_owner.email where patient_id =NEW.patient_id);
        NEW.effective_date := now();
    end if;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER email_biu
    BEFORE INSERT or UPDATE ON biomgr_owner.email
    FOR EACH ROW
EXECUTE PROCEDURE biomgr_owner.email_biu();

-- Address
drop table if exists biomgr_owner.address_type;
create table if not exists biomgr_owner.address_type (code varchar(4) primary key,
                                                      description varchar(20)
);

insert into biomgr_owner.address_type (code, description)
values ('H', 'Home'),
       ('B', 'Billing'),
       ('O', 'Other');


drop table if exists biomgr_owner.address;
CREATE TABLE if not exists biomgr_owner.address (id SERIAL,
                                                 patient_id INTEGER REFERENCES biomgr_owner.patients(patient_id),
                                                 seq_id int not null,
                                                 address_line_1 VARCHAR(255) not null,
                                                 address_line_2 VARCHAR(255),
                                                 city VARCHAR(255) not null ,
                                                 state VARCHAR(255) not null ,
                                                 zip VARCHAR(255) not null ,
                                                 type VARCHAR(50) references biomgr_owner.address_type(code),
                                                 effective_date timestamp not null,
                                                 expiration_date timestamp,
                                                 created_by varchar(20) not null,
                                                 created_date timestamp not null,
                                                 updated_by varchar(20) not null,
                                                 updated_date timestamp not null,
                                                 primary key (patient_id, seq_id)
);

CREATE OR REPLACE FUNCTION biomgr_owner.address_biu()
    RETURNS trigger AS $$
BEGIN
    if TG_OP = 'INSERT' then
        NEW.seq_id := (select coalesce(max(seq_id),0) + 1 from biomgr_owner.address where patient_id =NEW.patient_id);
        NEW.effective_date := now();
        NEW.created_by := current_user;
        NEW.created_date := now();
    end if;
    NEW.updated_by := current_user;
    NEW.updated_date := now();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER address_biu
    BEFORE INSERT or UPDATE ON biomgr_owner.address
    FOR EACH ROW
EXECUTE PROCEDURE biomgr_owner.address_biu();

------------------------------------------------------------------------------
-- Transactions
drop schema if exists finmgr_owner cascade;
create schema if not exists finmgr_owner;

drop table if exists finmgr_owner.transaction_desc;
create table if not exists finmgr_owner.transaction_desc (code varchar(4) primary key,
                                                          description varchar(255),
                                                          charge char
);
insert into finmgr_owner.transaction_desc (code, description, charge)
values ('APPT', 'Standard ', 'C'),
       ('PYMT', 'Payment', 'D'),
       ('LTFE', 'Late Fee', 'C'),
       ('PRMO', 'Promotion', 'D'),
       ('FEE', 'Fee', 'C'),
       ('INT', 'Interest', 'C');

-- main Transaction table
drop table if exists finmgr_owner.transactions;
create table if not exists finmgr_owner.transactions (pid int not null references biomgr_owner.patients(patient_id),
                                                      seq_id int not null,
                                                      amount numeric(10,2) not null,
                                                      trans_date date not null,
                                                      trans_code varchar(4) references finmgr_owner.transaction_desc(code),
                                                      trans_note varchar(255),
                                                      created_by varchar(20) not null,
                                                      created_date timestamp not null,
                                                      updated_by varchar(20) not null,
                                                      updated_date timestamp not null,
                                                      primary key (pid, seq_id)
);

CREATE OR REPLACE FUNCTION finmgr_owner.transactions_biu()
    RETURNS trigger AS $$
BEGIN
    if TG_OP = 'INSERT' then
        -- Set the value of 'my_column' in the new row
        NEW.seq_id := (select coalesce(max(seq_id),0) + 1 from finmgr_owner.transactions where pid =NEW.pid);
        NEW.pid := NEW.pid;
        NEW.created_by := current_user;
        NEW.created_date := now();
    end if;
    NEW.updated_by := current_user;
    NEW.updated_date := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER transactions_biu
    BEFORE INSERT or UPDATE ON finmgr_owner.transactions
    FOR EACH ROW
EXECUTE PROCEDURE finmgr_owner.transactions_biu();
