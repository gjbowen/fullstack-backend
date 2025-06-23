package com.bowen.backend.repository;


import com.bowen.backend.model.Address;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AddressRepository {

    private final JdbcClient jdbcClient;
    public AddressRepository(JdbcClient jdbcClient) {
        this.jdbcClient = jdbcClient;
    }

    public void insertAddress(int patientId, Address address) {
    }

    public Address getAddresses(int patientId) {
        String sql = "select * from biomgr_owner.address " +
                "where patient_id = :patientId " +
                "and expiration_date is null " +
                "order by seq_id desc " +
                "limit 1";
        try {

            Address result = jdbcClient.sql(sql)
                    .param("patientId", patientId)
                    .query(Address.class)
                    .single();
            log.info("Address found: {}", result);
            return result;
        } catch (EmptyResultDataAccessException e) {
            log.info("No address found with id: {}", patientId);
            throw new RuntimeException("No address found with id: " + patientId);
        }
    }
}
