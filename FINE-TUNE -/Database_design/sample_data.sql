-- =====================================================================
-- Clinical Triage Database — Sample Data
-- =====================================================================

INSERT INTO DEPARTMENT VALUES
(1,'Emergency Medicine','Floor 1','x1001'),
(2,'Cardiology','Floor 3','x3002'),
(3,'Internal Medicine','Floor 2','x2003'),
(4,'Pulmonology','Floor 3','x3004'),
(5,'Neurology','Floor 4','x4005');

INSERT INTO PATIENT VALUES
(1,1978,'M','512-555-0142'),
(2,1990,'F','512-555-0198'),
(3,1965,'M','512-555-0173'),
(4,1988,'F','512-555-0110'),
(5,1955,'F','512-555-0199');

INSERT INTO CLINICIAN VALUES
(1,'Dr. Boris Hsieh','Attending Physician',1),
(2,'Dr. James Whitfield','Cardiologist',2),
(3,'Dr. Priya Patel','Internist',3),
(4,'Dr. Marcus Ellison','Pulmonologist',4),
(5,'Dr. Laura Kim','Neurologist',5);

INSERT INTO DISEASE VALUES
(1,'Acute Myocardial Infarction',2),
(2,'Community-Acquired Pneumonia',4),
(3,'Type 2 Diabetes Mellitus',3),
(4,'Migraine with Aura',5),
(5,'Sepsis',1);

INSERT INTO SYMPTOM VALUES
(1,'Chest Pain','Cardiovascular'),
(2,'Shortness of Breath','Respiratory'),
(3,'Fever','General'),
(4,'Cough','Respiratory'),
(5,'Headache','Neurological'),
(6,'Nausea','Gastrointestinal'),
(7,'Fatigue','General'),
(8,'Dizziness','Neurological');

INSERT INTO TRIAGE_ENCOUNTER VALUES
(1,1,'2026-07-01 08:15','Crushing chest pain radiating to left arm',1,'Completed'),
(2,2,'2026-07-02 14:30','Persistent cough and fever for 5 days',3,'Completed'),
(3,3,'2026-07-03 09:00','Increased thirst, fatigue, blurred vision',4,'Completed'),
(4,4,'2026-07-04 19:45','Severe headache with visual aura',3,'Completed'),
(5,5,'2026-07-05 22:10','High fever, confusion, low blood pressure',1,'In Review');

INSERT INTO ENCOUNTER_SYMPTOM VALUES
(1,1,'Severe','Sudden'),
(1,2,'Moderate','Sudden'),
(2,3,'Mild','Gradual'),
(2,4,'Moderate','Gradual'),
(3,7,'Mild','Gradual'),
(3,6,'Mild','Gradual'),
(4,5,'Severe','Sudden'),
(4,8,'Moderate','Sudden'),
(5,3,'Severe','Sudden'),
(5,7,'Severe','Gradual');

INSERT INTO DISEASE_SYMPTOM VALUES
(1,1,'Typical'),
(1,2,'Typical'),
(2,3,'Typical'),
(2,4,'Typical'),
(3,7,'Typical'),
(3,6,'Atypical'),
(4,5,'Typical'),
(4,8,'Typical'),
(5,3,'Typical'),
(5,7,'Typical');

INSERT INTO MODEL_PREDICTION VALUES
(1,1,'BioMistral7B-LoRAv1.2','Acute MI','Cardiology',1,0.94,'2026-07-01 08:17'),
(2,2,'BioMistral7B-LoRAv1.2','Pneumonia','Pulmonology',2,0.87,'2026-07-02 14:32'),
(3,3,'BioMistral7B-LoRAv1.2','Type 2 Diabetes','Internal Medicine',3,0.79,'2026-07-03 09:03'),
(4,4,'BioMistral7B-LoRAv1.2','Migraine w/ aura','Neurology',4,0.82,'2026-07-04 19:48'),
(5,5,'BioMistral7B-LoRAv1.2','Sepsis','Emergency Medicine',5,0.91,'2026-07-05 22:13');

INSERT INTO CLINICIAN_REVIEW VALUES
(1,1,2,'Confirmed',2,'2026-07-01 08:25'),
(2,2,4,'Confirmed',4,'2026-07-02 14:50'),
(3,3,3,'Confirmed',3,'2026-07-03 09:20'),
(4,4,5,'Confirmed',5,'2026-07-04 20:05'),
(5,5,1,'Overridden - reassigned to ICU',1,'2026-07-05 22:30');

-- One additional encounter with a model prediction but NO review yet —
-- a realistic "still pending" case for the physician's review queue.
INSERT INTO TRIAGE_ENCOUNTER VALUES
(6,3,'2026-07-06 07:50','Sudden severe headache, worst of life',2,'In Review');

INSERT INTO ENCOUNTER_SYMPTOM VALUES
(6,5,'Severe','Sudden'),
(6,8,'Moderate','Sudden');

INSERT INTO MODEL_PREDICTION VALUES
(6,6,'BioMistral7B-LoRAv1.2','Migraine w/ aura','Neurology',4,0.58,'2026-07-06 07:52');
-- (intentionally no CLINICIAN_REVIEW row for prediction 6 — it awaits review)
