-- 1) Calculate the percent rank of patients based on age in ascending order.
SELECT
    patient_id,
    first_name,
    age,
    PERCENT_RANK() OVER (ORDER BY age) AS age_percent_rank
FROM Patients
WHERE age IS NOT NULL;


-- 2) Calculate the percent rank of patients based on age in descending order.
SELECT
    patient_id,
    first_name,
    age,
    PERCENT_RANK() OVER (ORDER BY age DESC) AS age_percent_rank
FROM Patients
WHERE age IS NOT NULL;

-- 3) Find the percent rank of doctors based on total number of visits handled.
SELECT
    doctor_id,
	Total_visits,
	PERCENT_RANK() OVER( ORDER BY Total_visits DESC) AS Percent_rank
FROM
(
SELECT
    doctor_id,
	COUNT(visit_id) AS Total_visits
FROM visits
GROUP BY doctor_id)t


-- 4) Calculate percent rank of visits based on visit_cost.
SELECT
    visit_id,
	visit_cost,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost) AS percent_rank
FROM visits;


-- 5) Find the percent rank of prescriptions based on dosage length (character count).
SELECT
    prescription_id,
	LEN(dosage) AS length_dosage,
	PERCENT_RANK() OVER(ORDER BY LEN(dosage) DESC) AS Percent_rank
FROM Prescriptions;

-- 6) Calculate percent rank of patients based on total billing amount (consultation_fee + medicine_cost).
SELECT
    patient_id,
	Total_billing_amount,
	PERCENT_RANK() OVER (ORDER BY Total_billing_amount DESC) AS Percent_rank
FROM
(
SELECT
    patient_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)-COALESCE(discount,0)) AS Total_billing_amount
FROM Billing
GROUP BY patient_id)t;


-- 7) Find percent rank of visits within each department based on visit_cost.
SELECT
    visit_id,
	department,
	visit_cost,
	PERCENT_RANK() OVER(PARTITION BY department ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost) AS percent_rank
FROM Visits
WHERE department IS NOT NULL;

-- 8) Calculate percent rank of doctors within each department based on total visits.
SELECT
   doctor_id,
   Total_number_of_visits,
   department,
   PERCENT_RANK() OVER(PARTITION BY department  ORDER BY Total_number_of_visits DESC) AS Percent_rank
FROM
(
SELECT
    doctor_id,
	department,
	COUNT(visit_id) AS Total_number_of_visits
FROM visits
WHERE department IS NOT NULL
GROUP BY doctor_id,department)t;


-- 9) Find percent rank of patients based on number of visits.
SELECT
    patient_id,
	Total_number_of_visits,
	PERCENT_RANK() OVER( ORDER BY Total_number_of_visits DESC) AS Percent_rank
FROM
(
SELECT
    patient_id,
	COUNT(visit_id) AS Total_number_of_visits
FROM visits
GROUP BY patient_id)t;

-- 10) Calculate percent rank of billing records based on discount amount.
SELECT
    bill_id,
	discount,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN discount IS NULL THEN 1 ELSE 0 END,discount DESC) AS PERCENT_RANK
FROM Billing;

-- 11) Find percent rank of billing records based on ABS(discount).
SELECT
    bill_id,
	ABS(discount) AS Discount,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN ABS(discount) IS NULL THEN 1 ELSE 0 END,discount DESC) AS PERCENT_RANK
FROM Billing;

-- 12) Calculate percent rank of patients based on maximum consultation_fee paid.
SELECT
    patient_id,
	Max_fee,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN Max_fee IS NULL THEN 1 ELSE 0 END,Max_fee) AS Percent_rank
FROM
(
SELECT
    patient_id,
	MAX(consultation_fee) AS Max_fee
FROM Billing
GROUP BY patient_id)t;

-- 13) Find percent rank of patients based on average medicine_cost.
SELECT
    patient_id,
	Avg_cost,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN Avg_cost IS NULL THEN 1 ELSE 0 END,Avg_cost DESC) AS Percent_rank
FROM
(
SELECT
    patient_id,
	AVG(medicine_cost) AS Avg_cost
FROM Billing
GROUP BY patient_id)t;

-- 14) Calculate percent rank of doctors based on total revenue generated.
SELECT
    doctor_id,
	Total_revenue,
	PERCENT_RANK() OVER(ORDER BY Total_revenue DESC) AS Percent_rank
FROM
(
SELECT
    doctor_id,
	SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_revenue
FROM Billing
GROUP BY doctor_id)t;

-- 15) Find percent rank of visits based on visit_date.
SELECT
    visit_id,
	visit_date,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Percent_rank
FROM Visits;

-- 16) Calculate percent rank of visits within each doctor based on visit_cost.
SELECT
    visit_id,
	doctor_id,
	visit_cost,
	PERCENT_RANK() OVER(PARTITION BY doctor_id ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost DESC) AS Percent_rank
FROM Visits;

-- 17) Find percent rank of patients within each city based on age.
SELECT
    patient_id,
	age,
	city,
	PERCENT_RANK() OVER(PARTITION BY city ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,age DESC) AS percent_rank
FROM Patients
WHERE city IS NOT NULL;


-- 18) Calculate percent rank of patients within gender based on age.
SELECT
    patient_id,
	age,
	gender,
	PERCENT_RANK() OVER(PARTITION BY gender ORDER BY CASE WHEN age IS NULL THEN 1 ELSE 0 END,age DESC) AS percent_rank
FROM Patients
WHERE gender IS NOT NULL;

-- 19) Find percent rank of billing records within each tax_percent based on medicine_cost.
SELECT
    bill_id,
	tax_percent,
	medicine_cost,
	PERCENT_RANK() OVER(PARTITION BY tax_percent ORDER BY CASE WHEN medicine_cost IS NULL THEN 1 ELSE 0 END,medicine_cost) AS Percent_rank
FROM Billing;

-- 20) Calculate percent rank of prescriptions within each visit based on dosage.
SELECT
    prescription_id,
	visit_id,
	PERCENT_RANK() OVER(PARTITION BY visit_id ORDER BY CASE WHEN dosage IS NULL THEN 1 ELSE 0 END,dosage) AS Percent_rank
FROM Prescriptions;

-- 21) Find percent rank of patients based on number of NULL values in billing records.
SELECT
    patient_id,
    Number_of_NULLs,
    PERCENT_RANK() OVER(ORDER BY Number_of_NULLs DESC) AS Percent_rank
FROM
(
    SELECT
        patient_id,
        SUM(
            CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END +
            CASE WHEN medicine_cost IS NULL THEN 1 ELSE 0 END +
            CASE WHEN discount IS NULL THEN 1 ELSE 0 END
        ) AS Number_of_NULLs
    FROM Billing
    GROUP BY patient_id
) t;

-- 22) Calculate percent rank of doctors based on count of high-cost visits (visit_cost > 600).
SELECT
    doctor_id,
    HighCost_Visits,
    PERCENT_RANK() OVER(ORDER BY HighCost_Visits DESC) AS Percent_rank
FROM
(
    SELECT
        doctor_id,
        COUNT(*) AS HighCost_Visits
    FROM Visits
    WHERE visit_cost > 600
    GROUP BY doctor_id
) t;

-- 23) Find percent rank of visits based on visit_cost where visit_status = 'COMPLETED'.
SELECT
    visit_id,
	visit_cost,
	visit_status,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost DESC) AS Percent_rank
FROM Visits
WHERE visit_status = 'COMPLETED';

-- 24) Calculate percent rank of visits within each month based on visit_cost.
SELECT
    visit_id,
	YEAR(visit_date) AS Year_visitdate,
	MONTH(visit_date) AS Month_visitdate,
	visit_cost,
	PERCENT_RANK() OVER(PARTITION BY YEAR(visit_date),MONTH(visit_date)
	ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost DESC) AS Percent_rank
FROM Visits
WHERE visit_date IS NOT NULL;


-- 25) Find percent rank of patients based on earliest visit_date.
SELECT
    patient_id,
    First_visit_date,
    PERCENT_RANK() OVER(
        ORDER BY 
        CASE WHEN First_visit_date IS NULL THEN 1 ELSE 0 END,
        First_visit_date ASC
    ) AS Percent_rank
FROM
(
    SELECT
        patient_id,
        MIN(visit_date) AS First_visit_date
    FROM Visits
    GROUP BY patient_id
) t;


-- 26) Calculate percent rank of patients based on latest visit_date.
SELECT
    patient_id,
    Last_visit_date,
    PERCENT_RANK() OVER(
        ORDER BY 
        CASE WHEN Last_visit_date IS NULL THEN 1 ELSE 0 END,
        Last_visit_date DESC
    ) AS Percent_rank
FROM
(
    SELECT
        patient_id,
        MAX(visit_date) AS Last_visit_date
    FROM Visits
    GROUP BY patient_id
) t;

-- 27) Find percent rank of billing records based on total bill amount including tax.
SELECT
    bill_id,
    Total_bill_amount,
    PERCENT_RANK() OVER(
        ORDER BY 
        CASE WHEN Total_bill_amount IS NULL THEN 1 ELSE 0 END,
        Total_bill_amount DESC
    ) AS Percent_rank
FROM
(
    SELECT
        bill_id,
        (
            (COALESCE(consultation_fee, 0) 
           + COALESCE(medicine_cost, 0) 
           - COALESCE(discount, 0))
          +
            (
            (COALESCE(consultation_fee, 0) 
           + COALESCE(medicine_cost, 0) 
           - COALESCE(discount, 0))
            * COALESCE(tax_percent, 0) / 100.0
            )
        ) AS Total_bill_amount
    FROM Billing
) t;
 
-- 28) Calculate percent rank of visits within each department based on visit_date.
SELECT
    visit_id,
	department,
	visit_date,
	PERCENT_RANK() OVER (PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date DESC) AS Percent_rank
FROM Visits
WHERE department IS NOT NULL;


-- 29) Find percent rank of doctors based on average consultation_fee.
SELECT
    doctor_id,
	Avg_fee,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN Avg_fee IS NULL THEN 1 ELSE 0 END,Avg_fee DESC) AS Percent_rank
FROM
(
SELECT
    doctor_id,
	AVG(consultation_fee) AS Avg_fee
FROM Billing
GROUP BY doctor_id)t;

-- 30) Calculate percent rank of patients based on total discount received.
SELECT
    patient_id,
	Total_discount,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN Total_discount IS NULL THEN 1 ELSE 0 END,Total_discount DESC) AS Percent_rank
FROM
(
SELECT
    patient_id,
	SUM(discount) AS Total_discount
FROM Billing
GROUP BY patient_id)t;

-- 31) Find percent rank of patients based on consistency of bp_systolic readings.
SELECT
    patient_id,
    bp_range,
    PERCENT_RANK() OVER(ORDER BY bp_range) AS Percent_rank
FROM
(
    SELECT
        patient_id,
        MAX(bp_systolic) - MIN(bp_systolic) AS bp_range
    FROM VitalReadings
    GROUP BY patient_id
) t;

-- 32) Calculate percent rank of vital readings within each patient based on bp_systolic.
SELECT
    reading_id,
	patient_id,
	bp_systolic,
	PERCENT_RANK() OVER(PARTITION BY patient_id ORDER BY CASE WHEN bp_systolic IS NULL THEN 1 ELSE 0 END,bp_systolic DESC) AS Percent_rank
FROM VitalReadings;

-- 33) Find percent rank of vital readings based on bp_diastolic.
SELECT
    reading_id,
	bp_diastolic,
	PERCENT_RANK() OVER( ORDER BY CASE WHEN bp_diastolic IS NULL THEN 1 ELSE 0 END,bp_diastolic DESC) AS Percent_rank
FROM VitalReadings;

-- 34) Calculate percent rank of patients based on maximum bp_systolic value.
SELECT
    patient_id,
	Max_bp,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN Max_bp IS NULL THEN 1 ELSE 0 END,Max_bp DESC) AS Percent_rank
FROM
(
SELECT
    patient_id,
	MAX(bp_systolic) AS Max_bp
FROM VitalReadings
GROUP BY patient_id)t;

-- 35) Find percent rank of patients based on minimum bp_diastolic value.
SELECT
    patient_id,
	Min_bp,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN Min_bp IS NULL THEN 1 ELSE 0 END,Min_bp DESC) AS Percent_rank
FROM
(
SELECT
    patient_id,
	MIN(bp_diastolic) AS Min_bp
FROM VitalReadings
GROUP BY patient_id)t;

-- 36) Calculate percent rank of billing records based on consultation_fee ignoring NULLs.
SELECT
    bill_id,
	consultation_fee,
	PERCENT_RANK() OVER(ORDER BY consultation_fee DESC) AS Percent_rank
FROM Billing
WHERE consultation_fee IS NOT NULL;

-- 37) Find percent rank of visits based on visit_cost with NULL visit_cost handled last.
SELECT
    visit_id,
	visit_cost,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost DESC) AS Percent_rank
FROM Visits;

-- 38) Calculate percent rank of doctors based on number of NULL departments.
SELECT
    doctor_id,
    No_of_null_department,
    PERCENT_RANK() OVER(ORDER BY No_of_null_department DESC) AS Percent_rank
FROM
(
    SELECT
        d.doctor_id,
        COUNT(CASE WHEN v.department IS NULL THEN 1 END) AS No_of_null_department
    FROM Doctors d
    LEFT JOIN Visits v
        ON d.doctor_id = v.doctor_id
    GROUP BY d.doctor_id
) t;

-- 39) Find percent rank of patients based on phone number availability.
SELECT
    patient_id,
    phone,
    PERCENT_RANK() OVER (
        ORDER BY CASE WHEN phone IS NOT NULL THEN 1 ELSE 0 END DESC
    ) AS Percent_rank
FROM Patients;

-- 40) Calculate percent rank of patients within each city based on number of visits.
SELECT
    patient_id,
    city,
    Number_of_visits,
    PERCENT_RANK() OVER (
        PARTITION BY city 
        ORDER BY Number_of_visits DESC
    ) AS Percent_rank
FROM (
    SELECT 
        p.patient_id,
        p.city,
        COUNT(v.visit_id) AS Number_of_visits
    FROM Patients p
    LEFT JOIN Visits v
        ON p.patient_id = v.patient_id
    WHERE p.city IS NOT NULL
    GROUP BY p.patient_id, p.city
) t;

-- 41) Find percent rank of visits based on diagnosis length.
SELECT
    visit_id,
	LEN(diagnosis) AS Length_of_diagnosis,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN LEN(diagnosis) IS NULL THEN 1 ELSE 0 END, LEN(diagnosis) DESC) AS Percent_rank
FROM Visits;

-- 42) Calculate percent rank of prescriptions based on presence of NULL medication_name.
SELECT
    prescription_id,
    medication_name,
    PERCENT_RANK() OVER(
        ORDER BY 
            CASE WHEN medication_name IS NULL THEN 1 ELSE 0 END
    ) AS Percent_rank
FROM Prescriptions;


-- 43) Find percent rank of patients based on average visit_cost.
SELECT
    patient_id,
	Avg_visit_cost,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN Avg_visit_cost IS NULL THEN 1 ELSE 0 END,Avg_visit_cost DESC) AS Percent_rank
FROM
(
SELECT
    patient_id,
	AVG(visit_cost) AS Avg_visit_cost
FROM Visits
GROUP BY patient_id)t;

-- 44) Calculate percent rank of doctors within each department based on revenue.
SELECT
    doctor_id,
    department,
    Total_revenue,
    PERCENT_RANK() OVER (
        PARTITION BY department
        ORDER BY Total_revenue DESC
    ) AS Percent_rank
FROM (
    SELECT 
        d.doctor_id,
        d.department,
        SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0) - COALESCE(discount,0)) AS Total_revenue
    FROM Doctors d
    LEFT JOIN Billing b
        ON d.doctor_id = b.doctor_id
    WHERE d.department IS NOT NULL
    GROUP BY d.doctor_id, d.department
) t;

-- 45) Find percent rank of visits within visit_status based on visit_cost.
SELECT
    visit_id,
	visit_cost,
	visit_status,
	PERCENT_RANK() OVER(PARTITION BY visit_status ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC) AS Percent_rank
FROM Visits;

-- 46) Calculate percent rank of patients based on total number of prescriptions.
SELECT
    patient_id,
	Total_no_pres,
	PERCENT_RANK() OVER(ORDER BY Total_no_pres DESC) AS Percent_rank
FROM
(
SELECT 
    v.patient_id,
	COUNT(p.prescription_id) AS Total_no_pres
FROM Visits v
LEFT JOIN Prescriptions p
ON v.visit_id = p.visit_id
GROUP BY v.patient_id)t;

-- 47) Find percent rank of visits based on visit_cost grouped by year.
SELECT
    visit_id,
	YEAR(visit_date) AS Year_visit_date,
	Visit_cost,
	PERCENT_RANK() OVER(PARTITION BY YEAR(visit_date) ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,visit_cost) AS Percent_rank
FROM Visits
WHERE visit_date IS NOT NULL;

-- 48) Calculate percent rank of billing records within each doctor based on total amount.
SELECT
    doctor_id,
    Total_revenue,
    PERCENT_RANK() OVER (
        ORDER BY Total_revenue DESC
    ) AS Percent_rank
FROM (
    SELECT 
        d.doctor_id,
        SUM(COALESCE(b.consultation_fee,0) + COALESCE(b.medicine_cost,0) - COALESCE(b.discount,0)) AS Total_revenue
    FROM Doctors d
    LEFT JOIN Billing b
        ON d.doctor_id = b.doctor_id
    GROUP BY d.doctor_id
) t;

-- 49) Find percent rank of patients based on count of completed visits.
SELECT
    patient_id,
	Number_of_visits,
	PERCENT_RANK() OVER(ORDER BY Number_of_visits DESC) AS Percent_rank
FROM
(
SELECT
    patient_id,
	COUNT(visit_id) AS Number_of_visits
FROM Visits
WHERE visit_status = 'COMPLETED'
GROUP BY patient_id)t;

-- 50) Calculate percent rank of doctors based on patient count handled.
SELECT
    doctor_id,
	no_of_patient,
	PERCENT_RANK() OVER(ORDER BY no_of_patient DESC) AS Percent_rank
FROM
(
SELECT
    doctor_id,
	COUNT(patient_id) AS no_of_patient
FROM Visits
GROUP BY doctor_id)t;
