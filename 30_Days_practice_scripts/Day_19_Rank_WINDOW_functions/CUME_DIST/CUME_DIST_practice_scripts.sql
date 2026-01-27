-- 1) Calculate the cumulative distribution of patients based on age.
SELECT
    patient_id,
	age,
	CUME_DIST() OVER( ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,age) AS Cume_dist_rank
FROM Patients;

-- 2) Find the CUME_DIST() of visit_cost in the Visits table ordered by visit_cost ascending.
SELECT
    visit_id,
	visit_cost,
	CUME_DIST() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost ASC) AS cume_dist_rank
FROM Visits;

-- 3) Compute cumulative distribution of bp_systolic readings per patient in VitalReadings.
SELECT
    reading_id,
	patient_id,
	bp_systolic,
	CUME_DIST() OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_systolic IS NULL THEN 1 ELSE 0 END, bp_systolic) AS Cume_dist_rank
FROM VitalReadings;

-- 4) Get cumulative distribution of prescription dosages (ignore NULLs) in Prescriptions.
SELECT
    prescription_id,
    dosage,
    CUME_DIST() OVER (
        ORDER BY CAST(REPLACE(dosage, 'mg', '') AS INT)
    ) AS cume_dist_rank
FROM Prescriptions
WHERE dosage IS NOT NULL;


-- 5) Rank doctors by visit_cost using CUME_DIST() over all visits.
SELECT
    doctor_id,
    AVG(visit_cost) AS avg_visit_cost,
    CUME_DIST() OVER (
        ORDER BY AVG(visit_cost)
    ) AS cume_dist_rank
FROM Visits
GROUP BY doctor_id;


-- 6) Find the cumulative distribution of consultation_fee in Billing.
SELECT
    bill_id,
	consultation_fee,
	CUME_DIST() OVER(ORDER BY CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END,consultation_fee) AS Cume_dist_rank
FROM Billing;


-- 7) Calculate CUME_DIST() of medicine_cost grouped by doctor_id.
SELECT
    doctor_id,
	Total_cost,
	CUME_DIST() OVER(ORDER BY Total_cost) AS Cume_dist_rank
FROM
(
SELECT
    doctor_id,
	SUM(COALESCE(medicine_cost,0)) AS Total_cost
FROM Billing
GROUP BY doctor_id)t;

-- 8) Find cumulative distribution of patients’ ages partitioned by gender.
SELECT
    patient_id,
	age,
	gender,
	CUME_DIST() OVER(PARTITION BY gender ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age) AS Cume_dist_rank
FROM Patients
WHERE gender IS NOT NULL;


-- 9) Compute CUME_DIST() for visits based on visit_date ascending.
SELECT
    visit_id,
	visit_date,
	CUME_DIST() OVER(ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date ASC) AS Cume_dist
FROM Visits;

-- 10) Find CUME_DIST() of bp_diastolic readings ordered descending.
SELECT
    reading_id,
	bp_diastolic,
	CUME_DIST() OVER(ORDER BY CASE WHEN bp_diastolic IS NULL THEN 1 ELSE 0 END,bp_diastolic DESC) AS Cume_dist_rank
FROM VitalReadings;

-- 11) Calculate cumulative distribution of total billing (consultation_fee + medicine_cost) per patient.
SELECT
    patient_id,
	Total_billing,
	CUME_DIST() OVER(ORDER BY Total_billing) AS Cume_dist
FROM
(
SELECT
    patient_id,
	SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_billing
FROM Billing
GROUP BY patient_id)t;

-- 12) Compute cumulative distribution of visit_cost partitioned by department.
SELECT
    visit_id,
	visit_cost,
	department,
	CUME_DIST() OVER(PARTITION BY department ORDER BY CASE WHEN visit_cost IS  NULL THEN 1 ELSE 0 END,visit_cost) AS Cume_dist_rank
FROM Visits
WHERE department IS NOT NULL;

-- 13) Find the cumulative distribution of patients’ phone numbers length (number of digits).
SELECT
    patient_id,
	LEN(phone) AS Length_of_phone,
	CUME_DIST() OVER(ORDER BY LEN(phone) ) AS Cume_dist
FROM Patients
WHERE phone IS NOT NULL;

-- 14) Compute CUME_DIST() of visits grouped by visit_status.
SELECT
    visit_status,
    visit_count,
    CUME_DIST() OVER (ORDER BY visit_count) AS cume_dist
FROM (
    SELECT
        visit_status,
        COUNT(*) AS visit_count
    FROM Visits
    WHERE visit_status IS NOT NULL
    GROUP BY visit_status
) t;

-- 15) Find cumulative distribution of number of prescriptions per visit.
SELECT
    visit_id,
	Number_of_prescriptions,
	CUME_DIST() OVER(ORDER BY Number_of_prescriptions ) AS Cume_dist
FROM
(
SELECT 
    v.visit_id,
    COUNT(p.prescription_id) AS Number_of_prescriptions
FROM Prescriptions p
LEFT JOIN visits v
ON p.visit_id = v.visit_id
GROUP BY v.visit_id)t;

-- 16) Calculate cumulative distribution of patients’ ages ignoring NULL values.
SELECT
    patient_id,
	age,
	CUME_DIST() OVER(ORDER BY age) AS Cume_dist_rank
FROM Patients
WHERE age IS NOT NULL;

-- 17) Find CUME_DIST() of prescription dosages partitioned by medication_name.
SELECT
    prescription_id,
    dosage,
    medication_name,
    CUME_DIST() OVER (
        PARTITION BY medication_name
        ORDER BY
            CASE WHEN dosage IS NULL THEN 1 ELSE 0 END,
            CAST(REPLACE(dosage, 'mg', '') AS INT)
    ) AS cume_dist
FROM Prescriptions
WHERE medication_name IS NOT NULL;

-- 18) Compute cumulative distribution of billing discount values ordered ascending.
SELECT
    bill_id,
	discount,
	CUME_DIST() OVER(ORDER BY CASE WHEN discount IS NULL THEN 1 ELSE 0 END, discount) AS Rank_cume_dist
FROM Billing;

-- 19) Find CUME_DIST() of visit_cost for visits with visit_status = 'COMPLETED'.
SELECT
    visit_id,
	visit_cost,
	visit_status,
	CUME_DIST() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost)  AS Cume_dist_rank
FROM Visits
WHERE visit_status = 'COMPLETED'
;

-- 20) Calculate cumulative distribution of patients’ ages partitioned by city.
SELECT
    patient_id,
	age,
	city,
	CUME_DIST() OVER(PARTITION BY city ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,age) AS Cume_dist_rank
FROM Patients
WHERE city IS NOT NULL;

-- 21) Find CUME_DIST() of doctors based on the number of visits they had.
SELECT
    doctor_id,
	number_of_visits,
	CUME_DIST() OVER(ORDER BY number_of_visits ) AS Cume_dist_rank
FROM
(
SELECT
    doctor_id,
	COUNT(visit_id) AS number_of_visits
FROM Visits
GROUP BY doctor_id)t;


-- 22) Compute cumulative distribution of visit_cost partitioned by doctor_id and department.
SELECT
    visit_id,
	visit_cost,
	doctor_id,
	department,
	CUME_DIST() OVER(PARTITION BY doctor_id,department ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost) AS CUme_rank
FROM Visits
WHERE department IS NOT NULL;


-- 23) Find cumulative distribution of total Vital readings per patient.
SELECT
    patient_id,
    total_readings,
    CUME_DIST() OVER (ORDER BY total_readings) AS cume_dist_rank
FROM (
    SELECT
        patient_id,
        COUNT(*) AS total_readings
    FROM VitalReadings
    GROUP BY patient_id
) t;


-- 24) Calculate CUME_DIST() of patients with NULL phone numbers.
SELECT
    patient_id,
    CUME_DIST() OVER (ORDER BY patient_id) AS cume_dist
FROM Patients
WHERE phone IS NULL;


-- 25) Compute cumulative distribution of visit_cost partitioned by visit_status.
SELECT
    visit_id,
	visit_status,
	visit_cost,
	CUME_DIST() OVER(PARTITION BY visit_status ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost) AS Cume_dist_rank
FROM Visits
WHERE visit_status IS NOT NULL;

-- 26) Find cumulative distribution of ages of patients who have a prescription.
SELECT 
    p.patient_id,
	p.age,
	pr.prescription_id,
	CUME_DIST() OVER(ORDER BY CASE WHEN p.age IS NULL THEN 1 ELSE 0 END, age) AS Cume_dist_rank
FROM Visits v
INNER JOIN Patients p
ON v.patient_id = p.patient_id
INNER JOIN Prescriptions pr
ON v.visit_id= pr.visit_id;

--  madhu below is correct because question is patientlevel
SELECT
    patient_id,
    age,
    CUME_DIST() OVER (
        ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age
    ) AS cume_dist_rank
FROM (
    SELECT DISTINCT
        p.patient_id,
        p.age
    FROM Patients p
    INNER JOIN Visits v
        ON p.patient_id = v.patient_id
    INNER JOIN Prescriptions pr
        ON v.visit_id = pr.visit_id
) t;


-- 27) Calculate CUME_DIST() of consultation_fee partitioned by doctor_id ordered descending.
SELECT
    doctor_id,
	consultation_fee,
	CUME_DIST() OVER (PARTITION BY doctor_id ORDER BY CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END, consultation_fee DESC) AS Cume_dist_rank
FROM Billing;

-- 28) Compute cumulative distribution of visit_cost where diagnosis is not NULL.
SELECT
    visit_id,
	visit_cost,
	diagnosis,
	CUME_DIST() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost) AS Cume_dist_rank
FROM Visits
WHERE diagnosis IS NOT NULL;

-- 29) Find cumulative distribution of number of prescriptions per patient.
-- 29) Find cumulative distribution of number of prescriptions per patient.
SELECT
    patient_id,
    number_of_prescriptions,
    CUME_DIST() OVER (ORDER BY number_of_prescriptions) AS cume_dist_rank
FROM (
    SELECT
        p.patient_id,
        COUNT(pr.prescription_id) AS number_of_prescriptions
    FROM Patients p
    LEFT JOIN Visits v
        ON p.patient_id = v.patient_id
    LEFT JOIN Prescriptions pr
        ON v.visit_id = pr.visit_id
    GROUP BY p.patient_id
) t;

-- 30) Calculate CUME_DIST() of bp_systolic readings partitioned by patient_id ordered ascending.
SELECT
    patient_id,
	bp_systolic,
	CUME_DIST() OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_systolic IS NULL THEN 1 ELSE 0 END,bp_systolic ASC) AS Cume_dist_rank
FROM VitalReadings;

-- 31) Find cumulative distribution of medicine_cost partitioned by tax_percent.
SELECT
    bill_id,
	medicine_cost,
	tax_percent,
	CUME_DIST() OVER(PARTITION BY tax_percent ORDER BY CASE WHEN medicine_cost IS NULL THEN 1 ELSE 0 END,medicine_cost) AS Cume_dist_rank
FROM Billing
WHERE tax_percent IS NOT NULL;

-- 32) Compute CUME_DIST() of patients based on number of visits they have made.
SELECT
    patient_id,
	Number_of_visits,
	CUME_DIST() OVER(ORDER BY Number_of_visits ) AS Cume_dist_rank
FROM
(
SELECT
    patient_id,
	COUNT(visit_id) AS Number_of_visits
FROM Visits
GROUP BY patient_id)t;

-- 33) Calculate cumulative distribution of visit_cost ordered descending with ties.
SELECT
    visit_id,
	visit_cost,
	CUME_DIST() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost DESC) AS Cume_dist_rank
FROM Visits;

-- 34) Find cumulative distribution of visits where visit_date is in 2024.
SELECT
    visit_id,
	YEAR(visit_date) AS Year_visit_date,
	CUME_DIST() OVER(ORDER BY CASE WHEN YEAR(visit_date) IS NULL THEN 1 ELSE 0 END,visit_date) AS Cume_dist_rank
FROM Visits
WHERE YEAR(visit_date)= 2024;

-- 35) Compute CUME_DIST() for patients with age > 40 partitioned by gender.
SELECT
    patient_id,
	age,
	gender,
	CUME_DIST() OVER(PARTITION BY gender ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age) AS Cume_dist_rank
FROM Patients
WHERE age > 40
AND gender IS NOT NULL;

-- 36) Find cumulative distribution of prescriptions with dosage not NULL ordered by dosage.
SELECT
    prescription_id,
	CAST(REPLACE(dosage,'mg','') AS INT) AS Dosage,
	CUME_DIST() OVER(ORDER BY CASE WHEN CAST(REPLACE(dosage,'mg','') AS INT) IS NULL THEN 1 ELSE 0 END, Dosage) AS Cume_dist
FROM Prescriptions
WHERE dosage IS NOT NULL;

-- 37) Calculate CUME_DIST() of billing discounts where discount is negative.
SELECT
    bill_id,
	discount,
	CUME_DIST() OVER(ORDER BY CASE WHEN discount IS NULL THEN 1 ELSE 0 END,discount) AS Cume_dist
FROM Billing
WHERE discount < 0;

-- 38) Compute cumulative distribution of bp_diastolic readings per patient ordered descending.
SELECT
    patient_id,
	bp_diastolic,
	CUME_DIST() OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_diastolic IS NULL THEN 1 ELSE 0 END, bp_diastolic DESC) AS Cume_dist_rank
FROM VitalReadings;

-- 39) Find cumulative distribution of visit_cost for Cardiology department only.
SELECT
    visit_id,
	department,
	visit_cost,
	CUME_DIST() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost) AS Cume_dist_rank
FROM Visits
WHERE department = 'Cardiology';

-- 40) Calculate CUME_DIST() of patients partitioned by city and gender.
SELECT
    patient_id,
	city,
	gender,
	CUME_DIST() OVER(PARTITION BY city,gender ORDER BY patient_id ) AS Cume_dist_rank
FROM Patients
WHERE city IS NOT NULL AND gender IS NOT NULL;

-- 41) Compute cumulative distribution of total bills per patient (consultation_fee + medicine_cost - discount).
SELECT
    patient_id,
	Total_bill,
	CUME_DIST() OVER(ORDER BY Total_bill) AS Cume_dist
FROM
(
SELECT
    patient_id,
	SUM(COALESCE(consultation_fee,0)+COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_bill
FROM Billing
GROUP BY patient_id)t;


-- 42) Find cumulative distribution of doctor visits 
SELECT
    doctor_id,
    Number_of_visits,
    CUME_DIST() OVER(ORDER BY Number_of_visits) AS Rank_cume_dist
FROM
(
    SELECT
        doctor_id,
        COUNT(visit_id) AS Number_of_visits
    FROM Visits
    GROUP BY doctor_id
) t;


-- 43) Calculate CUME_DIST() of prescription count per visit ordered descending.
SELECT
    visit_id,
	Number_of_prescriptions,
	CUME_DIST() OVER(ORDER BY Number_of_prescriptions DESC) AS Cume_dist_rank
FROM
(
SELECT
    visit_id,
	COUNT(prescription_id) AS Number_of_prescriptions
FROM Prescriptions
GROUP BY visit_id)t;

-- 44) Compute cumulative distribution of bp_systolic readings ignoring NULLs.
SELECT
    reading_id,
	bp_systolic,
	CUME_DIST() OVER(ORDER BY bp_systolic ) AS Cume_dist_rank
FROM VitalReadings
WHERE bp_systolic IS NOT NULL;

-- 45) Find cumulative distribution of patients ordered by last_name.
SELECT
    patient_id,
	last_name,
	CUME_DIST() OVER(ORDER BY last_name ) AS Cume_dist_rank
FROM Patients;

-- 46) Calculate CUME_DIST() of visit_cost partitioned by visit_status ordered ascending.
SELECT
    visit_id,
	visit_cost,
	visit_status,
	CUME_DIST() OVER(PARTITION BY visit_status ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost ASC) AS Cume_dist_rank
FROM Visits
WHERE visit_status IS NOT NULL;

-- 47) Compute cumulative distribution of medicine_cost for visits in April 2024.
SELECT
    bill_id,
	YEAR(created_date) AS Year_date,
	FORMAT(created_date,'MMMM') AS Month_date,
	medicine_cost,
	CUME_DIST() OVER(ORDER BY CASE WHEN medicine_cost IS NULL THEN 1 ELSE 0 END,medicine_cost) AS Cume_dist_rank
FROM Billing
WHERE YEAR(created_date)= 2024 AND FORMAT(created_date,'MMMM') ='April';

-- 48) Find cumulative distribution of patients who had multiple visits.
SELECT
    patient_id,
	Number_of_visits,
	CUME_DIST() OVER(ORDER BY Number_of_visits ) AS Cume_dist_rank
FROM
(
SELECT
    patient_id,
	COUNT(visit_id) AS Number_of_visits
FROM Visits
GROUP BY patient_id)t;

-- 49) Calculate CUME_DIST() of prescription dosages for a specific medication (e.g., 'Amlodipine').
SELECT
    prescription_id,
	CAST(REPLACE(dosage,'mg','') AS INT) AS Dosage,
	medication_name,
	CUME_DIST() over( ORDER BY CAST(REPLACE(dosage,'mg','') AS INT)) AS Cume_dist_rank
FROM Prescriptions
WHERE medication_name =  'Amlodipine';

-- 50) Compute cumulative distribution of patients’ ages where city is not NULL.
SELECT
    patient_id,
	age,
	city,
	CUME_DIST() OVER(ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,age) AS Cume_dist_rank
FROM Patients
WHERE city IS NOT NULL;
