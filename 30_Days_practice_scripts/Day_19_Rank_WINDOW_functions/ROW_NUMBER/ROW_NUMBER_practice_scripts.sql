-- 1) Assign a unique row number to each patient ordered by patient_id
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    ROW_NUMBER() OVER (ORDER BY patient_id) AS row_num
FROM Patients;


-- 2) Display patients with a row number ordered by age descending (NULLs last)
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    age,
    ROW_NUMBER() OVER (
        ORDER BY
            CASE WHEN age IS NULL THEN 1 ELSE 0 END,
            age DESC
    ) AS row_num
FROM Patients;


-- 3) Generate row numbers for patients partitioned by gender and ordered by age
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    gender,
    age,
    ROW_NUMBER() OVER (
        PARTITION BY gender
        ORDER BY
            CASE WHEN age IS NULL THEN 1 ELSE 0 END,
            age
    ) AS row_num
FROM Patients;


-- 4) Show row numbers for patients partitioned by city and ordered by first_name
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    city,
    ROW_NUMBER() OVER (
        PARTITION BY city
        ORDER BY first_name
    ) AS row_num
FROM Patients
WHERE city IS NOT NULL;


-- 5) Assign row numbers to doctors ordered by department alphabetically
SELECT
    doctor_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    department,
    ROW_NUMBER() OVER (ORDER BY department) AS row_num
FROM Doctors
WHERE department IS NOT NULL;


-- 6) Display visits with a row number ordered by visit_date
SELECT
    visit_id,
    visit_date,
    ROW_NUMBER() OVER (ORDER BY visit_date) AS row_num
FROM Visits
WHERE visit_date IS NOT NULL;


-- 7) Assign row numbers to visits partitioned by patient_id ordered by visit_date
SELECT
    visit_id,
    patient_id,
    visit_date,
    ROW_NUMBER() OVER (
        PARTITION BY patient_id
        ORDER BY visit_date, visit_id
    ) AS row_num
FROM Visits
WHERE visit_date IS NOT NULL;


-- 8) Find the first visit for each patient using ROW_NUMBER().

SELECT
    visit_id,
    patient_id,
    visit_date
FROM (
    SELECT
        visit_id,
        patient_id,
        visit_date,
        ROW_NUMBER() OVER (
            PARTITION BY patient_id
            ORDER BY visit_date ASC
        ) AS row_num
    FROM Visits
    WHERE visit_date IS NOT NULL
) t
WHERE row_num = 1;


-- 9) Find the most recent visit per patient using ROW_NUMBER().

SELECT
    visit_id,
    patient_id,
    visit_date
FROM (
    SELECT
        visit_id,
        patient_id,
        visit_date,
        ROW_NUMBER() OVER (
            PARTITION BY patient_id
            ORDER BY visit_date DESC
        ) AS row_num
    FROM Visits
    WHERE visit_date IS NOT NULL
) t
WHERE row_num = 1;


-- 10) Assign row numbers to visits partitioned by department ordered by visit_cost descending.
SELECT
    visit_id,
	department,
	visit_cost,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY visit_cost DESC) AS Unique_row_number
FROM Visits
WHERE department IS NOT NULL AND visit_cost IS NOT NULL;

-- 11) Display prescriptions with row numbers ordered by medication_name.
SELECT
    prescription_id,
	medication_name,
	ROW_NUMBER() OVER(ORDER BY 
	CASE WHEN medication_name IS NULL THEN 1 ELSE 0 END,
	medication_name) AS row_num
FROM Prescriptions;

-- 12) Assign row numbers to prescriptions partitioned by visit_id.
SELECT
    p.visit_id,
    p.prescription_id,
    ROW_NUMBER() OVER (
        PARTITION BY p.visit_id
        ORDER BY p.prescription_id
    ) AS row_num
FROM Prescriptions p;

-- 13) Show billing records with row numbers ordered by created_date.
SELECT
    bill_id,
	created_date,
	ROW_NUMBER() OVER(ORDER BY created_date) AS row_num
FROM Billing
WHERE created_date IS NOT NULL;

-- 14) Assign row numbers to billing records partitioned by patient_id ordered by created_date.
SELECT
    bill_id,
	created_date,
	patient_id,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY created_date) AS row_num
FROM Billing
WHERE created_date IS NOT NULL;

-- 15) Find the latest billing record per patient using ROW_NUMBER().
SELECT
    bill_id,
    patient_id,
    created_date
FROM (
    SELECT
        bill_id,
        patient_id,
        created_date,
        ROW_NUMBER() OVER(
            PARTITION BY patient_id 
            ORDER BY created_date DESC
        ) AS row_num
    FROM Billing
    WHERE created_date IS NOT NULL
) t
WHERE row_num = 1;


-- 16) Find the highest consultation_fee per doctor using ROW_NUMBER().
SELECT
    doctor_id,
	consultation_fee,
	Row_num
FROM 
(
SELECT
    doctor_id,
	consultation_fee,
	ROW_NUMBER() OVER(PARTITION BY doctor_id ORDER BY 
	                  CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END, 
					  consultation_fee DESC) AS Row_num
FROM Billing)t

WHERE Row_num = 1;


-- 17) Assign row numbers to billing rows partitioned by doctor_id ordered by consultation_fee descending.
SELECT
    doctor_id,
	consultation_fee,
	ROW_NUMBER() OVER(PARTITION BY doctor_id ORDER BY 
	                  CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END, 
					  consultation_fee DESC) AS Row_num
FROM Billing;

-- 18) Display vital readings with row numbers ordered by reading_date.
SELECT
    reading_id,
	reading_date,
	ROW_NUMBER() OVER(ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date) AS Row_nm
FROM VitalReadings;


-- 19) Assign row numbers to vital readings partitioned by patient_id ordered by reading_date.
SELECT
    reading_id,
	patient_id,
	reading_date,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date) AS Row_nm
FROM VitalReadings;

-- 20) Fetch the earliest blood pressure reading per patient using ROW_NUMBER().
SELECT 
    reading_id,
	patient_id,
	reading_date,
	Row_nm
FROM
(
SELECT
    reading_id,
	patient_id,
	reading_date,
	ROW_NUMBER() OVER(PARTITION BY patient_id 
	                  ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date ASC) 
					  AS Row_nm
FROM VitalReadings
) t
WHERE Row_nm = 1;

-- 21) Fetch the latest blood pressure reading per patient using ROW_NUMBER().
SELECT 
    reading_id,
	patient_id,
	reading_date,
	Row_nm
FROM
(
SELECT
    reading_id,
	patient_id,
	reading_date,
	ROW_NUMBER() OVER(PARTITION BY patient_id 
	                  ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date DESC) 
					  AS Row_nm
FROM VitalReadings
) t
WHERE Row_nm = 1;

-- 22) Assign row numbers to visits partitioned by visit_status ordered by visit_date.
SELECT
    visit_id,
	visit_date,
	visit_status,
	ROW_NUMBER() OVER(PARTITION BY visit_status 
	                  ORDER BY CASE WHEN Visit_date IS NULL THEN 1 ELSE 0 END,
					  visit_date) AS Row_nm
FROM Visits;

-- 23) Show row numbers for patients ordered by city, then age.
SELECT
    patient_id,
	city,
	age,
	ROW_NUMBER() OVER( ORDER BY CASE WHEN city IS NULL THEN 1 ELSE 0 END, city,
	                     CASE WHEN age IS NULL THEN 1 ELSE 0 END, age) AS Rn_num
FROM Patients;

-- 24) Assign row numbers to patients partitioned by city ordered by age descending.
SELECT
    patient_id,
	city,
	age,
	ROW_NUMBER() OVER(PARTITION BY city ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age DESC) Rn_num
FROM Patients
WHERE city IS NOT NULL;


-- 25) Identify duplicate cities in Patients using ROW_NUMBER().
SELECT
    patient_id,
	city,
	Rn_num
FROM
(
SELECT
    patient_id,
	city,
	ROW_NUMBER() OVER(PARTITION BY city ORDER BY patient_id) AS Rn_num
FROM patients
WHERE city IS NOT NULL) t
WHERE Rn_num > 1;


-- 26) Assign row numbers to doctors partitioned by department.
SELECT
    doctor_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	department,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY doctor_id) AS Row_nm
FROM Doctors
WHERE department IS NOT NULL;


	
-- 27) Show the first doctor per department using ROW_NUMBER().
SELECT
    doctor_id,
	Full_Name,
	department,
	Row_nm
FROM
(
SELECT
    doctor_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	department,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY doctor_id) AS Row_nm
FROM Doctors
WHERE department IS NOT NULL)t
WHERE Row_nm = 1;

-- 28) Assign row numbers to visits partitioned by doctor_id ordered by visit_date.
SELECT
    visit_id,
	doctor_id,
	visit_date,
	ROW_NUMBER() OVER(PARTITION BY doctor_id ORDER BY 
	                   CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date ) AS Rn_nm
FROM Visits;

-- 29) Find the first visit handled by each doctor using ROW_NUMBER().
SELECT
    visit_id,
	doctor_id,
	visit_date,
	Rn_nm
FROM
(
SELECT
    visit_id,
	doctor_id,
	visit_date,
	ROW_NUMBER() OVER(PARTITION BY doctor_id ORDER BY 
	                   CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date ) AS Rn_nm
FROM Visits)t
WHERE Rn_nm = 1;

-- 30) Find the most expensive visit per department using ROW_NUMBER().
SELECT
    visit_id,
	department,
	visit_cost,
	rn_num
FROM
(
SELECT
    visit_id,
	department,
	visit_cost,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY visit_cost DESC) AS rn_num
FROM Visits
WHERE department IS NOT NULL)t
WHERE rn_num = 1;


-- 31) Assign row numbers to billing records ordered by total cost (consultation + medicine).
SELECT
    bill_id,
	COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0) AS Total_cost,
	ROW_NUMBER() OVER(ORDER BY COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)) AS rn
FROM Billing;

-- 32) Assign row numbers to billing records partitioned by tax_percent ordered by created_date.
SELECT
    bill_id,
	tax_percent,
	created_date,
	ROW_NUMBER() OVER(PARTITION BY tax_percent ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Rn
FROM Billing;

-- 33) Fetch top 2 highest medicine_cost bills per patient using ROW_NUMBER().
SELECT 
    bill_id,
    patient_id,
    medicine_cost,
    rn
FROM
(
    SELECT 
        bill_id,
        patient_id,
        medicine_cost,
        ROW_NUMBER() OVER(
            PARTITION BY patient_id 
            ORDER BY CASE WHEN medicine_cost IS NULL THEN 1 ELSE 0 END,
                     medicine_cost DESC
        ) AS rn
    FROM Billing
) t
WHERE rn <= 2;


-- 34) Assign row numbers to DateTimePractice events ordered by event_datetime.

SELECT
    record_id,
	event_name,
	event_date,
	event_time,
	event_datetime,
	ROW_NUMBER() OVER(ORDER BY CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END, event_datetime) AS Rn
FROM DateTimePractice;

-- 35) Assign row numbers to DateTimePractice events partitioned by event_date ordered by event_time.
SELECT
    record_id,
	event_name,
	event_date,
	event_time,
	event_datetime,
	ROW_NUMBER() OVER(
    PARTITION BY event_date
    ORDER BY 
        CASE WHEN event_time IS NULL THEN 1 ELSE 0 END,
        event_time,
        event_datetime
) AS rn
FROM DateTimePractice;

-- 36) Find the first event per day using ROW_NUMBER().
SELECT *
FROM (
    SELECT
        record_id,
        event_name,
        event_date,
        event_time,
        event_datetime,
        ROW_NUMBER() OVER(
            PARTITION BY event_date
            ORDER BY 
                CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END,
                event_datetime
        ) AS Rn
    FROM DateTimePractice
) t
WHERE Rn = 1;

-- 37) Assign row numbers to patients ordered by last_name, first_name.
SELECT
    patient_id,
	first_name,
	last_name,
	ROW_NUMBER() OVER(ORDER BY last_name,first_name) AS Rn
FROM Patients;

-- 38) Assign row numbers to visits where diagnosis IS NOT NULL ordered by visit_date.
SELECT
    visit_id,
	diagnosis,
	visit_date,
	ROW_NUMBER() OVER(ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) rn
FROM Visits
WHERE diagnosis IS NOT NULL;

-- 39) Assign row numbers to visits where diagnosis IS NULL ordered by visit_date.
SELECT
    visit_id,
	diagnosis,
	visit_date,
	ROW_NUMBER() OVER(ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) rn
FROM Visits
WHERE diagnosis IS  NULL;

-- 40) Use ROW_NUMBER() to remove duplicate billing records for same patient and doctor.
SELECT
    bill_id,
	patient_id,
	doctor_id,
	created_date,
	rn
FROM
(
SELECT
    bill_id,
    patient_id,
    doctor_id,
    created_date,
    ROW_NUMBER() OVER(
        PARTITION BY patient_id, doctor_id
        ORDER BY created_date
    ) AS rn
FROM Billing)t
WHERE rn > 1;

-- 41) Assign row numbers to billing records partitioned by patient_id ordered by discount ascending.
SELECT
    bill_id,
	patient_id,
	discount,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY  CASE WHEN discount IS NULL THEN 1 ELSE 0 END, discount ASC) rn
FROM Billing;

-- 42) Find the maximum discount per patient using ROW_NUMBER().
SELECT
    bill_id,
	patient_id,
	discount,
	rn
FROM
(
SELECT
    bill_id,
	patient_id,
	discount,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY  CASE WHEN discount IS NULL THEN 1 ELSE 0 END, discount DESC ) rn
FROM Billing) t
WHERE rn = 1;

-- 43) Assign row numbers to vital readings partitioned by patient_id ordered by bp_systolic descending.
SELECT
    reading_id,
	patient_id,
	bp_systolic,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_systolic IS NULL THEN 1 ELSE 0 END, bp_systolic DESC) AS Rn
FROM VitalReadings;

-- 44) Find the highest systolic BP per patient using ROW_NUMBER().
SELECT
    reading_id,
	patient_id,
	bp_systolic,
	Rn
FROM
(
SELECT
    reading_id,
	patient_id,
	bp_systolic,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_systolic IS NULL THEN 1 ELSE 0 END, bp_systolic DESC) AS Rn
FROM VitalReadings)t
WHERE Rn = 1;

-- 45) Assign row numbers to visits partitioned by patient_id ordered by visit_cost descending.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC) rn
FROM Visits;

-- 46) Fetch the costliest visit per patient using ROW_NUMBER().
SELECT
    visit_id,
	patient_id,
	visit_cost,
	rn
FROM
(
SELECT
    visit_id,
	patient_id,
	visit_cost,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC) rn
FROM Visits)t
WHERE rn= 1;

-- 47) Assign row numbers to patients ordered by age with NULL ages last.
SELECT
    patient_id,
	age,
	ROW_NUMBER() OVER(ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age) rn
FROM Patients;

-- 48) Use ROW_NUMBER() to paginate patients data (e.g., rows 1–5, 6–10).
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	ROW_NUMBER() OVER(ORDER BY patient_id) rn
FROM Patients;

-- 49) Assign row numbers to doctors ordered by last_name.
SELECT
    Doctor_id,
	first_name,
	last_name,
	ROW_NUMBER() OVER(ORDER BY last_name) AS rn
FROM Doctors;

SELECT
    Doctor_id,
	first_name,
	last_name,
	ROW_NUMBER() OVER(ORDER BY last_name,first_name) AS rn
FROM Doctors;

-- 50) Compare ROW_NUMBER() results with and without PARTITION BY on Visits table.
SELECT
    visit_id,
    patient_id,
    visit_date,
    -- ROW_NUMBER without partition (global rank)
    ROW_NUMBER() OVER(ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date) AS rn_global,
    -- ROW_NUMBER partitioned by patient (rank resets per patient)
    ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date) AS rn_per_patient
FROM Visits;


