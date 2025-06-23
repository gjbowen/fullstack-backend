package com.bowen.backend.services;

import com.bowen.backend.model.*;
import com.bowen.backend.repository.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class EntityService {

    private final PatientRepository patientRepository;
    private final AddressRepository addressRepository;
    private final EmailRepository emailRepository;
    private final PhoneRepository phoneRepository;
    private final TransactionRepository transactionRepository;

    public EntityService(PatientRepository patientRepository, AddressRepository addressRepository, EmailRepository emailRepository, PhoneRepository phoneRepository, TransactionRepository transactionRepository) {
        this.patientRepository = patientRepository;
        this.addressRepository = addressRepository;
        this.emailRepository = emailRepository;
        this.phoneRepository = phoneRepository;
        this.transactionRepository = transactionRepository;
    }

    public void insertPhone(int patientId, Phone phone) {
        phoneRepository.insertPhone(patientId, phone);
    }

    public void insertEmailAddress(int patientId, Email email) {
        emailRepository.insertEmailAddress(patientId, email);
    }

    public void insertAddress(int patientId, Address address) {
        addressRepository.insertAddress(patientId, address);
    }

    public Patient getPatient(int patientId) {
        Patient patient = patientRepository.getPatientInfo(patientId);
        patient.setAddress(addressRepository.getAddresses(patientId));
        patient.setEmail(emailRepository.getEmail(patientId));
        patient.setPhone(phoneRepository.getPhone(patientId));
        return patient;
    }

    public Transactions getTransactions(Request request) {
         return new Transactions(transactionRepository.getTransactions(request.getPatientId()));
    }
}
