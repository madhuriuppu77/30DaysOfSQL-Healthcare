--PART 1 — 30 SQL  QUESTIONS (Each uses ROUND + ABS)


-- 1. Retrieve patients along with the rounded age (nearest 10) and absolute difference between age and 50.
SELECT 
    first_name,
    last_name,
    age,
    ROUND(age, -1) AS rounded_age_nearest_10,
    ABS(age - 50) AS abs_diff_from_50
FROM Patients;

-- 2. From Billing, calculate the rounded consultation fee and ABS() of any negative discount values.
SELECT * FROM Billing
SELECT
consultation_fee,
discount,
ROUND(consultation_fee,0) AS rounded_consulation,
ABS(discount) AS abs_discount
FROM Billing;

-- 3. Show visits where ABS difference between visit_id and doctor_id is LESS than 5, and round the patient_id to nearest 10.
SELECT
patient_id,
doctor_id,
visit_id,
ROUNd(patient_id, -1) AS ROUNDED_patient_id,
ABS(visit_id- doctor_id) AS ABS_both_id
FROM Visits
WHERE ABS(visit_id- doctor_id)< 5;

-- 4. From Prescriptions, round the numeric part of dosage to nearest 10 and apply ABS() on the difference from 100.
SELECT
    dosage,
    ABS(ROUND(CAST(LEFT(dosage, LEN(dosage)-2) AS INT), -1) - 100) AS dosage_after_cal
FROM Prescriptions
WHERE dosage IS NOT NULL;


-- 5. Show rounded medicine_cost and absolute discount for all bills created in April 2024.
SELECT
medicine_cost,
discount,
MONTH(created_date) AS Month_2024,
ROUND(medicine_cost,0) AS rounded_medicine_cost,
ABS(discount) AS ABS_discount
FROM Billing
WHERE MONTH(created_date)= 4 AND YEAR(created_date) =2024

-- 6. Return patients whose ABS(age – 30) is ≤ 10 and show age rounded to nearest 5.
SELECT
    age,
    ROUND(age / 5.0) * 5 AS rounded_age,
    ABS(age - 30) AS abs_age
FROM Patients
WHERE ABS(age - 30) <= 10;


-- 7. For each doctor, show ABS difference between doctor_id and length of their name, and round the name length.
SELECT
doctor_id,
LEN(CONCAT(first_name,'',last_name)) AS Full_name,
ABS(doctor_id- LEN(CONCAT(first_name,'',last_name))) AS ABS_doctor_id,
ROUND(LEN(CONCAT(first_name,'',last_name)),0) AS Rounded_name
FROM Doctors;

-- 8. Round consultation_fee to 0 decimals and show ABS(consultation_fee – medicine_cost).

SELECT
consultation_fee,
medicine_cost,
ROUND(consultation_fee,0) AS round_consultation,
ABS(consultation_fee - medicine_cost) AS abs_cons_med
FROM Billing
WHERE consultation_fee IS NOT NULL AND medicine_cost IS NOT NULL;

-- 9. Show billing records where ABS(discount) > 20, and round tax_percent to nearest integer.

SELECT
tax_percent,
discount,
ROUND(tax_percent, 0) AS rounded_tax,
ABS(discount) AS abs_discount
FROM Billing
WHERE ABS(discount)> 20;

-- 10. Show the rounded sum of (consultation_fee + medicine_cost) and ABS(discount) for each bill.

SELECT
    bill_id,
    ROUND(consultation_fee + medicine_cost, 0) AS rounded_total,
    ABS(discount) AS abs_discount
FROM Billing;

-- 11. Find patients whose age rounded to nearest 5 equals ABS(age – 10).
SELECT
age,
ROUND(age/5.0, 0) * 5 AS Rounded_age,
ABS(age-10) AS ABS_age
FROM Patients
WHERE ROUND(age/5.0, 0) * 5= ABS(age-10);

-- 12. Calculate rounded total bill = ROUND(consultation_fee + medicine_cost – ABS(discount), 2).

SELECT
    bill_id,
    consultation_fee,
    medicine_cost,
    discount,
    ABS(discount) AS abs_discount,
    ROUND(consultation_fee + medicine_cost - ABS(discount), 2) 
        AS total_rounded_bill
FROM Billing;

-- 13. For each doctor, show ABS difference between doctor_id and number of patients they treated; round the treatment count.
SELECT 
    d.doctor_id,
    ROUND(COUNT(v.patient_id), 0) AS total_patients,
    ABS(d.doctor_id - ROUND(COUNT(v.patient_id), 0)) AS abs_difference
FROM Doctors d
LEFT JOIN Visits v 
    ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_id;

-- 14. In Visits, round day number of visit_date and compute ABS difference from month number.
SELECT
visit_date,
ROUND(DAY(visit_date),0) AS Day_visit_date,
ROUND(MONTH(visit_date),0) AS Month_visit_date,
ABS(ROUND(DAY(visit_date),0)-ROUND(MONTH(visit_date),0)) AS ABS_MONTH_DAY
FROM Visits
WHERE visit_date IS NOT NULL;

-- 15. Show prescriptions where ABS(length(medication_name) – 10) < 3 and round dosage numeric part.
SELECT
    medication_name,
    dosage,
    ABS(LEN(medication_name) - 10) AS abs_medication_name,
    ROUND(CAST(LEFT(dosage, LEN(dosage)-2) AS INT), 0) AS rounded_numeric_dosage
FROM Prescriptions
WHERE ABS(LEN(medication_name) - 10) < 3
  AND dosage IS NOT NULL;


-- 16. For each patient, round their age divided by 3 and compute ABS(age – rounded_value).
SELECT
    patient_id,
    age,
    ROUND(age / 3.0, 0) AS rounded_value,
    ABS(age - ROUND(age / 3.0, 0)) AS abs_age
FROM Patients
WHERE age IS NOT NULL;


-- 17. Return all bills where ABS(discount) > ROUND(medicine_cost * 0.02, 2).
SELECT
medicine_cost,
discount,
ABS(discount) AS ABS_DISCOUNT,
ROUND(medicine_cost * 0.02, 2) AS rounded_medicine_cost
FROM Billing
WHERE ABS(discount)  > ROUND(medicine_cost * 0.02, 2);

-- 18. Show ABS difference between two visits of the same patient and rounded average visit_id.

SELECT
    patient_id,
    COUNT(visit_id) AS total_visits_per_patient,
    ROUND(AVG(visit_id), 0) AS rounded_avg_visit_id,
    ABS(MAX(visit_id) - MIN(visit_id)) AS abs_visit_gap
FROM Visits
GROUP BY patient_id
HAVING COUNT(visit_id) = 2;


-- 19. Compare rounded average dosage length per medication with ABS difference from 6.
SELECT
medication_name,
ROUND(AVG(LEN(LEFT(dosage, LEN(dosage)-2))),0) AS rounded_dosage_length,
ABS(ROUND(AVG(LEN(LEFT(dosage, LEN(dosage)-2))),0)-6) AS ABS_dosage_length
FROM Prescriptions
WHERE medication_name IS NOT NULL AND dosage IS NOT NULL
GROUP BY medication_name;

-- 20. In Billing, round tax amount (consultation_fee * tax_percent/100) and return ABS difference between tax and discount.

SELECT
tax_percent,
consultation_fee,
discount,
ROUND(consultation_fee * tax_percent/100, 0) AS rounded_tax_amount,
ABS((ROUND(consultation_fee * tax_percent/100, 0))-discount) AS ABS_tax_amount
FROM Billing;

-- 21. Find patients whose rounded average age of all Patients differs from their actual age by ABS() < 8.
SELECT
    patient_id,
    age,
    ROUND(AVG(age) OVER (), 0) AS rounded_avg_age,
    ABS(ROUND(AVG(age) OVER (), 0) - age) AS abs_age
FROM Patients
WHERE ABS(ROUND(AVG(age) OVER (), 0) - age) < 8;


-- 22. In Billing, compute rounded net bill, and return only those where ABS(net_bill – medicine_cost) > 100.
SELECT
consultation_fee,
medicine_cost,
discount,
ROUND(consultation_fee+medicine_cost-discount, 1) AS rounded_net_bill,
ABS((consultation_fee+medicine_cost-discount)-(medicine_cost)) AS abs_net_bill
FROM Billing
WHERE ABS((consultation_fee+medicine_cost-discount)-(medicine_cost))> 100;

-- 23. Calculate per-doctor total fees; show doctors where ABS(total – rounded_total) > 50.
SELECT 
d.doctor_id,
SUM(b.consultation_fee+b.medicine_cost-b.discount) AS total_fees_per_doc,
ROUND(SUM(b.consultation_fee+b.medicine_cost-b.discount),0) AS rounded_fees_per_doc,
ABS((SUM(b.consultation_fee+b.medicine_cost-b.discount))-(ROUND(SUM(b.consultation_fee+b.medicine_cost-b.discount),0))) AS ABS_total
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id
GROUP BY d.doctor_id
HAVING ABS((SUM(b.consultation_fee+b.medicine_cost-b.discount))-(ROUND(SUM(b.consultation_fee+b.medicine_cost-b.discount),0)))> 50;


-- 24. In Visits, compute ABS difference between rounded visit frequency and rounded average frequency of patients.
WITH freq AS (
    SELECT
        patient_id,
        COUNT(visit_id) AS visit_count
    FROM Visits
    GROUP BY patient_id
)
SELECT
    patient_id,
    ROUND(visit_count, 0) AS rounded_visit_count,
    ROUND(AVG(visit_count) OVER(), 0) AS rounded_avg_visit_count,
    ABS(ROUND(visit_count, 0) - ROUND(AVG(visit_count) OVER(), 0)) AS abs_diff
FROM freq;


-- 25. For each patient, compute rounded sum of all bill charges and compare ABS difference from consultation_fee.
SELECT 
p.patient_id,
ROUND(SUM(b.consultation_fee+b.medicine_cost-b.discount),0) AS total_bill_charge_rounded,
ABS((ROUND(SUM(b.consultation_fee+b.medicine_cost-b.discount),0))- (SUM(b.consultation_fee))) AS Round_abs
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id= p.patient_id
GROUP BY p.patient_id



-- 26. Extract numeric part of dosage, round it, and compute ABS difference from  prescription’s dosage.
SELECT
    dosage,
    ROUND(CAST(LEFT(dosage, LEN(dosage)-2) AS FLOAT), 0) AS rounded_dosage,
    ABS(
        ROUND(CAST(LEFT(dosage, LEN(dosage)-2) AS FLOAT), 0)
        - CAST(LEFT(dosage, LEN(dosage)-2) AS FLOAT)
    ) AS abs_dosage
FROM Prescriptions
WHERE dosage IS NOT NULL;

-- 27. Using Billing, find rows where ABS(ROUND(consultation_fee,1) – ROUND(medicine_cost,1)) > 200.
SELECT
consultation_fee,
medicine_cost,
ABS((ROUND(consultation_fee,1))- (ROUND(medicine_cost,1))) AS ABS_ROUND
FROM Billing
WHERE ABS((ROUND(consultation_fee,1))- (ROUND(medicine_cost,1))) > 200;

-- 28. Compute per-patient average discount (using ABS), round it, and filter those > 20.
SELECT 
p.patient_id,
ROUND(ABS(AVG(b.discount)),1) AS Round_abs_discount
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id=p.patient_id
GROUP BY p.patient_id
HAVING ROUND(ABS(AVG(b.discount)),1) > 20;

-- 29. For each doctor, compute rounded ABS difference between their average fee and highest fee session.
SELECT  
d.doctor_id,
AVG(consultation_fee) AS AVG_consultation_fee,
MAX(consultation_fee) AS MAX_consultation_fee,
ROUND(ABS(AVG(consultation_fee)-MAX(consultation_fee)),1) AS round_abs_total_fee
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id
GROUP BY d.doctor_id;

-- 30. Determine bills where ABS(actual_total – rounded_total_with_tax) > discount * 2.
SELECT
    consultation_fee,
    medicine_cost,
    discount,
    tax_percent,

    ABS(
        (consultation_fee + medicine_cost - discount)
        - ROUND(
            (consultation_fee + medicine_cost - discount) * (1 + tax_percent/100.0),
            0
        )
    ) AS abs_total_amount

FROM Billing
WHERE ABS(
        (consultation_fee + medicine_cost - discount)
        - ROUND(
            (consultation_fee + medicine_cost - discount) * (1 + tax_percent/100.0),
            0
        )
    ) > discount * 2;

-- PART 2 —  COMPLEX SQL QUESTIONS (mixing ROUND + ABS + multi-topic logic)
--(These questions combine multiple functions + business logic)

-- 1. Show billing entries where rounded total amount (consultation + medicine – discount) differs from unrounded by more than ABS(discount).
SELECT
    consultation_fee,
    medicine_cost,
    discount,
    ROUND(consultation_fee + medicine_cost - discount, 0) AS rounded_total_amount,
    ABS(discount) AS abs_discount
FROM Billing
WHERE ABS(
        ROUND(consultation_fee + medicine_cost - discount, 0)
        - (consultation_fee + medicine_cost - discount)
) > ABS(discount);


-- 2. List visits where ABS(length of diagnosis – 10) < 3 and round visit_id to nearest 5.
SELECT
    visit_id,
    diagnosis,
    ABS(LEN(diagnosis) - 10) AS abs_diagnosis,
    ROUND(visit_id / 5.0, 0) * 5 AS round_visit_id
FROM Visits
WHERE ABS(LEN(diagnosis) - 10) < 3;

-- 3. Find patients whose rounded age equals ABS( visit year).


SELECT
    p.age,
    v.visit_date,
    ROUND(p.age, 0) AS rounded_age,
    YEAR(v.visit_date) AS visit_year
FROM Visits v
LEFT JOIN Patients p
    ON v.patient_id = p.patient_id
WHERE ROUND(p.age, 0) = YEAR(v.visit_date);

-- 4. Round medicine_cost and compute ABS difference from consultation_fee; return only if > 100.
SELECT
    medicine_cost,
    ROUND(medicine_cost, 0) AS rounded_medicine_cost,
    ABS(ROUND(medicine_cost, 0) - consultation_fee) AS abs_diff
FROM Billing
WHERE ABS(ROUND(medicine_cost, 0) - consultation_fee) > 100;


-- 5. In Prescriptions, extract numeric dosage, round it, and compute ABS difference from length of medication_name.

SELECT
    medication_name,
    dosage,
    LEN(medication_name) AS length_of_medication_name,
    ROUND(CAST(LEFT(dosage, LEN(dosage)-2) AS INT), 0) AS rounded_dosage,
    ABS(ROUND(CAST(LEFT(dosage, LEN(dosage)-2) AS INT), 0) - LEN(medication_name)) AS abs_diff
FROM Prescriptions
WHERE medication_name IS NOT NULL 
  AND dosage IS NOT NULL;
