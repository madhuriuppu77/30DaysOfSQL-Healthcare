-- 1) Display each patient along with the maximum age among all patients using a window function.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	MAX(age) OVER() AS Maximum_age
FROM Patients
WHERE age IS NOT NULL;


-- 2) Show each patient with the maximum age within their gender.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_name,
	gender,
	age,
	MAX(age) OVER(PARTITION BY gender) AS Maximum_age
FROM Patients
WHERE age is not null and gender IS NOT NULL;

-- 3) Display each visit with the maximum visit_cost across all visits.
SELECT
    visit_id,
	visit_cost,
	MAX(visit_cost) OVER() AS Maximum_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;

-- 4) Show each visit along with the maximum visit_cost per department.
SELECT
    visit_id,
	visit_cost,
	department,
	MAX(visit_cost) OVER(PARTITION BY department) AS Maximum_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL AND department IS NOT NULL;


-- 5) Display each doctor with the maximum number of visits handled by any doctor.

SELECT
    doctor_id,
    full_name,
    visits_per_doctor,
    MAX(visits_per_doctor) OVER () AS max_visits_any_doctor
FROM (
    SELECT
        d.doctor_id,
        CONCAT(d.first_name, ' ', d.last_name) AS full_name,
        COUNT(v.visit_id) OVER (PARTITION BY d.doctor_id) AS visits_per_doctor
    FROM Doctors d
    LEFT JOIN Visits v
        ON d.doctor_id = v.doctor_id
) t;


-- 6) Show each billing record along with the maximum consultation_fee across all bills.
SELECT
    bill_id,
	consultation_fee,
	MAX(consultation_fee) OVER() AS Maximum_fee
FROM Billing
WHERE consultation_fee IS NOT NULL;

-- 7) Display each billing record with the maximum consultation_fee per doctor.
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.consultation_fee,
	MAX(b.consultation_fee) OVER(PARTITION BY d.doctor_id) AS Max_fee_per_doc
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id
WHERE b.consultation_fee IS NOT NULL;

-- 8) Show each patient with the maximum medicine_cost they have ever incurred.
SELECT
    b.bill_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.medicine_cost,
	MAX(b.medicine_cost) OVER(PARTITION BY p.patient_id) AS Maximum_medicine_cost
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id = p.patient_id
WHERE b.medicine_cost IS NOT NULL;

-- 9) Display each patient visit with the maximum visit_date per patient.
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	v.visit_date,
	MAX(visit_date) OVER(PARTITION BY p.patient_id) AS Maximum_visit_date
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id
WHERE v.visit_date IS NOT NULL;


-- 10) Show each prescription with the maximum dosage value per visit (treat dosage as text).
SELECT
    visit_id,
    prescription_id,
    dosage,
    MAX(dosage) OVER (PARTITION BY visit_id) AS Maximum_dosage
FROM Prescriptions
WHERE dosage IS NOT NULL;

-- 11) Display each visit with the maximum visit_cost per visit_status.
SELECT
    visit_id,
	visit_cost,
	visit_status,
	MAX(visit_cost) OVER( PARTITION BY visit_status) AS Maximum_visit_status
FROM Visits;

-- 12) Show each department’s visits along with the maximum visit_cost using a window function.
SELECT
    visit_id,
	visit_cost,
	department,
	COUNT(visit_id) OVER(PARTITION BY department) AS Visits_per_department,
	MAX(visit_cost) OVER(PARTITION BY department) AS Visit_cost_per_department
FROM Visits
WHERE department IS NOT NULL AND Visit_cost IS NOT NULL;


-- 13) Display each doctor with the maximum total billing amount among all doctors (without GROUP BY).
SELECT
    bill_id,
	doctor_id,
	Full_Name,
	Total_billing,
	MAX(Total_billing) OVER() AS Maximum_doc
FROM
(
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	SUM(COALESCE(b.consultation_fee,0) + COALESCE(b.medicine_cost,0)- COALESCE(b.discount,0)) OVER(PARTITION BY d.doctor_id) AS Total_billing
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id)t;

-- For disitinct rows

SELECT DISTINCT
    doctor_id,
    Full_Name,
    Total_billing,
    MAX(Total_billing) OVER() AS Maximum_doc
FROM (
    SELECT
        d.doctor_id,
        CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
        SUM(
            COALESCE(b.consultation_fee,0)
          + COALESCE(b.medicine_cost,0)
          - COALESCE(b.discount,0)
        ) OVER (PARTITION BY d.doctor_id) AS Total_billing
    FROM Doctors d
    LEFT JOIN Billing b
        ON d.doctor_id = b.doctor_id
) t;

  
-- 14) Show each patient and the maximum total billing amount among all patients.
SELECT DISTINCT
    patient_id,
    Full_Name,
    Total_billing,
    MAX(Total_billing) OVER() AS Maximum_patient
FROM (
    SELECT
        p.patient_id,
		b.bill_id,
        CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
        SUM(
            COALESCE(b.consultation_fee,0)
          + COALESCE(b.medicine_cost,0)
          - COALESCE(b.discount,0)
        ) OVER (PARTITION BY p.patient_id) AS Total_billing
    FROM patients p
    LEFT JOIN Billing b
        ON p.patient_id = b.patient_id
) t;

-- 15) Display each billing row with the maximum tax_percent across all billing records.
SELECT
    bill_id,
	tax_percent,
	MAX(tax_percent) OVER() AS Maximum_tax_percent
FROM Billing;

-- 16) Show each billing record with the maximum discount value per doctor.
SELECT
    b.bill_id,
    d.doctor_id,
    CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
    b.discount,
    MAX(ABS(b.discount)) OVER (PARTITION BY d.doctor_id) AS Maximum_discount_per_doc
FROM Billing b
LEFT JOIN Doctors d
    ON b.doctor_id = d.doctor_id;

-- 17) Display each visit with the maximum visit_cost for that doctor.
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	v.visit_cost,
	MAX(v.visit_cost) OVER(PARTITION BY d.doctor_id) AS Maximum_visit_cost
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id;

-- 18) Show each patient with the maximum number of visits any patient has made.
SELECT DISTINCT
    
	patient_id,
	Full_Name,
	Number_of_visits_per_patient,
	MAX(Number_of_visits_per_patient) OVER() AS Maximum_visits
FROM
(
SELECT 
    v.visit_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	COUNT(v.visit_id) OVER(PARTITION BY p.patient_id) AS Number_of_visits_per_patient
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id) t;
  
-- 19) Display each visit along with the maximum visit_cost per month using window functions.
SELECT
    visit_id,
	visit_cost,
	visit_date,
	YEAR(visit_date) AS Year_visit_date,
	MONTH(visit_date) AS Month_visit_date,
	MAX(visit_cost) OVER(PARTITION BY YEAR(visit_date), MONTH(visit_date)) AS Maximum_visit_cost
FROM visits
WHERE visit_date IS NOT NULL AND visit_cost IS NOT NULL;


-- 20) Show each billing record with the maximum consultation_fee per month.
SELECT
    bill_id,
	created_date,
	YEAR(created_date) AS Year_created_date,
	MONTH(created_date) AS Month_created_date,
	consultation_fee,
	MAX(consultation_fee) OVER(PARTITION BY YEAR(created_date), MONTH(created_date)) AS Maximum_fee
FROM Billing
WHERE consultation_fee IS NOT NULL;


-- 21) Display each patient with the maximum age per city.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	city,
	MAX(age) OVER(PARTITION BY city) AS Maximum_age
FROM Patients
WHERE age IS NOT NULL AND city IS NOT NULL;


-- 22) Show each visit with the maximum visit_cost among visits with non-NULL diagnosis.
SELECT
    visit_id,
    visit_cost,
    diagnosis,
    MAX(visit_cost) OVER() AS Maximum_visit_cost
FROM Visits
WHERE diagnosis IS NOT NULL
  AND visit_cost IS NOT NULL;


-- 23) Display each billing row with the maximum medicine_cost ignoring NULL values.
SELECT
    bill_id,
	medicine_cost,
	MAX(medicine_cost) OVER() AS Maximum_medicine_cost
FROM Billing
WHERE medicine_cost IS NOT NULL;

-- 24) Show each patient visit with the maximum visit_cost across all visits (same value on every row).
SELECT
    visit_id,
	patient_id,
	visit_cost,
	MAX(visit_cost) OVER() AS Maximum_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;

-- 25) Display each visit with the maximum visit_cost per patient and department.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	department,
	MAX(visit_cost) OVER(PARTITION BY patient_id,department) AS Max_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL AND department IS NOT NULL;

-- 26) Show each doctor with the maximum number of distinct patients handled.
SELECT DISTINCT
    doctor_id,
    Full_Name,
    Number_of_patients,
    MAX(Number_of_patients) OVER() AS Maximum_patients
FROM (
    SELECT
        d.doctor_id,
        CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
        COUNT(*) OVER (PARTITION BY d.doctor_id) AS Number_of_patients
    FROM (
        SELECT DISTINCT
            doctor_id,
            patient_id
        FROM Visits
        WHERE doctor_id IS NOT NULL
          AND patient_id IS NOT NULL
    ) v
    JOIN Doctors d
      ON v.doctor_id = d.doctor_id
) t;


-- 27) Display each billing record with the maximum absolute discount value using ABS() and window function.
SELECT
    bill_id,
	discount,
	MAX(ABS(discount)) OVER() AS Maximum_abs_discount
FROM Billing
WHERE discount IS NOT NULL;


-- 28) Show each visit with the maximum visit_cost for visits marked as COMPLETED.
SELECT
    visit_id,
	visit_status,
	visit_cost,
	MAX(visit_cost) OVER() AS Maximum_visit_cost
FROM Visits
WHERE visit_status = 'COMPLETED' AND visit_cost IS NOT NULL;

-- 29) Display each patient with the maximum bp_systolic reading across all patients.
SELECT
    reading_id,
	patient_id,
	reading_date,
	bp_systolic,
	MAX(bp_systolic) OVER () AS Maximum_bp_systolic
FROM VitalReadings;

    
-- 30) Show each vital reading with the maximum bp_systolic per patient.
SELECT
    reading_id,
	patient_id,
	reading_date,
	bp_systolic,
	MAX(bp_systolic) OVER (PARTITION BY patient_id) AS Maximum_bp_systolic
FROM VitalReadings ;

-- 31) Display each vital reading with the maximum bp_diastolic per patient.
SELECT
    reading_id,
    patient_id,
    reading_date,
    bp_diastolic,
    MAX(bp_diastolic) OVER (PARTITION BY patient_id) AS Maximum_bp_diastolic
FROM VitalReadings;

-- 32) Show each patient with the maximum gap between systolic readings using window functions.
SELECT DISTINCT
    patient_id,
    MAX(bp_gap) OVER (PARTITION BY patient_id) AS Maximum_bp_gap
FROM (
    SELECT
        patient_id,
        reading_date,
        bp_systolic,
        ABS(
            bp_systolic
          - LAG(bp_systolic) OVER (
                PARTITION BY patient_id
                ORDER BY reading_date
            )
        ) AS bp_gap
    FROM VitalReadings
) t
WHERE bp_gap IS NOT NULL;

-- 33) Display each visit with the maximum visit_cost compared to the previous visit (window comparison).
WITH cost_diff AS (
    SELECT
        visit_id,
        visit_date,
        visit_cost,
        visit_cost
          - LAG(visit_cost) OVER (ORDER BY visit_date) AS cost_difference
    FROM Visits
    WHERE visit_cost IS NOT NULL
      AND visit_date IS NOT NULL
)
SELECT
    visit_id,
    visit_date,
    visit_cost,
    cost_difference,
    MAX(cost_difference) OVER () AS Maximum_cost_difference
FROM cost_diff;


-- 34) Show each billing record with the maximum total bill amount (consultation + medicine).
SELECT
    bill_id,
    total_bill_amount,
    MAX(total_bill_amount) OVER () AS Maximum_Billing
FROM (
    SELECT
        bill_id,
        COALESCE(consultation_fee,0)
      + COALESCE(medicine_cost,0) AS total_bill_amount
    FROM Billing
) t;


    

-- 35) Display each billing record with the maximum total bill per doctor.
SELECT
    bill_id,
    doctor_id,
    full_name,
    total_bill_amount,
    MAX(total_bill_amount) OVER (PARTITION BY doctor_id) AS Maximum_total_bill_per_doctor
FROM (
    SELECT
        b.bill_id,
        d.doctor_id,
        CONCAT(d.first_name, ' ', d.last_name) AS full_name,
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0) AS total_bill_amount
    FROM Billing b
    LEFT JOIN Doctors d
        ON b.doctor_id = d.doctor_id
) t;


-- 36) Show each visit with the maximum visit_cost per year using window functions.
SELECT
    visit_id,
	visit_cost,
	visit_date,
	YEAR(visit_date) AS Year_visit_date,
	MAX(visit_cost) OVER(PARTITION BY YEAR(visit_date)) AS Maximum_visit_cost
FROM Visits
WHERE visit_date IS NOT NULL;


-- 37) Display each patient with the maximum number of visits in any city.
SELECT DISTINCT
    patient_id,
    full_name,
    MAX(visits_per_city) OVER (PARTITION BY patient_id) AS Maximum_visits
FROM (
    SELECT
        p.patient_id,
        CONCAT(p.first_name, ' ', p.last_name) AS full_name,
        p.city,
        COUNT(v.visit_id) OVER (
            PARTITION BY p.patient_id, p.city
        ) AS visits_per_city
    FROM Patients p
    INNER JOIN Visits v
        ON p.patient_id = v.patient_id
    WHERE p.city IS NOT NULL
) t;


-- 38) Show each visit with the maximum visit_cost where department is NULL vs NOT NULL.
SELECT
    visit_id,
    department,
    visit_cost,
    MAX(visit_cost) OVER (
        PARTITION BY
        CASE
            WHEN department IS NULL THEN 'NO_DEPT'
            ELSE 'HAS_DEPT'
        END
    ) AS Maximum_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;

-- 39) Display each doctor with the maximum average consultation_fee using window functions only.
SELECT DISTINCT
    doctor_id,
    Avg_consultation_fee,
    MAX(Avg_consultation_fee) OVER () AS Max_avg_fee
FROM (
    SELECT
        doctor_id,
        AVG(consultation_fee) OVER (PARTITION BY doctor_id) AS Avg_consultation_fee
    FROM Billing
    WHERE consultation_fee IS NOT NULL
) t;



-- 40) Show each billing record with the maximum tax_percent per doctor.
SELECT
    bill_id,
	doctor_id,
	tax_percent,
	MAX(tax_percent) OVER(PARTITION BY doctor_id) AS Maximum_tax_percent
FROM Billing
WHERE tax_percent IS NOT NULL;


-- 41) Display each visit with the maximum visit_cost among visits done by the same doctor.
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	v.visit_cost,
	MAX(v.visit_cost) OVER(PARTITION BY d.doctor_id) AS Max_visit_cost
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
WHERE v.visit_cost IS NOT NULL;


-- 42) Show each patient with the maximum billing amount across all billing dates.
SELECT
    patient_id,
	bill_id,
	COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0) AS Total_billing_amount,
	MAX(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) OVER(PARTITION BY patient_id) AS Max_bill_amount
FROM Billing;

-- 43) Display each visit with the maximum visit_cost per diagnosis.
SELECT
    visit_id,
	visit_cost,
	diagnosis,
	MAX(visit_cost) OVER(PARTITION BY diagnosis) AS Max_visit_per_diag
FROM Visits
WHERE visit_cost IS NOT NULL AND diagnosis IS NOT NULL;


-- 44) Show each patient with the maximum number of prescriptions issued.
SELECT DISTINCT
    prescription_id,
	patient_id,
	Number_of_prescriptions,
	MAX(Number_of_prescriptions) OVER() AS Maximum_number_patients
FROM
(

SELECT 
	p.prescription_id,
	v.patient_id,
	COUNT(prescription_id) OVER(PARTITION BY v.patient_id ) AS Number_of_prescriptions
FROM Prescriptions p
LEFT JOIN Visits v
ON p.visit_id= v.visit_id)t;


-- 45) Display each visit with the maximum visit_cost among visits in the same city (via joins + window).
SELECT 
    v.visit_id,
	v.visit_cost,
	p.city,
	MAX(v.visit_cost) OVER(PARTITION BY p.city) AS Maximum_visit_cost
FROM Visits v
INNER JOIN Patients p
ON v.patient_id = p.patient_id
WHERE p.city IS NOT NULL;

-- 46) Show each billing record with the maximum medicine_cost per patient.
SELECT 
    p.patient_id,
	b.bill_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.medicine_cost,
	MAX(b.medicine_cost) OVER(PARTITION BY p.patient_id) AS Maximum_medicine_cost
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id= p.patient_id
WHERE b.medicine_cost IS NOT NULL;




-- 47) Display each visit with the maximum visit_cost where visit_date is NULL vs NOT NULL.
SELECT
    visit_id,
    visit_date,
    visit_cost,
    MAX(visit_cost) OVER (
        PARTITION BY
            CASE
                WHEN visit_date IS NULL THEN 'NO_DATE'
                ELSE 'HAS_DATE'
            END
    ) AS Max_cost_in_my_group
FROM Visits
WHERE visit_cost IS NOT NULL;


-- 48) Show each doctor with the maximum visit_cost they have ever charged.
SELECT
    visit_id,
    doctor_id,
    visit_cost,
    MAX(visit_cost) OVER (PARTITION BY doctor_id) AS Maximum_visit_cost_per_doctor
FROM Visits
WHERE visit_cost IS NOT NULL;


-- 49) Display each patient with the maximum visit_cost they have incurred across all visits.
SELECT
    patient_id,
    visit_id,
    visit_cost,
    MAX(visit_cost) OVER (PARTITION BY patient_id) AS Maximum_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;



-- 50) Show each record Visits with the maximum visit_cost value and explain why GROUP BY cannot replace this window function.
SELECT
    visit_id,
	visit_cost,
	MAX(visit_cost) OVER() AS Maximum_visit_cost
FROM Visits;
-- because in group by we cant get level of details results but by using window functions will get result without collapsing rows and with level of details.
