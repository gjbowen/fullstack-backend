package com.bowen.backend.model;


import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

@Data
public class Patient {
    private int patientId;
    private String preferredName;
    private String firstName;
    private String middleName;
    private String lastName;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date dob;
    private String gender;
    private Address address;
    private Email email;
    private Phone phone;
}
