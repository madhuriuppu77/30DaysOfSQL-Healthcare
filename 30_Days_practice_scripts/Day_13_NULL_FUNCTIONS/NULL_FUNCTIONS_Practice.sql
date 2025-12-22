-- ==========================================================
-- Combined NULL Functions Questions (1–50)
-- ==========================================================

--1 Retrieve all patients and show their phone numbers, replacing NULL phone numbers with 'Not Provided' using COALESCE.
SELECT
CONCAT(first_name,' ',last_name) AS Full_name,
age,
city,
COALESCE(phone,'Not Provided') AS phone_null
FROM Patients;

--2 Select visits where the diagnosis is NULL and mark them as 'Pending Diagnosis' using ISNULL.
SELECT
diagnosis,
ISNULL(diagnosis, 'Pending Diagnosis') AS diagnosis_null
FROM Visits;



--3 Show prescriptions where the dosage is NULL, and replace it with 'Check Label', but only for patients above 50 years of age.
SELECT
    pt.patient_id,
    CONCAT(pt.first_name, ' ', pt.last_name) AS full_name,
    pt.age,
    p.medication_name,
    COALESCE(p.dosage, 'Check Label') AS dosage
FROM Prescriptions p
JOIN Visits v  ON p.visit_id = v.visit_id
JOIN Patients pt ON v.patient_id = pt.patient_id
WHERE pt.age > 50;


--4 List all doctors and if their department is NULL, replace it with 'General' using COALESCE.
SELECT
CONCAT(first_name,' ',last_name) AS Full_name,
COALESCE(department,'General') AS department
FROM Doctors;

--5 Retrieve patients’ ages and replace NULL ages with the average age of all patients.
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    COALESCE(age, (SELECT AVG(age) FROM Patients)) AS age_filled
FROM Patients;

--6 Select patients and their visits; show 'Unknown Visit Date' for visits where the date is NULL.
SELECT
    p.*,
    v.visit_id,
    v.visit_date,
    CASE WHEN v.visit_date IS NULL
         THEN 'Unknown Visit Date'
         ELSE 'Date Available'
    END AS visit_status
FROM Visits v
LEFT JOIN Patients p
    ON v.patient_id = p.patient_id;



--7 Find all prescriptions where medication name is NULL and display 'No Medication' instead.
SELECT
medication_name,
COALESCE(medication_name, 'No medication') AS medication_name_null
FROM Prescriptions
WHERE medication_name IS NULL;

--8 List patients whose city is NULL or empty, and replace with 'City Not Available'.
SELECT
    CONCAT(first_name,' ',last_name) AS full_name,
    CASE 
        WHEN city IS NULL OR city = '' THEN 'City Not Available'
        ELSE city
    END AS city
FROM Patients;

--9 Select all visits and show the diagnosis; if it’s NULL, use 'Not Diagnosed' and highlight patients older than 60.
SELECT
p.*,
v.visit_id,
COALESCE(v.diagnosis,'Not Diagnosed') AS Diagnosis
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
WHERE p.age > 60;

--10 Retrieve doctors’ department and if it’s NULL, replace it with 'Other'; also indicate if doctor has no visits using IS NULL.
SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS full_name,
    COALESCE(d.department, 'Other') AS department,
    v.visit_id,
    CASE 
        WHEN v.visit_id IS NULL THEN 'No Visits'
        ELSE 'Has Visits'
    END AS visit_status
FROM Doctors d
LEFT JOIN Visits v
    ON d.doctor_id = v.doctor_id;

--11 Retrieve patients’ names, phone numbers, and visit dates; replace any NULL phone with 'No Phone' and NULL visit dates with 'Pending'.
SELECT
	CONCAT(p.first_name,' ',p.last_name) AS Full_name,
	CASE 
		WHEN p.phone IS NULL THEN 'No phone'
		ELSE p.phone
	END AS phone,
	v.visit_date,
	CASE 
		WHEN v.visit_date IS NULL THEN 'pending'
		ELSE 'has_date'
	END AS visit_status
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id;

--12 Find prescriptions where dosage is NULL or 0 using NULLIF, and replace them with 'Confirm Dosage'.
SELECT
    prescription_id,
    medication_name,
    dosage,
    CASE 
        WHEN dosage IS NULL OR dosage LIKE '0%' THEN 'Confirm Dosage'
        ELSE 'Has Dosage'
    END AS dosage_status
FROM Prescriptions
WHERE dosage IS NULL OR dosage LIKE '0%';


--13 List patients and their total visits; for patients without visits, display 0 using ISNULL and only include those with age NOT NULL.
SELECT 
    p.patient_id,
    COUNT(v.visit_id) AS total_visits
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
WHERE p.age IS NOT NULL
GROUP BY p.patient_id;


--14 Retrieve all patients’ names, and replace NULL city with 'Unknown'; exclude patients with NULL age using IS NOT NULL.
SELECT
    CONCAT(first_name, ' ', last_name) AS Full_name,
    COALESCE(city, 'Unknown') AS city,
    age
FROM Patients
WHERE age IS NOT NULL;


--15 Show visit details with diagnosis replaced as 'Diagnosis Missing' if NULL, and replace NULL department with 'General'.
SELECT
visit_id,
COALESCE(diagnosis, 'Diagnosis Missing') AS diagnosis,
COALESCE(department, 'General') AS department
FROM Visits;


--16 List patients along with their doctor’s department; if department is NULL, replace with 'Other', and indicate patients with NULL doctor using ISNULL.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    COALESCE(d.department, 'Other') AS department,
    CASE 
        WHEN d.doctor_id IS NULL THEN 'No Doctor Assigned'
        ELSE 'Has Doctor'
    END AS doctor_status
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
LEFT JOIN Doctors d
    ON v.doctor_id = d.doctor_id;


--17 Show prescriptions where medication_name is NULL and dosage is NULL; replace medication_name with 'Unassigned' and dosage with 'Check Dose'.
SELECT
medication_name,
COALESCE(medication_name, 'Unassigned') AS medication_name_null,
dosage,
COALESCE(dosage, 'Check Dose') AS dosage_null
FROM Prescriptions
WHERE medication_name is  NULL OR dosage is NULL;

--18 Retrieve patient name, city, and age; replace NULL age with average age, and NULL city with 'City Unknown'.
SELECT
    CONCAT(first_name, ' ', last_name) AS Full_name,
    COALESCE(age, (SELECT AVG(age) FROM Patients)) AS age,
    COALESCE(city, 'City Unknown') AS city
FROM Patients;

--19 Select visits and mark 'No Diagnosis' if diagnosis is NULL, also show 'No Doctor Assigned' if doctor_id is NULL.
SELECT
    visit_id,
	doctor_id,
	CASE 
	    WHEN doctor_id IS NULL THEN 'No Doctor Assigned'
		ELSE 'Doctor Assigned'
	END AS doctor_status,
	COALESCE(diagnosis, 'No Diagnosis') AS diagnosis
FROM Visits

--20 Find all patients with NULL phone numbers or NULL city and replace them with 'Not Available'.
SELECT
    CONCAT(first_name,' ',last_name) AS Full_name,
	COALESCE(phone, 'Not Available') AS Phone,
	COALESCE( city, 'Not Available') AS city
FROM Patients
WHERE phone IS NULL OR city IS NULL;

--21 Retrieve visits where either diagnosis or department is NULL; replace diagnosis with 'Pending Diagnosis' and department with 'General', also flag patients with age > 60.
SELECT 
    COALESCE(v.diagnosis, 'pending Diagnosis') AS diagnosis,
	COALESCE(d.department, 'General') AS department,
	p.age,
	CASE 
	    WHEN p.age > 60 THEN 1
		ELSE 0
	END AS flag_patient_age
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id =p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE v.diagnosis IS NULL OR d.department IS NULL;

--22 Show all prescriptions where medication_name or dosage is NULL, replace medication_name with 'To Be Assigned' and dosage with 'Check Label'.
SELECT
    COALESCE(medication_name, 'To Be Assigned') AS medication_name,
	COALESCE(dosage, 'Check Label') AS dosage
FROM Prescriptions
WHERE medication_name IS NULL OR dosage IS NULL;

--23 List patients and doctors, show 'Unknown Doctor' if doctor_id is NULL and 'Unknown Patient' if patient_id is NULL, replacing NULL fields appropriately.
SELECT 
    p.patient_id,
	CASE
	    WHEN p.patient_id IS NULL THEN 'Unknown patient'
		ELSE 'known patient'
	END AS patient_status,
	d.doctor_id,
	CASE
	    WHEN d.doctor_id IS NULL THEN 'Unknown Doctor'
		ELSE 'known Doctor'
	END AS Doctor_status
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id;

--24 Show all visits and replace NULL diagnosis with 'Diagnosis Missing' and visit_date with 'Date Not Set', but only for patients whose age is NOT NULL.
SELECT 
    v.visit_id,
    p.age,
    COALESCE(v.diagnosis, 'Diagnosis Missing') AS diagnosis,
    COALESCE(CONVERT(VARCHAR(20), v.visit_date), 'Date Not Set') AS visit_date
FROM Visits v
LEFT JOIN Patients p
    ON v.patient_id = p.patient_id
WHERE p.age IS NOT NULL;

--25 Retrieve prescriptions with NULL dosage; if medication_name is also NULL, replace both using COALESCE with 'Check Medication' and 'Check Dosage'.
SELECT
    COALESCE(medication_name, 'Check Medication') AS medication_name,
	COALESCE(dosage, 'Check Dosage') AS dosage
FROM Prescriptions
WHERE medication_name IS NULL OR dosage IS NULL;

--26 List patients, their visits, and prescriptions; replace NULL values in each field with a descriptive default using COALESCE.
SELECT 
    CONCAT(p.first_name, ' ',p.last_name) AS Full_name,
	p.patient_id,
	COALESCE(CONVERT(VARCHAR(10),p.age), 'Default') AS age,
	COALESCE(p.city, 'Default') AS city,
    pr.prescription_id,
	COALESCE(CONVERT(VARCHAR(20),pr.dosage), 'Default') AS dosage,
	COALESCE(pr.medication_name, 'Default') AS medication_name, 
	v.visit_id,
	COALESCE(d.department, 'Default') AS department,
	COALESCE(CONVERT(VARCHAR(25),v.visit_date), 'Default') AS visit_date
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
LEFT JOIN Prescriptions pr
ON v.visit_id= pr.visit_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id;

--27 Show patients whose city or phone is NULL; replace city with 'Unknown City' and phone with 'No Phone', then count such patients.
SELECT
    COALESCE(city, 'UNknown city') AS city,
	COALESCE(CONVERT(VARCHAR(25), phone), 'No phone') AS phone
FROM patients
WHERE city IS NULL OR phone IS NULL;

--28 Retrieve all doctors; if department is NULL, replace with 'General'; also find doctors who have no visits using IS NULL.
SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COALESCE(d.department, 'General') AS department,
    CASE 
        WHEN v.visit_id IS NULL THEN 'No Visits'
        ELSE 'Has Visits'
    END AS visit_status
FROM Doctors d
LEFT JOIN Visits v
    ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.department, v.visit_id;

--29 List all visits, replace NULL diagnosis with 'TBD'; replace department NULL with 'General'; also ignore visits with NULL patient_id.
SELECT
    v.visit_id,
    v.patient_id,
    COALESCE(v.diagnosis, 'TBD') AS diagnosis,
    COALESCE(d.department, 'General') AS department
FROM Visits v
LEFT JOIN Doctors d
    ON v.doctor_id = d.doctor_id
WHERE v.patient_id IS NOT NULL;

--30 Show prescriptions where dosage is NULL; replace it with 'Confirm Dosage' but only for patients above age 40 whose visit_date is NOT NULL.
SELECT 
    pr.prescription_id,
    p.patient_id,
    v.visit_date,
    p.age,
    COALESCE(pr.dosage, 'Confirm Dosage') AS dosage
FROM Visits v
LEFT JOIN Patients p
    ON v.patient_id = p.patient_id
LEFT JOIN Prescriptions pr
    ON v.visit_id = pr.visit_id
WHERE p.age > 40
  AND v.visit_date IS NOT NULL
  AND pr.dosage IS NULL;

--31 Find patients with NULL city or age, replace city with 'Unknown City' and age with average age; exclude patients with NULL phone.
SELECT
    patient_id,
    phone,
    COALESCE(city, 'Unknown City') AS city,
    COALESCE(age, (SELECT AVG(age) FROM Patients)) AS age
FROM Patients
WHERE (age IS NULL OR city IS NULL)
  AND phone IS NOT NULL;

--32 Retrieve visits and show diagnosis, replace NULL with 'Pending'; also replace NULL department with 'General' for doctors with missing department.
SELECT
    visit_id,
	COALESCE(diagnosis, 'pending') AS diagnosis,
	COALESCE(department,'General') AS department
FROM Visits

--33 Show prescriptions where medication_name is NULL, replace with 'Not Assigned'; for NULL dosage, use 'Check Dose'.

SELECT
    prescription_id,
    COALESCE(medication_name, 'Not Assigned') AS medication_name,
    COALESCE(CONVERT(VARCHAR(25), dosage), 'Check Dose') AS dosage
FROM Prescriptions
WHERE medication_name IS NULL OR dosage IS NULL;

--34 List all patients with their last visit; replace NULL visit_date with 'No Visit Yet' and NULL doctor_id with 'No Doctor Assigned'.
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    COALESCE(CONVERT(VARCHAR(20), MAX(v.visit_date)), 'No Visit Yet') AS last_visit_date,
    COALESCE(MAX(v.doctor_id), 'No Doctor Assigned') AS doctor_id
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;

--35 Retrieve patients and doctors; if department or city is NULL, replace with 'Unknown'; show only patients older than 50.
SELECT 
    p.patient_id,
	v.doctor_id,
    CONCAT(p.first_name,' ',p.last_name) AS Full_name,
	p.age,
	COALESCE(p.city ,'unknown') AS city,
	COALESCE(v.department, 'unknown') AS department
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
WHERE p.age > 50;

--36 Select visits and replace NULL diagnosis with 'Diagnosis Pending'; if visit_date is NULL, replace with 'Date Unknown' using COALESCE.
SELECT
    visit_id,
    COALESCE(diagnosis,'Diagnosis pending') AS diagnosis,
	COALESCE(CONVERT(VARCHAR(25),visit_date), 'Date Unknown') AS visit_date
FROM Visits;

--37 List patients with NULL age or phone; replace age with average age and phone with 'No Contact'.
SELECT
    patient_id,
    CONCAT(first_name,' ',last_name) AS Full_name,
    COALESCE(age, (SELECT AVG(age) FROM Patients WHERE age IS NOT NULL)) AS age,
    COALESCE(phone, 'No Contact') AS phone
FROM Patients
WHERE age IS NULL OR phone IS NULL;


--38 Find prescriptions where medication_name or dosage is NULL; replace both with descriptive defaults using COALESCE.
SELECT
    Prescription_id,
    COALESCE(medication_name, 'default') AS medication_name,
	COALESCE(CONVERT(VARCHAR(25),dosage), 'default') AS dosage
FROM Prescriptions
WHERE medication_name IS NULL OR dosage IS NULL;

--39 Retrieve doctors’ departments; replace NULL with 'General'; count doctors who have no visits.


SELECT 
    d.doctor_id,
    COALESCE(d.department, 'General') AS department,
    COUNT(v.visit_id) AS total_visit_per_doc
FROM Doctors d
LEFT JOIN Visits v
    ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_id, d.department;


--40 Show visits with NULL diagnosis or department; replace both appropriately and filter only patients with age > 30.
SELECT
    p.patient_id,
    CONCAT(p.first_name,' ',p.last_name) AS Full_name,
    p.age,
    v.visit_id,
    COALESCE(v.diagnosis, 'Unknown') AS diagnosis,
    COALESCE(v.department, 'Unknown') AS department
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
WHERE p.age > 30;


--41 Select patients, visits, and prescriptions; replace all NULLs with meaningful defaults using COALESCE, and flag patients with missing visits.
SELECT 
    CONCAT(p.first_name, ' ',p.last_name) AS Full_name,
	p.patient_id,
	COALESCE(CONVERT(VARCHAR(10),p.age), 'Default') AS age,
	COALESCE(p.city, 'Default') AS city,
    pr.prescription_id,
	COALESCE(CONVERT(VARCHAR(20),pr.dosage), 'Default') AS dosage,
	COALESCE(pr.medication_name, 'Default') AS medication_name, 
	v.visit_id,
	CASE
	    WHEN v.visit_id IS NULL THEN  0
		ELSE  1
	END AS visit_id_flag,
	COALESCE(v.department, 'Default') AS department,
	COALESCE(CONVERT(VARCHAR(25),v.visit_date), 'Default') AS visit_date
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
LEFT JOIN Prescriptions pr
ON v.visit_id= pr.visit_id

--42 List all patients with NULL city; replace with 'Unknown'; if age is NULL, replace with average age; count how many replacements were done.
SELECT
    COUNT(*) AS total_replaced_patients,
    COALESCE(city, 'Unknown') AS City,
    COALESCE(age, (SELECT AVG(age) FROM Patients)) AS age
FROM Patients
WHERE city IS NULL OR age IS NULL;

--43 Retrieve prescriptions with NULL dosage; use NULLIF to treat '0' as NULL and replace with 'Confirm Dosage'.
SELECT
    prescription_id,
    medication_name,
    COALESCE(NULLIF(CONVERT(VARCHAR(25), dosage), '0'), 'Confirm Dosage') AS dosage
FROM Prescriptions
WHERE dosage IS NULL OR dosage = 0;


--44 Find patients who have no visits (visit_id NULL); replace patient name with 'Unknown Patient' and count them.
SELECT 
    p.patient_id,
    COALESCE(CONCAT(p.first_name,' ',p.last_name), 'Unknown Patient') AS Full_name,
    COUNT(v.visit_id) AS Total_visit_per_patient
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(v.visit_id) = 0;

--45 Show doctors with NULL department; replace with 'General'; also show number of visits per doctor using ISNULL for missing counts.
SELECT 
    d.doctor_id,
    COALESCE(d.department, 'General') AS department,
    COUNT(v.visit_id) AS total_visits_per_doc
FROM Doctors d
LEFT JOIN Visits v
    ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_id, d.department;

--46 List visits and prescriptions; if diagnosis or medication_name is NULL, replace using COALESCE with meaningful defaults.
SELECT 
    v.visit_id,
	p.prescription_id,
	COALESCE(v.diagnosis, 'un diagnosied') AS daignosis,
	COALESCE(p.medication_name, 'no prescribed') AS medication_name
FROM Visits v
LEFT JOIN Prescriptions p
ON v.visit_id = p.visit_id
WHERE medication_name IS NULL OR diagnosis IS NULL;

--47 Show patients with NULL city or age; replace city with 'City Not Set' and age with median age; exclude patients with NULL phone.
SELECT
    patient_id,
    phone,
    COALESCE(city, 'City Not Set') AS city,
    COALESCE(age, (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age) OVER())) AS age
FROM Patients
WHERE (city IS NULL OR age IS NULL)
  AND phone IS NOT NULL;


--48 Retrieve all visits where department is NULL; replace with 'General' and diagnosis NULL with 'Pending'; show only patients under 60.

SELECT 
   p.patient_id,
   v.visit_id,
   p.age,
   COALESCE(v.department, 'General') AS department,
   COALESCE(v.diagnosis, 'Pending') AS diagnosis
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
WHERE v.department IS NULL
  AND p.age < 60;



--49 List prescriptions where dosage is NULL or medication_name is NULL; replace both using COALESCE; show patient name and visit date.
SELECT 
    v.visit_id,
	pr.prescription_id,
	p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_name,
	v.visit_date,
    COALESCE(CONVERT(VARCHAR(25), pr.dosage), 'unknown')  AS dosage,
	COALESCE(pr.medication_name, 'N/A') AS medication_name
FROM visits v
LEFT JOIN Prescriptions pr
ON v.visit_id = pr.visit_id
LEFT JOIN patients p
ON v.patient_id = p.patient_id
WHERE pr.dosage IS NULL OR pr.medication_name IS NULL;


--50 Retrieve patients and their doctors; if either patient or doctor info is NULL, replace with 'Unknown'; also show total visits using ISNULL for NULL counts.

SELECT 
    p.patient_id,
    d.doctor_id,
    v.visit_id,
    CONCAT(p.first_name,' ',p.last_name) AS Full_name,
    COALESCE(CONVERT(VARCHAR(25),p.age), 'Unknown') AS age,
    COALESCE(p.city, 'Unknown') AS city,
    COALESCE(CONVERT(VARCHAR(25),p.phone), 'Unknown') AS phone,
    COALESCE(d.department,'Unknown') AS department
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
LEFT JOIN Doctors d
    ON v.doctor_id = d.doctor_id;

-- ==========================================================
-- Single-Topic NULL Questions (1–50)
-- ==========================================================

--1 Retrieve all patients and show their phone numbers; if NULL, replace with 'Not Provided'.
SELECT 
    patient_id,
	COALESCE(phone, 'Not provided') AS phone
FROM Patients;

--2 Show visits with diagnosis; if NULL, replace with 'Pending Diagnosis'.
SELECT 
    visit_id,
	COALESCE(diagnosis,'Pending Diagnosis') AS Diagnosis
FROM Visits;

--3 Display prescriptions’ dosage; replace NULL dosage with 'Check Label'.
SELECT
    prescription_id,
	COALESCE(CONVERT(VARCHAR(25),dosage),'check Label') AS dosage
FROM Prescriptions;

--4 Show doctors’ department; replace NULL with 'General'.
SELECT
    doctor_id,
	COALESCE(department, 'General') AS department
FROM Doctors;

--5 Retrieve patients’ ages; if NULL, replace with average age.

SELECT
    patient_id,
	COALESCE(age, (SELECT AVG(age) FROM Patients)) AS age
FROM Patients;

--6 Select visits where visit_date is NULL; replace with 'Date Unknown'.
SELECT
    visit_id,
	COALESCE(CONVERT(VARCHAR(25),visit_date), 'Date Unknown') AS visit_date

FROM Visits;

--7 Show patients’ city; replace NULL with 'Unknown City'.
SELECT
    patient_id,
	COALESCE(city, 'Unknown City') AS city
FROM Patients;

--8 Retrieve prescriptions’ medication_name; if NULL, replace with 'No Medication'.
SELECT
    prescription_id,
	COALESCE(medication_name, 'No medication') AS medication_name
FROM Prescriptions;

--9 Display consultation_fee from Billing; if NULL, replace with 0.
SELECT
    Bill_id,
	COALESCE(consultation_fee, 0) AS consultation_fee
FROM Billing;

--10 List patients and replace NULL phone numbers with 'No Contact'.
SELECT
    patient_id,
	COALESCE(phone, 'No contact') AS phone
FROM Patients;

--11 Retrieve patients’ city; replace NULL with 'Unknown'.
SELECT
    patient_id,
	COALESCE(city, 'Unknown') AS city
FROM Patients;

--12 Show visits with diagnosis or visit_date; replace any NULL with 'Pending'.
SELECT
    visit_id,
	COALESCE(diagnosis, 'pending') AS Diagnosis,
	COALESCE(CONVERT(VARCHAR(25), visit_date), 'pending') AS Visit_date
FROM Visits;

--13 Display doctors’ department; replace NULL with 'Other'.
SELECT
    doctor_id,
	COALESCE( department, 'other') AS department
FROM Doctors;

--14 Show prescriptions’ dosage; if NULL, replace with 'Check Dosage'.

SELECT
    prescription_id,
	COALESCE(CONVERT(VARCHAR(20), dosage), 'check Dosage') AS dosage
FROM Prescriptions;

--15 Retrieve patients’ age; replace NULL with average age using COALESCE.
SELECT
    patient_id,
	COALESCE(age, (SELECT AVG(age) FROM Patients)) AS age
FROM Patients;

--16 Show visits; if diagnosis is NULL, replace with 'Diagnosis Pending'.
SELECT
    visit_id,
	COALESCE(diagnosis, 'Diagnosis pending') AS diagnosis
FROM Visits;

--17 Display patient phone numbers; replace NULL with 'No Phone'.
SELECT
    patient_id,
	COALESCE(phone, 'NO phone') AS phone
FROM Patients;

--18 Retrieve prescriptions’ medication_name; if NULL, replace with 'To Be Assigned'.

SELECT
    prescription_id,
	COALESCE(medication_name, 'To Be Assigned') AS medication_name
FROM Prescriptions;

--19 Show Billing discount; if NULL, replace with 0.
SELECT
    Bill_id,
	COALESCE(discount, 0) AS discount
FROM Billing;

--20 Retrieve patient city and phone; use COALESCE to replace NULLs with 'Unknown' and 'No Contact'.
SELECT
    patient_id,
	COALESCE(city, 'Unknown') AS city,
	COALESCE(CONVERT(VARCHAR(20), phone),'No Contact') AS phone
FROM Patients;

--21 Show prescriptions where dosage is '0'; treat '0' as NULL.
SELECT
    prescription_id,
    medication_name,
    COALESCE(NULLIF(dosage, '0'), 'Treated as NULL') AS dosage
FROM Prescriptions
WHERE dosage IS NULL OR dosage = '0';

--22 Retrieve patient phone; treat empty string '' as NULL.

SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_name,
	COALESCE(NULLIF(phone,''), 'Treated AS null') AS phone
FROM Patients;


--23 Display doctors’ department; treat 'NA' as NULL.

SELECT
    doctor_id,
	CONCAT(first_name,' ',last_name) AS Full_name,
	COALESCE(NULLIF(department,'NA'), 'Treated AS NA') AS department
FROM Doctors;

--24 Show patients’ age; treat 0 as NULL.

SELECT
    patient_id,
    COALESCE(CONVERT(VARCHAR(20), NULLIF(age, 0)), 'Treat AS 0') AS age
FROM Patients;


--25 Retrieve Billing consultation_fee; treat 0 as NULL.
SELECT
    Bill_id,
    COALESCE(CONVERT(VARCHAR(20), NULLIF(ROUND(consultation_fee,0), 0)), 'Treat AS 0') AS consultation_fee
FROM Billing;


--26 Show prescriptions; treat 'Not Assigned' medication_name as NULL.
SELECT
    prescription_id,
    COALESCE(NULLIF(medication_name, 'Not Assigned'), 'Treated as NULL') AS medication_name
FROM Prescriptions;


--27 Display visits; treat 'Unknown' department as NULL.
SELECT
    visit_id,
    COALESCE(NULLIF(department, 'Unknown'), 'Treated as NULL') AS department
FROM Visits;


--28 Retrieve patients’ city; treat 'N/A' as NULL.
SELECT
    patient_id,
    COALESCE(NULLIF(city, 'N/A'), 'Treated as NULL') AS city
FROM Patients;


--29 Show doctors’ last_name; treat empty string as NULL.
SELECT
    doctor_id,
    first_name,
    COALESCE(NULLIF(last_name, ''), 'Treated as NULL') AS last_name
FROM Doctors;

--30 Retrieve prescriptions’ dosage; treat 0mg as NULL.
SELECT
    prescription_id,
	COALESCE(NULLIF(CONVERT(VARCHAR(20),dosage), '0mg'), 'Treated as NULL') AS dosage
FROM Prescriptions;

--31 Find patients whose phone is NULL.
SELECT * FROM Patients
WHERE phone IS NULL;

--32 List visits where diagnosis IS NULL.
SELECT * FROM Visits
WHERE diagnosis IS NULL;

--33 Retrieve prescriptions where dosage IS NULL.
SELECT * FROM Prescriptions
WHERE dosage IS NULL;

--34 Show doctors whose department IS NULL.
SELECT * FROM Doctors
WHERE department IS NULL;

--35 Find patients with NULL age.
SELECT * FROM Patients
 WHERE age IS NULL;

--36 List visits where visit_date IS NULL.
SELECT * FROM Visits
WHERE visit_date IS NULL;

--37 Retrieve prescriptions where medication_name IS NULL.
SELECT * FROM Prescriptions
WHERE medication_name IS NULL;

--38 Show Billing rows where discount IS NULL.
SELECT * FROM Billing
WHERE discount IS NULL;

--39 Find patients whose city IS NULL.
SELECT * FROM Patients
WHERE city IS NULL;

--40 List doctors with NULL last_name.
SELECT * FROM Doctors
WHERE last_name IS NULL;

--41 Show patients with NOT NULL phone numbers.
SELECT * FROM Patients
WHERE phone IS NOT NULL;

--42 Retrieve visits where diagnosis IS NOT NULL.
SELECT * FROM Visits
WHERE diagnosis IS NOT NULL;

--43 Display prescriptions with NOT NULL dosage.
SELECT * FROM Prescriptions
WHERE dosage IS NOT NULL;

--44 List doctors with department IS NOT NULL.
SELECT * FROM Doctors
WHERE department IS NOT NULL;

--45 Find patients whose age IS NOT NULL.
SELECT * FROM Patients
WHERE age IS NOT NULL;

--46 Show visits with visit_date IS NOT NULL.
SELECT * FROM Visits
WHERE visit_date IS NOT NULL;

--47 Retrieve prescriptions where medication_name IS NOT NULL.
SELECT * FROM Prescriptions
WHERE medication_name IS NOT NULL;

--48 Display Billing rows where discount IS NOT NULL.
SELECT * FROM Billing
WHERE discount IS NOT NULL;

--49 Find patients whose city IS NOT NULL.
SELECT * FROM Patients
WHERE city IS NOT NULL;

--50 List doctors with last_name IS NOT NULL.
SELECT * FROM Doctors
WHERE last_name IS NOT NULL;

