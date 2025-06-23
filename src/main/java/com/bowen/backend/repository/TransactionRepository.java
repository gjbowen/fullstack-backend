package com.bowen.backend.repository;

import com.bowen.backend.model.Transaction;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class TransactionRepository {
    private final JdbcClient jdbcClient;

    public TransactionRepository(JdbcClient jdbcClient) {
        this.jdbcClient = jdbcClient;
    }


    public List<Transaction> getTransactions(int patientId) {
        String sql = "select *,td.charge as trans_code_charge, td.description as trans_code_desc " +
                "from finmgr_owner.transactions t,finmgr_owner.transaction_desc td " +
                "where t.trans_code = td.code " +
                "and t.pid = ? " +
                "order by t.seq_id";
        List<Transaction> transactions = jdbcClient.sql(sql)
                .params(patientId)
                .query(Transaction.class)
                .list();
        return transactions;
    }
}
