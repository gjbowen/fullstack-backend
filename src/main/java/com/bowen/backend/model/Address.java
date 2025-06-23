package com.bowen.backend.model;

import lombok.Data;

@Data
public class Address {
    private String seqId;
    private String addressLine1;
    private String addressLine2;
    private String city;
    private String state;
    private String zip;
    private String type;
}
