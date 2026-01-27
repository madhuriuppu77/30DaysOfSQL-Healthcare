-- 1) Use LAG() to get the previous visit date for each patient.
SELECT
    patient_id,
	visit_date,
	LAG(visit_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS previous_visit_date
FROM visits;

-- 2) For each patient, find the previous blood pressure reading using LAG().
SELECT
    reading_id,
	patient_id,
	bp_diastolic,
	bp_systolic,
	reading_date,
	LAG(bp_systolic) OVER (PARTITION BY patient_id ORDER BY reading_date) AS Previous_systolic,
    LAG(bp_diastolic) OVER (PARTITION BY patient_id ORDER BY reading_date) AS Previous_diastolic
FROM VitalReadings;

-- 3) Calculate the previous visit cost for each patient.
SELECT
    patient_id,
	visit_id,
	visit_cost,
	visit_date,
	LAG(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date ) AS Previous_visit_cost
FROM Visits;

-- 4) Find the previous diagnosis for each patient in Visits table.
SELECT
    patient_id,
	visit_id,
	diagnosis,
	visit_date,
	LAG(diagnosis) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date ) AS Previous_diagnosis
FROM Visits;

-- 5) Use LAG() to show previous doctor_id for each patient visit.
SELECT
    doctor_id,
	visit_id,
	patient_id,
	visit_date,
	LAG(doctor_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_doc_id
FROM Visits;

-- 6) Display the previous consultation_fee for each patient from Billing.
SELECT
    patient_id,
	consultation_fee,
	created_date,
	LAG(consultation_fee) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Previous_consultation_fee
FROM Billing;

-- 7) For each doctor, find the previous patient's visit cost.
SELECT
    doctor_id,
    visit_id,
    visit_cost,
    visit_date,
    LAG(visit_cost) OVER (
        PARTITION BY doctor_id
        ORDER BY 
            CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,
            visit_date
    ) AS previous_visit_cost
FROM Visits;

-- 8) Find previous medication_name prescribed for each visit.
SELECT 
    v.visit_id,
    v.patient_id,
    p.medication_name,
    v.visit_date,
    LAG(p.medication_name) OVER (
        PARTITION BY v.patient_id
        ORDER BY 
            CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,
            v.visit_date
    ) AS previous_medication_name
FROM Prescriptions p
LEFT JOIN Visits v
    ON p.visit_id = v.visit_id;

-- 9) Calculate previous medicine_cost for each patient visit.
SELECT
    patient_id,
	medicine_cost,
	created_date,
	LAG(medicine_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Previous_medicine_cost
FROM Billing;

-- 10) Show previous discount applied for each billing record.
SELECT
    patient_id,
	discount,
	created_date,
	LAG(discount) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Previous_discount
FROM Billing;

-- 11) For each patient, show previous systolic BP reading.
SELECT
    patient_id,
	reading_date,
	bp_systolic,
	LAG(bp_systolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Previous_bp_systolic
FROM VitalReadings;

-- 12) Find previous diastolic BP reading for each patient.
SELECT
    patient_id,
	reading_date,
	bp_diastolic,
	LAG(bp_diastolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Previous_bp_diastolic
FROM VitalReadings;

-- 13) Display previous visit_status for each patient.
SELECT
    visit_id,
	patient_id,
	visit_status,
	visit_date,
	LAG(visit_status) OVER(PARTITION BY patient_id ORDER  BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_status
FROM Visits;

-- 14) Show previous visit_cost for each doctor.
SELECT
    visit_id,
	doctor_id,
	visit_cost,
	visit_date,
	LAG(visit_cost) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_visit_cost
FROM Visits;

-- 15) Find previous department visited for each patient.
SELECT
    visit_id,
    patient_id,
    department,
    visit_date,
    LAG(department) OVER (
        PARTITION BY patient_id
        ORDER BY 
            CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,
            visit_date
    ) AS previous_department
FROM Visits;

-- 16) Show previous age of patient (if changed in dataset updates).
SELECT 
    p.patient_id,
	p.age,
	v.visit_date,
	LAG(p.age) OVER(PARTITION BY p.patient_id ORDER BY  CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date) AS Previous_age
FROM Patients p
LEFT JOIN visits v
ON p.patient_id= v.patient_id;
    
-- 17) Find previous event_date for each event in DateTimePractice
SELECT
    record_id,
    event_name,
    event_date,
    LAG(event_date) OVER (
        ORDER BY 
            CASE WHEN event_date IS NULL THEN 1 ELSE 0 END,
            event_date
    ) AS previous_event_date
FROM DateTimePractice;

-- 18) Display previous event_time for each event.
SELECT
    record_id,
    event_name,
    event_date,
    event_time,
    LAG(event_time) OVER (
        ORDER BY 
            CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END,
            event_datetime
    ) AS previous_event_time
FROM DateTimePractice;

-- 19) Find previous event_datetime for each record.
SELECT
    record_id,
    event_name,
    event_date,
    event_time,
    event_datetime,
    LAG(event_datetime) OVER (
        ORDER BY 
            CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END,
            event_datetime
    ) AS previous_event_datetime
FROM DateTimePractice;

-- 20) For each patient, show previous NULL handling scenario using LAG().
SELECT * FROM 
(
SELECT
    patient_id,
	visit_date,
	LAG(visit_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_date
FROM Visits)t
WHERE visit_date IS NOT NULL AND Previous_date IS NULL;


-- 21) Use LAG() with default value to handle first row as 0 for visit_cost.
SELECT
    patient_id,
	visit_date,
	visit_cost,
	LAG(visit_cost,1,0) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_visit_cost
FROM Visits;

-- 22) Compare previous visit_cost with current visit_cost for increase/decrease.
SELECT
    patient_id,
	visit_date,
	Current_visit_cost,
	Previous_visit_cost,
	CASE
	    WHEN Previous_visit_cost IS NULL THEN 'No previous value'
	    WHEN Previous_visit_cost > Current_visit_cost THEN 'Increase'
		WHEN Previous_visit_cost < Current_visit_cost THEN 'decrease'
		ELSE 'No change'
	END AS status_visit
FROM
(
SELECT
    patient_id,
	visit_date,
	visit_cost AS Current_visit_cost,
	LAG(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_visit_cost
FROM Visits)t;

-- 23) Find gap in days between current and previous visit_date using LAG().

SELECT
    patient_id,
    visit_date AS Current_visit_date,
    LAG(visit_date) OVER(
        PARTITION BY patient_id
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
    ) AS Previous_visit_date,
    DATEDIFF(
        DAY,
        LAG(visit_date) OVER(
            PARTITION BY patient_id
            ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ),
        visit_date
    ) AS gap_days
FROM Visits;

-- 24) For each doctor, find previous visit with same department.
SELECT * FROM
(
SELECT
    doctor_id,
	visit_date,
	department,
	LAG(department) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_department
FROM Visits)t
WHERE department = Previous_department;

-- 25) Display previous visit_id for each patient.
SELECT
    patient_id,
	visit_id,
	visit_date,
	LAG(visit_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_visit_id
FROM Visits;

-- 26) Show previous reading_date for each patient in VitalReadings.
SELECT
    patient_id,
	reading_date,
	LAG(reading_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Previous_reading_date
FROM VitalReadings;

-- 27) Find previous reading_id using LAG() for each patient.
SELECT
    patient_id,
	reading_id,
	reading_date,
	LAG(reading_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Previous_reading_id
FROM VitalReadings;

-- 28) Display previous visit_cost for visits ordered by visit_date.
SELECT
    patient_id,
	visit_cost,
	visit_date,
	LAG(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_visit_cost
FROM Visits;

-- 29) Use LAG() to find previous discount for each patient ordered by created_date.
SELECT
    patient_id,
	created_date,
	discount,
	LAG(discount) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Previous_discount
FROM Billing;

-- 30) For each patient, show previous billing total (consultation_fee + medicine_cost - discount).
SELECT
    patient_id,
	created_date,
	Total_billing,
	LAG(Total_billing) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Previous_billing_total
FROM
(
SELECT
    patient_id,
	created_date,
	COALESCE(consultation_fee,0)+COALESCE(medicine_cost,0)-COALESCE(discount,0) AS Total_billing
FROM Billing)t;



-- 31) Find previous patient_id for each doctor’s visit.
SELECT
    doctor_id,
    visit_date,
    patient_id,
    LAG(patient_id) OVER(
        PARTITION BY doctor_id
        ORDER BY 
            CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,
            visit_date
    ) AS Previous_patient_id
FROM Visits;

-- 32) Compare previous and current visit_status for each patient.
SELECT
    patient_id,
	visit_date,
	visit_status AS Current_visit_status,
	LAG(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_visit_status
FROM Visits;

-- 33) Show previous doctor_id for each patient ordered by visit_date.
SELECT
    doctor_id,
    visit_date,
    patient_id,
    LAG(doctor_id) OVER(
        PARTITION BY  patient_id
        ORDER BY 
            CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,
            visit_date
    ) AS Previous_DOC_id
FROM Visits;

-- 34) For each patient, display previous medication dosage.
SELECT 
    v.patient_id,
	v.visit_date,
	p.dosage,
	LAG(p.dosage) OVER(PARTITION BY v.patient_id 
	                     ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,
            v.visit_date) AS Previous_dosage
FROM Prescriptions p
LEFT JOIN Visits v
ON p.visit_id = v.visit_id;

-- 35) Find previous consultation_fee for each patient in descending order of created_date.
SELECT
    patient_id,
	consultation_fee,
	created_date,
	LAG(consultation_fee) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date DESC) AS Previous_fee
FROM Billing;


-- 36) Use LAG() to identify previous abnormal BP reading for each patient.
SELECT
    patient_id,
    reading_date,
    bp_systolic,
    bp_diastolic,

    LAG(
        CASE 
            WHEN bp_systolic >= 140 OR bp_diastolic >= 90 
            THEN 'ABNORMAL' 
        END
    ) OVER (
        PARTITION BY patient_id 
        ORDER BY 
            CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,
            reading_date
    ) AS Previous_abnormal_bp_status

FROM VitalReadings;

-- 37) Show previous visit diagnosis for each patient in Visits table.
SELECT
    visit_id,
	patient_id,
	visit_date,
	diagnosis,
	LAG(diagnosis) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_diag
FROM Visits;

-- 38) Calculate previous visit cost difference for each patient.

SELECT
    patient_id,
    visit_date,
    visit_cost AS current_visit_cost,
    LAG(visit_cost) OVER (
        PARTITION BY patient_id
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
    ) AS previous_visit_cost,
    visit_cost 
    - LAG(visit_cost) OVER (
        PARTITION BY patient_id
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
    ) AS visit_cost_diff
FROM Visits;

-- 39) Display previous tax_percent for each billing record.
SELECT
    patient_id,
    tax_percent AS current_tax_percent,
    created_date,
    LAG(tax_percent) OVER (
        PARTITION BY patient_id
        ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date
    ) AS previous_tax_percent
FROM Billing;


-- 40) For each patient, display previous visit department to detect department change.
SELECT *
FROM (
    SELECT
        patient_id,
        visit_date,
        department,
        LAG(department) OVER (
            PARTITION BY patient_id
            ORDER BY 
                CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,
                visit_date
        ) AS previous_department
    FROM Visits
) t
WHERE department <> previous_department;

-- 41) Use LAG() with PARTITION BY city to show previous patient visit cost.
SELECT 
    p.patient_id,
    p.city,
    v.visit_cost,
    v.visit_date,
    LAG(v.visit_cost) OVER (
        PARTITION BY p.city
        ORDER BY 
            CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,
            v.visit_date
    ) AS previous_city_visit_cost
FROM Patients p
LEFT JOIN Visits v
ON p.patient_id = v.patient_id;


-- 42) For each department, display previous doctor_id using LAG().
SELECT
    visit_id,
    department,
    doctor_id,
    visit_date,
    LAG(doctor_id) OVER (
        PARTITION BY department
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
    ) AS previous_doctor_id
FROM Visits
WHERE department IS NOT NULL;
           
-- 43) Find previous visit_cost for each patient only when visit_status = 'COMPLETED'.
SELECT *
FROM (
    SELECT
        patient_id,
        visit_date,
        visit_cost,
        visit_status,
        LAG(
            CASE WHEN visit_status = 'COMPLETED' THEN visit_cost END
        ) OVER (
            PARTITION BY patient_id
            ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ) AS previous_completed_visit_cost
    FROM Visits
) t
WHERE visit_status = 'COMPLETED';

-- 44) Display previous medicine_cost for each patient using LAG().
SELECT
    patient_id,
	created_date,
	medicine_cost,
	LAG(medicine_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Previous_medicine_cost
FROM Billing;

-- 45) For each patient, find previous visit and calculate cost increase %.
SELECT
    patient_id,
    visit_date,
    visit_cost AS current_visit_cost,
    LAG(visit_cost) OVER(
        PARTITION BY patient_id
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
    ) AS previous_visit_cost,
    CASE 
        WHEN LAG(visit_cost) OVER(
            PARTITION BY patient_id
            ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ) IS NULL THEN NULL
        ELSE ROUND(
            (visit_cost - LAG(visit_cost) OVER(
                PARTITION BY patient_id
                ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
            )) * 100.0
            / LAG(visit_cost) OVER(
                PARTITION BY patient_id
                ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
            ), 2)
    END AS percent_increase
FROM Visits;


-- 46) Show previous systolic BP reading and check if it decreased.
SELECT
    patient_id,
    reading_date,
    Current_bp_systolic,
    Previous_Bp_systolic,
    CASE
        WHEN Previous_Bp_systolic IS NULL THEN 'No previous reading'
        WHEN Current_bp_systolic < Previous_Bp_systolic THEN 'Decreased'
        WHEN Current_bp_systolic > Previous_Bp_systolic THEN 'Increased'
        ELSE 'No change'
    END AS bp_status
FROM
(
    SELECT
        patient_id,
        reading_date,
        bp_systolic AS Current_bp_systolic,
        LAG(bp_systolic) OVER(
            PARTITION BY patient_id 
            ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date
        ) AS Previous_Bp_systolic
    FROM VitalReadings
) t;

-- 47) Use LAG() to find previous event_date for each event_name in DateTimePractice.
SELECT
    event_name,
    event_date,
    LAG(event_date) OVER(
        PARTITION BY event_name
        ORDER BY CASE WHEN event_date IS NULL THEN 1 ELSE 0 END, event_date
    ) AS previous_event_date
FROM DateTimePractice;

-- 48) Display previous visit_cost for each doctor ordered by visit_date DESC.
SELECT
    doctor_id,
	visit_cost,
	visit_date,
	LAG(visit_cost) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date DESC) AS Previous_visit_cost
FROM Visits;

-- 49) For each patient, show previous visit and mark if it was NULL in diagnosis.
SELECT * FROM
(
SELECT
    patient_id,
	visit_date,
	diagnosis,
	LAG(diagnosis) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Previous_diag
FROM Visits)t
WHERE diagnosis IS NOT NULL AND Previous_diag IS NULL;

-- 50) Compare previous and current prescription dosage for each patient.
SELECT 
    v.patient_id,
    p.dosage AS Current_dosage,
	v.visit_date,
	LAG(p.dosage) OVER(PARTITION BY v.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date) AS Previous_dosage
FROM Prescriptions p
LEFT JOIN visits v
ON p.visit_id = v.visit_id;
