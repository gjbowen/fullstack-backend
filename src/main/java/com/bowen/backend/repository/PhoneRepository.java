package com.bowen.backend.repository;


import com.bowen.backend.model.Phone;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class PhoneRepository {
    private final JdbcClient jdbcClient;

    public PhoneRepository(JdbcClient jdbcClient) {
        this.jdbcClient = jdbcClient;
    }

    public int insertPhone(int patientId, Phone phone) {
        // set old phone to expired
        retirePhone(patientId, phone.getType());

        String sql = "insert into biomgr_owner.phone(patient_id, phone_number, type) " +
                "values (:patientId, :phone, :type)";

        int count = jdbcClient.sql(sql)
                .param("patientId", patientId)
                .param("phone", phone.getPhoneNumber().replaceAll("[^0-9]", "").trim())
                .param("type", phone.getType())
                .update();
        log.info("Inserted row {patient_id: {}, phone: {}, type: {}}", patientId, phone, phone.getType());
        return count;
    }

    private void retirePhone(int patientId, String type) {
        String sql = "update biomgr_owner.phone " +
                "set expiration_date = current_timestamp " +
                "where patient_id = ? " +
                "and type = ? " +
                "and expiration_date is null";
        int count = jdbcClient.sql(sql)
                .params(patientId)
                .params(type)
                .update();
        log.info("retired {} row(s) for patient {}", count, patientId);
    }

    public Phone getPhone(int patientId) {
        String sql = "select * " +
                "from biomgr_owner.phone " +
                "where patient_id = ? " +
                "and expiration_date is null " +
                "order by seq_id desc " +
                "limit 1";
        return jdbcClient.sql(sql)
                .params(patientId)
                .query(Phone.class)
                .single();
    }}
