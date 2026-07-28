-- =====================================================================
-- Clinical Triage Database — Schema (3NF, 10 tables)
-- Cheng Chin (Boris) Hsieh
-- Backend for the fine-tuned BioMistral-7B triage model
-- =====================================================================

DROP TABLE IF EXISTS CLINICIAN_REVIEW;
DROP TABLE IF EXISTS MODEL_PREDICTION;
DROP TABLE IF EXISTS DISEASE_SYMPTOM;
DROP TABLE IF EXISTS ENCOUNTER_SYMPTOM;
DROP TABLE IF EXISTS TRIAGE_ENCOUNTER;
DROP TABLE IF EXISTS DISEASE;
DROP TABLE IF EXISTS SYMPTOM;
DROP TABLE IF EXISTS CLINICIAN;
DROP TABLE IF EXISTS PATIENT;
DROP TABLE IF EXISTS DEPARTMENT;

CREATE TABLE PATIENT (
    patient_id  INTEGER PRIMARY KEY,
    birth_year  INTEGER,
    sex         TEXT,
    phone       TEXT
);

CREATE TABLE DEPARTMENT (
    department_id   INTEGER PRIMARY KEY,
    department_name TEXT NOT NULL,
    floor_location  TEXT,
    phone_ext       TEXT
);

CREATE TABLE CLINICIAN (
    clinician_id  INTEGER PRIMARY KEY,
    full_name     TEXT NOT NULL,
    role          TEXT,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id)
);

CREATE TABLE DISEASE (
    disease_id    INTEGER PRIMARY KEY,
    disease_name  TEXT NOT NULL,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id)
);

CREATE TABLE SYMPTOM (
    symptom_id   INTEGER PRIMARY KEY,
    symptom_name TEXT NOT NULL,
    body_system  TEXT
);

CREATE TABLE TRIAGE_ENCOUNTER (
    encounter_id    INTEGER PRIMARY KEY,
    patient_id      INTEGER,
    encounter_time  TEXT,
    chief_complaint TEXT,
    acuity_level    INTEGER,
    status          TEXT,
    FOREIGN KEY (patient_id) REFERENCES PATIENT(patient_id)
);

CREATE TABLE ENCOUNTER_SYMPTOM (
    encounter_id INTEGER,
    symptom_id   INTEGER,
    severity     TEXT,
    onset        TEXT,
    PRIMARY KEY (encounter_id, symptom_id),
    FOREIGN KEY (encounter_id) REFERENCES TRIAGE_ENCOUNTER(encounter_id),
    FOREIGN KEY (symptom_id)   REFERENCES SYMPTOM(symptom_id)
);

CREATE TABLE DISEASE_SYMPTOM (
    disease_id INTEGER,
    symptom_id INTEGER,
    typicality TEXT,
    PRIMARY KEY (disease_id, symptom_id),
    FOREIGN KEY (disease_id) REFERENCES DISEASE(disease_id),
    FOREIGN KEY (symptom_id) REFERENCES SYMPTOM(symptom_id)
);

CREATE TABLE MODEL_PREDICTION (
    prediction_id        INTEGER PRIMARY KEY,
    encounter_id         INTEGER,
    model_version        TEXT,
    raw_disease_text     TEXT,
    raw_department_text  TEXT,
    predicted_disease_id INTEGER,
    confidence           REAL,
    predicted_at         TEXT,
    FOREIGN KEY (encounter_id)         REFERENCES TRIAGE_ENCOUNTER(encounter_id),
    FOREIGN KEY (predicted_disease_id) REFERENCES DISEASE(disease_id)
);

CREATE TABLE CLINICIAN_REVIEW (
    review_id           INTEGER PRIMARY KEY,
    prediction_id       INTEGER,
    clinician_id        INTEGER,
    decision             TEXT,
    final_department_id INTEGER,
    reviewed_at          TEXT,
    FOREIGN KEY (prediction_id)       REFERENCES MODEL_PREDICTION(prediction_id),
    FOREIGN KEY (clinician_id)        REFERENCES CLINICIAN(clinician_id),
    FOREIGN KEY (final_department_id) REFERENCES DEPARTMENT(department_id)
);
