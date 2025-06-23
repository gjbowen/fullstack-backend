package com.bowen.backend.controller;


import com.bowen.backend.model.Patient;
import com.bowen.backend.model.Request;
import com.bowen.backend.model.Transactions;
import com.bowen.backend.services.EntityService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api")
public class MainController {

    private final EntityService entityService;

    public MainController(EntityService entityService) {
        this.entityService = entityService;
    }

    @PostMapping(value = "/get/patient", consumes = "application/json", produces = "application/json")
    public Patient getPatient(@RequestBody Request request) {
        Patient patient = entityService.getPatient(request.getPatientId());
        log.info("Patient: {}", patient);
        return patient;
    }

    @PostMapping(value = "/get/transactions", consumes = "application/json", produces = "application/json")
    public Transactions getTransactions(@RequestBody Request request) {
        log.info( "Request: {}", request);
        return entityService.getTransactions(request);
    }

    @PostMapping(value = "/insert/phone", consumes = "application/json", produces = "application/json")
    public String insertPhone(@RequestBody Request request) {
        entityService.insertPhone(request.getPatientId(), request.getPhone());
        return "{\"Hello\": \"World!\"}";
    }

    @PostMapping(value = "/insert/email", consumes = "application/json", produces = "application/json")
    public String insertEmail(@RequestBody Request request) {
        entityService.insertEmailAddress(request.getPatientId(), request.getEmail());
        return "{\"Hello\": \"World!\"}";
    }

    @PostMapping(value = "/insert/address", consumes = "application/json", produces = "application/json")
    public String updateAddress(@RequestBody Request request) {
        entityService.insertAddress(request.getPatientId(), request.getAddress());
        return "{\"Hello\": \"World!\"}";
    }

}
