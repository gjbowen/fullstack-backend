-- Insert into phone number table
drop procedure if exists biomgr_owner.insert_phone(patientid integer, number varchar, type varchar);
CREATE or replace PROCEDURE biomgr_owner.insert_phone(p_patient_id int, p_phone_number varchar, p_type varchar)
    LANGUAGE plpgsql
AS $$
BEGIN
    DECLARE
        row_count numeric := 0;
        v_phone_number biomgr_owner.phone.phone_number%type;
    BEGIN
        update biomgr_owner.phone
        set expiration_date = now()
        where patient_id = p_patient_id
          and type = p_type
          and expiration_date is null;
        -- get count of updated
        GET DIAGNOSTICS row_count = ROW_COUNT;
        -- display count of updated
        RAISE NOTICE 'Row(s) updated: %', row_count;
        -- Format phone number - remove non-numerics
        v_phone_number := regexp_replace(p_phone_number, '[^0-9]+', '', 'g');
        if length(v_phone_number) =  10 then
            v_phone_number := substr(v_phone_number,0,4) || '-' || substr(v_phone_number,4,3) || '-' || substr(v_phone_number,7);
        end if;

        insert into biomgr_owner.phone (patient_id, phone_number, type) values (p_patient_id, v_phone_number, p_type);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'An error while inserting phone number: %', v_phone_number;
    END;
END;
$$;

-- insert into address table
drop procedure if exists biomgr_owner.insert_address(patientid integer, street varchar, city varchar, state varchar, zip varchar);
CREATE or replace PROCEDURE biomgr_owner.insert_address(p_patient_id int, p_street1 varchar, p_street2 varchar, p_city varchar, p_state varchar, p_zip varchar, p_type varchar)
    LANGUAGE plpgsql
AS $$
BEGIN
    DECLARE
        row_count numeric := 0;
    BEGIN
        update biomgr_owner.address
        set expiration_date = now()
        where patient_id = p_patient_id
          and type = p_type
          and expiration_date is null;
        -- get count of updated
        GET DIAGNOSTICS row_count = ROW_COUNT;
        -- display count of updated
        RAISE NOTICE 'Row(s) updated: %', row_count;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'An error while expiring address for patient: %', p_patient_id;
    END;

    BEGIN
        insert into biomgr_owner.address (patient_id, address_line_1, address_line_2, city, state, zip, type)
        values (p_patient_id, p_street1, p_street2, p_city, p_state, p_zip, p_type);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'An error while inserting address for patient: %', p_patient_id;
    END;
END;
$$;

-- Insert into phone number table
drop procedure if exists biomgr_owner.insert_email(p_patient_id int, p_email varchar);
CREATE or replace PROCEDURE biomgr_owner.insert_email(p_patient_id int, p_email varchar)
    LANGUAGE plpgsql
AS $$
BEGIN
    DECLARE
        row_count numeric := 0;
    BEGIN
        update biomgr_owner.email
        set expiration_date = now()
        where patient_id = p_patient_id
          and expiration_date is null;
        -- get count of updated
        GET DIAGNOSTICS row_count = ROW_COUNT;
        -- display count of updated
        RAISE NOTICE 'Row(s) updated: %', row_count;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'An error while expiring email for patient: %', p_patient_id;
    END;

    BEGIN
        insert into biomgr_owner.email (patient_id, email) values (p_patient_id, p_email);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'An error while inserting email for patient: %', p_patient_id;
    END;
END;
$$;