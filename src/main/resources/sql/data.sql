
insert into biomgr_owner.patients
(preferred_name, first_name, middle_name, last_name, dob, gender)
values ('Greg', 'Gregory', 'John', 'Bowen', '1991-05-04', 'F'),
       (null,'John', null, 'Doe', '1990-01-01', 'M'),
       (null, 'David',null, 'Smith','1950-01-01','M');


insert into biomgr_owner.phone
(patient_id, phone_number, type)
values (1, '800-600-6014', 'H'),
       (1, '000000000002', 'M'),
       (2, '000000000003', 'W');

insert into biomgr_owner.address
(patient_id, address_line_1, city, state, zip, type)
values (1, '123 Main St', 'New York', 'NY', '10001', 'H'),
       (2, '456 Main St', 'New York', 'NY', '10001', 'H');

insert into biomgr_owner.email (patient_id, email)
values (1, 'john.doe@example.com'),
       (2, 'david.smith@example.com');

insert into finmgr_owner.transactions (pid, amount, trans_date, trans_code, trans_note)
values (1, 1000, '2023-01-01', 'APPT', 'First Appointment'),
       (1, 100, '2024-01-02', 'LTFE', null),
       (1, -1000, '2024-05-03', 'PYMT', 'Payment on account'),
       (1, 800, '2024-11-04', 'APPT', 'Second appointment'),
       (1, -900, '2025-01-04', 'PYMT', 'Last payment');

select * from finmgr_owner.transactions;
