package com.bowen.backend.repository;

import com.bowen.backend.model.Patient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Service;


@Slf4j
@Service
public class PatientRepository {
    private final JdbcClient jdbcClient;
    public PatientRepository(JdbcClient jdbcClient) {
        this.jdbcClient = jdbcClient;
    }

    public Patient getPatientInfo(int patientId) {
        String sql = "select * from biomgr_owner.patients " +
                "where patient_id = :patientId " +
                "limit 1";
        try {

           Patient result = jdbcClient.sql(sql)
                    .param("patientId", patientId)
                    .query(Patient.class)
                    .single();
            log.info("Patient found: {}", result);
            return result;
        }
        catch(EmptyResultDataAccessException e){
            log.info("No patient found with id: {}", patientId);
            throw new RuntimeException("No patient found with id: " + patientId);
        }

    }
}

