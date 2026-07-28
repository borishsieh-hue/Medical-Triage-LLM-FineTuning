-- =====================================================================
-- Clinical Triage Database — Hospital Use-Case Queries
-- Run after schema.sql and sample_data.sql
-- =====================================================================

-- 1. TRIAGE SORTING — ED triage nurse deciding who to see next.
--    Unresolved encounters, most urgent first, earliest arrival first.
SELECT encounter_id, chief_complaint, acuity_level, status
FROM   TRIAGE_ENCOUNTER
WHERE  status != 'Completed'
ORDER  BY acuity_level ASC, encounter_time ASC;


-- 2. REVIEW QUEUE — physician's list of predictions still awaiting review.
--    LEFT JOIN + IS NULL finds predictions with no matching review row.
SELECT te.encounter_id, te.chief_complaint,
       mp.raw_disease_text AS predicted_disease, mp.confidence
FROM   MODEL_PREDICTION mp
JOIN   TRIAGE_ENCOUNTER te ON mp.encounter_id = te.encounter_id
LEFT JOIN CLINICIAN_REVIEW cr ON mp.prediction_id = cr.prediction_id
WHERE  cr.review_id IS NULL
ORDER  BY te.acuity_level ASC;


-- 3. OVERRIDE ANALYSIS — patient-safety / AI oversight.
--    What the model predicted vs. where the clinician actually routed
--    the patient. MODEL_PREDICTION and CLINICIAN_REVIEW are separate
--    tables, so the disagreement is preserved rather than overwritten.
SELECT te.encounter_id,
       mp.raw_disease_text AS model_predicted,
       cr.decision,
       dep.department_name AS final_department
FROM   CLINICIAN_REVIEW cr
JOIN   MODEL_PREDICTION mp ON cr.prediction_id = mp.prediction_id
JOIN   TRIAGE_ENCOUNTER te ON mp.encounter_id  = te.encounter_id
JOIN   DEPARTMENT dep      ON cr.final_department_id = dep.department_id
WHERE  cr.decision LIKE '%Overridden%';


-- 4. MODEL CONFIDENCE — AI quality-assurance dashboard.
--    Average / min / max confidence across all predictions.
SELECT ROUND(AVG(confidence), 4) AS avg_confidence,
       MIN(confidence)           AS lowest_confidence,
       MAX(confidence)           AS highest_confidence,
       COUNT(*)                  AS total_predictions
FROM   MODEL_PREDICTION;


-- 5. TRUST CALIBRATION — does confidence relate to being overridden?
--    Average confidence of overridden vs. confirmed predictions.
SELECT CASE WHEN cr.decision LIKE '%Overridden%' THEN 'Overridden'
            ELSE 'Confirmed' END     AS review_outcome,
       COUNT(*)                      AS n,
       ROUND(AVG(mp.confidence), 4)  AS avg_confidence
FROM   CLINICIAN_REVIEW cr
JOIN   MODEL_PREDICTION mp ON cr.prediction_id = mp.prediction_id
GROUP  BY review_outcome;
