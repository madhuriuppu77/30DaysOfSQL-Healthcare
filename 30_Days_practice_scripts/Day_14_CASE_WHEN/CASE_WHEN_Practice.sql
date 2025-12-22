-- ==========================================================
-- 50 SQL  Questions on CASE WHEN 
-- ==========================================================

-- 

-- 1. Show all patients and categorize their age group as 'Young' (<35), 'Middle' (35-60), or 'Senior' (>60) using CASE WHEN.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	city,
	age,
	CASE 
	    WHEN age < 35 THEN 'Young'
		WHEN age BETWEEN 35 AND 60 THEN 'Middle'
		WHEN age > 60 THEN 'Senior'
		ELSE 'N/A'
	END AS age_group,
	phone
FROM Patients;

-- 2. Display all doctors and label them as 'Specialist' if department is 'Cardiology' or 'Neurology', otherwise 'General'.
SELECT
    doctor_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	department,
	CASE
	    WHEN department IN ('Cardiology' ,'Neurology') THEN 'Specialist'
		ELSE 'General'
	END AS department_group
FROM Doctors;

-- 3. Retrieve visits and add a column 'Visit Type' as 'Critical' if diagnosis is 'Hypertension' or 'Fracture', else 'Regular'.
SELECT
    visit_id,
	visit_date,
	diagnosis,
	CASE 
	    WHEN diagnosis IN ('Hypertension' , 'Fracture') THEN 'Critical'
		ELSE 'Regular'
	END AS visit_Type
FROM Visits;


-- 4. List patients with a column 'Phone Status' as 'Available' or 'Missing' depending on whether phone is NULL.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	city,
	Phone,
	CASE
	    WHEN Phone IS NOT NULL THEN 'Available'
		ELSE 'Missing'
	END AS phone_status
FROM Patients;


-- 5. For each prescription, mark 'Dosage Info' as 'Provided' if dosage is not NULL, else 'Pending'.
SELECT
    prescription_id,
	dosage,
	CASE
	    WHEN dosage IS NOT NULL THEN 'provided'
		ELSE 'Pending'
	END AS Dosage_Info
FROM Prescriptions;

-- 6. Show billing records and create a column 'Discount Status' as 'Negative' if discount < 0, 'Zero' if 0, 'Positive' otherwise.
SELECT
    bill_id,
	discount,
	CASE
	    WHEN discount < 0 THEN 'Negative'
		WHEN discount = 0 THEN 'Zero'
		ELSE 'Positive'
	END AS Discount_Status
FROM Billing;

-- 7. List patients and indicate 'Senior Citizen' if age >= 60, else 'Adult'.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	CASE
	    WHEN age >= 60 THEN 'Senior Citizen'
		ELSE 'Adult'
	END AS Age_status
FROM Patients;


-- 8. Display visits with 'Doctor Assigned' as 'Yes' if doctor_id is not NULL, else 'No'.
SELECT
    visit_id,
	doctor_id,
	CASE
	    WHEN doctor_id IS NOT NULL THEN 'Yes'
		ELSE 'No'
	END AS Doctor_Assigned
FROM Visits;


-- 9. Show billing records and flag 'Tax High' if tax_percent > 15, else 'Tax Normal'.
SELECT
    bill_id,
	tax_percent,
	CASE 
	    WHEN tax_percent > 15 THEN 'Tax High'
		ELSE 'Tax Normal'
	END AS Flag
FROM Billing;

-- 10. List patients and categorize them by gender using CASE WHEN (Male/Female/Unknown).

SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	city,
	gender,
	CASE
	    WHEN UPPER(gender)= 'M' THEN 'MALE'
		WHEN UPPER(gender) ='F' THEN 'FEMALE'
		ELSE 'UNKNOWN'
	END AS Gender_categorize
FROM Patients;


-- 11. Count the number of patients in each age group (Young, Middle, Senior) using CASE WHEN in GROUP BY.
SELECT
   
    CASE 
	    WHEN age < 35 THEN 'Young'
		WHEN age BETWEEN 35 AND 60 THEN 'Middle'
		WHEN age > 60 THEN 'Senior'
		ELSE 'N/A'
	END AS age_group,
	COUNT(patient_id) AS Total_patients_per_agegroup
FROM Patients
WHERE age IS NOT NULL
GROUP BY 
CASE 
	    WHEN age < 35 THEN 'Young'
		WHEN age BETWEEN 35 AND 60 THEN 'Middle'
		WHEN age > 60 THEN 'Senior'
		ELSE 'N/A'
END ;

-- 12. Display each visit and calculate 'Total Fee' as consultation_fee + medicine_cost - discount. Use CASE WHEN to mark if total_fee > 1000 as 'High', else 'Normal'.(wrong query)
SELECT
    visit_id,
	Total_fee,
	CASE 
	    WHEN Total_fee > 1000 THEN 'High'
		ELSE 'Normal'
	END AS Total_fee_mark
FROM
(SELECT 
    v.visit_id,
	SUM(COALESCE(b.consultation_fee,0)+COALESCE(b.medicine_cost,0)-COALESCE(b.discount,0)) AS Total_fee
FROM Billing b
LEFT JOIN Visits v
ON b.patient_id= v.patient_id
GROUP BY v.visit_id)t;

-- Calculate total fee per visit safely and mark as High/Normal( correct query)
SELECT
    v.visit_id,
    v.patient_id,
    COALESCE(b.consultation_fee, 0) + COALESCE(b.medicine_cost, 0) - COALESCE(b.discount, 0) AS Total_fee,
    CASE
        WHEN COALESCE(b.consultation_fee, 0) + COALESCE(b.medicine_cost, 0) - COALESCE(b.discount, 0) > 1000
        THEN 'High'
        ELSE 'Normal'
    END AS Total_fee_mark
FROM Visits v
LEFT JOIN Billing b
    ON v.patient_id = b.patient_id
    AND v.visit_date = b.created_date;  -- Match billing to visit by date



-- 13. Show patients and mark 'High Risk' if age > 50 AND city is 'Hyderabad' using CASE WHEN.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_name,
	city,
	age,
	CASE 
	    WHEN age > 50 AND UPPER(city) = 'HYDERABAD' THEN 'High Risk'
		ELSE 'Normal'
	END AS Age_city_mark
FROM Patients
WHERE age IS NOT NULL AND city IS NOT NULL;

-- 14. Retrieve all doctors and categorize as 'Busy' if they have more than 2 visits assigned, else 'Free'.
SELECT 
    d.doctor_id,
    CONCAT(d.first_name,' ',d.last_name) AS Doctor_name,
    COUNT(v.visit_id) AS Total_visits_per_doc,
    CASE
        WHEN COUNT(v.visit_id) > 2 THEN 'Busy'
        ELSE 'Free'
    END AS doctors_schedule
FROM Doctors d
LEFT JOIN Visits v
ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;


-- 15. Show visits with a column 'Critical Visit' as 'Yes' if diagnosis is in ('Hypertension', 'Migraine', 'Fracture') and visit_date before '2024-04-01', else 'No'.
SELECT
    visit_id,
	visit_date,
	diagnosis,
	CASE 
	    WHEN diagnosis IN ('Hypertension', 'Migraine', 'Fracture') AND visit_date < '2024-04-01' THEN 'Yes'
		ELSE 'No'
	END AS  Critical_Visit
FROM Visits
WHERE visit_date IS NOT NULL AND diagnosis IS NOT NULL;


-- 16. List patients along with the number of visits and label them 'Frequent' if visits > 2 using CASE WHEN.
SELECT 
    patient_id,
    Full_Name,
	Total_visits_per_patient,
	CASE
	    WHEN Total_visits_per_patient > 2 THEN 'Frequent'
		ELSE 'Normal'
	END AS visits_frequency
FROM
(SELECT 
p.patient_id,
CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
COUNT(v.visit_id) AS Total_visits_per_patient
FROM Patients p
LEFT JOIN Visits v
ON P.patient_id= v.patient_id
GROUP BY p.patient_id,p.first_name, p.last_name) t;


-- 17. Display billing and create a column 'Net Medicine Cost' as medicine_cost - discount; if medicine_cost is NULL, mark as 0. ELSE 1
SELECT
    bill_id,
    medicine_cost,
    discount,
    CASE
        WHEN medicine_cost IS NULL THEN 0
        ELSE medicine_cost - discount
    END AS Net_Medicine_Cost
FROM Billing;


-- 18. Show all prescriptions and mark 'Urgent' if dosage contains 'mg' and visit_id corresponds to diagnosis 'Fracture'.
SELECT 
    p.prescription_id,
	v.visit_id,
	p.dosage,
	v.diagnosis,
	CASE
	    WHEN p.dosage LIKE '%mg%'  AND v.diagnosis = 'Fracture' THEN 'Urgent'
		ELSE 'No Urgent'
	END AS mark_urgency
FROM Prescriptions p
LEFT JOIN Visits v
ON p.visit_id = v.visit_id
WHERE p.dosage IS NOT NULL AND v.diagnosis IS NOT NULL;



-- 19. Retrieve visits with a column 'Doctor Type' as 'Cardiology Specialist' if department='Cardiology' AND doctor_id is not NULL, else 'Other'.
SELECT
    Visit_id,
	doctor_id,
	department,
	CASE
	    WHEN department ='Cardiology' AND doctor_id IS NOT NULL THEN 'Cardiology Specialist'
		ELSE 'Other'
	END AS Doctor_Type
FROM Visits


-- 20. List patients and mark 'Has Contact' if phone is not NULL AND city is not NULL.
SELECT
    patient_id,
	city,
	age,
	phone,
	CASE
	   WHEN phone IS NOT NULL AND city IS NOT NULL THEN 'Has Contact'
	   ELSE 'No contact'
	END AS Patient_Details
FROM Patients;


-- 21. Show billing records and classify as 'Loss' if consultation_fee + medicine_cost - discount < 0, else 'Profit'.
SELECT
    bill_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_Revenue,
	CASE
	    WHEN SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) < 0 THEN 'Loss'
		ELSE 'Profit'
	END AS Revenue_status
FROM Billing
GROUP BY  bill_id;



-- 22. Display visits and create 'Visit Month Type' as 'Quarter Start' if MONTH(visit_date) in (1,4,7,10), else 'Other Month'.
SELECT
    visit_id,
	visit_date,
	CASE
	    WHEN MONTH(visit_date) IN (1,4,7,10) THEN 'Quarter Start'
		ELSE 'Other Month'
	END AS Visit_Month_Type
FROM Visits;


-- 23. Retrieve patients and label as 'Senior Female' if gender='F' AND age > 60, 'Senior Male' if gender='M' AND age>60, else 'Other'.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	gender,
	age,
	CASE 
	    WHEN gender ='F' AND age> 60 THEN 'Senior Female'
		WHEN gender ='M' AND age > 60 THEN 'Senior Male'
		ELSE 'Other'
	END AS Gender_age_group
FROM Patients
WHERE age IS NOT NULL AND gender IS NOT NULL;

-- 24. List doctors and flag 'No Department' if department IS NULL, else 'Assigned'.
SELECT
    doctor_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	department,
	CASE
	    WHEN department IS NULL THEN 'No Department'
		ELSE 'Assigned'
	END AS flag_department
FROM Doctors;



-- 25. Show prescriptions and categorize dosage as 'High Dose' if >50mg, 'Low Dose' if <=50mg using CASE WHEN.
SELECT
    prescription_id,
    dosage,
    CASE 
        WHEN CAST(REPLACE(dosage, 'mg', '') AS INT) > 50 THEN 'High Dose'
        WHEN CAST(REPLACE(dosage, 'mg', '') AS INT) <= 50 THEN 'Low Dose'
        ELSE 'No Dose'
    END AS Categorize_dosage
FROM Prescriptions;




-- 26. Display each billing record and create a column 'Tax Category' as 'High Tax' if tax_percent > 12 AND discount < 0, else 'Normal Tax'.
SELECT
    bill_id,
	tax_percent,
	discount,
	CASE
	    WHEN tax_percent > 12 AND discount < 0 THEN 'High Tax'
		ELSE 'Normal Tax'
	END AS Tax_category
FROM Billing;


-- 27. Retrieve visits and categorize as 'Recent Critical' if diagnosis IN ('Hypertension','Fracture') AND visit_date >= '2024-03-01', else 'Other'.
SELECT
    visit_id,
	diagnosis,
	CASE
	   WHEN diagnosis IN ('Hypertension','Fracture') AND visit_date >= '2024-03-01' THEN 'Recent Critical'
	   ELSE 'Other'
	END AS categorize_diagnosis
FROM Visits
WHERE diagnosis IS NOT NULL AND Visit_date IS NOT NULL;


-- 28. Show patients and mark 'VIP Patient' if age > 50 AND city IN ('Hyderabad','Chennai') AND phone IS NOT NULL.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	city,
	CASE
	    WHEN age > 50 AND city IN ('Hyderabad','Chennai') AND phone IS NOT NULL THEN 'VIP Patient'
		ELSE 'Normal Patient'
	END AS categorize_patient
FROM Patients;


-- 29. List visits and create a column 'Visit Status' as 'Completed' if diagnosis IS NOT NULL AND doctor_id IS NOT NULL, else 'Pending'.
SELECT
    visit_id,
	doctor_id,
	diagnosis,
	CASE
	   WHEN diagnosis IS NOT NULL AND doctor_id IS NOT NULL THEN 'Completed'
	   ELSE 'Pending'
	END AS Visit_Status
FROM Visits;


-- 30. Show billing and flag 'Check Discount' if discount < 0 AND consultation_fee < 500.
SELECT
    bill_id,
	discount,
	consultation_fee,
	CASE
	   WHEN discount < 0 AND consultation_fee < 500 THEN 'Check Discount'
	   ELSE 'Ignore'
	END AS Flag_bill
FROM Billing;


-- 31. Display prescriptions joined with visits and label 'Urgent Medication' if dosage > '50mg' AND diagnosis IN ('Fracture','Hypertension').
SELECT  
    p.prescription_id,
    v.visit_id,
    p.dosage,
    v.diagnosis,
    CASE
        WHEN CAST(REPLACE(REPLACE(dosage,'mg',''),' ','') AS INT) > 50
             AND diagnosis IN ('Fracture','Hypertension')
        THEN 'Urgent Medication'
        ELSE 'No Urgency'
    END AS Label_diagnosis
FROM Visits v
LEFT JOIN Prescriptions p
ON v.visit_id = p.visit_id;

-- 32. List patients with a column 'Contact Validity' as 'Valid' if phone IS NOT NULL AND LEN(phone)=10, else 'Invalid'.
SELECT  
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	age,
	city,
	phone,
	CASE 
	   WHEN phone IS NOT NULL AND LEN(phone) =10 THEN 'Valid'
	   ELSE 'Invalid'
	END AS contact_validity
FROM Patients;

-- 33. Retrieve visits and classify 'Doctor Availability' as 'Multiple Doctors' if patient has more than 1 visit with different doctors, else 'Single Doctor'.
SELECT
    patient_id,
	COUNT(doctor_id) AS Total_doctors_per_patient,
	CASE 
	    WHEN COUNT(doctor_id)> 1 THEN 'Multiple Doctors'
		ELSE 'Single Doctor'
	END AS Doctor_availability
FROM
(SELECT 
    p.patient_id,
	d.doctor_id,
	COUNT(v.visit_id) AS Total_visits
FROM Visits v
LEFT JOIN patients p
ON v.patient_id= p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id, p.patient_id)t

GROUP BY patient_id;

SELECT 
    v.patient_id,
    COUNT(DISTINCT v.doctor_id) AS distinct_doctors,
    CASE 
        WHEN COUNT(DISTINCT v.doctor_id) > 1 THEN 'Multiple Doctors'
        ELSE 'Single Doctor'
    END AS doctor_availability
FROM Visits v
GROUP BY v.patient_id;


-- 34. Show billing and categorize 'Profit Bracket' as 'High' if total_fee (consultation_fee + medicine_cost - discount) > 1500, 'Medium' if between 1000-1500, else 'Low'.
SELECT
    bill_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_fee,
	CASE
	    WHEN SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) > 1500 THEN 'High'
		WHEN SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) BETWEEN 1000 AND 1500 THEN 'Medium'
		ELSE 'Low'
	END AS profit_Bracket
FROM Billing
GROUP BY bill_id;


-- 35. List visits and flag 'Null Department' if department IS NULL OR doctor_id IS NULL, else 'Assigned'.
SELECT
    visit_id,
	department,
	CASE
	    WHEN department IS NULL OR doctor_id IS NULL THEN 'Null Department'
		ELSE 'Assigned'
	END AS Flag_Department
FROM Visits;

-- 36. Display patients and classify age using nested CASE WHEN: 'Young Adult' if 18-35, 'Adult' if 36-60, 'Elderly' if >60.
SELECT
    patient_id,
	age,
	CASE
	    WHEN age BETWEEN 18 AND 35 THEN 'Young Adult'
		WHEN age BETWEEN 36 AND 60 THEN 'Adult'
		WHEN age > 60 THEN 'Elderly'
	    ELSE 'N/A'
	END AS age_group
FROM Patients;


-- 37. Retrieve billing records and mark 'Special Case' if consultation_fee > 500 AND medicine_cost > 1000 AND discount < 0.
SELECT
    bill_id,
	CASE
	    WHEN  consultation_fee > 500 AND medicine_cost > 1000 AND discount < 0 THEN 'Special Case'
		ELSE 'No Special Case'
	END AS Billing_record_mark
FROM Billing;

-- 38. Show visits with 'Critical Follow-up' if diagnosis IN ('Hypertension','Migraine') AND patient had previous visit in last 30 days.
SELECT
    visit_id,
	diagnosis,
	visit_date,
	CASE
    WHEN diagnosis IN ('Hypertension','Migraine') 
         AND visit_date >= DATEADD(DAY,-30, GETDATE()) THEN 'Critical Follow-up'
    ELSE 'Nothing Serious'
END AS Follow_up

FROM Visits;


-- 39. Display prescriptions with 'Dosage Status' as 'Missing' if dosage IS NULL OR dosage='' else 'Provided'.
SELECT
    prescription_id,
	dosage,
	CASE
	    WHEN dosage IS NULL OR dosage ='' THEN 'Missing'
		ELSE 'provided'
	END AS Dosage_Status
FROM Prescriptions;

-- 40. List visits and classify 'Priority Visit' as 'High' if diagnosis IN ('Fracture','Chest Pain') AND visit_date falls on weekend.
SELECT
    visit_id,
	visit_date,
	FORMAT(visit_date,'dddd') AS Formatted_date,
	diagnosis,
	CASE
    WHEN diagnosis IN ('Fracture','Chest Pain') 
         AND DATEPART(WEEKDAY, visit_date) IN (7,1) THEN 'High'
    ELSE 'Low'
END AS priority_visit

FROM Visits;



-- 41. Show patients and mark 'At Risk' if age > 60 OR phone IS NULL OR city IN ('Delhi','Bangalore').
SELECT
    patient_id,
	age,
	city,
	phone,
	CASE 
	    WHEN age > 60 OR phone IS NULL OR city IN ('Delhi','Bangalore') THEN 'At Risk'
		ELSE 'No Risk'
	END AS Recent_overview
FROM Patients;

-- 42. Retrieve billing records and create 'Financial Alert' as 'Critical Loss' if consultation_fee + medicine_cost - discount < 0 AND tax_percent > 15.

SELECT
    bill_id,
	tax_percent,
	
	CASE 
	    WHEN consultation_fee + medicine_cost - discount < 0 AND tax_percent > 15 THEN 'Critical Loss'
		ELSE 'No Loss'
	END AS Financial_Alert
FROM Billing;

-- 43. Display visits and create 'Follow-up Required' as 'Yes' if diagnosis IS NULL OR patient had previous visit in last 15 days.
SELECT
    v1.visit_id,
    v1.patient_id,
    v1.diagnosis,
    v1.visit_date,
    CASE
        WHEN v1.diagnosis IS NULL 
             OR EXISTS (
                 SELECT 1
                 FROM Visits v2
                 WHERE v2.patient_id = v1.patient_id
                   AND v2.visit_date < v1.visit_date
                   AND v2.visit_date >= DATEADD(DAY, -15, v1.visit_date)
             )
        THEN 'Follow-up Required'
        ELSE 'No Follow-up Required'
    END AS Check_up
FROM Visits v1;


-- 44. List doctors and mark 'Multi-department' if doctor has visits in more than 1 department, else 'Single Department'.
SELECT
    doctor_id,
    COUNT(DISTINCT department) AS Total_department_per_doc,
    CASE
        WHEN COUNT(DISTINCT department) > 1 THEN 'Multi-department'
        ELSE 'Single-department'
    END AS Mark_department
FROM Visits
WHERE department IS NOT NULL
GROUP BY doctor_id;


-- 45. Show prescriptions and classify medication as 'High Risk' if medication_name IN ('Amlodipine','Atorvastatin') AND dosage > '20mg'.
SELECT
    prescription_id,
	dosage,
	medication_name,
	CASE
	    WHEN medication_name IN ('Amlodipine','Atorvastatin') AND CAST(REPLACE(dosage,'mg','')AS INT)>20 THEN 'High Risk'
		ELSE 'No Risk'
	END AS Classify_medication
FROM Prescriptions;

-- 46. Retrieve patients and flag 'Incomplete Info' if any of age, phone, city IS NULL.
SELECT
    patient_id,
	CONCAT(first_name,' ',last_name) AS Full_Name,
	city,
	age,
	phone,
	CASE
	    WHEN age IS NULL OR phone IS NULL OR city IS NULL THEN 'Incomplete Info'
		ELSE 'Complete Info'
	END AS patient_Info
FROM Patients;


-- 47. Display billing joined with patients and mark 'Senior Discount' if age > 60 AND discount > 0, else 'No Discount'.
SELECT
    b.bill_id,
	p.patient_id,
	p.age,
	b.discount,
	CASE 
	    WHEN p.age >60 AND discount > 0 THEN 'Senior Discount'
		ELSE 'No Discount'
	END AS bill_patient

FROM Billing b
LEFT JOIN Patients p
ON b.patient_id= p.patient_id

-- 48. Show visits joined with prescriptions and flag 'Urgent Follow-up' if diagnosis IN ('Back Pain','Fracture') AND prescription dosage IS NULL.
SELECT 
    p.prescription_id,
	v.visit_date,
	v.diagnosis,
	p.dosage,
	CASE
	    WHEN v.diagnosis IN ('Back Pain','Fracture') AND p.dosage IS NULL THEN 'Urgent Follow-up'
		ELSE 'Not Requried Follow-up'
	END AS Flag_follow_up


FROM Visits v
LEFT JOIN Prescriptions p
ON v.visit_id= p.visit_id;

-- 49. List all events from DateTimePractice and categorize 'Time of Day' as 'Morning' (06-12), 'Afternoon' (12-18), 'Evening' (18-24), 'Night' (00-06) using CASE WHEN on event_time.

SELECT
    record_id,
    event_name,
    event_date,
    event_datetime,
    CASE
        WHEN DATEPART(HOUR, event_datetime) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, event_datetime) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, event_datetime) BETWEEN 18 AND 23 THEN 'Evening'
        WHEN DATEPART(HOUR, event_datetime) BETWEEN 0 AND 5 THEN 'Night'
        ELSE 'N/A'
    END AS Time_of_day
FROM DateTimePractice;

-- 50. Retrieve all events and classify 'Event Type' as 'Peak Hours' if event_datetime falls on weekday between 09:00-17:00, else 'Off Hours'.
SELECT
    record_id,
    event_name,
    event_date,
    event_datetime,
    CASE
        WHEN DATEPART(WEEKDAY, event_datetime) BETWEEN 2 AND 6 
             AND DATEPART(HOUR, event_datetime) BETWEEN 9 AND 17
        THEN 'Peak Hours'
        ELSE 'Off Hours'
    END AS Event_Type
FROM DateTimePractice;


--COUNTS DUPLICATE KEYS

SELECT SUM(visits_count * billing_count) AS predicted_rows
FROM
    (SELECT patient_id, COUNT(*) AS visits_count
     FROM Visits
     GROUP BY patient_id) v
JOIN
    (SELECT patient_id, COUNT(*) AS billing_count
     FROM Billing
     GROUP BY patient_id) b
ON v.patient_id = b.patient_id;


