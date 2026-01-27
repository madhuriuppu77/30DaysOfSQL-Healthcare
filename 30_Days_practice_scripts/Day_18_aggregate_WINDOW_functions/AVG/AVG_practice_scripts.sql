/* =========================================================
   AVG() WINDOW FUNCTION PRACTICE — 1 TO 50
   Healthcare Schema
   ========================================================= */

-- 1) Find the average age of patients using AVG() as a window function without collapsing rows.
SELECT
    patient_id,
    first_name,
    last_name,
    age,
    AVG(age) OVER() AS avg_age
FROM Patients
WHERE age IS NOT NULL;
-- Explanation: OVER() calculates overall average without GROUP BY


-- 2) Display each patient along with the average age of all patients.
SELECT
    patient_id,
    first_name,
    last_name,
    age,
    AVG(age) OVER() AS avg_age
FROM Patients
WHERE age IS NOT NULL;
-- Explanation: Same as Q1, overall average repeated for each row


-- 3) Show each patient and the average age partitioned by gender using AVG() OVER().
SELECT
    patient_id,
    gender,
    age,
    AVG(age) OVER(PARTITION BY gender) AS avg_age_by_gender
FROM Patients
WHERE age IS NOT NULL;
-- Explanation: Partition creates gender-wise averages


-- 4) Calculate the average age of patients per city using a window function.
SELECT
    patient_id,
    city,
    age,
    AVG(age) OVER(PARTITION BY city) AS avg_age_by_city
FROM Patients
WHERE age IS NOT NULL AND city IS NOT NULL;
-- Explanation: Average calculated separately per city


-- 5) Display each patient with the average age of patients in their city.
SELECT
    patient_id,
    city,
    age,
    AVG(age) OVER(PARTITION BY city) AS avg_age_by_city
FROM Patients
WHERE age IS NOT NULL;
-- Explanation: Same logic as Q4, row-level output preserved


-- 6) Find the average consultation_fee across all billing records using a window function.
SELECT
    bill_id,
    consultation_fee,
    AVG(consultation_fee) OVER() AS avg_consultation_fee
FROM Billing
WHERE consultation_fee IS NOT NULL;
-- Explanation: Overall average across Billing table


-- 7) Show each billing record along with the overall average consultation_fee.
SELECT
    bill_id,
    consultation_fee,
    AVG(consultation_fee) OVER() AS avg_consultation_fee
FROM Billing
WHERE consultation_fee IS NOT NULL;
-- Explanation: Same as Q6


-- 8) Calculate the average consultation_fee per doctor using AVG() OVER(PARTITION BY doctor_id).
SELECT
    bill_id,
    doctor_id,
    consultation_fee,
    AVG(consultation_fee) OVER(PARTITION BY doctor_id) AS avg_fee_per_doctor
FROM Billing
WHERE consultation_fee IS NOT NULL;
-- Explanation: Doctor-wise partitioning


-- 9) Display each billing row with the average medicine_cost per patient.
SELECT
    bill_id,
    patient_id,
    medicine_cost,
    AVG(medicine_cost) OVER(PARTITION BY patient_id) AS avg_medicine_cost
FROM Billing
WHERE medicine_cost IS NOT NULL;
-- Explanation: Patient-level average


-- 10) Find the average total bill amount (consultation_fee + medicine_cost) using a window function.
SELECT
    bill_id,
    (COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0)) AS total_bill,
    AVG(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0)) OVER() AS avg_total_bill
FROM Billing;
-- Explanation: Expression can be used directly inside AVG()


-- 11) Calculate the average visit_cost across all visits using AVG() OVER().
SELECT
    visit_id,
    visit_cost,
    AVG(visit_cost) OVER() AS avg_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;
-- Explanation: Overall visit cost average


-- 12) Display each visit with the average visit_cost per department.
SELECT
    visit_id,
    department,
    visit_cost,
    AVG(visit_cost) OVER(PARTITION BY department) AS avg_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;
-- Explanation: Department-wise average


-- 13) Find the average visit_cost per doctor without using GROUP BY.
SELECT
    visit_id,
    doctor_id,
    visit_cost,
    AVG(visit_cost) OVER(PARTITION BY doctor_id) AS avg_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;
-- Explanation: Window function replaces GROUP BY


-- 14) Show each visit along with the average visit_cost for that patient.
SELECT
    visit_id,
    patient_id,
    visit_cost,
    AVG(visit_cost) OVER(PARTITION BY patient_id) AS avg_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;
-- Explanation: Patient-level partition


-- 15) Calculate the running average of visit_cost ordered by visit_date.
SELECT
    visit_id,
    visit_date,
    visit_cost,
    AVG(visit_cost) OVER(
        ORDER BY visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_avg
FROM Visits;
-- Explanation: Running average grows row by row


-- 16) Display the moving average of visit_cost for each patient ordered by visit_date.
SELECT
    visit_id,
    patient_id,
    visit_date,
    visit_cost,
    AVG(visit_cost) OVER(
        PARTITION BY patient_id
        ORDER BY visit_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM Visits;
-- Explanation: Moving average of last 3 visits


-- 17) Find the average BP systolic reading across all patients using a window function.
SELECT
    reading_id,
    bp_systolic,
    AVG(bp_systolic) OVER() AS avg_bp_systolic
FROM VitalReadings
WHERE bp_systolic IS NOT NULL;
-- Explanation: Overall BP systolic average


-- 18) Display each vital reading with the average bp_systolic per patient.
SELECT
    reading_id,
    patient_id,
    bp_systolic,
    AVG(bp_systolic) OVER(PARTITION BY patient_id) AS avg_bp_systolic
FROM VitalReadings;
-- Explanation: Patient-wise average


-- 19) Calculate the average bp_diastolic per patient using AVG() OVER().
SELECT
    reading_id,
    patient_id,
    bp_diastolic,
    AVG(bp_diastolic) OVER(PARTITION BY patient_id) AS avg_bp_diastolic
FROM VitalReadings;
-- Explanation: Partition by patient


-- 20) Show each vital reading along with the overall average bp_diastolic.
SELECT
    reading_id,
    bp_diastolic,
    AVG(bp_diastolic) OVER() AS avg_bp_diastolic
FROM VitalReadings;
-- Explanation: Overall average


-- 21) Find the average bp_systolic per day using a window function.
SELECT
    reading_id,
    reading_date,
    bp_systolic,
    AVG(bp_systolic) OVER(PARTITION BY reading_date) AS avg_bp_per_day
FROM VitalReadings;
-- Explanation: Partition by date


-- 22) Calculate the running average of bp_systolic ordered by reading_date.
SELECT
    reading_id,
    reading_date,
    bp_systolic,
    AVG(bp_systolic) OVER(
        ORDER BY reading_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_avg
FROM VitalReadings;
-- Explanation: Cumulative average


-- 23) Display each prescription with the average dosage count per visit using a window function.
SELECT
    prescription_id,
    visit_id,
    COUNT(*) OVER(PARTITION BY visit_id) AS dosage_count,
    AVG(COUNT(*)) OVER() AS avg_dosage_per_visit
FROM Prescriptions
GROUP BY prescription_id, visit_id;
-- Explanation: Nested aggregation logic


-- 24) Find the average number of visits per patient using AVG() OVER().
SELECT
    patient_id,
    AVG(total_visits) OVER() AS avg_visits
FROM (
    SELECT patient_id, COUNT(*) AS total_visits
    FROM Visits
    GROUP BY patient_id
) t;
-- Explanation: First count per patient, then average


-- 25) Display each visit with the average number of visits per doctor.
SELECT
    doctor_id,
    AVG(total_visits) OVER() AS avg_visits
FROM (
    SELECT doctor_id, COUNT(*) AS total_visits
    FROM Visits
    GROUP BY doctor_id
) t;
-- Explanation: Two-step aggregation


-- 26) Calculate the average age of patients who have visits.
SELECT
    patient_id,
    age,
    AVG(age) OVER() AS avg_age
FROM Patients
WHERE patient_id IN (SELECT DISTINCT patient_id FROM Visits);
-- Explanation: Only patients with visits considered


-- 27) Show each doctor with the average visit_cost of their patients.
SELECT
    doctor_id,
    visit_cost,
    AVG(visit_cost) OVER(PARTITION BY doctor_id) AS avg_visit_cost
FROM Visits;
-- Explanation: Doctor-wise average


-- 28) Find the average consultation_fee per department using AVG() OVER().
SELECT
    department,
    consultation_fee,
    AVG(consultation_fee) OVER(PARTITION BY department) AS avg_fee
FROM Billing b
JOIN Doctors d ON b.doctor_id = d.doctor_id;
-- Explanation: Join + partition


-- 29) Display each billing record with the average discount applied across all bills.
SELECT
    bill_id,
    discount,
    AVG(discount) OVER() AS avg_discount
FROM Billing;
-- Explanation: Overall discount average


-- 30) Calculate the average absolute discount using ABS() and AVG() as a window function.
SELECT
    bill_id,
    discount,
    AVG(ABS(discount)) OVER() AS avg_abs_discount
FROM Billing;
-- Explanation: ABS inside AVG()


-- 31) Show each billing record with the average tax_percent across all records.
SELECT
    bill_id,
    tax_percent,
    AVG(tax_percent) OVER() AS avg_tax
FROM Billing;
-- Explanation: Global average


-- 32) Find the average tax_percent per doctor using a window function.
SELECT
    bill_id,
    doctor_id,
    tax_percent,
    AVG(tax_percent) OVER(PARTITION BY doctor_id) AS avg_tax
FROM Billing;
-- Explanation: Doctor-level partition


-- 33) Display each visit with the average visit_cost for completed visits only.
SELECT
    visit_id,
    visit_cost,
    AVG(visit_cost) OVER() AS avg_completed_cost
FROM Visits
WHERE visit_status = 'COMPLETED';
-- Explanation: Filter before window execution


-- 34) Calculate the average visit_cost per visit_status using AVG() OVER().
SELECT
    visit_id,
    visit_status,
    visit_cost,
    AVG(visit_cost) OVER(PARTITION BY visit_status) AS avg_cost
FROM Visits;
-- Explanation: Status-wise average


-- 35) Show each patient with the average visit_cost of all their visits.
SELECT
    visit_id,
    patient_id,
    visit_cost,
    AVG(visit_cost) OVER(PARTITION BY patient_id) AS avg_cost
FROM Visits;
-- Explanation: Patient partition


-- 36) Find the average age of patients per city including NULL handling.
SELECT
    patient_id,
    city,
    age,
    AVG(age) OVER(PARTITION BY city) AS avg_age
FROM Patients;
-- Explanation: AVG ignores NULLs automatically


-- 37) Display each patient with the average age of patients older than them.
SELECT
    p1.patient_id,
    p1.age,
    (
        SELECT AVG(p2.age)
        FROM Patients p2
        WHERE p2.age > p1.age
    ) AS avg_older_age
FROM Patients p1;
-- Explanation: Correlated subquery needed


-- 38) Calculate the average medicine_cost per billing date.
SELECT
    bill_id,
    created_date,
    medicine_cost,
    AVG(medicine_cost) OVER(PARTITION BY created_date) AS avg_cost
FROM Billing;
-- Explanation: Date-wise partition


-- 39) Show each billing row with the running average of consultation_fee.
SELECT
    bill_id,
    created_date,
    consultation_fee,
    AVG(consultation_fee) OVER(
        ORDER BY created_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_avg
FROM Billing;
-- Explanation: Running average


-- 40) Find the average number of billing records per patient.
SELECT
    AVG(total_bills) OVER() AS avg_bills
FROM (
    SELECT patient_id, COUNT(*) AS total_bills
    FROM Billing
    GROUP BY patient_id
) t;
-- Explanation: Two-step calculation


-- 41) Display each visit with the average visit_cost for the same month.
SELECT
    visit_id,
    visit_date,
    visit_cost,
    AVG(visit_cost) OVER(
        PARTITION BY YEAR(visit_date), MONTH(visit_date)
    ) AS avg_monthly_cost
FROM Visits;
-- Explanation: Month-level partition


-- 42) Calculate the average bp_systolic per patient for the last 3 readings.
SELECT
    reading_id,
    patient_id,
    reading_date,
    bp_systolic,
    AVG(bp_systolic) OVER(
        PARTITION BY patient_id
        ORDER BY reading_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS avg_last_3
FROM VitalReadings;
-- Explanation: Moving window frame


-- 43) Show each vital reading with the cumulative average bp_diastolic.
SELECT
    reading_id,
    bp_diastolic,
    AVG(bp_diastolic) OVER(
        ORDER BY reading_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_avg
FROM VitalReadings;
-- Explanation: Cumulative average


-- 44) Find the average visit_cost per patient excluding the current row.
SELECT
    visit_id,
    patient_id,
    visit_cost,
    AVG(visit_cost) OVER(
        PARTITION BY patient_id
        ORDER BY visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS avg_excluding_current
FROM Visits;
-- Explanation: Current row excluded using frame


-- 45) Display each billing record with the average of (consultation_fee + medicine_cost).
SELECT
    bill_id,
    (consultation_fee + medicine_cost) AS total_amount,
    AVG(consultation_fee + medicine_cost) OVER() AS avg_total
FROM Billing;
-- Explanation: Expression inside AVG()


-- 46) Calculate the average consultation_fee per doctor ordered by created_date as a running average.
SELECT
    bill_id,
    doctor_id,
    consultation_fee,
    AVG(consultation_fee) OVER(
        PARTITION BY doctor_id
        ORDER BY created_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_avg
FROM Billing;
-- Explanation: Doctor-wise running average


-- 47) Show each patient with the average visit_cost of all patients.
SELECT
    visit_id,
    patient_id,
    visit_cost,
    AVG(visit_cost) OVER() AS avg_all_patients
FROM Visits;
-- Explanation: Global average


-- 48) Find the average visit_cost per department and display it on every visit row.
SELECT
    visit_id,
    department,
    visit_cost,
    AVG(visit_cost) OVER(PARTITION BY department) AS avg_department_cost
FROM Visits;
-- Explanation: Department partition


-- 49) Display each doctor with the average visit_cost of visits handled by them.
SELECT
    visit_id,
    doctor_id,
    visit_cost,
    AVG(visit_cost) OVER(PARTITION BY doctor_id) AS avg_visit_cost
FROM Visits;
-- Explanation: Doctor-wise average


-- 50) Calculate the overall average age and display it for every patient.
SELECT
    patient_id,
    age,
    AVG(age) OVER() AS avg_age
FROM Patients
WHERE age IS NOT NULL;
-- Explanation: Overall average age shown on each row
