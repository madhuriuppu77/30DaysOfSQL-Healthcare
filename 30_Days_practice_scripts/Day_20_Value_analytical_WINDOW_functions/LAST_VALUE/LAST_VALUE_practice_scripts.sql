-- 1) Use LAST_VALUE() to get the last BP systolic reading for each patient ordered by reading_date.
SELECT
    patient_id,
	bp_systolic,
	reading_date,
	LAST_VALUE(bp_systolic) OVER(
	PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_bp_systolic
FROM VitalReadings;

-- 2) Find the last visit cost for each patient using LAST_VALUE() ordered by visit_date.
SELECT
    visit_id,
	visit_cost,
	patient_id,
	visit_date,
	LAST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_visit_cost
FROM Visits;

-- 3) Get the last medication_name prescribed to each patient using LAST_VALUE().
SELECT 
    v.patient_id,
	p.medication_name,
	v.visit_date,
	LAST_VALUE(p.medication_name) OVER(PARTITION BY v.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                                     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_medication_name
FROM Visits v
LEFT JOIN prescriptions p 
ON v.visit_id = p.visit_id;

-- 4) For each doctor, find the last consultation fee collected using LAST_VALUE() ordered by created_date.
SELECT
    doctor_id,
	consultation_fee,
	created_date,
	LAST_VALUE(consultation_fee) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
	                                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS Last_value_fee
FROM Billing;

-- 5) For each patient, find the last visit_status using LAST_VALUE() ordered by visit_date.
SELECT
    patient_id,
	visit_status,
	visit_date,
	LAST_VALUE(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LAST_VALUE_VISIT_STATUS
FROM Visits;

-- 6) For each patient, show the last bp_diastolic value along with current reading.
SELECT
    patient_id,
	bp_diastolic,
	reading_date,
	LAST_VALUE(bp_diastolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_bp_distolic
FROM VitalReadings;

-- 7) Find the last doctor_id seen by each patient using LAST_VALUE() ordered by visit_date.
SELECT
    patient_id,
	doctor_id,
	visit_date,
	LAST_VALUE(doctor_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date 
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_doc_id
FROM Visits;

-- 8) Find the last prescription dosage for each patient using LAST_VALUE().
SELECT 
    v.patient_id,
	v.visit_date,
	p.dosage,
	LAST_VALUE(p.dosage) OVER(PARTITION BY v.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LAST_VALUE_dosage
FROM Prescriptions p
LEFT JOIN Visits v
ON p.visit_id = v.visit_id;

-- 9) For each patient, get the last city they visited a doctor in using LAST_VALUE() ordered by visit_date.
SELECT 
    p.patient_id,
	v.doctor_id,
	v.visit_date,
	p.city,
	LAST_VALUE(p.city) OVER(PARTITION BY p.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_city
FROM patients p
LEFT JOIN Visits v
ON p.patient_id = v.patient_id;

-- 10) For each doctor, get the last patient_id they saw using LAST_VALUE() ordered by visit_date.
SELECT 
    d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	v.visit_date,
	v.patient_id,
	LAST_VALUE(v.patient_id) OVER(PARTITION BY d.doctor_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END, v.visit_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_patient_id
FROM Doctors d
LEFT JOIN Visits v
ON d.doctor_id = v.doctor_id;


-- 11) Get the last reading_date for each patient using LAST_VALUE().
SELECT
    patient_id,
	reading_date,
	LAST_VALUE(reading_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS Last_value_reading_date
FROM VitalReadings;

-- 12) Show the last visit_cost for each department using LAST_VALUE() ordered by visit_date.
SELECT
	department,
	visit_cost,
	visit_date,
	LAST_VALUE(visit_cost) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS Last_value_visit_cost
FROM Visits;

-- 13) Find the last discount applied to each patient in Billing using LAST_VALUE().
SELECT
    patient_id,
	discount,
	created_date,
	LAST_VALUE(discount) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
	                              ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_discount
FROM Billing;

-- 14) For each patient, get the last diagnosis using LAST_VALUE() ordered by visit_date.
SELECT
    patient_id,
	diagnosis,
	visit_date,
	LAST_VALUE(diagnosis) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_diagnosis
FROM Visits;

-- 15) For each patient, get the last visit_id using LAST_VALUE() ordered by visit_date.
SELECT
    patient_id,
	visit_id,
	visit_date,
	LAST_VALUE(visit_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date 
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_value_visit_id
FROM Visits;

-- 16) For each doctor, show the last medicine_cost collected using LAST_VALUE().
SELECT
    doctor_id,
	medicine_cost,
	created_date,
	LAST_VALUE(medicine_cost) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_medicine_cost
FROM Billing;

-- 17) Get the last event_datetime from DateTimePractice using LAST_VALUE().

SELECT
    event_name,
	event_date,
	event_datetime,
	LAST_VALUE(event_datetime) OVER(ORDER BY CASE WHEN event_date IS NULL THEN 1 ELSE 0 END,event_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_event_date
FROM DateTimePractice;

-- 18) Find the last reading of bp_systolic and bp_diastolic for each patient using LAST_VALUE().
SELECT
    patient_id,
	reading_date,
	bp_systolic,
	bp_diastolic,
	LAST_VALUE(bp_systolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_bp_systolic,
    LAST_VALUE(bp_diastolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_bp_diastolic
FROM VitalReadings;

-- 19) For each patient, find the last doctor_id who prescribed medication using LAST_VALUE().
SELECT 
    v.patient_id,
	v.doctor_id,
	v.visit_date,
	p.medication_name,
	LAST_VALUE(v.doctor_id) OVER(PARTITION BY v.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_doc_id
FROM Prescriptions p
LEFT JOIN Visits v
ON p.visit_id= v.visit_id;


-- 20) Find the last patient_id visited in each department using LAST_VALUE() ordered by visit_date.
SELECT
    patient_id,
	department,
	visit_date,
	LAST_VALUE(patient_id) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_patient_id
FROM Visits;

-- 21) Show the last dosage prescribed for each medication_name using LAST_VALUE().
SELECT 
    p.prescription_id,
	p.dosage,
	p.medication_name,
	v.visit_date,
	LAST_VALUE(p.dosage) OVER(PARTITION BY p.medication_name ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LAST_value_dosage
FROM Prescriptions p
LEFT JOIN visits v
ON p.visit_id = v.visit_id;

-- 22) For each patient, get the last consultation_fee in Billing using LAST_VALUE().
SELECT
    patient_id,
	consultation_fee,
	created_date,
	LAST_VALUE(consultation_fee) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
	                                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_fee
FROM Billing;

-- 23) For each patient, find the last visit_status change using LAST_VALUE().
SELECT
    patient_id,
	visit_status,
	visit_date,
	LAST_VALUE(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_visit_status
FROM Visits;

-- 24) Find the last visit_cost for patients above age 50 using LAST_VALUE().
SELECT 
    p.patient_id,
	p.age,
	v.visit_cost,
	v.visit_date,
	LAST_VALUE(v.visit_cost) OVER(PARTITION BY  p.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_visit_cost
FROM Patients p
LEFT JOIN visits v
ON p.patient_id = v.patient_id
WHERE p.age > 50;
 
-- 25) For each doctor, find the last diagnosis they made using LAST_VALUE() ordered by visit_date.
SELECT
    doctor_id,
	diagnosis,
	visit_date,
	LAST_VALUE(diagnosis) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_diag
FROM Visits;

-- 26) Get the last reading_date where bp_systolic > 140 for each patient using LAST_VALUE().
SELECT
    patient_id,
	bp_systolic,
	reading_date,
	LAST_VALUE(reading_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_reading_date
FROM VitalReadings
WHERE bp_systolic  > 140;

-- 27) For each patient, show the last medicine prescribed where dosage is not NULL using LAST_VALUE().
SELECT 
    v.patient_id,
	p.medication_name,
	p.dosage,
	v.visit_date,
	LAST_VALUE(p.medication_name) OVER(PARTITION BY v.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_medication_prescribed
FROM Prescriptions p
LEFT JOIN visits v
ON p.visit_id = v.visit_id
WHERE p.dosage IS NOT  NULL;

-- 28) Find the last created_date in Billing for each doctor using LAST_VALUE().
SELECT
    doctor_id,
	created_date,
	LAST_VALUE(created_date) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LAST_Value_created_date
FROM Billing;

-- 29) Show the last visit_id for patients in Hyderabad using LAST_VALUE().
SELECT 
    p.patient_id,
	v.visit_id,
	p.city,
	v.visit_date,
	LAST_VALUE(v.visit_id) OVER(PARTITION BY p.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_visit_id
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
WHERE p.city ='Hyderabad';

-- 30) Get the last visit_cost for completed visits using LAST_VALUE().
SELECT
    visit_id,
	patient_id,
	visit_cost,
	visit_date,
	visit_status,
	LAST_VALUE(visit_cost) OVER( PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_visit_cost
FROM visits
WHERE visit_status = 'COMPLETED';

-- 31) For each department, find the last patient seen using LAST_VALUE().
SELECT
    patient_id,
	department,
	visit_date,
	LAST_VALUE(patient_id) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
	                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_id
FROM Visits;

-- 32) Get the last visit_status for each patient where diagnosis IS NULL using LAST_VALUE().
SELECT
    visit_id,
	patient_id,
	diagnosis,
	visit_status,
	visit_date,
	LAST_VALUE(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_status
FROM Visits
WHERE diagnosis IS NULL;

-- 33) For each patient, get the last consultation_fee after discount using LAST_VALUE().
SELECT
    patient_id,
    consultation_fee,
    discount,
    created_date,
    LAST_VALUE(consultation_fee - COALESCE(discount, 0)) OVER (
        PARTITION BY patient_id
        ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_net_consultation_fee
FROM Billing;


-- 34) Find the last medicine_name prescribed for each patient using LAST_VALUE().
SELECT 
    v.patient_id,
	v.visit_date,
	p.medication_name,
	LAST_VALUE(p.medication_name) OVER(PARTITION BY v.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_medicine_name
FROM Prescriptions p
LEFT JOIN Visits v
ON p.visit_id = v.visit_id;

-- 35) For each patient, show the last bp_diastolic reading where bp_diastolic > 90 using LAST_VALUE().
SELECT
    patient_id,
    bp_diastolic,
    reading_date,
    LAST_VALUE(
        CASE WHEN bp_diastolic > 90 THEN bp_diastolic END
    ) OVER (
        PARTITION BY patient_id
        ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_bp_diastolic_gt_90
FROM VitalReadings;


-- 36) For each patient, get the last visit_cost where visit_status = 'COMPLETED' using LAST_VALUE().
SELECT
    patient_id,
	visit_cost,
	visit_status,
	visit_date,
	LAST_VALUE(CASE WHEN visit_status = 'COMPLETED' THEN visit_cost END) 
	                          OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_visit_cost
FROM Visits;



-- 37) Find the last doctor_id seen by each patient in Cardiology using LAST_VALUE().
SELECT
    doctor_id,
	patient_id,
	department,
	visit_date,
	LAST_VALUE(CASE WHEN department = 'Cardiology' THEN doctor_id END) 
	                              OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_doctor_id
FROM Visits


-- 38) Show the last dosage of 'Amlodipine' prescribed to any patient using LAST_VALUE().
SELECT
    v.patient_id,
    v.visit_date,
    p.medication_name,
    p.dosage,
    LAST_VALUE(
        CASE WHEN p.medication_name = 'Amlodipine' THEN p.dosage END
    ) OVER (
        ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END, v.visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_amlodipine_dosage
FROM Prescriptions p
JOIN Visits v
    ON p.visit_id = v.visit_id;



-- 39) For each patient, show the last reading_date in VitalReadings using LAST_VALUE().
SELECT
    patient_id,
	reading_date,
	LAST_VALUE(reading_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                              ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_reading_date
FROM VitalReadings;

-- 40) Get the last visit_cost for each patient where city IS NOT NULL using LAST_VALUE().
SELECT 
    p.patient_id,
	p.city,
	v.visit_date,
	v.visit_cost,
	LAST_VALUE(CASE WHEN p.city IS NOT NULL THEN v.visit_cost END) 
	                        OVER(PARTITION BY p.patient_id ORDER BY CASE WHEN v.visit_date IS NULL THEN 1 ELSE 0 END,v.visit_date
	                             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED  FOLLOWING) AS Last_visit_cost
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id


-- 41) For each doctor, show the last patient_id and visit_date using LAST_VALUE().
SELECT
    patient_id,
	doctor_id,
	visit_id,
	visit_cost,
	visit_date,
	LAST_VALUE( patient_id) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS Last_value_patient_id,
    LAST_VALUE(visit_date) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS Last_value_visit_date
FROM visits;
-- 42) Find the last consultation_fee in Billing for each patient ordered by created_date using LAST_VALUE().
SELECT
    patient_id,
	consultation_fee,
	created_date,
	LAST_VALUE(consultation_fee) OVER(PARTITION BY patient_id 
	                   ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
					   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS LAST_value_consultation_fee
FROM Billing;
-- 43) For each patient, show the last medicine_cost greater than 500 using LAST_VALUE().
SELECT
    patient_id,
	medicine_cost,
	created_date,
	LAST_VALUE(CASE WHEN medicine_cost > 500 THEN medicine_cost END) OVER(PARTITION BY patient_id 
	                   ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date
					   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS LAST_value_medicine_cost
FROM Billing;

-- 44) For each patient, get the last doctor_id who handled their visit using LAST_VALUE().
SELECT
    patient_id,
	doctor_id,
	visit_date,
	LAST_VALUE(doctor_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_doc_id
FROM Visits;

-- 45) Find the last visit_id and visit_cost for each department using LAST_VALUE().
SELECT
    visit_id,
	visit_date,
	department,
	visit_cost,
	LAST_VALUE(visit_cost) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_visit_cost,
	LAST_VALUE(visit_id) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_visit_id
FROM visits;

-- 46) For each patient, get the last diagnosis where diagnosis IS NOT NULL using LAST_VALUE().
SELECT
    patient_id,
	diagnosis,
	visit_date,
	LAST_VALUE(CASE WHEN diagnosis IS NOT NULL THEN diagnosis END) 
	OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_diagnosis
FROM Visits;


-- 47) Show the last visit_cost for each patient ordered by visit_date using LAST_VALUE().
SELECT
    patient_id,
	visit_cost,
	visit_date,
	LAST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_cost
FROM Visits;


-- 48) For each patient, show the last visit_status using LAST_VALUE() including pending visits.
SELECT
    patient_id,
	visit_status,
	visit_date,
	LAST_VALUE(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_status
FROM Visits;

-- 49) Get the last reading_date and last bp_systolic for each patient using LAST_VALUE().
SELECT
    patient_id,
	reading_date,
	bp_systolic,
	LAST_VALUE(reading_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_reading_date,
	LAST_VALUE(bp_systolic) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date
	                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value_bp_systolic
FROM VitalReadings;


-- 50) For each patient, show the last visit_cost and last visit_id in Visits using LAST_VALUE().
SELECT
    patient_id,
	visit_id,
	visit_cost,
	visit_date,
	LAST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS Last_value_visit_cost,
    LAST_VALUE(visit_id) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS Last_value_visit_id
FROM visits;
