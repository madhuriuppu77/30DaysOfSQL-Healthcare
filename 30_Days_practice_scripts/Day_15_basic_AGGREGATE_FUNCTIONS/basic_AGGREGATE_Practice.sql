
/* ================== BASIC AGGREGATE SQL QUESTIONS () ================== */


/* 1. Count total visits per doctor and show only doctors who handled more than 2 visits.
   Explanation:
   - We want results per doctor → GROUP BY doctor.
   - COUNT() counts visits.
   - HAVING is used because we filter on aggregated value.
*/
SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS Full_Name,
    COUNT(v.visit_id) AS Total_visits
FROM Visits v
JOIN Doctors d
ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING COUNT(v.visit_id) > 2;


/* 2. Calculate total billing amount per patient and show only totals above 1500.
   Explanation:
   - Arithmetic operation → COALESCE required.
   - GROUP BY patient.
   - HAVING filters aggregated sum.
*/
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    SUM(
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0)
    ) AS Total_billing
FROM Billing b
JOIN Patients p
ON b.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING SUM(
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0)
    ) > 1500;


/* 3. Find average patient age per city, excluding NULL age.
   Explanation:
   - AVG ignores NULL automatically.
   - WHERE filters invalid rows before grouping.
*/
SELECT
    city,
    AVG(age) AS Avg_age
FROM Patients
WHERE age IS NOT NULL
  AND city IS NOT NULL
GROUP BY city;


/* 4. Show department-wise count of visits excluding NULL departments.
   Explanation:
   - Group by department.
   - WHERE removes NULL departments before aggregation.
*/
SELECT
    department,
    COUNT(visit_id) AS Total_visits
FROM Visits
WHERE department IS NOT NULL
GROUP BY department;


/* 5. Find maximum and minimum consultation_fee charged by each doctor.
   Explanation:
   - MAX/MIN pick values → DO NOT COALESCE.
   - Group by doctor.
*/
SELECT
    d.doctor_id,
    CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
    MAX(b.consultation_fee) AS Max_fee,
    MIN(b.consultation_fee) AS Min_fee
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;



/* 6. Count number of patients per city and show only cities with more than 1 patient.
   Explanation:
   - COUNT patients per city.
   - HAVING filters aggregated count.
*/
SELECT
    city,
    COUNT(patient_id) AS Total_patients
FROM Patients
WHERE city IS NOT NULL
GROUP BY city
HAVING COUNT(patient_id) > 1;


/* 7. Calculate total medicine_cost per month using created_date.
   Explanation:
   - SUM → COALESCE required.
   - Group by YEAR + MONTH.
*/
SELECT
    YEAR(created_date) AS Year_,
    MONTH(created_date) AS Month_,
    SUM(COALESCE(medicine_cost,0)) AS Total_medicine_cost
FROM Billing
GROUP BY YEAR(created_date), MONTH(created_date);


/* 8. Show doctors who have handled patients from more than one city.
   Explanation:
   - DISTINCT counts unique cities.
   - HAVING filters doctors with >1 city.
*/
SELECT
    d.doctor_id,
    COUNT(DISTINCT p.city) AS City_count
FROM Visits v
JOIN Doctors d ON v.doctor_id = d.doctor_id
JOIN Patients p ON v.patient_id = p.patient_id
WHERE p.city IS NOT NULL
GROUP BY d.doctor_id
HAVING COUNT(DISTINCT p.city) > 1;


/* 9. Find total visits per month excluding NULL visit_date.
   Explanation:
   - WHERE removes NULL dates.
   - GROUP BY month/year.
*/
SELECT
    YEAR(visit_date) AS Year_,
    MONTH(visit_date) AS Month_,
    COUNT(visit_id) AS Total_visits
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY YEAR(visit_date), MONTH(visit_date);


/* 10. Calculate average billing amount per doctor.
   Explanation:
   - Arithmetic → COALESCE required.
   - AVG ignores NULL automatically.
*/
SELECT
    d.doctor_id,
    AVG(
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0)
    ) AS Avg_billing
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.doctor_id;


/* 11. Show patients with more than one visit.
   Explanation:
   - Count visits per patient.
   - HAVING filters aggregated count.
*/
SELECT
    p.patient_id,
    COUNT(v.visit_id) AS Visit_count
FROM Visits v
JOIN Patients p
ON v.patient_id = p.patient_id
GROUP BY p.patient_id
HAVING COUNT(v.visit_id) > 1;


/* 12. Find total revenue per department.
   Explanation:
   - Arithmetic → COALESCE.
   - Group by department.
*/
SELECT
    d.department,
    SUM(
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0)
    ) AS Total_revenue
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.department;


/* 13. Calculate total discount per doctor and show discounts < 0.
   Explanation:
   - SUM discounts.
   - HAVING filters negative totals.
*/
SELECT
    d.doctor_id,
    SUM(b.discount) AS Total_discount
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.doctor_id
HAVING SUM(b.discount) < 0;


/* 14. Show department-wise average patient age.
   Explanation:
   - AVG ignores NULL age.
   - Group by department.
*/
SELECT
    v.department,
    AVG(p.age) AS Avg_age
FROM Visits v
JOIN Patients p
ON v.patient_id = p.patient_id
WHERE v.department IS NOT NULL
GROUP BY v.department;


/* 15. Count prescriptions per medication_name excluding NULL.
   Explanation:
   - WHERE removes NULL values before grouping.
*/
SELECT
    medication_name,
    COUNT(prescription_id) AS Total_prescriptions
FROM Prescriptions
WHERE medication_name IS NOT NULL
GROUP BY medication_name;


/* 16. Find doctors whose average consultation_fee > 600.
   Explanation:
   - AVG ignores NULL automatically.
   - HAVING filters aggregated value.
*/
SELECT
    doctor_id,
    AVG(consultation_fee) AS Avg_fee
FROM Billing
GROUP BY doctor_id
HAVING AVG(consultation_fee) > 600;


/* 17. Show city-wise total billing for patients aged above 40.
   Explanation:
   - Age filter in WHERE.
   - Arithmetic → COALESCE.
*/
SELECT
    p.city,
    SUM(
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0)
    ) AS Total_billing
FROM Billing b
JOIN Patients p
ON b.patient_id = p.patient_id
WHERE p.age > 40
GROUP BY p.city;


/* 18. Count visits per diagnosis excluding NULL.
   Explanation:
   - WHERE removes NULL diagnosis.
*/
SELECT
    diagnosis,
    COUNT(*) AS Total_visits
FROM Visits
WHERE diagnosis IS NOT NULL
GROUP BY diagnosis;


/* 19. Calculate month-wise total tax collected.
   Explanation:
   - SUM → COALESCE.
   - Group by month/year.
*/

SELECT
    YEAR(created_date) AS Year_,
    MONTH(created_date) AS Month_,
    SUM(
        (COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0))
        * COALESCE(tax_percent,0) / 100
    ) AS Total_tax
FROM Billing
GROUP BY YEAR(created_date), MONTH(created_date);



/* 20. Show doctors who treated more than 3 distinct patients.
   Explanation:
   - DISTINCT counts unique patients.
*/
SELECT
    doctor_id,
    COUNT(DISTINCT patient_id) AS Patient_count
FROM Visits
GROUP BY doctor_id
HAVING COUNT(DISTINCT patient_id) > 3;


/* 21. Find patients whose total billing > overall average billing.
   Explanation:
   - Compare per-patient SUM with global AVG.
*/
SELECT
    patient_id,
    SUM(
        COALESCE(consultation_fee,0)
      + COALESCE(medicine_cost,0)
      - COALESCE(discount,0)
    ) AS Total_billing
FROM Billing
GROUP BY patient_id
HAVING SUM(
        COALESCE(consultation_fee,0)
      + COALESCE(medicine_cost,0)
      - COALESCE(discount,0)
    ) > (
        SELECT AVG(
            COALESCE(consultation_fee,0)
          + COALESCE(medicine_cost,0)
          - COALESCE(discount,0)
        )
        FROM Billing
    );


/* 22. Calculate average medicine_cost per department.
   Explanation:
   - AVG ignores NULL automatically.
*/
SELECT
    d.department,
    AVG(b.medicine_cost) AS Avg_medicine_cost
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.department;


/* 23. Show department-wise count of doctors and visits together.
   Explanation:
   - COUNT DISTINCT doctors.
   - COUNT visits.
*/
SELECT
    department,
    COUNT(DISTINCT doctor_id) AS Doctor_count,
    COUNT(visit_id) AS Visit_count
FROM Visits
GROUP BY department;


/* 24. Find doctors who have never prescribed any medication.
   Explanation:
   - LEFT JOIN + NULL check identifies missing records.
*/
SELECT
    d.doctor_id
FROM Doctors d
LEFT JOIN Prescriptions p
ON d.doctor_id = p.doctor_id
WHERE p.prescription_id IS NULL;


/* 25. Calculate total revenue per patient including tax.
   Explanation:
   - Arithmetic → COALESCE.
*/
SELECT
    patient_id,
    SUM(
        COALESCE(consultation_fee,0)
      + COALESCE(medicine_cost,0)
      + COALESCE(tax_percent,0)
      - COALESCE(discount,0)
    ) AS Total_revenue
FROM Billing
GROUP BY patient_id;


/* 26. Show visit count per weekday using visit_date.
   Explanation:
   - DATENAME extracts weekday.
*/
SELECT
    DATEPART(WEEKDAY, visit_date) AS Weekday_Number,
    DATENAME(WEEKDAY, visit_date) AS Weekday_Name,
    COUNT(*) AS Visit_count
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATEPART(WEEKDAY, visit_date), DATENAME(WEEKDAY, visit_date)
ORDER BY Weekday_Number;



/* 27. Find departments where average billing exceeds 1200.
   Explanation:
   - AVG arithmetic → COALESCE.
   - HAVING filters aggregated average.
*/
SELECT
    d.department,
    AVG(
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0)
    ) AS Avg_billing
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.department
HAVING AVG(
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0)
    ) > 1200;


-- 28. Count number of NULL diagnoses per department.
-- Explanation:
-- - WHERE diagnosis IS NULL filters only NULL rows.
-- - COUNT(*) counts rows, not column values.
-- - GROUP BY department gives department-wise count.

SELECT
    department,
    COUNT(*) AS Number_of_null_diagnosis
FROM Visits
WHERE diagnosis IS NULL
GROUP BY department;


-- 29. Show patients who have visits in more than one department.
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	COUNT(DISTINCT v.department) Total_departments_visited_patient
FROM visits v
INNER JOIN patients p
ON v.patient_id= p.patient_id
WHERE v.department IS NOT NULL
GROUP BY p.patient_id,p.first_name,p.last_name
HAVING COUNT(DISTINCT v.department) > 1;


-- 30. Calculate total billing per month and show only top 3 months by revenue.
SELECT TOP 3
    YEAR(created_date) AS Year_created_date,
    MONTH(created_date) AS Month_created_date,
    SUM(
        COALESCE(consultation_fee, 0) 
      + COALESCE(medicine_cost, 0) 
      - COALESCE(discount, 0)
    ) AS Total_billing
FROM Billing
GROUP BY YEAR(created_date), MONTH(created_date)
ORDER BY Total_billing DESC;


-- 31. Show doctors who have handled patients aged above the average age.
-- Explanation:
-- - Subquery calculates average patient age.
-- - Filter patients whose age is above average.
-- - DISTINCT ensures each doctor appears only once.

SELECT DISTINCT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS Full_Name
FROM Visits v
INNER JOIN Doctors d
    ON v.doctor_id = d.doctor_id
INNER JOIN Patients p
    ON v.patient_id = p.patient_id
WHERE p.age > (
    SELECT AVG(age)
    FROM Patients
    WHERE age IS NOT NULL
);

-- 32. Count prescriptions per visit and show visits with more than one prescription.
-- Explanation:
-- - GROUP BY visit_id to aggregate prescriptions per visit.
-- - COUNT(*) counts number of prescription records.
-- - HAVING filters visits with more than one prescription.

SELECT
    v.visit_id,
    COUNT(*) AS Total_prescriptions_per_visit
FROM Prescriptions p
JOIN Visits v
    ON p.visit_id = v.visit_id
GROUP BY v.visit_id
HAVING COUNT(*) > 1;

  
-- 33. Calculate city-wise average consultation_fee.
SELECT  
    p.city,
	AVG(b.consultation_fee) AS Avg_fee
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id= p.patient_id
AND p.city IS NOT NULL
GROUP BY p.city
HAVING p.city IS NOT NULL;


-- 34. Find maximum billing amount per patient.
-- Explanation:
-- - Calculate billing amount per bill.
-- - MAX() finds the highest bill per patient.

SELECT
    patient_id,
    MAX(
        COALESCE(consultation_fee, 0)
      + COALESCE(medicine_cost, 0)
      - COALESCE(discount, 0)
    ) AS Max_billing
FROM Billing
GROUP BY patient_id;

-- 35. Show doctors whose total medicine_cost exceeds 2000.
-- Explanation:
-- - Aggregate medicine_cost per doctor.
-- - GROUP BY doctor to calculate totals.
-- - HAVING filters doctors whose total exceeds 2000.

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS Full_Name,
    SUM(COALESCE(b.medicine_cost, 0)) AS Total_medicine_cost
FROM Billing b
JOIN Doctors d
    ON b.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING SUM(COALESCE(b.medicine_cost, 0)) > 2000;


-- 36. Calculate visit count per quarter using visit_date.
-- 36. Calculate visit count per quarter using visit_date.
-- Explanation:
-- - YEAR() separates data across years.
-- - DATEPART(QUARTER) groups visits per quarter.
-- - COUNT(*) counts visits.

SELECT
    YEAR(visit_date) AS Visit_Year,
    DATEPART(QUARTER, visit_date) AS Visit_Quarter,
    COUNT(*) AS Total_visits
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY
    YEAR(visit_date),
    DATEPART(QUARTER, visit_date)
ORDER BY
    Visit_Year,
    Visit_Quarter;
-- 37. Show patients who never appeared in Billing table.
-- Explanation:
-- - LEFT JOIN keeps all patients.
-- - Billing rows that don’t match become NULL.
-- - WHERE b.patient_id IS NULL finds patients with no billing.

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name
FROM Patients p
LEFT JOIN Billing b
    ON p.patient_id = b.patient_id
WHERE b.patient_id IS NULL;


-- 38. Find department-wise highest consultation_fee.
-- Explanation:
-- - LEFT JOIN keeps billing records.
-- - Filter on department is applied in ON clause.
-- - MAX() finds highest consultation fee per department.

SELECT
    d.department,
    MAX(b.consultation_fee) AS Highest_fee
FROM Billing b
LEFT JOIN Doctors d
    ON b.doctor_id = d.doctor_id   
GROUP BY d.department
HAVING d.department IS NOT NULL


-- 39. Count total visits where diagnosis is NOT NULL per doctor.
SELECT 
    d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	COUNT(v.visit_id) AS Total_visits_per_doc
FROM Visits v
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE diagnosis IS NOT NULL
GROUP BY d.doctor_id,d.first_name,d.last_name;

-- 40. Calculate average discount per month.
SELECT
    YEAR(created_date) AS Year_created_date,
	MONTH(created_date) AS Month_created_date,
	AVG(discount) AS Avg_discount
FROM Billing
WHERE discount IS NOT NULL
GROUP BY YEAR(created_date), MONTH(created_date);

-- 41. Show doctors whose total revenue is higher than average revenue of all doctors.
SELECT 
    d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	SUM(COALESCE(consultation_fee,0)+COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_revenue
FROM Doctors d
INNER JOIN Billing b
ON d.doctor_id= b.doctor_id
GROUP BY d.doctor_id,d.first_name,d.last_name
HAVING SUM(COALESCE(consultation_fee,0)+COALESCE(medicine_cost,0)- COALESCE(discount,0)) >
(
SELECT AVG(Total_revenue) FROM (
SELECT 
    d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	SUM(COALESCE(consultation_fee,0)+COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_revenue
FROM Doctors d
INNER JOIN Billing b
ON d.doctor_id= b.doctor_id
GROUP BY d.doctor_id,d.first_name,d.last_name)t);


-- 42. Count patients who have at least one NULL field (age, city, or phone).
SELECT
    
    COUNT(*) AS Total_patients
FROM Patients
WHERE age IS NULL OR city IS NULL OR phone IS NULL;

-- 43. Calculate total billing for male vs female patients.
-- Explanation:
-- - Join billing with patients.
-- - Group by gender.
-- - Exclude NULL gender values.

SELECT
    p.gender,
    SUM(
        COALESCE(b.consultation_fee, 0)
      + COALESCE(b.medicine_cost, 0)
      - COALESCE(b.discount, 0)
    ) AS Total_Billing
FROM Billing b
JOIN Patients p
    ON b.patient_id = p.patient_id
WHERE p.gender IS NOT NULL
GROUP BY p.gender;


-- 44. Find departments with more visits than the overall average visits per department.
SELECT
d.department,
COUNT(v.visit_id) AS Total_visits
FROM Visits v
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.department
HAVING COUNT(v.visit_id) > (
SELECT AVG(Total_visits) FROM (
SELECT
d.department,
COUNT(v.visit_id) AS Total_visits
FROM Visits v
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.department)t);


-- 45. Show patient-wise visit count and billing count together.
-- Explanation:
-- - Aggregate visits per patient.
-- - Aggregate bills per patient.
-- - Join both to Patients to avoid fan-out.

WITH VisitCounts AS (
    SELECT
        patient_id,
        COUNT(*) AS Total_visits
    FROM Visits
    GROUP BY patient_id
),
BillingCounts AS (
    SELECT
        patient_id,
        COUNT(*) AS Total_bills
    FROM Billing
    GROUP BY patient_id
)
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    COALESCE(v.Total_visits, 0) AS Total_visits_per_patient,
    COALESCE(b.Total_bills, 0) AS Total_bills_per_patient
FROM Patients p
LEFT JOIN VisitCounts v
    ON p.patient_id = v.patient_id
LEFT JOIN BillingCounts b
    ON p.patient_id = b.patient_id;



-- 46. Calculate average visit gap per patient using visit_date.
-- Explanation:
-- - LAG() gets the previous visit date per patient.
-- - DATEDIFF calculates gap in days.
-- - AVG() gives average gap per patient.

WITH VisitGaps AS (
    SELECT
        patient_id,
        visit_date,
        DATEDIFF(
            DAY,
            LAG(visit_date) OVER (PARTITION BY patient_id ORDER BY visit_date),
            visit_date
        ) AS Visit_Gap_Days
    FROM Visits
)
SELECT
    patient_id,
    AVG(Visit_Gap_Days) AS Avg_Visit_Gap_Days
FROM VisitGaps
WHERE Visit_Gap_Days IS NOT NULL
GROUP BY patient_id;


-- 47. Count prescriptions where dosage is NULL per month.
SELECT
    YEAR(v.visit_date) AS Year_visit_date,
	MONTH(v.visit_date) AS Month_visit_date,
	COUNT(*)AS Total_prescriptions
FROM Prescriptions p
INNER JOIN visits v
ON p.visit_id= v.visit_id
WHERE p.dosage IS NULL
GROUP BY YEAR(v.visit_date) ,
	MONTH(v.visit_date) ;

-- 48. Show doctors who handled maximum number of visits.
SELECT 
    CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
    d.doctor_id,
	COUNT(v.visit_id) AS Total_visits
 FROM Doctors d
INNER JOIN visits v
ON d.doctor_id= v.doctor_id
GROUP BY  d.doctor_id,d.first_name,d.last_name
HAVING COUNT(v.visit_id) = (

SELECT MAX(Total_visits) FROM (
SELECT 
    d.doctor_id,
	COUNT(v.visit_id) AS Total_visits
 FROM Doctors d
INNER JOIN visits v
ON d.doctor_id= v.doctor_id
GROUP BY  d.doctor_id)T);


-- 49. Calculate department-wise revenue percentage contribution.
-- Explanation:
-- - First calculate department-wise revenue.
-- - Then divide by total revenue.
-- - Multiply by 100 for percentage.

WITH DeptRevenue AS (
    SELECT
        d.department,
        SUM(
            COALESCE(b.consultation_fee,0)
          + COALESCE(b.medicine_cost,0)
          - COALESCE(b.discount,0)
        ) AS Dept_Revenue
    FROM Billing b
    JOIN Doctors d
        ON b.doctor_id = d.doctor_id
    GROUP BY d.department
)
SELECT
    department,
    Dept_Revenue,
    ROUND(
        Dept_Revenue * 100.0 / SUM(Dept_Revenue) OVER (),
        2
    ) AS Revenue_Percentage
FROM DeptRevenue;

-- 50. Find patients whose total discount exceeds their total tax amount.
-- Explanation:
-- - Aggregate discount and tax per patient.
-- - HAVING compares aggregated values.

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    SUM(COALESCE(b.discount,0)) AS Total_Discount,
    SUM(COALESCE(b.tax,0)) AS Total_Tax
FROM Patients p
JOIN Billing b
    ON p.patient_id = b.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING
    SUM(COALESCE(b.discount,0)) >
    SUM(COALESCE(b.tax,0));

/* =========================================================
   SECTION 2: BASIC AGGREGATION – SEPARATE TOPIC QUESTIONS
   (NO Window Functions | Interview-Style | HealthcareDB)
   ========================================================= */


/* -------------------- COUNT() QUESTIONS -------------------- */

-- 1. Count total number of patients in the Patients table.
SELECT COUNT(*) AS Total_Number_of_patients FROM Patients;

-- 2. Count patients whose city is NOT NULL.
SELECT COUNT(*) AS Total_no_of_patients FROM Patients WHERE city IS NOT NULL;

-- 3. Count total visits recorded in the Visits table.
SELECT COUNT(*) AS Total_visits_recorded FROM Visits;

-- 4. Count visits where diagnosis is NOT NULL.
SELECT COUNT(*) AS Total_visits_recorded FROM Visits WHERE diagnosis IS NOT NULL;

-- 5. Count number of doctors per department.
SELECT
    department,
	COUNT(doctor_id) AS Total_doc_per_department
FROM Doctors
WHERE department IS NOT NULL
GROUP BY  department;


-- 6. Count patients per city.
SELECT
    city,
	COUNT(patient_id) AS Total_patients_per_city
FROM Patients
WHERE city IS NOT NULL
GROUP BY city;

-- 7. Count visits handled by each doctor.
SELECT d.doctor_id,
COUNT(v.visit_id) AS Total_visits_per_doc 
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
GROUP BY d.doctor_id;

SELECT 
doctor_id, 
COUNT(visit_id) AS Total_visits_per_doc 
FROM Visits 
GROUP BY doctor_id;

-- 8. Count prescriptions per visit.
SELECT
    visit_id,
	COUNT(prescription_id) AS Total_prescriptions_per_visit
FROM Prescriptions
GROUP BY visit_id;

-- 9. Count number of patients with NULL phone numbers.
SELECT COUNT(*) AS Total_patients FROM patients WHERE phone IS NULL;

-- 10. Count visits per month using visit_date.
SELECT 
    MONTH(visit_date) AS Month_visit_date,
	COUNT(visit_id) AS Total_visits_per_month
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY MONTH(visit_date);

-- 11. Count number of billing records per doctor.
SELECT
    doctor_id,
	COUNT(bill_id) AS Number_billing_records
FROM Billing
GROUP BY doctor_id;

-- 12. Count patients aged above 60.
SELECT COUNT(*) AS total_patients_count FROM Patients WHERE age> 60;

-- 13. Count number of unique diagnoses.
SELECT COUNT(DISTINCT diagnosis) AS Total_unique_diagnosis
FROM Visits
WHERE diagnosis IS NOT NULL;


-- 14. Count visits where department is NULL.
SELECT 
    COUNT(*) AS Total_visits
FROM Visits
WHERE department IS NULL;


/* =========================================================
   SUM() PRACTICE — Q15 to Q28 WITH EXPLANATIONS
   (HealthcareDB | Interview-Oriented)
   ========================================================= */


/* 15. Calculate total consultation_fee from the Billing table.
   Explanation:
   - No GROUP BY needed because we want one single total.
   - COALESCE converts NULL fees to 0 so they are included safely.
*/
SELECT
    SUM(COALESCE(consultation_fee, 0)) AS Total_Consultation_Fee
FROM Billing;


/* 16. Calculate total medicine_cost ignoring NULL values.
   Explanation:
   - SUM ignores NULL by default, but COALESCE ensures safety
     when used in expressions later.
*/
SELECT
    SUM(COALESCE(medicine_cost, 0)) AS Total_Medicine_Cost
FROM Billing;


/* 17. Calculate total billing amount per patient.
   Explanation:
   - Grouping must be done by patient_id (not bill_id).
   - bill_id is unique, grouping by it makes SUM meaningless.
*/
SELECT
    patient_id,
    SUM(
        COALESCE(consultation_fee, 0)
      + COALESCE(medicine_cost, 0)
      - COALESCE(discount, 0)
    ) AS Total_Billing_Per_Patient
FROM Billing
GROUP BY patient_id;


/* 18. Calculate total revenue generated per doctor.
   Explanation:
   - Group by doctor_id to get revenue per doctor.
   - COALESCE prevents NULL values from skipping rows.
*/
SELECT
    doctor_id,
    SUM(
        COALESCE(consultation_fee, 0)
      + COALESCE(medicine_cost, 0)
      - COALESCE(discount, 0)
    ) AS Total_Revenue_Per_Doctor
FROM Billing
GROUP BY doctor_id;


/* 19. Calculate total discount given per month.
   Explanation:
   - Use YEAR and MONTH number to avoid mixing same months
     across different years.
*/
SELECT
    YEAR(created_date)  AS Billing_Year,
    MONTH(created_date) AS Billing_Month,
    SUM(COALESCE(discount, 0)) AS Total_Discount
FROM Billing
GROUP BY
    YEAR(created_date),
    MONTH(created_date);


/* 20. Calculate total tax collected per department.
   Explanation:
   - tax_percent is NOT money.
   - Actual tax = (billing amount * tax_percent / 100).
*/
SELECT
    d.department,
    SUM(
        (
            COALESCE(b.consultation_fee, 0)
          + COALESCE(b.medicine_cost, 0)
          - COALESCE(b.discount, 0)
        ) * COALESCE(b.tax_percent, 0) / 100
    ) AS Total_Tax_Collected
FROM Billing b
JOIN Doctors d
    ON b.doctor_id = d.doctor_id
GROUP BY d.department;


/* 21. Calculate city-wise total billing amount.
   Explanation:
   - Join Billing with Patients to access city.
   - Group by city to get city-wise totals.
*/
SELECT
    p.city,
    SUM(
        COALESCE(b.consultation_fee, 0)
      + COALESCE(b.medicine_cost, 0)
      - COALESCE(b.discount, 0)
    ) AS Total_Billing_Citywise
FROM Billing b
JOIN Patients p
    ON b.patient_id = p.patient_id
WHERE p.city IS NOT NULL
GROUP BY p.city;


/* 22. Calculate total revenue generated by the Cardiology department.
   Explanation:
   - Filter department in WHERE clause.
   - No GROUP BY needed because result is a single total.
*/
SELECT
    SUM(
        COALESCE(b.consultation_fee, 0)
      + COALESCE(b.medicine_cost, 0)
      - COALESCE(b.discount, 0)
    ) AS Cardiology_Total_Revenue
FROM Billing b
JOIN Doctors d
    ON b.doctor_id = d.doctor_id
WHERE d.department = 'Cardiology';


/* 23. Calculate total medicine_cost per patient.
   Explanation:
   - Group by patient_id to calculate patient-wise totals.
*/
SELECT
    patient_id,
    SUM(COALESCE(medicine_cost, 0)) AS Total_Medicine_Cost_Per_Patient
FROM Billing
GROUP BY patient_id;


/* 24. Calculate total discount where discount is negative.
   Explanation:
   - Filter only negative discounts.
   - No GROUP BY because we want a single total.
*/
SELECT
    SUM(discount) AS Total_Negative_Discount
FROM Billing
WHERE discount < 0;


/* 25. Calculate total billing amount per month.
   Explanation:
   - Use YEAR + MONTH number for safe grouping.
*/
SELECT
    YEAR(created_date)  AS Billing_Year,
    MONTH(created_date) AS Billing_Month,
    SUM(
        COALESCE(consultation_fee, 0)
      + COALESCE(medicine_cost, 0)
      - COALESCE(discount, 0)
    ) AS Total_Billing_Per_Month
FROM Billing
GROUP BY
    YEAR(created_date),
    MONTH(created_date);


/* 26. Calculate total consultation_fee per doctor.
   Explanation:
   - Group by doctor_id to calculate per-doctor totals.
*/
SELECT
    doctor_id,
    SUM(COALESCE(consultation_fee, 0)) AS Total_Consultation_Fee_Per_Doctor
FROM Billing
GROUP BY doctor_id;


/* 27. Calculate total billing for patients aged above 50.
   Explanation:
   - Join Billing and Patients to filter by age.
   - No GROUP BY needed because result is one total.
*/
SELECT
    SUM(
        COALESCE(b.consultation_fee, 0)
      + COALESCE(b.medicine_cost, 0)
      - COALESCE(b.discount, 0)
    ) AS Total_Billing_Above_50
FROM Billing b
JOIN Patients p
    ON b.patient_id = p.patient_id
WHERE p.age > 50;


/* 28. Calculate department-wise total revenue.
   Explanation:
   - Join Doctors to get department.
   - Group by department for department-wise totals.
*/
SELECT
    d.department,
    SUM(
        COALESCE(b.consultation_fee, 0)
      + COALESCE(b.medicine_cost, 0)
      - COALESCE(b.discount, 0)
    ) AS Department_Total_Revenue
FROM Billing b
JOIN Doctors d
    ON b.doctor_id = d.doctor_id
GROUP BY d.department;



/* -------------------------------------------------------------------
29. Calculate the average age of all patients.
Explanation:
- AVG ignores NULL values automatically.
- No GROUP BY is needed because we want a single overall result.
------------------------------------------------------------------- */
SELECT
    AVG(age) AS Avg_Age_Of_All_Patients
FROM Patients;


/* -------------------------------------------------------------------
30. Calculate average patient age per city.
Explanation:
- city is a non-aggregated column, so it must be in GROUP BY.
- AVG(age) ignores NULL ages automatically.
------------------------------------------------------------------- */
SELECT
    city,
    AVG(age) AS Avg_Age_Per_City
FROM Patients
WHERE city IS NOT NULL
GROUP BY city;


/* -------------------------------------------------------------------
31. Calculate average consultation_fee charged.
Explanation:
- AVG ignores NULL consultation_fee values.
- No GROUP BY needed because we want one overall average.
------------------------------------------------------------------- */
SELECT
    AVG(consultation_fee) AS Avg_Consultation_Fee
FROM Billing;


/* -------------------------------------------------------------------
32. Calculate average medicine_cost excluding NULL values.
Explanation:
- AVG already ignores NULL values.
- No need to convert NULL to 0.
------------------------------------------------------------------- */
SELECT
    AVG(medicine_cost) AS Avg_Medicine_Cost
FROM Billing;


/* -------------------------------------------------------------------
33. Calculate average billing amount per doctor.
Explanation:
- doctor_id must be in GROUP BY.
- NULL values are ignored automatically in AVG.
- We should NOT convert NULL to 0, as it would distort the average.
------------------------------------------------------------------- */
SELECT
    doctor_id,
    AVG(consultation_fee + medicine_cost - discount) AS Avg_Billing_Per_Doctor
FROM Billing
GROUP BY doctor_id;


/* -------------------------------------------------------------------
34. Calculate department-wise average billing amount.
Explanation:
- department is required in the output, so it must be grouped.
- Using INNER JOIN since department must exist.
- Avoid COALESCE to prevent lowering averages.
------------------------------------------------------------------- */
SELECT
    d.department,
    AVG(b.consultation_fee + b.medicine_cost - b.discount) AS Avg_Billing_Per_Department
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.department;


/* -------------------------------------------------------------------
35. Calculate average discount given per month.
Explanation:
- Discount NULL usually means no discount.
- Converting NULL to 0 is business-valid here.
- Grouping by YEAR and MONTH avoids mixing years.
------------------------------------------------------------------- */
SELECT
    YEAR(created_date) AS Year_Value,
    MONTH(created_date) AS Month_Value,
    AVG(COALESCE(discount, 0)) AS Avg_Discount
FROM Billing
GROUP BY YEAR(created_date), MONTH(created_date);


/* -------------------------------------------------------------------
36. Calculate average tax_percent applied.
Explanation:
- AVG ignores NULL tax_percent values.
- Simple aggregation without GROUP BY.
------------------------------------------------------------------- */
SELECT
    AVG(tax_percent) AS Avg_Tax_Percent
FROM Billing;


/* -------------------------------------------------------------------
37. Calculate average billing amount for male vs female patients.
Explanation:
- gender must be grouped.
- tax_percent is NOT money and must not be subtracted.
- Revenue = consultation_fee + medicine_cost - discount.
------------------------------------------------------------------- */
SELECT
    p.gender,
    AVG(b.consultation_fee + b.medicine_cost - b.discount) AS Avg_Billing_Amount
FROM Billing b
JOIN Patients p
ON b.patient_id = p.patient_id
GROUP BY p.gender;


/* -------------------------------------------------------------------
38. Calculate average number of visits per patient.
Explanation:
- visit_id is an identifier, not a measurable value.
- First count visits per patient, then calculate the average.
------------------------------------------------------------------- */
SELECT
    AVG(visit_count) AS Avg_Visits_Per_Patient
FROM (
    SELECT
        patient_id,
        COUNT(*) AS visit_count
    FROM Visits
    GROUP BY patient_id
) t;


/* -------------------------------------------------------------------
39. Calculate average revenue per department.
Explanation:
- Revenue calculation should not use tax_percent.
- department must be grouped.
------------------------------------------------------------------- */
SELECT
    d.department,
    AVG(b.consultation_fee + b.medicine_cost - b.discount) AS Avg_Revenue_Per_Department
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.department;


/* -------------------------------------------------------------------
40. Calculate average age of patients per department.
Explanation:
- AVG ignores NULL ages.
- Proper joins are required to link patients to departments.
------------------------------------------------------------------- */
SELECT
    d.department,
    AVG(p.age) AS Avg_Age_Of_Patients
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
GROUP BY d.department;


/* -------------------------------------------------------------------
41. Calculate average medicine_cost per month.
Explanation:
- Do NOT convert NULL medicine_cost to 0.
- AVG ignores NULL automatically.
------------------------------------------------------------------- */
SELECT
    YEAR(created_date) AS Year_Value,
    MONTH(created_date) AS Month_Value,
    AVG(medicine_cost) AS Avg_Medicine_Cost
FROM Billing
GROUP BY YEAR(created_date), MONTH(created_date);


/* -------------------------------------------------------------------
42. Calculate average consultation_fee per city.
Explanation:
- city must be grouped.
- AVG ignores NULL consultation_fee values.
------------------------------------------------------------------- */
SELECT
    p.city,
    AVG(b.consultation_fee) AS Avg_Consultation_Fee
FROM Billing b
JOIN Patients p
ON b.patient_id = p.patient_id
GROUP BY p.city;


/* -------------------- MAX() QUESTIONS -------------------- */

-- 43. Find the maximum consultation_fee charged.
SELECT
MAX(consultation_fee) AS Maximum_fee
FROM Billing;

-- 44. Find the maximum medicine_cost charged.
SELECT
MAX(medicine_cost) AS Maximum_cost
FROM Billing;

-- 45. Find the highest billing amount per patient.
SELECT 
    patient_id,
	MAX(consultation_fee + medicine_cost- discount) AS Max_billing
FROM Billing
GROUP BY patient_id;

-- 46. Find the maximum discount given.
SELECT
    MAX(discount) AS Max_discount
FROM Billing;

-- 47. Find the highest tax_percent applied.
SELECT MAX(tax_percent) AS Tax_percent FROM Billing;

-- 48. Find the most recent billing date.
SELECT MAX(created_date) AS Max_created_date FROM Billing;

-- 49. Find the maximum patient age.
SELECT MAX(age) AS Max_patient_age FROM Patients;

-- 50. Find the department with the highest total revenue.
SELECT TOP 1
    d.department,
    SUM(b.consultation_fee + b.medicine_cost - b.discount) AS Total_Revenue
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
GROUP BY d.department
ORDER BY Total_Revenue DESC;




-- 51. Find the doctor who charged the maximum consultation_fee.
SELECT TOP 1
    d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_name,
	MAX(b.consultation_fee) AS Maximum_consultation_fee
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id
GROUP BY d.doctor_id, d.first_name,d.last_name
ORDER BY Maximum_consultation_fee DESC

-- 52. Find the month with the highest total billing amount.
SELECT TOP 1
    MONTH(created_date) AS Month_created_date,
	YEAR(created_date) AS Year_created_date,
	SUM(consultation_fee+ medicine_cost-discount) AS Total_billing_amount
FROM Billing
GROUP BY 
	YEAR(created_date), MONTH(created_date) 
ORDER BY Total_billing_amount DESC;

-- 53. Find the visit with the latest visit_date.
SELECT MAX(visit_date) AS latest_visit_date FROM Visits;

-- 54. Find the maximum number of visits handled by a doctor.
SELECT 
    d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	COUNT(v.visit_id) AS Total_number_of_visits
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
GROUP BY d.doctor_id,d.first_name,d.last_name
HAVING COUNT(v.visit_id) =

(SELECT
    MAX(Total_number_of_visits) AS Maximum_number_visits_doc
FROM(
SELECT 
    d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	COUNT(v.visit_id) AS Total_number_of_visits
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
GROUP BY d.doctor_id,d.first_name,d.last_name) t);


-- 55. Find the highest medicine_cost per department.
SELECT 
    d.department,
	MAX(b.medicine_cost) AS Highest_medc
FROM Billing b
LEFT JOIN Doctors d
ON b. doctor_id = d.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.department;

-- 56. Find the city with the maximum number of patients.

SELECT
    city,
    COUNT(*) AS number_patients
FROM Patients
WHERE city IS NOT NULL
GROUP BY city
HAVING COUNT(*) = (
    SELECT MAX(number_patients)
    FROM (
        SELECT COUNT(*) AS number_patients
        FROM Patients
        WHERE city IS NOT NULL
        GROUP BY city
    ) t
);






/* ==================== MIN() QUESTIONS (57–70) ==================== */

/* 57. Find the minimum consultation_fee charged.
   Explanation:
   - MIN() ignores NULL automatically.
   - Do NOT convert NULL to 0 because we are "picking a value".
*/
SELECT
    MIN(consultation_fee) AS Minimum_consultation_fee
FROM Billing;


/* 58. Find the minimum medicine_cost charged.
   Explanation:
   - MIN() skips NULL values by default.
   - COALESCE is NOT needed here.
*/
SELECT
    MIN(medicine_cost) AS Minimum_medicine_cost
FROM Billing;


/* 59. Find the minimum patient age.
   Explanation:
   - NULL ages are ignored by MIN().
*/
SELECT
    MIN(age) AS Minimum_patient_age
FROM Patients;


/* 60. Find the minimum billing amount.
   Explanation:
   - Arithmetic operation requires NULL protection.
   - If any component is NULL, entire expression becomes NULL.
   - COALESCE is REQUIRED here.
*/
SELECT
    MIN(
        COALESCE(consultation_fee, 0)
      + COALESCE(medicine_cost, 0)
      - COALESCE(discount, 0)
    ) AS Minimum_billing_amount
FROM Billing;


/* 61. Find the earliest visit_date.
   Explanation:
   - Dates work naturally with MIN().
*/
SELECT
    MIN(visit_date) AS Earliest_visit_date
FROM Visits;


/* 62. Find the minimum discount applied.
   Explanation:
   - MIN ignores NULL discounts.
*/
SELECT
    MIN(discount) AS Minimum_discount
FROM Billing;


/* 63. Find the lowest tax_percent applied.
   Explanation:
   - Straight MIN() usage.
*/
SELECT
    MIN(tax_percent) AS Minimum_tax_percent
FROM Billing;


/* 64. Find the department with the minimum total revenue.
   Explanation:
   - First calculate total revenue per department.
   - Then filter the department(s) having the minimum revenue.
*/
SELECT
    d.department,
    SUM(
        COALESCE(b.consultation_fee, 0)
      + COALESCE(b.medicine_cost, 0)
      - COALESCE(b.discount, 0)
    ) AS Total_revenue
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.department
HAVING SUM(
        COALESCE(b.consultation_fee, 0)
      + COALESCE(b.medicine_cost, 0)
      - COALESCE(b.discount, 0)
    ) = (
        SELECT MIN(Total_revenue)
        FROM (
            SELECT
                SUM(
                    COALESCE(b2.consultation_fee, 0)
                  + COALESCE(b2.medicine_cost, 0)
                  - COALESCE(b2.discount, 0)
                ) AS Total_revenue
            FROM Billing b2
            JOIN Doctors d2
            ON b2.doctor_id = d2.doctor_id
            WHERE d2.department IS NOT NULL
            GROUP BY d2.department
        ) t
    );


/* 65. Find the doctor with the minimum total visits.
   Explanation:
   - Count visits per doctor.
   - Compare with minimum visit count.
   - Handles ties correctly.
*/
SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS Full_Name,
    COUNT(v.visit_id) AS Total_visits
FROM Visits v
JOIN Doctors d
ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING COUNT(v.visit_id) = (
    SELECT MIN(Total_visits)
    FROM (
        SELECT
            COUNT(v2.visit_id) AS Total_visits
        FROM Visits v2
        GROUP BY v2.doctor_id
    ) t
);


/* 66. Find the city with the minimum number of patients.
   Explanation:
   - Group patients by city.
   - Filter city having minimum count.
*/
SELECT
    city,
    COUNT(patient_id) AS Total_patients
FROM Patients
WHERE city IS NOT NULL
GROUP BY city
HAVING COUNT(patient_id) = (
    SELECT MIN(Total_patients)
    FROM (
        SELECT
            COUNT(patient_id) AS Total_patients
        FROM Patients
        WHERE city IS NOT NULL
        GROUP BY city
    ) t
);


/* 67. Find the minimum medicine_cost per patient.
   Explanation:
   - MIN per group.
   - NULL medicine_cost automatically ignored.
*/
SELECT
    patient_id,
    MIN(medicine_cost) AS Minimum_medicine_cost
FROM Billing
GROUP BY patient_id;


/* 68. Find the earliest billing date.
   Explanation:
   - Simple MIN on date column.
*/
SELECT
    MIN(created_date) AS Earliest_billing_date
FROM Billing;


/* 69. Find the minimum consultation_fee per department.
   Explanation:
   - Join Billing with Doctors to get department.
   - MIN ignores NULL consultation_fee.
*/
SELECT
    d.department,
    MIN(b.consultation_fee) AS Minimum_fee
FROM Billing b
JOIN Doctors d
ON b.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.department;


/* 70. Find the minimum billing amount per month.
   Explanation:
   - Group by YEAR + MONTH.
   - COALESCE required due to arithmetic.
*/
SELECT
    YEAR(created_date) AS Billing_year,
    MONTH(created_date) AS Billing_month,
    MIN(
        COALESCE(consultation_fee, 0)
      + COALESCE(medicine_cost, 0)
      - COALESCE(discount, 0)
    ) AS Minimum_billing_amount
FROM Billing
GROUP BY YEAR(created_date), MONTH(created_date);
