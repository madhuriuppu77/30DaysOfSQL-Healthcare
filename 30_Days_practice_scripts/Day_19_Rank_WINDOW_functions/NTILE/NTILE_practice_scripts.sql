-- 1) Assign NTILE(4) to patients based on age in ascending order.
SELECT
    patient_id,
	age,
	NTILE(4) OVER(ORDER BY age ASC) AS Rank_group
FROM Patients
WHERE age IS NOT NULL;

SELECT
    patient_id,
	age,
	NTILE(4) OVER(ORDER BY CASE WHEN  age IS NULL THEN 1 ELSE 0 END, age ASC) AS Rank_group
FROM Patients

-- 2) Divide all visits into 3 buckets based on visit_cost descending.
SELECT
    visit_id,
	visit_cost,
	NTILE(3) OVER( ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC) AS Rank_grp
FROM Visits;

-- 3) Assign NTILE(5) to doctors based on the number of visits they handled.
SELECT
    doctor_id,
	COUNT(visit_id) AS Number_visits,
	NTILE(5) OVER(ORDER BY COUNT(visit_id) DESC) AS Rank_grp
FROM Visits
GROUP BY doctor_id;

-- 4) Divide patients into 2 buckets based on the number of prescriptions.
SELECT
    patient_id,
    Number_of_prescription,
    NTILE(2) OVER (
        ORDER BY Number_of_prescription DESC
    ) AS Rank_into_grps
FROM (
    SELECT
        v.patient_id,
        COUNT(pr.prescription_id) AS Number_of_prescription
    FROM Visits v
    LEFT JOIN Prescriptions pr
        ON v.visit_id = pr.visit_id
    GROUP BY v.patient_id
) t;

-- 5) Create quartiles for total billing amount per patient using NTILE(4).
SELECT
    patient_id,
	Total_billing,
	NTILE(4) OVER(ORDER BY Total_billing DESC) AS Rank_in_grps
FROM
(
SELECT
    patient_id,
	SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_billing
FROM Billing
GROUP BY patient_id)t;

-- 6) Partition visits by department and assign NTILE(3) based on visit_cost.
SELECT
    visit_id,
	department,
	COALESCE(visit_cost,0) AS visit_cost,
	NTILE(3) OVER(PARTITION BY department ORDER BY COALESCE(visit_cost,0) DESC) AS Rank_in_grps
FROM Visits
WHERE department IS NOT NULL;


-- 7) Partition patients by city and divide each city into 2 buckets based on age.
SELECT
    patient_id,
	city,
	age,
	NTILE(2) OVER(PARTITION BY city ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,age) AS Rank_in_grps
FROM Patients
WHERE city IS NOT NULL;

-- 8) Divide prescriptions into 3 buckets based on dosage (highest to lowest).
SELECT
    prescription_id,
    dosage,
    NTILE(3) OVER (
        ORDER BY 
            CASE WHEN dosage IS NULL THEN 1 ELSE 0 END,
            CAST(REPLACE(dosage, 'mg', '') AS INT) DESC
    ) AS Rank_into_grps
FROM Prescriptions;

-- 9) Partition visits by visit_status and assign NTILE(2) based on visit_cost.
SELECT
    visit_id,
	visit_status,
	COALESCE(visit_cost,0) AS Visit_cost,
	NTILE(2) OVER(PARTITION BY visit_status ORDER BY COALESCE(visit_cost,0) DESC) AS Rank_into_grps
FROM Visits
WHERE visit_status IS NOT NULL;

-- 10) Create deciles (NTILE(10)) for bp_systolic readings per patient.
SELECT
    patient_id,
    bp_systolic,
    NTILE(10) OVER (
        ORDER BY 
            CASE WHEN bp_systolic IS NULL THEN 1 ELSE 0 END,
            bp_systolic DESC
    ) AS Rank_in_grps
FROM VitalReadings;

-- 11) Partition vital readings by patient_id and assign NTILE(4) on bp_diastolic.
SELECT
	patient_id,
	bp_diastolic,
	NTILE(4) OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_diastolic IS NULL THEN 1 ELSE 0 END, bp_diastolic DESC) AS Rank_in_grps
FROM VitalReadings;

-- 12) Rank patients into NTILE(3) buckets based on total number of visits.
SELECT
    patient_id,
	number_of_visits,
	NTILE(3) OVER(ORDER BY number_of_visits DESC) AS Rank_in_grps
FROM
(
SELECT
    patient_id,
	COUNT(visit_id) AS number_of_visits
FROM Visits
GROUP BY patient_id)t;

-- 13) Partition doctors by department and assign NTILE(4) on total consultation_fee.
SELECT
    doctor_id,
	department,
	Total_consultation_fee,
	NTILE(4) OVER(PARTITION BY department ORDER BY Total_consultation_fee DESC) Rank_into_grps
FROM
(
SELECT 
    d.doctor_id,
	d.department,
	SUM(COALESCE(b.consultation_fee,0)) AS Total_consultation_fee
FROM Doctors d
LEFT JOIN Billing b
ON d.doctor_id= b.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.doctor_id,d.department)t
;

-- 14) Assign NTILE(2) for billing records based on medicine_cost descending.
SELECT
    bill_id,
	COALESCE(medicine_cost,0) AS medicine_cost,
	NTILE(2) OVER(ORDER BY COALESCE(medicine_cost,0) DESC) AS Rank_in_grps
FROM Billing;

-- 15) Divide all billing records into 5 NTILE buckets based on discount amount.
SELECT
    bill_id,
    COALESCE(discount, 0) AS discount,
    NTILE(5) OVER (ORDER BY COALESCE(discount, 0) DESC) AS Rank_in_grps
FROM Billing;

-- 16) Partition visits by doctor_id and create 3 NTILE buckets by visit_cost.
SELECT
    visit_id,
	doctor_id,
	COALESCE(visit_cost,0) AS visit_cost,
	NTILE(3) OVER(PARTITION BY doctor_id ORDER BY COALESCE(visit_cost,0) DESC) AS Rank_in_grps
FROM Visits;

-- 17) Assign NTILE(4) to patients based on age, ignore NULL values.
SELECT
    patient_id,
	age,
	NTILE(4) OVER(ORDER BY age DESC) AS Rank_in_grps
FROM Patients
WHERE age IS NOT NULL;

-- 18) Partition prescriptions by visit_id and assign NTILE(2) based on dosage.
SELECT
    prescription_id,
    visit_id,
    dosage,
    NTILE(2) OVER (
        PARTITION BY visit_id
        ORDER BY
            CASE WHEN dosage IS NULL THEN 1 ELSE 0 END,
            dosage DESC
    ) AS Rank_in_grps
FROM (
    SELECT
        prescription_id,
        visit_id,
        CAST(REPLACE(dosage, 'mg', '') AS INT) AS dosage
    FROM Prescriptions
) t;


-- 19) Divide all patients into NTILE(3) based on number of visits where diagnosis IS NULL.
SELECT
    patient_id,
	Number_of_visits,
	NTILE(3) OVER(ORDER BY Number_of_visits DESC) AS Rank_in_grps
FROM
(
SELECT
    patient_id,
	COUNT(visit_id) AS Number_of_visits
FROM Visits
WHERE diagnosis IS  NULL
GROUP BY patient_id)t;

-- 20) Partition Billing by doctor_id and create 4 NTILE buckets based on total cost (consultation_fee + medicine_cost - discount).
SELECT
    doctor_id,
	Total_cost,
	NTILE(4) OVER(ORDER BY Total_cost DESC) AS Rank_in_grps
FROM
(
SELECT
    doctor_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_cost
FROM Billing
GROUP BY doctor_id)t;

-- 21) Assign NTILE(4) for visit_cost among visits that have visit_status = 'COMPLETED'.
SELECT
    visit_id,
	visit_status,
	COALESCE(visit_cost,0) AS Visit_cost,
	NTILE(4) OVER(ORDER BY COALESCE(visit_cost,0) DESC) AS Rank_in_grps
FROM Visits
WHERE visit_status = 'COMPLETED';

-- 22) Partition patients by gender and assign NTILE(3) based on age.
SELECT
    patient_id,
	gender,
	age,
	NTILE(3) OVER(PARTITION BY gender ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,age) AS Rank_in_grps
FROM Patients
WHERE gender IS NOT NULL;


-- 23) Create NTILE(5) for all visits based on visit_date ascending.
SELECT
    visit_id,
    visit_date,
    NTILE(5) OVER (
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date ASC
    ) AS Rank_in_grp
FROM Visits;

-- 24) Partition vital readings by patient_id and assign NTILE(3) based on reading_date.
SELECT
    patient_id,
	reading_date,
	NTILE(3) OVER(PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Rank_grp
FROM VitalReadings;

-- 25) Divide all doctors into NTILE(3) buckets based on total number of patients they have seen.
SELECT
    doctor_id,
	Number_of_patient,
	NTILE(3) OVER(ORDER BY Number_of_patient DESC) AS Rank_in_grps
FROM
(
SELECT
    doctor_id,
	COUNT(patient_id) AS Number_of_patient
FROM Visits
GROUP BY doctor_id)t;

-- 26) Partition billing records by patient_id and assign NTILE(2) based on consultation_fee.
SELECT
    bill_id,
	patient_id,
	COALESCE(consultation_fee,0) AS consultation_fee,
	NTILE(2) OVER(PARTITION BY patient_id ORDER BY COALESCE(consultation_fee,0)DESC) AS Rank_in_grp
FROM Billing;

-- 27) Assign NTILE(4) to patients based on total number of prescriptions per patient.
SELECT
    patient_id,
	Total_number_prescription,
	NTILE(4) OVER(ORDER BY Total_number_prescription DESC) AS Rank_in_grps
FROM
(
SELECT 
    v.patient_id,
	COUNT(pr.prescription_id) AS Total_number_prescription
FROM Prescriptions pr 
LEFT JOIN visits v
ON pr.visit_id= v.visit_id
GROUP BY v.patient_id)t;

-- 28) Partition visits by department and assign NTILE(3) based on visit_date ascending.
SELECT
    visit_id,
	department,
	visit_date,
	NTILE(3) OVER(PARTITION BY department ORDER BY  CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date ASC) AS Rank_in_grp
FROM Visits
WHERE department IS NOT NULL;

-- 29) Divide all prescriptions into NTILE(5) based on length of medication_name.
SELECT
    prescription_id,
	medication_name,
	LEN(medication_name) AS Length_of_medication_name,
	NTILE(5) OVER(ORDER BY LEN(medication_name) DESC) AS Rank_in_grp
FROM Prescriptions
WHERE medication_name IS NOT NULL;

-- 30) Partition billing by doctor_id and create 3 NTILE buckets using tax_percent descending.
SELECT
    bill_id,
	doctor_id,
	COALESCE(tax_percent,0) AS Tax_percent,
	NTILE(3) OVER(PARTITION BY doctor_id ORDER BY COALESCE(tax_percent,0) DESC) AS Rank_in_grp
FROM Billing;

-- 31) Assign NTILE(2) to visits based on visit_cost where diagnosis IS NOT NULL.
SELECT
    visit_id,
	COALESCE(visit_cost,0) AS Visit_cost,
	NTILE(2) OVER(ORDER BY COALESCE(visit_cost,0) DESC) AS Rank_in_grp
FROM Visits
WHERE diagnosis IS NOT NULL;

-- 32) Partition patients by city and assign NTILE(3) based on age descending.
SELECT
    patient_id,
    city,
    age,
    NTILE(3) OVER (
        PARTITION BY city
        ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END, age DESC
    ) AS Rank_in_grp
FROM Patients
WHERE city IS NOT NULL;

-- 33) Divide vital readings into NTILE(4) buckets based on bp_systolic descending.
SELECT
    reading_id,
	bp_systolic,
	NTILE(4) OVER(ORDER BY CASE WHEN bp_systolic IS NULL THEN 1 ELSE 0 END,bp_systolic DESC ) AS rank_in_grp
FROM VitalReadings;

-- 34) Partition doctors by department and assign NTILE(2) based on total billing amount of patients.
SELECT
    doctor_id,
	department,
	Total_billing_patient,
	NTILE(2) OVER(PARTITION BY department ORDER BY Total_billing_patient DESC) AS Rank_in_grp
FROM
(
SELECT 
    d.doctor_id,
	d.department,
	SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0)-COALESCE(b.discount,0)) AS Total_billing_patient
FROM Doctors d
LEFT JOIN Billing b
ON d.doctor_id= b.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.doctor_id, d.department)t;
  
-- 35) Assign NTILE(3) to patients based on total sum of discounts in Billing.
SELECT
    patient_id,
	Total_discount,
	NTILE(3) OVER(ORDER BY Total_discount DESC) AS Rank_in_grp
FROM
(
SELECT
    patient_id,
	SUM(COALESCE(discount,0)) AS Total_discount
FROM Billing
GROUP BY patient_id)t;

-- 36) Partition billing by patient_id and assign NTILE(4) using total_amount = consultation_fee + medicine_cost - discount.
SELECT
    patient_id,
	Total_amount,
	NTILE(4) OVER(ORDER BY Total_amount DESC) AS Rank_in_grp
FROM
(
SELECT
    patient_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)-COALESCE(discount,0)) AS Total_amount
FROM Billing
GROUP BY patient_id)t;

-- 37) Divide all visits into NTILE(3) based on visit_cost, ignoring NULL visit_cost values.
SELECT
    visit_id,
    COALESCE(visit_cost, 0) AS visit_cost,
    NTILE(3) OVER (ORDER BY COALESCE(visit_cost, 0) DESC) AS Rank_in_grp
FROM Visits
WHERE visit_cost IS NOT NULL;

-- 38) Partition prescriptions by visit_id and create NTILE(2) based on dosage ascending.
SELECT
    visit_id,
	prescription_id,
	CAST(REPLACE(dosage, 'mg','') AS INT) AS dosage,
	NTILE(2) OVER(ORDER BY CAST(REPLACE(dosage, 'mg','') AS INT) ASC) AS Rank_in_grp
FROM Prescriptions
WHERE dosage IS NOT NULL;

-- 39) Assign NTILE(5) to patients based on age, partitioned by gender.
SELECT
    patient_id,
	gender,
	age,
	NTILE(5) OVER(PARTITION BY gender ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,age) AS Rank_in_grp
FROM Patients
WHERE gender IS NOT NULL;

-- 40) Partition visits by doctor_id and assign NTILE(4) based on number of prescriptions per visit.
WITH visit_cte AS (
    SELECT
        v.visit_id,
        v.doctor_id,
        COUNT(p.prescription_id) AS Number_of_prescriptions
    FROM Visits v
    LEFT JOIN Prescriptions p
        ON v.visit_id = p.visit_id
    GROUP BY v.visit_id, v.doctor_id
)
SELECT
    visit_id,
    doctor_id,
    Number_of_prescriptions,
    NTILE(4) OVER (
        PARTITION BY doctor_id
        ORDER BY Number_of_prescriptions DESC
    ) AS Rank_in_grp
FROM visit_cte;


-- 41) Divide all billing records into 3 NTILE buckets based on created_date ascending.
SELECT
    bill_id,
	created_date,
	NTILE(3) OVER(ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date ASC) AS Rank_in_grp
FROM Billing;

-- 42) Partition patients by city and assign NTILE(2) on number of visits where visit_status = 'PENDING'.
SELECT
    patient_id,
	Number_of_visits,
	city,
	NTILE(2) OVER(PARTITION BY city ORDER BY Number_of_visits DESC) AS Rank_in_grp
FROM
(
SELECT 
    p.patient_id,
	p.city,
	COUNT(v.visit_id) AS Number_of_visits
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id
WHERE v.visit_status = 'PENDING'
GROUP BY p.patient_id,p.city)t
WHERE city IS NOT NULL;
  
-- 43) Assign NTILE(4) to doctors based on total consultation_fee they received.
SELECT
    doctor_id,
	Total_fee,
	NTILE(4) OVER(ORDER BY Total_fee DESC) AS Rank_in_grp
FROM
(
SELECT
    doctor_id,
	SUM(COALESCE(consultation_fee,0)) AS Total_fee
FROM Billing
GROUP BY doctor_id)t;

-- 44) Partition vital readings by patient_id and assign NTILE(2) on bp_diastolic ascending.
SELECT
    patient_id,
    bp_diastolic,
    NTILE(2) OVER (
        PARTITION BY patient_id
        ORDER BY 
            CASE WHEN bp_diastolic IS NULL THEN 1 ELSE 0 END,
            bp_diastolic ASC
    ) AS Rank_in_grp
FROM VitalReadings;

-- 45) Divide patients into NTILE(3) buckets based on number of visits in Cardiology department.
SELECT
    patient_id,
    Number_of_visits,
    NTILE(3) OVER (ORDER BY Number_of_visits DESC) AS Rank_in_grp
FROM (
    SELECT
        patient_id,
        COUNT(visit_id) AS Number_of_visits
    FROM Visits
    WHERE department = 'Cardiology'
    GROUP BY patient_id
) t;

-- 46) Partition billing by doctor_id and assign NTILE(4) based on discount descending.
SELECT
    doctor_id,
	discount,
	NTILE(4) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN discount IS NULL THEN 1 ELSE 0 END,discount DESC) AS Rank_in_grp
FROM Billing;

-- 47) Assign NTILE(3) to all visits based on visit_cost, partitioned by visit_status.
SELECT
    visit_id,
    visit_cost,
    visit_status,
    NTILE(3) OVER (
        PARTITION BY visit_status
        ORDER BY 
            CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,
            visit_cost
    ) AS Rank_in_grp
FROM Visits
WHERE visit_status IS NOT NULL;

-- 48) Partition prescriptions by visit_id and assign NTILE(4) based on medication_name alphabetically.
SELECT
    prescription_id,
	visit_id,
	medication_name,
	NTILE(4) OVER(PARTITION BY visit_id ORDER BY CASE WHEN medication_name IS NULL THEN 1 ELSE 0 END,medication_name ASC) AS Rank_in_grp
FROM Prescriptions;

-- 49) Divide patients into NTILE(5) based on age where city IS NOT NULL.
SELECT
    patient_id,
    age,
    NTILE(5) OVER (
        ORDER BY age DESC
    ) AS Rank_in_grp
FROM Patients
WHERE city IS NOT NULL
  AND age IS NOT NULL;


-- 50) Partition visits by department and assign NTILE(3) on visit_date descending.
SELECT
    visit_id,
	department,
	visit_date,
	NTILE(3) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date DESC) AS Rank_in_grp
FROM Visits
WHERE department IS NOT NULL;
