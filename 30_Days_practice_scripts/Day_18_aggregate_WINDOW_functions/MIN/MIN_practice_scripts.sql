-- 1) Find the minimum age across all patients using MIN() as a window function.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	MIN(age) OVER() As Minium_age
FROM Patients
WHERE age IS NOT NULL;


-- 2) Display each patient along with the minimum age among all patients.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	MIN(age) OVER() As Minium_age
FROM Patients
WHERE age IS NOT NULL;

-- 3) Find the minimum visit_cost across all visits without collapsing rows.
SELECT
    visit_id,
	visit_cost,
	MIN(visit_cost) OVER() AS Minimum_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;


-- 4) Show each visit with the minimum visit_cost per department using a window function.
SELECT
    visit_id,
	department,
	visit_cost,
	MIN(visit_cost) OVER (PARTITION BY department) AS Minimum_visit_cost_per_department
FROM Visits
WHERE department IS NOT NULL;


-- 5) Find the minimum consultation_fee across the entire Billing table using MIN() OVER().
SELECT
    bill_id,
	consultation_fee,
	MIN(consultation_fee) OVER() AS Minimum_consultation_fee
FROM Billing
WHERE consultation_fee IS NOT NULL;

-- 6) Display each billing record with the minimum consultation_fee per doctor.
SELECT 
    d.doctor_id,
	b.bill_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.consultation_fee,
	MIN(b.consultation_fee) OVER(PARTITION BY d.doctor_id) AS Minimum_doc_fee
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id
WHERE b.consultation_fee IS NOT NULL;


-- 7) Find the minimum medicine_cost per patient using a window function.
SELECT 
    b.bill_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.medicine_cost,
	MIN(b.medicine_cost) OVER(PARTITION BY p.patient_id) AS Minimum_medicine_cost
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id= p.patient_id
WHERE b.medicine_cost IS NOT NULL;


-- 8) Show each billing row with the minimum medicine_cost per created_date.
SELECT
    bill_id,
	medicine_cost,
	created_date,
	MIN(medicine_cost) OVER(PARTITION BY created_date) AS Minimum_medicine_cost
FROM Billing
WHERE medicine_cost IS NOT NULL;


-- 9) Find the minimum discount value across all billing records (including negative values).
SELECT
    bill_id,
	discount,
	MIN(discount) OVER() AS Minimum_discount
FROM Billing;


-- 10) Display each billing row with the minimum discount per doctor.
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.discount,
	MIN(b.discount) OVER (PARTITION BY d.doctor_id) AS Minimum_discount
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id = d.doctor_id;


-- 11) Find the minimum bp_systolic reading per patient using a window function.
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	v.bp_systolic,
	MIN(v.bp_systolic) OVER(PARTITION BY p.patient_id) AS Minimum_bp_systolic
FROM VitalReadings v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id
WHERE v.bp_systolic IS NOT NULL;


-- 12) Display each vital reading along with the minimum bp_diastolic per patient.
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    v.bp_diastolic,
    MIN(v.bp_diastolic) OVER(PARTITION BY p.patient_id) AS minimum_bp_diastolic
FROM VitalReadings v
LEFT JOIN Patients p
    ON v.patient_id = p.patient_id
WHERE v.bp_diastolic IS NOT NULL;


-- 13) Find the minimum bp_systolic across all patients without GROUP BY.
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	v.bp_systolic,
	MIN(v.bp_systolic) OVER() AS Minimum_bp_systolic
FROM VitalReadings v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id
WHERE v.bp_systolic IS NOT NULL;

-- 14) Show each reading with the minimum bp_systolic for that patient ordered by date.
SELECT
    reading_id,
	patient_id,
	reading_date,
	MIN(bp_systolic) OVER(PARTITION BY patient_id ORDER BY reading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Minimum_bp_systolic
FROM VitalReadings;

-- 15) Find the minimum visit_date across all visits using MIN() OVER().
SELECT
    visit_id,
	visit_date,
	MIN(visit_date) OVER() AS minimum_visit_date
FROM Visits
WHERE visit_date IS NOT NULL;


-- 16) Display each visit with the earliest visit_date per patient.
SELECT 
    v.visit_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_name,
	MIN(v.visit_date) OVER(PARTITION BY p.patient_id) AS earliest_visit_date_per_patient
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id
WHERE v.visit_date IS NOT NULL;


-- 17) Find the minimum visit_cost per visit_status using a window function.
SELECT
    visit_id,
	visit_status,
	visit_cost,
	MIN(visit_cost) OVER(PARTITION BY visit_status) AS Min_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;


-- 18) Show each visit with the minimum visit_cost per doctor.
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	v.visit_cost,
	MIN(visit_cost) OVER(PARTITION BY d.doctor_id) AS Minimum_visit_cost
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id;

-- 19) Find the minimum age per city using MIN() OVER(PARTITION BY city).
SELECT
    patient_id,
	age,
	city,
	MIN(age) OVER(PARTITION BY city) AS Min_age
FROM Patients
WHERE city IS NOT NULL AND age IS NOT NULL;

-- 20) Display patients whose age equals the minimum age of their city (using window MIN).
SELECT 
    patient_id,
    age,
    city
FROM (
    SELECT 
        patient_id,
        age,
        city,
        MIN(age) OVER(PARTITION BY city) AS min_age_per_city
    FROM Patients
    WHERE age IS NOT NULL AND city IS NOT NULL
) AS sub
WHERE age = min_age_per_city;


-- 21) Find the minimum tax_percent across all billing records.
SELECT 
    bill_id,
	tax_percent,
	MIN(tax_percent) OVER() AS Minimum_tax_percent
FROM Billing;

-- 22) Show each billing row with the minimum tax_percent per doctor.
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.tax_percent,
	MIN(tax_percent) OVER(PARTITION BY d.doctor_id) AS Min_tax_percent
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id = d.doctor_id

-- 23) Find the minimum consultation_fee per patient using a window function.
SELECT 
    b.bill_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.consultation_fee,
	MIN(b.consultation_fee) OVER(PARTITION BY p.patient_id) AS Min_fee
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id = p.patient_id;

    
-- 24) Display each billing record with the minimum total cost (consultation_fee + medicine_cost) per patient.
SELECT 
    b.bill_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.consultation_fee+ b.medicine_cost AS Total_cost,
	MIN(b.consultation_fee+ b.medicine_cost) OVER(PARTITION BY p.patient_id) AS Min_fee
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id = p.patient_id;

-- 25) Find the minimum visit_cost per month using a window function.
SELECT
    visit_id,
	YEAR(visit_date) AS Year_visit_id,
	MONTH(visit_date) AS Month_visit_id,
	visit_cost,
	MIN(visit_cost) OVER(PARTITION BY YEAR(visit_date), MONTH(visit_date)) AS Min_cost
FROM Visits
WHERE visit_date IS NOT NULL;


-- 26) Display each visit with the minimum visit_cost within the same department.
SELECT
    visit_id,
	visit_cost,
	department,
	MIN(visit_cost) OVER(PARTITION BY department) AS Minimum_visit_cost
FROM Visits
WHERE department IS NOT NULL;


-- 27) Find the minimum event_time from DateTimePractice using MIN() OVER().
SELECT
    event_time,
	MIN(event_time) OVER() AS Minimum_event_time
FROM DateTimePractice;
 SELECT * FROM DateTimePractice

-- 28) Display each event with the earliest event_datetime.
SELECT
    record_id,
	event_name,
	event_date,
	event_time,
	event_datetime,
	MIN(event_datetime) OVER() AS Earliest_datetime
FROM DateTimePractice;

-- 29) Find the minimum event_time per event_date using a window function.
SELECT
    record_id,
    event_name,
    event_date,
    event_time,
    event_datetime,
    MIN(event_time) OVER(PARTITION BY event_date) AS Earliest_time
FROM DateTimePractice;

-- 30) Show each event with the minimum event_time of that day.
SELECT
    record_id,
    event_name,
    YEAR(event_date) AS Year_event_date,
	MONTH(event_date) AS Month_event_date,
	DAY(event_date) AS Day_event_date,
    event_time,
    event_datetime,
    MIN(event_time) OVER(PARTITION BY YEAR(event_date), MONTH(event_date),DAY(event_date)) AS Earliest_time
FROM DateTimePractice;

-- 31) Find the minimum consultation_fee ignoring NULLs using a window function.
SELECT
    bill_id,
    consultation_fee,
    MIN(consultation_fee) OVER () AS Minimum_consultation_fee
FROM Billing
WHERE consultation_fee IS NOT NULL;

-- 32) Display billing rows where consultation_fee equals the minimum per doctor.
SELECT
    bill_id,
	doctor_id,
	Full_Name,
	consultation_fee
FROM (
SELECT 
    b.bill_id,
    d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.consultation_fee,
	MIN(b.consultation_fee) OVER(PARTITION BY d.doctor_id) AS Minimum_fee_per_doc
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id = d.doctor_id) t
WHERE consultation_fee = Minimum_fee_per_doc;

-- 33) Find the minimum medicine_cost per doctor using MIN() OVER().
SELECT 
    b.doctor_id,
	b.bill_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.medicine_cost,
	MIN(b.medicine_cost) OVER(PARTITION BY  b.doctor_id) AS Minimum_medicine_cost
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id
WHERE medicine_cost IS NOT NULL;

-- 34) Display each billing row with the minimum medicine_cost per doctor and created_date.
SELECT 
    b.doctor_id,
	b.bill_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.medicine_cost,
	b.created_date,
	MIN(b.medicine_cost) OVER(PARTITION BY  b.doctor_id,created_date) AS Minimum_medicine_cost
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id
WHERE medicine_cost IS NOT NULL;

-- 35) Find the minimum bp_diastolic per patient ordered by reading_date.
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	v.bp_diastolic,
	v.reading_date,
	MIN(v.bp_diastolic) 
	OVER(PARTITION BY p.patient_id ORDER BY v.reading_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Minimum_bp_diastolic
FROM VitalReadings v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id;


-- 36) Show only the rows where bp_systolic is the minimum for that patient (using window MIN).
SELECT
    patient_id,
    Full_Name,
    bp_systolic,
    reading_date
FROM (
    SELECT 
        p.patient_id,
        CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
        v.bp_systolic,
        v.reading_date,
        MIN(v.bp_systolic) OVER (PARTITION BY p.patient_id) AS min_bp
    FROM VitalReadings v
    LEFT JOIN Patients p
        ON v.patient_id = p.patient_id
) t
WHERE bp_systolic = min_bp;


-- 37) Find the minimum visit_cost per patient per department.
SELECT
    visit_id,
	patient_id,
	department,
	visit_cost,
	MIN(visit_cost) OVER(PARTITION BY patient_id, department) AS Minimum_cost
FROM Visits
WHERE department IS NOT NULL;


-- 38) Display visits where visit_cost equals the minimum cost for that patient.
SELECT
    visit_id,
	patient_id,
	visit_cost
FROM 
(
SELECT
    visit_id,
	patient_id,
	visit_cost,
	MIN(visit_cost) OVER(PARTITION BY patient_id) AS Minimum_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL)t

WHERE visit_cost = Minimum_visit_cost;


-- 39) Find the minimum age among male and female patients separately using window MIN.
SELECT
    patient_id,
	age,
	gender,
	MIN(age) OVER(PARTITION BY gender) AS Minimum_age
FROM Patients
WHERE age IS NOT NULL AND gender IS NOT NULL;

-- 40) Display each patient with the minimum age per gender.
SELECT
    patient_id,
    age,
    gender
FROM (
    SELECT
        patient_id,
        age,
        gender,
        MIN(age) OVER (PARTITION BY gender) AS min_age
    FROM Patients
    WHERE age IS NOT NULL
      AND gender IS NOT NULL
) t
WHERE age = min_age;


-- 41) Find the minimum discount per created_date using a window function.
SELECT
    bill_id,
	discount,
	created_date,
	MIN(discount) OVER(PARTITION BY created_date) AS Minimum_discount
FROM Billing;

-- 42) Display billing rows where discount equals the minimum discount of that day.
SELECT
    bill_id,
	discount,
	created_date
FROM
(SELECT
    bill_id,
	discount,
	created_date,
	MIN(discount) OVER(PARTITION BY created_date) AS Minimum_discount
FROM Billing
WHERE discount IS NOT NULL)t
WHERE discount= Minimum_discount;

-- 43) Find the minimum visit_cost per doctor across all visits.
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	v.visit_cost,
	MIN(v.visit_cost) OVER(PARTITION BY d.doctor_id) AS Min_visit_cost_per_doc
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
WHERE v.visit_cost IS NOT NULL;

-- 44) Display each visit with the minimum visit_cost of the doctor they visited.
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	v.visit_cost,
	MIN(v.visit_cost) OVER(PARTITION BY d.doctor_id) AS Min_visit_cost_per_doc
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
WHERE v.visit_cost IS NOT NULL;

-- 45) Find the minimum consultation_fee per department using Billing + Doctors and window MIN.
SELECT 
    b.bill_id,
	d.doctor_id,
	d.department,
	b.consultation_fee,
	MIN(b.consultation_fee) OVER(PARTITION BY d.department) AS Min_consultation_fee
FROM Billing b
INNER JOIN Doctors d
ON b.doctor_id= d.doctor_id
WHERE d.department IS NOT NULL AND b.consultation_fee IS NOT NULL;


-- 46) Display billing rows with minimum consultation_fee per department.
SELECT
    bill_id,
    doctor_id,
    department,
    consultation_fee
FROM (
    SELECT 
        b.bill_id,
        d.doctor_id,
        d.department,
        b.consultation_fee,
        MIN(b.consultation_fee) 
            OVER (PARTITION BY d.department) AS min_fee
    FROM Billing b
    JOIN Doctors d
        ON b.doctor_id = d.doctor_id
    WHERE d.department IS NOT NULL
      AND b.consultation_fee IS NOT NULL
) t
WHERE consultation_fee = min_fee;


-- 47) Find the minimum bp_systolic reading per patient considering only January 2024 using a window function.
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	v.bp_systolic,
	v.reading_date,
	MIN(v.bp_systolic) OVER(PARTITION BY  p.patient_id) AS Minimum_bp_systolic
FROM VitalReadings v
LEFT JOIN Patients P
ON v.patient_id= p.patient_id
WHERE  YEAR(v.reading_date)= 2024 AND FORMAT(v.reading_date,'MMMM')= 'January';


-- 48) Display vital readings where bp_systolic equals the patient’s minimum reading.
SELECT
    patient_id,
	Full_Name,
	bp_systolic,
	Minimum_bp_systolic
FROM(
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	v.bp_systolic,
	v.reading_date,
	MIN(v.bp_systolic) OVER(PARTITION BY  p.patient_id) AS Minimum_bp_systolic
FROM VitalReadings v
LEFT JOIN Patients P
ON v.patient_id= p.patient_id)t
WHERE bp_systolic = Minimum_bp_systolic;

-- 49) Find the minimum visit_cost per visit_status and department using window functions.
SELECT
    visit_id,
	visit_status,
	department,
	visit_cost,
	MIN(visit_cost) OVER(PARTITION BY visit_status, department) AS Min_visit_cost
FROM Visits
WHERE department IS NOT NULL;


-- 50) Display each visit along with the minimum visit_cost across the entire Visits table.
SELECT
    visit_id,
	visit_cost,
	MIN(visit_cost) OVER() AS Minimum_visit_cost
FROM Visits;
