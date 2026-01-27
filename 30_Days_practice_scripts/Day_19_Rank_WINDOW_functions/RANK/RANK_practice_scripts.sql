-- 1) Rank patients by age in descending order.
SELECT
    patient_id,
	age,
	RANK() OVER(ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age DESC) AS rank_nm
FROM Patients;

-- 2) Rank patients within each city based on age.
SELECT
    patient_id,
	age,
	city,
	RANK() OVER(PARTITION BY city ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age DESC) AS rank_nm
FROM Patients
WHERE city IS NOT NULL;

-- 3) Rank doctors based on the number of visits they handled.
SELECT
    doctor_id,
    Full_Name,
    Number_of_visits,
    RANK() OVER (ORDER BY Number_of_visits DESC) AS rank_nm
FROM (
    SELECT 
        d.doctor_id,
        CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
        COUNT(v.visit_id) OVER (PARTITION BY d.doctor_id) AS Number_of_visits
    FROM Doctors d
    LEFT JOIN Visits v
        ON v.doctor_id = d.doctor_id
) t
GROUP BY doctor_id, Full_Name, Number_of_visits;
-- You can use group or distinct to geto only one coulmn
SELECT DISTINCT
    doctor_id,
    Full_Name,
    Number_of_visits,
    RANK() OVER (ORDER BY Number_of_visits DESC) AS rank_nm
FROM (
    SELECT 
        d.doctor_id,
        CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
        COUNT(v.visit_id) OVER (PARTITION BY d.doctor_id) AS Number_of_visits
    FROM Doctors d
    LEFT JOIN Visits v
        ON v.doctor_id = d.doctor_id
) t


-- 4) Rank doctors within each department by total visits.
SELECT
    doctor_id,
    Full_Name,
    department,
    Number_of_visits,
    RANK() OVER (
        PARTITION BY department
        ORDER BY Number_of_visits DESC
    ) AS rank_nm
FROM (
    SELECT
        d.doctor_id,
        CONCAT(d.first_name, ' ', d.last_name) AS Full_Name,
        d.department,
        COUNT(v.visit_id) OVER (PARTITION BY d.doctor_id) AS Number_of_visits
    FROM Doctors d
    LEFT JOIN Visits v
        ON v.doctor_id = d.doctor_id
    WHERE d.department IS NOT NULL
) t
GROUP BY doctor_id, Full_Name, department, Number_of_visits;


-- 5) Rank visits based on visit_cost from highest to lowest.
SELECT
    visit_id,
	visit_cost,
	RANK() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC) AS Rank_nm
FROM visits;

-- 6) Rank visits per patient based on visit_cost.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	RANK() OVER( PARTITION BY patient_id ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC) AS Rank_nm
FROM visits;

-- 7) Rank patients based on total billing amount (consultation_fee + medicine_cost).
SELECT
    patient_id,
    SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0)) AS total_billing_amount,
    RANK() OVER (
        ORDER BY SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0)) DESC
    ) AS rank_num
FROM Billing
GROUP BY patient_id;


-- 8) Rank patients within each city by total billing amount.
SELECT
    p.patient_id,
    CONCAT(p.first_name,' ',p.last_name) AS full_name,
    p.city,
    SUM(COALESCE(b.consultation_fee,0) + COALESCE(b.medicine_cost,0)) AS total_billing_amount,
    RANK() OVER (
        PARTITION BY p.city
        ORDER BY SUM(COALESCE(b.consultation_fee,0) + COALESCE(b.medicine_cost,0)) DESC
    ) AS rank_num
FROM Patients p
LEFT JOIN Billing b
    ON p.patient_id = b.patient_id
WHERE p.city IS NOT NULL
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    p.city;

-- 9) Rank billing records by absolute discount value (highest discount first).
SELECT
    bill_id,
    discount,
    RANK() OVER (
        ORDER BY ABS(discount) DESC
    ) AS rank_row
FROM Billing;


-- 10) Rank patients based on maximum discount received.
SELECT
    patient_id,
    MAX(discount) AS max_discount,
    RANK() OVER (
        ORDER BY MAX(discount) DESC
    ) AS rn
FROM Billing
GROUP BY patient_id;


-- 11) Rank billing entries per doctor based on consultation_fee.
SELECT
    bill_id,
	doctor_id,
	consultation_fee,
	RANK() OVER(PARTITION BY doctor_id ORDER BY CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END, consultation_fee DESC) AS Rn
FROM Billing;

-- 12) Rank doctors based on average consultation_fee.
SELECT
    doctor_id,
	AVG(consultation_fee) AS avg_fee,
	RANK() OVER(ORDER BY AVG(consultation_fee) DESC) AS Rn
FROM Billing
WHERE consultation_fee IS NOT NULL
GROUP BY doctor_id;

-- 13) Rank patients by number of visits.
SELECT
    patient_id,
	COUNT(visit_id) AS Number_of_visits,
	RANK() OVER(ORDER BY COUNT(visit_id) DESC) AS Rn
FROM Visits
GROUP BY patient_id;

-- 14) Rank patients within gender based on number of visits.
SELECT
    p.patient_id,
	p.gender,
	COUNT(v.visit_id) AS Number_of_visits,
	RANK() OVER(PARTITION BY p.gender ORDER BY COUNT(v.visit_id) DESC) AS Rn
FROM patients p
LEFT JOIN  Visits v
ON p.patient_id = v.patient_id
GROUP BY p.patient_id,p.gender;

-- 15) Rank visits by created_date (latest first).
SELECT
    visit_id,
	visit_date,
	RANK() OVER(ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date DESC) AS Rank_visits_latest_date
FROM Visits;

-- 16) Rank visits per doctor by visit_date.
SELECT
    visit_id,
	doctor_id,
	RANK() OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date DESC) AS Rank_per_doc
FROM Visits;

-- 17) Rank patients based on total medicine_cost.
SELECT
    patient_id,
    SUM(COALESCE(medicine_cost, 0)) AS total_medicine_cost,
    RANK() OVER (
        ORDER BY SUM(COALESCE(medicine_cost, 0)) DESC
    ) AS rank_patients
FROM Billing
GROUP BY patient_id;

-- 18) Rank patients within each city by medicine_cost.
SELECT 
    p.patient_id,
    p.city,
    SUM(COALESCE(b.medicine_cost, 0)) AS total_medicine_cost,
    RANK() OVER (
        PARTITION BY p.city
        ORDER BY SUM(COALESCE(b.medicine_cost, 0)) DESC
    ) AS rank_patients
FROM Patients p
LEFT JOIN Billing b
    ON p.patient_id = b.patient_id
WHERE p.city IS NOT NULL
GROUP BY p.patient_id, p.city;

-- 19) Rank billing records ignoring NULL consultation_fee.
SELECT
    bill_id,
	consultation_fee,
	RANK() OVER(ORDER BY CASE WHEN consultation_fee IS  NULL THEN 1 ELSE 0 END,consultation_fee DESC) AS Rank_bill_records
FROM Billing;

-- 20) Rank billing records pushing NULL discounts to the bottom.
SELECT
    bill_id,
	discount,
	RANK() OVER(ORDER BY CASE WHEN discount IS  NULL THEN 1 ELSE 0 END,discount DESC) AS Rank_bill_records
FROM Billing;

-- 21) Rank vital readings per patient based on bp_systolic.
SELECT
    reading_id,
	patient_id,
	bp_systolic,
	RANK() OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_systolic IS NULL THEN 1 ELSE 0 END, bp_systolic DESC) AS Rank_vital_reading
FROM VitalReadings;

-- 22) Rank vital readings per patient based on bp_diastolic.
SELECT
    reading_id,
	patient_id,
	bp_diastolic,
	RANK() OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_diastolic IS NULL THEN 1 ELSE 0 END, bp_diastolic DESC) AS Rank_vital_reading
FROM VitalReadings;

-- 23) Rank patients based on highest recorded bp_systolic.
SELECT
    patient_id,
	MAX(bp_systolic) AS Max_bp,
	RANK() OVER(ORDER BY MAX(bp_systolic) DESC) AS Rank_patients
FROM VitalReadings
GROUP BY patient_id;

SELECT 
    p.patient_id,
	MAX(v.bp_systolic) AS Max_bp,
	RANK() OVER(ORDER BY MAX(v.bp_systolic) DESC) AS Rank_patients
FROM Patients p
LEFT JOIN VitalReadings v
ON p.patient_id= v.patient_id
GROUP BY p.patient_id;

-- 24) Rank patients by average bp_systolic.
SELECT 
    p.patient_id,
	AVG(v.bp_systolic) AS AVG_Bp,
	RANK() OVER(ORDER BY AVG(v.bp_systolic) DESC) AS Rank_patients
FROM Patients p
LEFT JOIN VitalReadings v
ON p.patient_id= v.patient_id
GROUP BY p.patient_id;

-- 25) Rank patients per age group (age < 40, 40–60, >60) using RANK().
SELECT
    patient_id,
    CONCAT(first_name,' ',last_name) AS full_name,
    age,
    CASE
        WHEN age < 40 THEN 'YOUNG'
        WHEN age BETWEEN 40 AND 60 THEN 'ADULT'
        ELSE 'OLD'
    END AS age_group,
    RANK() OVER(
        PARTITION BY CASE
                         WHEN age < 40 THEN 'YOUNG'
                         WHEN age BETWEEN 40 AND 60 THEN 'ADULT'
                         ELSE 'OLD'
                     END
        ORDER BY age DESC
    ) AS rank_per_age_group
FROM Patients;

-- 26) Rank visits based on diagnosis alphabetically.
SELECT
    visit_id,
	diagnosis,
	RANK() OVER(ORDER BY CASE WHEN diagnosis IS NULL THEN 1 ELSE 0 END, diagnosis ASC) AS Rank_visits
FROM Visits;


-- 27) Rank patients by earliest visit_date.
SELECT
    patient_id,
	MIN(visit_date) AS earliest_date,
	RANK() OVER(ORDER BY CASE WHEN MIN(visit_date) IS NULL THEN 1 ELSE 0 END,MIN(visit_date) ASC) AS Rank_patients_earliest
FROM Visits
GROUP BY patient_id;

-- 28) Rank patients by latest visit_date.
SELECT
    patient_id,
	MAX(visit_date) AS Latest_date,
	RANK() OVER(ORDER BY CASE WHEN MAX(visit_date) IS NULL THEN 1 ELSE 0 END, MAX(visit_date) DESC) AS Rank_patients_latest
FROM Visits
GROUP BY patient_id;

-- 29) Rank doctors by total billing revenue.
SELECT
    doctor_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0) -COALESCE(discount,0)) AS Total_billing_revenue,
	RANK() OVER(ORDER BY SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0) -COALESCE(discount,0)) DESC) AS Rank_doc_total_revenue
FROM Billing
GROUP BY doctor_id;


-- 30) Rank doctors within department by billing revenue.
SELECT
    d.doctor_id,
	d.department,
	SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0) -COALESCE(b.discount,0)) AS Total_billing_revenue,
	RANK() OVER(PARTITION BY d.department 
	ORDER BY SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0) -COALESCE(b.discount,0)) DESC) AS Rank_doc_total_revenue
FROM Doctors d
LEFT JOIN Billing b
ON d.doctor_id= b.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.doctor_id, d.department
;

-- 31) Rank billing records per patient by created_date.
SELECT
    bill_id,
	patient_id,
	created_date,
	RANK() OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END , created_date) AS Rank_bill_records
FROM Billing;

-- 32) Rank visits per patient where visit_status = 'COMPLETED'.
SELECT
    visit_id,
	patient_id,
	visit_status,
	RANK() OVER(PARTITION BY patient_id ORDER BY visit_id DESC)  AS Rank_visits
FROM Visits
WHERE visit_status = 'COMPLETED';

-- 33) Rank visits per department based on visit_cost.
SELECT
    visit_id,
	department,
	visit_cost,
	RANK() OVER(PARTITION BY department ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost DESC) AS Rank_visits
FROM Visits
WHERE department IS NOT NULL;

-- 34) Rank patients based on number of prescriptions received.
SELECT 
    v.patient_id,
	COUNT(p.prescription_id) AS Number_prescriptions,
	RANK() OVER(ORDER BY COUNT(p.prescription_id) DESC) AS Rank_patients
FROM visits v
LEFT JOIN prescriptions p
ON v.visit_id = p.visit_id
GROUP BY v.patient_id;

SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_name,
	COUNT(pr.prescription_id) AS Number_prescriptions,
	RANK() OVER(ORDER BY COUNT(pr.prescription_id) DESC) AS Rank_patients
FROM visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id
LEFT JOIN prescriptions pr
on v.visit_id= pr.visit_id
GROUP BY p.patient_id,p.first_name,p.last_name;

-- 35) Rank medications based on frequency prescribed.
SELECT
    prescription_id,
    COUNT(medication_name) AS total_medications,
    RANK() OVER(ORDER BY COUNT(medication_name) DESC) AS Rank_medication
FROM Prescriptions
GROUP BY prescription_id;

-- 36) Rank patients by total tax  amount paid.
SELECT
    patient_id,
    SUM(
        (COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0) - COALESCE(discount,0))
        * COALESCE(tax_percent,0) / 100
    ) AS Total_tax_amount,
    RANK() OVER(
        ORDER BY SUM(
            (COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0) - COALESCE(discount,0))
            * COALESCE(tax_percent,0) / 100
        ) DESC
    ) AS Rank_patients
FROM Billing
GROUP BY patient_id;

-- 37) Rank billing records by net payable amount.
SELECT
    bill_id,
    (COALESCE(consultation_fee,0) 
     + COALESCE(medicine_cost,0) 
     - COALESCE(discount,0)
    ) AS net_payable_amount,
    RANK() OVER(
        ORDER BY
            (COALESCE(consultation_fee,0) 
             + COALESCE(medicine_cost,0) 
             - COALESCE(discount,0)
            ) DESC
    ) AS Rank_bills
FROM Billing;

-- 38) Rank doctors based on number of unique patients treated.
SELECT
    doctor_id,
	COUNT(DISTINCT patient_id) AS unique_patients_total,
	RANK() OVER(ORDER BY COUNT(DISTINCT patient_id) DESC) AS Rank_doctors
FROM Visits
GROUP BY doctor_id;

-- 39) Rank patients within each city by age, handling NULL ages last.
SELECT
    patient_id,
	city,
	age,
	RANK() OVER(PARTITION BY city ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age) Rank_patients
FROM Patients
WHERE city IS NOT NULL;

-- 40) Rank billing records per doctor by discount amount.
SELECT
    bill_id,
	doctor_id,
	discount,
	RANK() OVER(PARTITION BY doctor_id ORDER BY CASE WHEN discount IS NULL THEN 1 ELSE 0 END,discount DESC) AS Rank_records
FROM Billing;


-- 41) Rank visits per patient by visit_cost but exclude NULL visit_cost.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	RANK() OVER(PARTITION BY patient_id ORDER BY visit_cost DESC) AS Rank_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;

-- 42) Rank patients by consultation_fee only (highest consultation).
SELECT
    patient_id,
	MAX(COALESCE(consultation_fee,0)) AS highest_fee,
	RANK() OVER(ORDER BY MAX(COALESCE(consultation_fee,0)) DESC) AS Rank_patient_highest_fee
FROM Billing
GROUP BY patient_id;

-- 43) Rank doctors by maximum single consultation_fee.
SELECT
    doctor_id,
	MAX(COALESCE(consultation_fee,0)) AS highest_fee,
	RANK() OVER(ORDER BY MAX(COALESCE(consultation_fee,0)) DESC) AS Rank_patient_highest_fee
FROM Billing
GROUP BY doctor_id;

-- 44) Rank billing records per month based on total revenue.
SELECT
    bill_id,
	created_date,
	YEAR(created_date) AS Year_created_date,
	MONTH(created_date) AS Month_created_date,
    (COALESCE(consultation_fee,0) 
     + COALESCE(medicine_cost,0) 
     - COALESCE(discount,0)
    ) AS Total_revenue,
    RANK() OVER( PARTITION BY YEAR(created_date), MONTH(created_date)
        ORDER BY
            (COALESCE(consultation_fee,0) 
             + COALESCE(medicine_cost,0) 
             - COALESCE(discount,0)
            ) DESC
    ) AS Rank_bills
FROM Billing
WHERE created_date IS NOT NULL;


-- 45) Rank patients by number of completed vs pending visits.
SELECT
    patient_id,
	visit_status,
	COUNT(visit_id) AS Number_of_visits,
	RANK() OVER(PARTITION BY visit_status ORDER BY COUNT(visit_id) DESC) AS Total_visits_per_patient_rank
FROM Visits
GROUP BY patient_id, visit_status;

-- 46) Rank vital readings by reading_date per patient.
SELECT
    patient_id,
	reading_id,
	reading_date,
	RANK() OVER(PARTITION BY patient_id ORDER BY reading_date DESC) AS Rank_vital_reading
FROM VitalReadings;

-- 47) Rank visits per doctor by visit_status priority (COMPLETED first).
SELECT
    visit_id,
    doctor_id,
	visit_status,
	RANK() OVER(PARTITION BY doctor_id ORDER BY  CASE WHEN visit_status = 'COMPLETED' THEN 0 ELSE 1 END) AS Rank_visits
FROM Visits;

-- 48) Rank patients based on combined consultation_fee + medicine_cost + tax.
SELECT
    patient_id,
    SUM(
        COALESCE(consultation_fee, 0)
      + COALESCE(medicine_cost, 0)
      + COALESCE(tax_percent, 0)
    ) AS Total_amount,
    RANK() OVER(
        ORDER BY SUM(
            COALESCE(consultation_fee, 0)
          + COALESCE(medicine_cost, 0)
          + COALESCE(tax_percent, 0)
        ) DESC
    ) AS Rank_patients
FROM Billing
GROUP BY patient_id;

-- 49) Rank patients within each gender by total billing.
SELECT 
    p.patient_id,
	p.gender,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_billing,
	RANK() OVER(PARTITION BY p.gender ORDER BY SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0))DESC) AS Rank_patients
FROM Patients p
LEFT JOIN Billing b
ON p.patient_id= b.patient_id
GROUP BY p.patient_id,p.gender;

-- 50) Rank doctors based on total visits where diagnosis IS NOT NULL.
SELECT
    doctor_id,
	COUNT(visit_id) AS Total_visits,
	RANK() OVER (ORDER BY COUNT(visit_id) DESC) AS Rank_doctors
FROM Visits
WHERE diagnosis IS NOT NULL
GROUP BY doctor_id;

