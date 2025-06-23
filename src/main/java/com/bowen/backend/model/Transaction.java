package com.bowen.backend.model;

import lombok.Data;

import java.util.Date;

@Data
public class Transaction {
    private int seqId;
    private double amount;
    private Date transDate;
    private Date dueDate;
    private String transCode;
    private String transCodeDesc;
    private String transNote;
    private String transCodeCharge;
}
