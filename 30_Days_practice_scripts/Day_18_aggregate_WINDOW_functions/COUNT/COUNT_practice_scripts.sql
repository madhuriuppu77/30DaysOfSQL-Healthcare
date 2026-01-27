-- 1) Count total visits for each patient without collapsing rows
SELECT 
    v.visit_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	COUNT(v.visit_id) OVER(PARTITION BY p.patient_id) AS Total_visits
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id;

-- 2) Count total visits per patient using COUNT() OVER(PARTITION BY patient_id)
SELECT 
    v.visit_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	COUNT(v.visit_id) OVER(PARTITION BY p.patient_id) AS Total_visits
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id;

-- 3) Show each visit with total number of visits done by that patient
SELECT 
    v.visit_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	COUNT(v.visit_id) OVER(PARTITION BY p.patient_id) AS Total_visits
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id;

-- 4) Count how many visits each doctor has handled (window function only)
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	COUNT(v.visit_id) OVER(PARTITION BY d.doctor_id) AS Total_visits_per_doc
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id;

-- 5) Display each visit along with total visits for that doctor
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	COUNT(v.visit_id) OVER(PARTITION BY d.doctor_id) AS Total_visits_per_doc
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id;

-- 6) Count number of visits per department without using GROUP BY

SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	d.department,
	COUNT(v.visit_id) OVER(PARTITION BY d.department) AS Total_visits_per_doc
FROM Visits v
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL;

-- 7) Show visit details with department-wise visit count.
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	d.department,
	COUNT(v.visit_id) OVER(PARTITION BY d.department) AS Total_visits_per_doc
FROM Visits v
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL;

-- 8) Count number of completed vs pending visits using COUNT() OVER with PARTITION BY visit_status
SELECT
    visit_id,
	visit_status,
	COUNT(visit_id) OVER(PARTITION BY visit_status) AS Total_visits_per_status
FROM Visits;

-- 9) Show each visit with count of visits having same visit_status.
SELECT
    visit_id,
	visit_status,
	COUNT(visit_id) OVER(PARTITION BY visit_status) AS Total_visits_per_status
FROM Visits;

-- 10) Count number of visits per patient per department using window function
SELECT 
    v.visit_id,
    p.patient_id,
    d.department,
    COUNT(*) OVER (
        PARTITION BY p.patient_id, d.department
    ) AS Visits_per_patient_per_department
FROM Visits v
INNER JOIN Patients p
    ON v.patient_id = p.patient_id
INNER JOIN Doctors d
    ON v.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL;


-- 11) Count total bills generated per patient using COUNT() OVER
SELECT 
    p.patient_id,
	b.bill_id,
	CONCAT(p.first_name,' ',p.last_name) AS patient_Full_Name,
	COUNT(bill_id) OVER(PARTITION BY p.patient_id) AS Total_bills_per_patient
FROM Billing b
LEFT JOIN patients p
ON b.patient_id= p.patient_id;

-- 12) Show each billing record with total bills for that patient
SELECT 
    p.patient_id,
	b.bill_id,
	CONCAT(p.first_name,' ',p.last_name) AS patient_Full_Name,
	COUNT(bill_id) OVER(PARTITION BY p.patient_id) AS Total_bills_per_patient
FROM Billing b
LEFT JOIN patients p
ON b.patient_id= p.patient_id;

-- 13) Count number of bills per doctor without GROUP BY
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	COUNT(b.bill_id) OVER(PARTITION BY d.doctor_id) AS Total_bills_per_doc
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id;

-- 14) Display billing rows with doctor-wise bill count
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	COUNT(b.bill_id) OVER(PARTITION BY d.doctor_id) AS Total_bills_per_doc
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id;

-- 15) Count how many bills exist for each consultation_fee value
SELECT 
    bill_id,
	consultation_fee,
	COUNT(bill_id) OVER (PARTITION BY consultation_fee) AS Total_bills_each_consul_fee
FROM Billing
WHERE consultation_fee IS NOT NULL;


-- 16) Show duplicate consultation_fee rows with count using window function.
SELECT * FROM
(
SELECT 
    bill_id,
	consultation_fee,
	COUNT(bill_id) OVER (PARTITION BY consultation_fee) AS Total_bills_each_consul_fee
FROM Billing
WHERE consultation_fee IS NOT NULL)t
WHERE Total_bills_each_consul_fee > 1;


-- 17) Count total billing records in the entire table using COUNT() OVER()
SELECT
    bill_id,
	COUNT(*) OVER() AS Total_billing_record
FROM Billing;

-- 18) Show each bill with total number of rows in Billing table
SELECT
    bill_id,
	COUNT(*) OVER(PARTITION BY bill_id) AS Total_billing_record
FROM Billing;

-- 19) Count number of bills per created_date using window function
SELECT
    bill_id,
	created_date,
	COUNT(bill_id) OVER(PARTITION BY created_date ) AS bill_per_created_date
FROM Billing
WHERE created_date IS NOT NULL;

-- 20) Display billing data with date-wise bill count
SELECT
    bill_id,
	created_date,
	COUNT(bill_id) OVER(PARTITION BY created_date ) AS bill_per_created_date
FROM Billing
WHERE created_date IS NOT NULL;

-- 21) Count number of prescriptions per visit using COUNT() OVER
SELECT 
    p.prescription_id,
	v.visit_id,
	COUNT(p.prescription_id) OVER(PARTITION BY v.visit_id) AS Total_prescriptions_per_visits
FROM Visits v
LEFT JOIN Prescriptions p
ON v.visit_id= p.visit_id;

-- 22) Show each prescription with count of prescriptions for that visit.
SELECT 
    p.prescription_id,
	v.visit_id,
	COUNT(p.prescription_id) OVER(PARTITION BY v.visit_id) AS Total_prescriptions_per_visits
FROM Visits v
LEFT JOIN Prescriptions p
ON v.visit_id= p.visit_id;

-- 23) Count how many prescriptions have NULL medication_name using window function.
SELECT
    prescription_id,
	medication_name,
	COUNT(prescription_id) OVER() AS Total_null_prescription
FROM Prescriptions
WHERE medication_name IS NULL;

-- 24) Show each prescription row with total prescriptions having NULL dosage
SELECT
    prescription_id,
	dosage,
	COUNT(prescription_id) OVER() AS Total_null_dosage
FROM Prescriptions
WHERE dosage IS NULL;

-- 25) Count number of prescriptions per patient by joining Visits and Prescriptions using window function.
SELECT 
    p.prescription_id,
	v.patient_id,
	COUNT(p.prescription_id) OVER(PARTITION BY v.patient_id) AS Total_prescriptions_per_patient
FROM Prescriptions p
LEFT JOIN visits v
ON p.visit_id= v.visit_id;

-- 26) Count number of patients per city using COUNT() OVER
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	city,
	COUNT(patient_id) OVER(PARTITION BY city) AS Total_patients_per_city
FROM Patients
WHERE city IS NOT NULL;

SELECT
	
	city,
	COUNT(patient_id)  AS Total_patients_per_city
FROM Patients
WHERE city IS NOT NULL
GROUP BY city;


-- 27) Show each patient with total patients in the same city.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	city,
	COUNT(patient_id) OVER(PARTITION BY city) AS Total_patients_per_city
FROM Patients
WHERE city IS NOT NULL;

-- 28) Count number of male and female patients using window function.
SELECT
    patient_id,
	gender,
	COUNT(patient_id) OVER(PARTITION BY gender) AS number_patients_gender
FROM Patients
WHERE gender IS NOT NULL;

-- 29) Display patient rows with gender-wise patient count
SELECT
    patient_id,
	gender,
	COUNT(patient_id) OVER(PARTITION BY gender) AS number_patients_gender
FROM Patients
WHERE gender IS NOT NULL;

-- 30) Count patients having NULL phone numbers using COUNT() OVER
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	phone,
	COUNT(patient_id) OVER(PARTITION BY phone) AS Total_Null_phones
FROM Patients
WHERE phone IS NULL;


-- 31) Count number of visits per month using COUNT() OVER with DATE functions.
SELECT
    visit_id,
	visit_date,
	FORMAT(visit_date,'MMMM') AS Month_visit_date,
	COUNT(visit_id) OVER(PARTITION BY MONTH(visit_date)) AS Total_visits_per_month
FROM visits
WHERE visit_date IS NOT NULL;

-- 32) Show visit rows with QUARTERLY-wise visit count.
SELECT
    visit_id,
	visit_date,
	DATEPART(QUARTER ,visit_date) AS Quarter_visit_date,
	COUNT(visit_id) OVER(PARTITION BY DATEPART(QUARTER ,visit_date)) AS Total_visits_per_month
FROM visits
WHERE visit_date IS NOT NULL;

-- 33) Count number of visits per year using window function.
SELECT
    visit_id,
	visit_date,
	YEAR(visit_date) AS Year_visit_date,
	COUNT(visit_id) OVER(PARTITION BY YEAR(visit_date)) AS Total_visits_per_Year
FROM visits
WHERE visit_date IS NOT NULL;

-- 34) Display visit details with WEEKEND-wise visit count
SELECT
    visit_id,
    visit_date,
    DATENAME(WEEKDAY, visit_date) AS weekday_name,
    COUNT(visit_id) OVER () AS total_weekend_visits
FROM Visits
WHERE visit_date IS NOT NULL
  AND DATEPART(WEEKDAY, visit_date) IN (1, 7) -- Sunday & Saturday
  AND YEAR(visit_date) = 2024
  AND MONTH(visit_date) = 5;

-- 35) Count number of visits per patient ordered by visit_date (cumulative count)

SELECT
    visit_id,
    patient_id,
    visit_date,
    COUNT(visit_id) OVER(
        PARTITION BY patient_id
        ORDER BY visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_visits_per_patient
FROM Visits
WHERE visit_date IS NOT NULL;

-- 36) Show running count of visits for each patient ordered by visit_date.
SELECT
    visit_id,
	patient_id,
	visit_date,
	COUNT(visit_id) OVER(PARTITION BY patient_id ORDER BY visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total
FROM Visits
WHERE visit_date IS NOT NULL;

-- 37) Count visits per doctor ordered by visit_date using COUNT() OVER
SELECT
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Doc_full_name,
	v.visit_date,
	COUNT(v.visit_id) OVER(PARTITION BY d.doctor_id ORDER BY v.visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Total_visits_per_doc
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE visit_date IS NOT NULL;

-- 38) Show cumulative visit count per doctor
SELECT
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Doc_full_name,
	v.visit_date,
	COUNT(v.visit_id) OVER(PARTITION BY d.doctor_id ORDER BY v.visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumilative_visit_count
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE visit_date IS NOT NULL;

-- 39) Count number of billing records per patient ordered by created_date
SELECT
    bill_id,
	patient_id,
	created_date,
	COUNT(bill_id) OVER(PARTITION BY patient_id ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_bills_per_patient
FROM Billing
WHERE created_date IS NOT NULL;

-- 40) Show running count of bills per patient
SELECT
    bill_id,
	patient_id,
	created_date,
	COUNT(bill_id) OVER(PARTITION BY patient_id ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total
FROM Billing
WHERE created_date IS NOT NULL;

-- 41) Count number of visits where diagnosis is NOT NULL using window function.
SELECT
    visit_id,
	diagnosis,
	COUNT(*) OVER() AS Number_of_visits
FROM Visits
WHERE diagnosis IS NOT NULL;

-- 42) Show each visit with count of non-NULL diagnoses
SELECT
    visit_id,
	diagnosis,
	COUNT(*) OVER() AS Number_of_visits
FROM Visits
WHERE diagnosis IS NOT NULL;

-- 43) Count number of visits per department where department is NULL vs NOT NULL
SELECT DISTINCT
    department_status,
    COUNT(*) OVER (PARTITION BY department_status) AS visit_count
FROM (
    SELECT
        CASE
            WHEN department IS NULL THEN 'NULL'
            ELSE 'NOT NULL'
        END AS department_status
    FROM Visits
) t;


-- 44) Display visit rows with NULL-department count using COUNT() OVER
SELECT
    visit_id,
    department,
    COUNT(*) OVER () AS total_visits,
    COUNT(CASE WHEN department IS NULL THEN 1 END) OVER () AS null_department_visits
FROM Visits;


-- 45) Count number of visits per patient where visit_cost > 600 using window function
SELECT
    visit_id,
    patient_id,
    visit_cost,
    COUNT(*) OVER(PARTITION BY patient_id) AS total_visits_per_patient,
    COUNT(CASE WHEN visit_cost > 600 THEN 1 END) 
        OVER(PARTITION BY patient_id) AS visits_over_600
FROM Visits;


-- 46) Count number of vital readings per patient using COUNT() OVER

SELECT
    reading_id,
	patient_id,
	COUNT(*) OVER(PARTITION BY patient_id) AS Total_readings
FROM VitalReadings;

-- 47) Show each vital reading with total readings for that patient.
SELECT
    reading_id,
	patient_id,
	COUNT(*) OVER(PARTITION BY patient_id) AS Total_readings
FROM VitalReadings;

-- 48) Count number of blood pressure readings per patient ordered by reading_date.


SELECT
    reading_id,
	patient_id,
	COUNT(*) OVER(PARTITION BY patient_id ORDER BY reading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Total_readings
	
FROM VitalReadings;

-- 49) Show running count of vital readings per patient.
SELECT
    reading_id,
	patient_id,
	COUNT(*) OVER(PARTITION BY patient_id ORDER BY reading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total
	
FROM VitalReadings;

-- 50) Count total vital readings in the table and display it on every row
SELECT
    reading_id,
	patient_id,
	COUNT(*) OVER() AS Total_readings
FROM VitalReadings;

