-- 1) Rank patients by age using DENSE_RANK() (highest age gets rank 1).
SELECT
    patient_id,
    age,
    DENSE_RANK() OVER(
        ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,
                 age DESC
    ) AS Rank_patient
FROM Patients;

-- 2) Rank patients by age within each gender using DENSE_RANK().
SELECT
    patient_id,
    age,
	gender,
    DENSE_RANK() OVER( PARTITION BY gender
        ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,
                 age DESC
    ) AS Rank_patient
FROM Patients
WHERE gender IS NOT NULL;

-- 3) Rank doctors by total number of visits using DENSE_RANK().
SELECT
    doctor_id,
	COUNT(visit_id) AS Total_number_visits,
	DENSE_RANK() OVER(ORDER BY COUNT(visit_id) DESC) Rank_doctors
FROM Visits
GROUP BY doctor_id;

-- 4) Rank doctors within each department by total visits using DENSE_RANK().
SELECT
    d.doctor_id,
    d.department,
    COUNT(v.visit_id) AS Total_number_visits,
    DENSE_RANK() OVER(
        PARTITION BY d.department
        ORDER BY COUNT(v.visit_id) DESC
    ) AS Rank_doctors
FROM Doctors d
LEFT JOIN Visits v
    ON d.doctor_id = v.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.doctor_id, d.department;

-- 5) Rank cities by total number of patients using DENSE_RANK().
SELECT
	city,
	COUNT(patient_id) AS Total_number_patients,
	DENSE_RANK() OVER(ORDER BY COUNT(patient_id)DESC ) Rank_patients
FROM Patients
WHERE city IS NOT NULL
GROUP BY city;

-- 6) Rank patients by total visit_cost using DENSE_RANK().
SELECT 
    p.patient_id,
    SUM(COALESCE(v.visit_cost, 0)) AS Total_visit_cost,
    DENSE_RANK() OVER(
        ORDER BY SUM(COALESCE(v.visit_cost, 0)) DESC
    ) AS Rank_patients
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
GROUP BY p.patient_id;

-- 7) Rank patients within each city by total visit_cost using DENSE_RANK().
SELECT 
    p.patient_id,
	p.city,
    SUM(COALESCE(v.visit_cost, 0)) AS Total_visit_cost,
    DENSE_RANK() OVER( PARTITION BY p.city
        ORDER BY SUM(COALESCE(v.visit_cost, 0)) DESC
    ) AS Rank_patients
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
WHERE p.city IS NOT NULL
GROUP BY p.patient_id ,p.city
;

-- 8) Rank visits by visit_date using DENSE_RANK().
SELECT
    visit_id,
	visit_date,
	DENSE_RANK() OVER(ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Rank_visits
FROM Visits;

-- 9) Rank visits per patient by visit_date using DENSE_RANK().
SELECT
    visit_id,
	patient_id,
	visit_date,
	DENSE_RANK() OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Rank_visits
FROM Visits;

-- 10) Rank patients by total billing amount (consultation_fee + medicine_cost) using DENSE_RANK().
SELECT
    patient_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)) AS Total_billing_amount,
	DENSE_RANK() OVER(ORDER BY SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)) DESC) AS Rank_total_billing
FROM Billing
GROUP BY patient_id;

-- 11) Rank doctors by total billing revenue using DENSE_RANK().
SELECT
    doctor_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)-COALESCE(discount,0)) AS Total_billing_amount,
	DENSE_RANK() OVER(ORDER BY SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)-COALESCE(discount,0)) DESC) AS Rank_total_billing
FROM Billing
GROUP BY doctor_id;

-- 12) Rank doctors within each department by total billing revenue using DENSE_RANK().
SELECT 
    d.doctor_id,
	d.department,
	SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0)-COALESCE(b.discount,0)) AS Total_billing_amount,
	DENSE_RANK() OVER( PARTITION BY d.department
	ORDER BY SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0)-COALESCE(b.discount,0)) DESC) AS Rank_total_billing
FROM Doctors d
LEFT JOIN Billing b
ON d.doctor_id= b.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.doctor_id, d.department;

-- 13) Rank patients by number of prescriptions using DENSE_RANK().
SELECT 
    p.patient_id,
    COUNT(pr.prescription_id) AS Number_of_prescriptions,
    DENSE_RANK() OVER(
        ORDER BY COUNT(pr.prescription_id) DESC
    ) AS rank_patients
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
LEFT JOIN Prescriptions pr
    ON v.visit_id = pr.visit_id
GROUP BY p.patient_id;

-- 14) Rank visits by visit_cost within each department using DENSE_RANK().
SELECT
    visit_id,
	department,
	COALESCE(visit_cost,0) AS visit_cost,
	DENSE_RANK() OVER(PARTITION BY department ORDER BY COALESCE(visit_cost,0) DESC) Rank_visits
FROM Visits
WHERE department IS NOT NULL;


-- 15) Rank patients by maximum bp_systolic value using DENSE_RANK().
SELECT
    patient_id,
	MAX(bp_systolic) AS Max_bp,
	DENSE_RANK() OVER (ORDER BY MAX(bp_systolic) DESC ) AS Rank_patient
FROM VitalReadings
WHERE bp_systolic IS NOT NULL
GROUP BY patient_id;

-- 16) Rank patients by average bp_systolic using DENSE_RANK().
SELECT
    patient_id,
	AVG(bp_systolic) AS AVG_bp,
	DENSE_RANK() OVER (ORDER BY AVG(bp_systolic) DESC ) AS Rank_patient
FROM VitalReadings
WHERE bp_systolic IS NOT NULL
GROUP BY patient_id;

-- 17) Rank patients within each gender by average bp_systolic using DENSE_RANK().
SELECT 
    p.patient_id,
	p.gender,
	AVG(v.bp_systolic) AS AVG_bp,
	DENSE_RANK() OVER (PARTITION BY p.gender ORDER BY AVG(v.bp_systolic) DESC ) AS Rank_patient
FROM patients p
LEFT JOIN VitalReadings v
ON p.patient_id = v.patient_id
AND v.bp_systolic IS NOT NULL
GROUP BY p.patient_id,p.gender;

-- 18) Rank readings per patient by bp_systolic (highest first) using DENSE_RANK().
SELECT
    reading_id,
	patient_id,
	bp_systolic,
	DENSE_RANK() OVER (PARTITION BY patient_id ORDER BY bp_systolic DESC) AS Rank_reading
FROM VitalReadings
WHERE bp_systolic IS NOT NULL;

-- 19) Rank doctors by number of distinct patients treated using DENSE_RANK().
SELECT
    doctor_id,
	COUNT(DISTINCT patient_id) AS Number_distinct_patients,
	DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT patient_id) DESC) Rank_doc
FROM Visits
GROUP BY doctor_id;

-- 20) Rank departments by total number of visits using DENSE_RANK().
SELECT
    department,
	COUNT(visit_id) AS Total_visits,
	DENSE_RANK() OVER( ORDER BY  COUNT(visit_id) DESC) AS Rank_department
FROM Visits
GROUP BY department;


-- 21) Rank patients by total discount amount (absolute value) using DENSE_RANK().
SELECT
    patient_id,
	SUM(ABS(COALESCE(discount,0))) AS Total_discount,
	DENSE_RANK() OVER(ORDER BY SUM(ABS(COALESCE(discount,0))) DESC) Rank_patients
FROM Billing
GROUP BY patient_id;


-- 22) Rank billing records by tax_percent using DENSE_RANK().
SELECT
    bill_id,
	tax_percent,
	DENSE_RANK() OVER(ORDER BY tax_percent DESC) AS Rank_patients
FROM Billing
WHERE tax_percent IS NOT NULL;

-- 23) Rank patients by total medicine_cost using DENSE_RANK().
SELECT
    patient_id,
	SUM(COALESCE(medicine_cost,0)) AS medicine_cost,
	DENSE_RANK() OVER(ORDER BY SUM(COALESCE(medicine_cost,0)) DESC) AS Rank_patient
FROM Billing
GROUP BY patient_id;

-- 24) Rank doctors by average consultation_fee using DENSE_RANK().
SELECT
    doctor_id,
	AVG(COALESCE(consultation_fee,0)) AS Avg_consultation_fee,
	DENSE_RANK() OVER(ORDER BY AVG(COALESCE(consultation_fee,0)) DESC) AS Rank_doc
FROM Billing
GROUP BY doctor_id;


-- 25) Rank visits by diagnosis count using DENSE_RANK().
SELECT
    patient_id,
    visit_id,
    COUNT(diagnosis) AS Total_count_diag,
    DENSE_RANK() OVER(
        PARTITION BY patient_id
        ORDER BY COUNT(diagnosis) DESC
    ) AS Rank_diag
FROM Visits
GROUP BY patient_id, visit_id;

-- 26) Rank patients by number of completed visits using DENSE_RANK().
SELECT
    patient_id,
	COUNT(visit_status) AS Number_visit_status,
	DENSE_RANK() OVER(ORDER BY COUNT(visit_status) DESC) AS Rank_patient
FROM Visits
WHERE visit_status = 'COMPLETED'
GROUP BY patient_id;

-- 27) Rank departments by average visit_cost using DENSE_RANK().
SELECT
    department,
	AVG(COALESCE(visit_cost,0)) AS Avg_visit_cost,
	DENSE_RANK() OVER( ORDER BY AVG(COALESCE(visit_cost,0)) DESC) AS Rank_department
FROM Visits
GROUP BY department;

-- 28) Rank patients within each city by number of visits using DENSE_RANK().
SELECT 
    p.patient_id,
	p.city,
	COUNT(v.visit_id) AS Number_of_visits,
	DENSE_RANK() OVER( PARTITION BY p.city ORDER BY COUNT(v.visit_id) DESC) AS Rank_patients
FROM Patients p 
LEFT JOIN Visits v
ON p.patient_id = v.patient_id
WHERE p.city IS NOT NULL
GROUP BY p.patient_id, p.city
   
-- 29) Rank doctors by number of NULL diagnoses handled using DENSE_RANK().
SELECT
    doctor_id,
    COUNT(*) AS Number_null_diag,
    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS Rank_diag
FROM Visits
WHERE diagnosis IS NULL
GROUP BY doctor_id;

-- 30) Rank visits per doctor by visit_date using DENSE_RANK().
SELECT
    visit_id,
	doctor_id,
	visit_date,
	DENSE_RANK() OVER(PARTITION BY doctor_id ORDER BY  CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date ) AS Rank_visits
FROM Visits;

-- 31) Rank patients by earliest visit_date using DENSE_RANK().
SELECT
    patient_id,
	MIN(visit_date) AS earliest_visit_date,
	DENSE_RANK() OVER( ORDER BY MIN(visit_date) ASC) AS Rank_patients
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY patient_id;


-- 32) Rank events in DateTimePractice by event_datetime using DENSE_RANK().
SELECT
    record_id,
	event_datetime,
	DENSE_RANK() OVER(ORDER BY event_datetime DESC) AS Rank_datetime
	FROM DateTimePractice
WHERE event_datetime IS NOT NULL;

-- 33) Rank events per month by event_datetime using DENSE_RANK().
SELECT
    record_id,
    event_datetime,
    YEAR(event_datetime) AS Year_event,
    MONTH(event_datetime) AS Month_event,
    DENSE_RANK() OVER (
        PARTITION BY YEAR(event_datetime), MONTH(event_datetime)
        ORDER BY event_datetime DESC
    ) AS Rank_datetime
FROM DateTimePractice
WHERE event_datetime IS NOT NULL;

-- 34) Rank patients by total number of vital readings using DENSE_RANK().
SELECT
    patient_id,
	COUNT(reading_id) AS Total_number_reading,
	DENSE_RANK() OVER(ORDER BY COUNT(reading_id) DESC) AS Rank_patient
FROM VitalReadings
GROUP BY patient_id;

-- 35) Rank patients by difference between max and min bp_systolic using DENSE_RANK().
SELECT
    patient_id,
    MAX(bp_systolic) AS max_bp,
    MIN(bp_systolic) AS min_bp,
    MAX(bp_systolic) - MIN(bp_systolic) AS bp_difference,
    DENSE_RANK() OVER (
        ORDER BY MAX(bp_systolic) - MIN(bp_systolic) DESC
    ) AS Rank_patient
FROM VitalReadings
WHERE bp_systolic IS NOT NULL
GROUP BY patient_id;

-- 36) Rank doctors by total consultation_fee collected using DENSE_RANK().
SELECT
    doctor_id,
	SUM(COALESCE(consultation_fee,0)) AS Total_fee,
	DENSE_RANK() OVER(ORDER BY SUM(COALESCE(consultation_fee,0)) DESC) AS Rank_doc
FROM Billing
GROUP BY doctor_id;

-- 37) Rank patients by total billing rows count using DENSE_RANK().
SELECT
    patient_id,
	COUNT(bill_id) AS Total_bill_rows,
	DENSE_RANK() OVER(ORDER BY COUNT(bill_id) DESC) AS Rank_patients
FROM Billing
GROUP BY patient_id;

-- 38) Rank doctors by total medicine_cost prescribed using DENSE_RANK().
SELECT
    doctor_id,
	SUM(COALESCE(medicine_cost,0)) AS Total_medicine_cost,
	DENSE_RANK() OVER(ORDER BY SUM(COALESCE(medicine_cost,0)) DESC) AS Rank_doc
FROM Billing
GROUP BY doctor_id;

-- 39) Rank visits by visit_cost ignoring NULL values using DENSE_RANK().
SELECT
    visit_id,
	visit_cost,
	DENSE_RANK() OVER(ORDER BY visit_cost DESC) AS Rank_visits
FROM Visits
WHERE visit_cost IS NOT NULL;

-- 40) Rank patients within each age group by total visit_cost using DENSE_RANK().
SELECT
    p.patient_id,
    CASE
        WHEN p.age BETWEEN 0 AND 18 THEN '0-18'
        WHEN p.age BETWEEN 19 AND 30 THEN '19-30'
        WHEN p.age BETWEEN 31 AND 45 THEN '31-45'
        WHEN p.age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_group,
    SUM(COALESCE(v.visit_cost, 0)) AS Total_visit_cost,
    DENSE_RANK() OVER (
        PARTITION BY 
            CASE
                WHEN p.age BETWEEN 0 AND 18 THEN '0-18'
                WHEN p.age BETWEEN 19 AND 30 THEN '19-30'
                WHEN p.age BETWEEN 31 AND 45 THEN '31-45'
                WHEN p.age BETWEEN 46 AND 60 THEN '46-60'
                ELSE '60+'
            END
        ORDER BY SUM(COALESCE(v.visit_cost, 0)) DESC
    ) AS Rank_patient
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
WHERE p.age IS NOT NULL
GROUP BY
    p.patient_id,
    CASE
        WHEN p.age BETWEEN 0 AND 18 THEN '0-18'
        WHEN p.age BETWEEN 19 AND 30 THEN '19-30'
        WHEN p.age BETWEEN 31 AND 45 THEN '31-45'
        WHEN p.age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END;


-- 41) Rank departments by number of doctors using DENSE_RANK().
SELECT
    department,
	COUNT(doctor_id) AS Number_of_doc,
	DENSE_RANK() OVER(ORDER BY COUNT(doctor_id)DESC) AS Rank_depart
FROM Doctors
WHERE department IS NOT NULL
GROUP BY department;

-- 42) Rank patients by latest visit_date using DENSE_RANK().
SELECT
    patient_id,
	MAX(visit_date) AS Latest_visit_date,
	DENSE_RANK() OVER(ORDER BY MAX(visit_date) DESC ) AS Rank_patient
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY patient_id;

-- 43) Rank doctors within each department by average visit_cost using DENSE_RANK().
SELECT 
    d.doctor_id,
    d.department,
    AVG(COALESCE(v.visit_cost,0)) AS Avg_visit_cost,
    DENSE_RANK() OVER(
        PARTITION BY d.department 
        ORDER BY AVG(COALESCE(v.visit_cost,0)) DESC
    ) AS Rank_doc
FROM Doctors d
LEFT JOIN Visits v
    ON d.doctor_id = v.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.doctor_id, d.department;

-- 44) Rank patients by sum of consultation_fee using DENSE_RANK().
SELECT
    patient_id,
	SUM(COALESCE(consultation_fee,0)) AS Total_fee,
	DENSE_RANK() OVER(ORDER BY SUM(COALESCE(consultation_fee,0)) DESC) AS Rank_patient
FROM Billing
GROUP BY patient_id;


-- 45) Rank visits by number of medications prescribed using DENSE_RANK().
SELECT 
    v.visit_id,
	COUNT(p.prescription_id) AS Total_prescriptions,
	DENSE_RANK() OVER(ORDER BY COUNT(p.prescription_id) DESC) AS Rank_visits
FROM Visits v
LEFT JOIN prescriptions p
ON v.visit_id = p.visit_id
GROUP BY v.visit_id;

-- 46) Rank patients within each city by total billing amount using DENSE_RANK().
SELECT 
    p.patient_id,
	p.city,
	SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0) -COALESCE(b.discount,0))  AS Total_billing,
	DENSE_RANK() OVER(PARTITION BY p.city
	ORDER BY SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0) -COALESCE(b.discount,0)) DESC) AS Rank_patient
FROM patients p
LEFT JOIN Billing b
ON p.patient_id = b.patient_id
WHERE p.city IS NOT NULL
GROUP  BY p.patient_id, p.city;

-- 47) Rank doctors by count of high-cost visits (visit_cost > 600) using DENSE_RANK().
SELECT
    doctor_id,
    COUNT(*) AS HighCost_visits,
    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS Rank_doc
FROM Visits
WHERE visit_cost > 600
GROUP BY doctor_id;


-- 48) Rank patients by number of NULL values in billing records using DENSE_RANK().
SELECT
    patient_id,
    SUM(
        CASE 
            WHEN consultation_fee IS NULL THEN 1 ELSE 0 
        END +
        CASE 
            WHEN medicine_cost IS NULL THEN 1 ELSE 0 
        END +
        CASE 
            WHEN discount IS NULL THEN 1 ELSE 0 
        END
    ) AS Num_NULLs,
    DENSE_RANK() OVER(ORDER BY SUM(
        CASE 
            WHEN consultation_fee IS NULL THEN 1 ELSE 0 
        END +
        CASE 
            WHEN medicine_cost IS NULL THEN 1 ELSE 0 
        END +
        CASE 
            WHEN discount IS NULL THEN 1 ELSE 0 
        END
    ) DESC) AS Rank_patient
FROM Billing
GROUP BY patient_id;

-- 49) Rank patients by consistency of bp_systolic readings using DENSE_RANK().
SELECT
    patient_id,
    MAX(bp_systolic) - MIN(bp_systolic) AS bp_range,
    DENSE_RANK() OVER(ORDER BY MAX(bp_systolic) - MIN(bp_systolic) ASC) AS Rank_patient
FROM VitalReadings
WHERE bp_systolic IS NOT NULL
GROUP BY patient_id;

-- 50) Rank doctors by combined visit_cost + consultation_fee using DENSE_RANK().

WITH VisitTotals AS (
    SELECT doctor_id, SUM(COALESCE(visit_cost,0)) AS Total_visit_cost
    FROM Visits
    GROUP BY doctor_id
),
BillingTotals AS (
    SELECT doctor_id, SUM(COALESCE(consultation_fee,0)) AS Total_consult_fee
    FROM Billing
    GROUP BY doctor_id
)
SELECT 
    d.doctor_id,
    COALESCE(vt.Total_visit_cost,0) + COALESCE(bt.Total_consult_fee,0) AS Total_combined,
    DENSE_RANK() OVER(ORDER BY COALESCE(vt.Total_visit_cost,0) + COALESCE(bt.Total_consult_fee,0) DESC) AS Rank_doc
FROM Doctors d
LEFT JOIN VisitTotals vt ON d.doctor_id = vt.doctor_id
LEFT JOIN BillingTotals bt ON d.doctor_id = bt.doctor_id;
