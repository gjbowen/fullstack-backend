package com.bowen.backend.repository;

import com.bowen.backend.model.Email;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class EmailRepository {
    private final JdbcClient jdbcClient;

    public EmailRepository(JdbcClient jdbcClient) {
        this.jdbcClient = jdbcClient;
    }

    public int insertEmailAddress(int patientId, Email email) {
        // set old email to expired
        retireEmail(patientId);

        String sql = "insert into biomgr_owner.email(patient_id, email) " +
                "values (:patientId, :email)";

        int count = jdbcClient.sql(sql)
                .param("patientId", patientId)
                .param("email", email.getEmail().trim())
                .update();
        log.info("Inserted row {patient_id: {}, email: {}}", patientId, email);
        return count;
    }

    private void retireEmail(int patientId) {
        String sql = "update biomgr_owner.email " +
                "set expiration_date = current_timestamp " +
                "where patient_id = ? " +
                "and expiration_date is null";
        int count = jdbcClient.sql(sql)
                .params(patientId)
                .update();
        log.info("retired {} row(s) for patient {}", count, patientId);
    }

    public Email getEmail(int patientId) {
        String sql = "select * " +
                "from biomgr_owner.email " +
                "where patient_id = ? " +
                "and expiration_date is null " +
                "order by seq_id desc " +
                "limit 1";
        return jdbcClient.sql(sql)
                .params(patientId)
                .query(Email.class)
                .single();
    }
}
