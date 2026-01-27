-- 1) For each patient, show the first visit_date using FIRST_VALUE().

SELECT
    patient_id,
	visit_date,
	FIRST_VALUE(visit_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS first_value
FROM Visits;

-- 2) For each patient, get the first visit_cost ordered by visit_date.
SELECT
    patient_id,
	visit_date,
	visit_cost,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS first_value_visit_cost
FROM Visits;

-- 3) For each doctor, find the first patient_id they consulted based on visit_date.
SELECT
    doctor_id,
	patient_id,
	visit_date,
	FIRST_VALUE(patient_id) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_value_id
FROM visits;

-- 4) Show the first visit_id for each department ordered by visit_date.
SELECT
    visit_id,
	department,
	visit_date,
	FIRST_VALUE(visit_id) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_id
FROM Visits;

-- 5) For each patient, display the first doctor_id who handled their visit.
SELECT
    patient_id,
	doctor_id,
	visit_date,
	FIRST_VALUE(doctor_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_id
FROM Visits;
    
-- 6) Find the first non-NULL diagnosis for each patient using FIRST_VALUE().
SELECT *
FROM (
  SELECT
      patient_id,
      diagnosis,
      visit_date,
      FIRST_VALUE(diagnosis) OVER (
          PARTITION BY patient_id
          ORDER BY visit_date
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      ) AS first_diagnosis
  FROM visits
  WHERE diagnosis IS NOT NULL
) t;


-- 7) For each patient, show the first visit_status ordered by visit_date.
SELECT
    patient_id,
	visit_status,
	visit_date,
	FIRST_VALUE(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_id
FROM Visits;

-- 8) Get the first consultation_fee for each patient ordered by created_date.
SELECT
    patient_id,
	consultation_fee,
	created_date,
	FIRST_VALUE(consultation_fee) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
	                                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_value_fee
FROM Billing;

-- 9) For each department, show the first visit_cost recorded.
SELECT
    visit_id,
	department,
	visit_date,
	visit_cost,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS First_value_visit_cost
FROM visits;

-- 10) For each patient, retrieve the first medicine_cost greater than 500 using FIRST_VALUE().
SELECT *
FROM (
    SELECT
        patient_id,
        created_date,
        medicine_cost,
        FIRST_VALUE(medicine_cost) OVER (
            PARTITION BY patient_id
            ORDER BY created_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS first_medicine_cost
    FROM Billing
    WHERE medicine_cost > 500
) t;

-- 11) For each doctor, find the first visit_date including NULL handling.
SELECT
    doctor_id,
	visit_date,
	FIRST_value(visit_date) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_visit_date
FROM Visits;

-- 12) Show the first visit_cost for each patient when visit_cost IS NOT NULL.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	visit_date,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;


-- 13) For each patient, display the first diagnosis where diagnosis IS NOT NULL.
SELECT
    patient_id,
	diagnosis,
	visit_date,
	FIRST_VALUE(diagnosis) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date 
	                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_diag
FROM Visits
WHERE diagnosis IS NOT NULL;


-- 14) For each patient, get the first bp_systolic reading ordered by reading_date.
SELECT
    patient_id,
	bp_systolic,
	reading_date,
	FIRST_VALUE(bp_systolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_bp_systolic
FROM VitalReadings
WHERE bp_systolic IS NOT NULL
;

-- 15) Find the first reading_date for each patient using FIRST_VALUE().
SELECT
    patient_id,
	reading_date,
	FIRST_VALUE(reading_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_reading_date
FROM VitalReadings;

-- 16) For each department, show the first visit_id based on visit_date.
SELECT
    visit_id,
	department,
	visit_date,
	FIRST_VALUE(visit_id) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_id
FROM Visits;

-- 17) For each patient, show the first visit_cost including zero-cost visits.
SELECT
    patient_id,
	visit_cost,
	visit_date,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_cost
FROM Visits;

-- 18) For each doctor, get the first department they worked in based on visit_date.
SELECT
    doctor_id,
	department,
	visit_date,
	FIRST_VALUE(department) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_department
FROM Visits;

-- 19) For each patient, display the first visit_date ignoring NULL visit_date.
SELECT
    patient_id,
	visit_date,
	FIRST_VALUE(visit_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_date
FROM Visits
WHERE visit_date IS NOT NULL;

-- 20) For each patient, show the first visit_status excluding pending visits.
SELECT
    patient_id,
	visit_status,
	visit_date,
	FIRST_VALUE(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
	                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS First_value_visit_status
FROM Visits
WHERE visit_status IS NOT NULL
  AND visit_status <> 'PENDING';


-- 21) For each patient, retrieve the first consultation_fee greater than 300.
SELECT
    patient_id,
	consultation_fee,
	created_date,
	FIRST_VALUE(consultation_fee) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_consultation_fee
FROM Billing
WHERE consultation_fee > 300;


-- 22) Show the first doctor_id for each patient ordered by visit_date descending.
SELECT
    patient_id,
	doctor_id,
	visit_date,
	FIRST_VALUE(doctor_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date DESC
	                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_doc_id
FROM Visits;

-- 23) For each department, get the first visit_cost ordered by visit_cost ascending.
SELECT
    patient_id,
	department,
	visit_cost,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY department ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost ASC
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL
;

-- 24) For each patient, display the first visit_id ordered by visit_date.
SELECT
    patient_id,
	visit_id,
	visit_date,
	FIRST_VALUE(visit_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date 
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_id
FROM visits;

-- 25) Find the first bp_diastolic value for each patient ordered by reading_date.
SELECT
    patient_id,
	reading_date,
	bp_diastolic,
	FIRST_VALUE(bp_diastolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_bp_diastolic
FROM VitalReadings
WHERE bp_diastolic IS NOT NULL;

-- 26) For each patient, show the first non-NULL bp_systolic reading.
SELECT
    patient_id,
	reading_date,
	bp_systolic,
	FIRST_VALUE(bp_systolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS First_value_bp_systolic
FROM VitalReadings
WHERE bp_systolic IS NOT NULL;

-- 27) For each doctor, display the first visit_cost they handled.
SELECT
     doctor_id,
	 visit_cost,
	 visit_date,
	 FIRST_VALUE(visit_cost) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_cost
FROM Visits;

-- 28) For each patient, retrieve the first visit where visit_cost > 1000.
SELECT
     patient_id,
	 visit_cost,
	 visit_date,
	 FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_cost
FROM Visits
WHERE visit_cost > 1000;

-- 29) For each department, show the first visit_date ignoring NULLs.
SELECT
    visit_id,
	department,
	visit_date,
	FIRST_VALUE(visit_date) OVER (PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS First_value_visit_date
FROM Visits
WHERE visit_date IS NOT NULL;

-- 30) For each patient, show the first diagnosis ordered alphabetically.
SELECT
    patient_id,
	visit_date,
	diagnosis,
	FIRST_VALUE(diagnosis) OVER(PARTITION BY patient_id ORDER BY diagnosis ASC  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_diag
FROM visits
WHERE diagnosis IS NOT NULL;


-- 31) For each patient, get the first visit_cost when visit_status = 'Completed'.
SELECT
    patient_id,
	visit_cost,
	visit_status,
	visit_date,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_visit_cost
FROM Visits
WHERE visit_status = 'COMPLETED';

-- 32) Show the first visit_id for each doctor ordered by visit_date.
SELECT
    visit_id,
	doctor_id,
	visit_date,
	FIRST_VALUE(visit_id) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_visit_ID
FROM Visits;

-- 33) For each patient, retrieve the first medicine_cost ordered by created_date.
SELECT
    patient_id,
	medicine_cost,
	created_date,
	FIRST_VALUE(medicine_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
	                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_cost
FROM Billing
WHERE medicine_cost IS NOT NULL;

-- 34) For each department, show the first visit_status based on visit_date.
SELECT
    visit_id,
	department,
	visit_date,
	visit_status,
	FIRST_VALUE(visit_status) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_status
FROM Visits;

-- 35) For each patient, display the first visit_date using FIRST_VALUE() with ROWS frame.
SELECT
    patient_id,
    department,
    visit_date,
    FIRST_VALUE(visit_date) OVER (
        PARTITION BY patient_id
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS First_visit_date
FROM Visits;


-- 36) For each patient, show the first visit_cost using FIRST_VALUE() with RANGE frame.
SELECT
    patient_id,
	visit_cost,
	visit_date,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_cost
FROM Visits;

-- 37) For each patient, retrieve the first doctor_id ignoring NULL doctor_id.
SELECT
    patient_id,
	doctor_id,
	visit_date,
	FIRST_VALUE(doctor_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_doc_id
FROM Visits
WHERE doctor_id IS NOT NULL;


-- 38) For each doctor, get the first patient_id ordered by visit_id.
SELECT
    doctor_id,
	visit_id,
	patient_id,
	FIRST_VALUE(patient_id) OVER(PARTITION BY doctor_id ORDER BY visit_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_id
FROM Visits;

-- 39) For each patient, show the first visit_date ordered descending.
SELECT
    patient_id,
	visit_date,
	FIRST_VALUE(visit_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date DESC
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_date
FROM Visits;

-- 40) For each department, find the first visit_cost greater than 500.
SELECT
    patient_id,
	department,
	visit_cost,
	visit_date,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date DESC
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_cost
FROM Visits
 WHERE visit_cost > 500;


-- 41) For each patient, display the first bp_systolic where reading_date IS NOT NULL.
SELECT
    patient_id,
	bp_systolic,
	reading_date,
	FIRST_VALUE(bp_systolic)  OVER(PARTITION BY patient_id ORDER BY reading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_bp
FROM VitalReadings
WHERE reading_date IS NOT NULL;

-- 42) For each patient, get the first reading_date including NULL handling.
SELECT
    patient_id,
	reading_date,
	FIRST_VALUE(reading_date)  OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_reading_date
FROM VitalReadings;


-- 43) For each patient, retrieve the first visit_status ordered by visit_date.
SELECT
	patient_id,
	visit_date,
	visit_status,
	FIRST_VALUE(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_status
FROM Visits;

-- 44) For each doctor, show the first visit_date using FIRST_VALUE().
SELECT
	patient_id,
	visit_date,
	doctor_id,
	FIRST_VALUE(visit_date) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_date
FROM Visits;

-- 45) For each patient, display the first visit_id where visit_cost IS NOT NULL.
SELECT
    patient_id,
	visit_id,
	visit_cost,
	visit_date,
	FIRST_VALUE(visit_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_id
FROM visits
WHERE visit_cost IS NOT NULL;

-- 46) For each department, retrieve the first doctor_id based on visit_date.
SELECT
    doctor_id,
	visit_date,
	department,
	FIRST_VALUE(doctor_id) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_doctor_id
FROM Visits;

-- 47) For each patient, show the first diagnosis ordered by visit_date.
SELECT
    patient_id,
	diagnosis,
	visit_date,
	FIRST_VALUE(diagnosis) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_diag
FROM Visits;

-- 48) For each patient, get the first visit_cost ignoring NULL visit_cost.
SELECT
    patient_id,
    visit_cost,
    visit_date,
    FIRST_VALUE(visit_cost) OVER(
        PARTITION BY patient_id
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS First_value_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;



-- 49) For each patient, display the first visit_date across all visits.
SELECT
    patient_id,
	visit_date,
	FIRST_VALUE(visit_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_date
FROM visits;

-- 50) For each department, show the first visit_id using FIRST_VALUE().
SELECT
    visit_id,
	visit_date,
	department,
	FIRST_VALUE(visit_id) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS First_value_visit_id
FROM Visits;
