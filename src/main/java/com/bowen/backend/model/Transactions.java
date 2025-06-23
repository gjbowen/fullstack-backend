package com.bowen.backend.model;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class Transactions {
    List<Transaction> transactions;
}
