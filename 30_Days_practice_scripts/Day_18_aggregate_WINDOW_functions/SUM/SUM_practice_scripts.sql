-- 1) Calculate total visit_cost across all visits using SUM() as a window function.
SELECT
     visit_id,
	 visit_cost,
	 SUM(visit_cost) OVER() AS Total_visit_cost
FROM Visits
WHERE visit_cost IS NOT NULL;

-- 2) Show each visit along with the running total of visit_cost ordered by visit_date.
SELECT
    visit_id,
    visit_date,
    visit_cost,
    SUM(visit_cost) OVER (
        ORDER BY visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_visit_cost
FROM Visits
WHERE visit_date IS NOT NULL;


-- 3) Display patient_id, visit_id, and cumulative visit_cost per patient using SUM() OVER(PARTITION BY patient_id).
SELECT
    patient_id,
    visit_id,
    visit_date,
    visit_cost,
    SUM(visit_cost) OVER (
        PARTITION BY patient_id
        ORDER BY visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_visit_cost
FROM Visits;

-- 4) Calculate total billing consultation_fee for each doctor without collapsing rows.
SELECT  
    d.doctor_id,
	b.bill_id,
	b.consultation_fee,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name_doc,
	SUM(COALESCE(consultation_fee,0)) OVER(PARTITION BY d.doctor_id) AS Total_billing_fee
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id;


-- 5) Show each billing row with total medicine_cost across the entire Billing table.
SELECT
    bill_id,
	medicine_cost,
	SUM(COALESCE(medicine_cost,0)) OVER() AS Total_medicine_cost
FROM Billing;

-- 6) Calculate running total of medicine_cost ordered by created_date.
SELECT
    bill_id,
	medicine_cost,
	SUM(COALESCE(medicine_cost,0)) OVER(ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total
FROM Billing;

-- 7) Display each billing record with cumulative consultation_fee per doctor ordered by created_date.
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.consultation_fee,
	b.created_date,
	SUM(COALESCE(b.consultation_fee,0)) OVER(PARTITION BY d.doctor_id ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_fee
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id = d.doctor_id;

-- 8) Show total discount given across all bills using SUM() as a window function.
SELECT
    bill_id,
	discount,
	SUM(COALESCE(discount,0)) OVER() AS Total_discount
FROM Billing;

-- 9) Display each billing row with cumulative discount per patient.
SELECT
    bill_id,
	patient_id,
	discount,
	SUM(COALESCE(discount,0)) OVER(PARTITION BY patient_id ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Total_Running_discount
FROM Billing;

-- 10) Calculate total revenue (consultation_fee + medicine_cost) using SUM() OVER().
SELECT
    bill_id,
	consultation_fee,
	medicine_cost,
	discount,
	SUM(COALESCE(consultation_fee,0)+COALESCE(medicine_cost,0)-COALESCE(discount,0)) OVER() As Total_revenue
FROM Billing;


-- 11) Show visit_id, department, and total visit_cost per department using window SUM().
SELECT
    visit_id,
	department,
	visit_cost,
	SUM(COALESCE(visit_cost,0)) OVER(PARTITION BY department) AS Total_visit_cost
FROM visits;

-- 12) Display each visit with cumulative visit_cost partitioned by department.
SELECT
    visit_id,
	department,
	visit_cost,
	SUM(COALESCE(visit_cost,0)) OVER(PARTITION BY department ORDER BY visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Total_visit_cost
FROM visits;

-- 13) Calculate running total of visit_cost ordered by visit_id.
SELECT
    visit_id,
    visit_date,
    visit_cost,
    SUM(COALESCE(visit_cost,0)) OVER (
        ORDER BY visit_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM Visits;

-- 14) Show each patient visit Count along with total cost incurred by that patient.
SELECT
    v.visit_id,
    p.patient_id,
    CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
    v.visit_cost,
    COUNT(v.visit_id) OVER(PARTITION BY p.patient_id) AS total_visit_count,
    SUM(COALESCE(v.visit_cost,0)) OVER(PARTITION BY p.patient_id) AS total_visit_cost
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id;


-- 15) Display billing rows with cumulative tax amount calculated using SUM().
SELECT
    bill_id,
    created_date,
    tax_percent,
    SUM(COALESCE(tax_percent,0)) OVER(
        ORDER BY created_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_tax
FROM Billing;

-- 16) Calculate total consultation_fee ignoring NULL values using SUM() OVER().
SELECT
    bill_id,
	consultation_fee,
	SUM(COALESCE(consultation_fee,0)) OVER() AS Total_consultation_fee
FROM Billing;

-- 17) Show cumulative consultation_fee per patient ordered by created_date.
SELECT 
    p.patient_id,
	b.bill_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.consultation_fee,
	b.created_date,
	SUM(COALESCE(b.consultation_fee,0)) OVER(PARTITION BY p.patient_id ORDER BY b.created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_fee
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id= p.patient_id;

-- 18) Display each doctor’s billing row with total revenue generated by that doctor.
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Doc_Full_Name,
	SUM(COALESCE(b.medicine_cost,0)+COALESCE(b.consultation_fee,0)- COALESCE(b.discount,0)) OVER(PARTITION BY d.doctor_id) AS Total_Revenue
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id;

-- 19) Calculate running total of medicine_cost per doctor.
SELECT 
    b.bill_id,
    d.doctor_id,
    CONCAT(d.first_name,' ',d.last_name) AS Doc_Full_Name,
    b.medicine_cost,
    b.created_date,
    SUM(COALESCE(b.medicine_cost,0)) OVER(
        PARTITION BY d.doctor_id
        ORDER BY b.created_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Medicine_Cost
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id = d.doctor_id;

-- 20) Show billing rows with cumulative net amount (consultation + medicine - discount).
SELECT
    bill_id,
	consultation_fee,
	medicine_cost,
	discount,
	created_date,
	SUM(COALESCE(medicine_cost,0)+COALESCE(consultation_fee,0)- COALESCE(discount,0)) 
	OVER(ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_net_amount
FROM Billing;


-- 21) Display each visit with cumulative visit_cost per patient ordered by visit_date.
SELECT 
    p.patient_id,
	v.visit_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	v.visit_date,
	v.visit_cost,
	SUM(COALESCE(visit_cost,0)) 
	OVER(PARTITION BY p.patient_id ORDER BY v.visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_visit_cost
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id;

-- 22) Calculate total visit_cost across completed visits using window SUM().
SELECT
    visit_id,
    visit_cost,
    SUM(COALESCE(visit_cost,0)) OVER() AS total_visit_cost
FROM Visits
WHERE visit_status = 'COMPLETED';

-- 23) Show each visit along with total cost of all visits till that date.
SELECT
    visit_id,
    visit_cost,
	visit_date,
    SUM(COALESCE(visit_cost,0)) OVER(ORDER BY visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_visit_cost
FROM Visits;

-- 24) Display billing rows with cumulative consultation_fee across all records.
SELECT
    bill_id,
	consultation_fee,
	created_date,
	SUM(COALESCE(consultation_fee,0))
	OVER(ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_fee
FROM Billing;

-- 25) Calculate cumulative medicine_cost ordered by bill_id.
SELECT
    bill_id,
	medicine_cost,
	created_date,
	SUM(COALESCE(medicine_cost,0))
	OVER(ORDER BY bill_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_fee
FROM Billing;

-- 26) Show each billing row with total discount per doctor.
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.discount,
	SUM(COALESCE(b.discount,0)) OVER(PARTITION BY d.doctor_id) AS Total_discount_per_doc
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id= d.doctor_id;

-- 27) Display visit_id and cumulative visit_cost without using GROUP BY.
SELECT
    visit_id,
	visit_cost,
	visit_date,
	SUM(COALESCE(visit_cost,0)) OVER(ORDER BY visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS culative_visit_cost
FROM Visits;

-- 28) Calculate running total of visit_cost partitioned by visit_status.
SELECT
    visit_id,
	visit_status,
	visit_cost,
	visit_date,
	SUM(COALESCE(visit_cost,0))
	OVER(PARTITION BY visit_status ORDER BY visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total
FROM Visits;

-- 29) Show each patient’s visit with total visit_cost incurred so far.
SELECT 
    p.patient_id,
    CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
    v.visit_id,
    v.visit_date,
    v.visit_cost,
    SUM(COALESCE(visit_cost,0)) OVER(
        PARTITION BY p.patient_id
        ORDER BY v.visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Total_Visit_Cost
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id;


-- 30) Display cumulative consultation_fee ordered by patient_id.
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.consultation_fee,
	SUM(COALESCE(consultation_fee,0)) OVER(ORDER BY p.patient_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_fee
FROM Billing b
LEFT JOIN patients p
ON b.patient_id= p.patient_id;

-- 31) Calculate total billing amount per patient using SUM() OVER(PARTITION BY patient_id).
SELECT 
    p.patient_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.bill_id,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)-COALESCE(discount,0)) 
	OVER(PARTITION BY p.patient_id) AS Total_billing_amount
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id = p.patient_id;

-- 32) Show each billing row with cumulative billing amount ordered by created_date.
SELECT
    bill_id,
	created_date,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)-COALESCE(discount,0))
	OVER(ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_billing_amount
FROM Billing;

-- 33) Display each visit with total visit_cost across the entire table.
SELECT
    visit_id,
	visit_cost,
    visit_date,
	SUM(visit_cost) OVER() AS Total_visit_cost
FROM Visits;

-- 34) Calculate cumulative discount ordered by created_date.
SELECT
    bill_id,
	discount,
	created_date,
	SUM(COALESCE(discount,0)) OVER(ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_discount
FROM Billing;

-- 35) Show each doctor’s visit with total visit_cost for that doctor.
SELECT  
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	v.visit_cost,
	SUM(COALESCE(v.visit_cost,0)) OVER (PARTITION BY d.doctor_id) AS Total_visit_cost
FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id;

-- 36) Display cumulative consultation_fee per department using window SUM().
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	d.department,
	b.created_date,
	b.consultation_fee,
	SUM(COALESCE(b.consultation_fee,0)) 
	OVER(PARTITION BY d.department ORDER BY b.created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_fee
FROM Billing b
INNER JOIN Doctors d
ON b.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL;

-- 37) Calculate running total of medicine_cost partitioned by patient_id.
SELECT 
    p.patient_id,
	b.bill_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.medicine_cost,
	b.created_date,
	SUM(COALESCE(b.medicine_cost,0)) 
	OVER(PARTITION BY p.patient_id ORDER BY b.created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total_medicine_cost
FROM Billing b
LEFT JOIN Patients p
ON b.patient_id = p.patient_id;

-- 38) Show each visit with cumulative cost ordered by visit_date and visit_id.
SELECT
    visit_id,
	visit_cost,
	visit_date,
	SUM(COALESCE(visit_cost,0)) OVER( ORDER BY visit_date,visit_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_visit_cost
FROM Visits;

-- 39) Display billing rows with total tax percentage applied using window SUM().
SELECT
    bill_id,
    tax_percent,
    (COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0))
      * COALESCE(tax_percent,0) / 100.0 AS tax_amount,
    SUM(
        (COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0))
        * COALESCE(tax_percent,0) / 100.0
    ) OVER() AS Total_tax_amount
FROM Billing;


-- 40) Calculate cumulative net payable amount per patient.
SELECT 
    p.patient_id,
	b.bill_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.created_date,
	SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0)- COALESCE(b.discount,0)) 
	OVER(PARTITION BY p.patient_id ORDER BY b.created_date, b.bill_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumlitaive_net_pay
FROM Billing b
LEFT JOIN patients p
ON b.patient_id = p.patient_id;

-- 41) Show each visit row with total cost of visits for that department.
SELECT
    visit_id,
	visit_cost,
	department,
	SUM(COALESCE(visit_cost,0)) OVER(PARTITION BY department) AS Total_visits_cost
FROM Visits
WHERE department IS NOT NULL;

-- 42) Calculate running total of consultation_fee ignoring NULL fees.
SELECT
    bill_id,
	consultation_fee,
	created_date,
	SUM(COALESCE(consultation_fee,0)) 
	OVER (ORDER BY created_date, bill_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total_consultation_fee
FROM Billing;

-- 43) Display each billing row with cumulative revenue across all doctors.
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0)-COALESCE(b.discount,0) AS Total_revenue,
	SUM(COALESCE(b.consultation_fee,0)+ COALESCE(b.medicine_cost,0)-COALESCE(b.discount,0))
	OVER(ORDER BY b.created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_revenue
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id = d.doctor_id;

--if multiple bills share same created -date so running total will vary so you need to add bill_id after created_date in window function

SELECT 
    b.bill_id,
    d.doctor_id,
    CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
    COALESCE(b.consultation_fee,0)
  + COALESCE(b.medicine_cost,0)
  - COALESCE(b.discount,0) AS Total_revenue,
    SUM(
        COALESCE(b.consultation_fee,0)
      + COALESCE(b.medicine_cost,0)
      - COALESCE(b.discount,0)
    ) OVER (
        ORDER BY b.created_date, b.bill_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Cumulative_revenue
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id = d.doctor_id;


-- 44) Calculate cumulative visit_cost per month using window SUM().
SELECT
    visit_id,
    visit_date,
    MONTH(visit_date) AS month_num,
    YEAR(visit_date) AS year_num,
    FORMAT(visit_date,'MMMM') AS month_name,
    visit_cost,
    SUM(COALESCE(visit_cost,0))
    OVER (
        PARTITION BY YEAR(visit_date), MONTH(visit_date)
        ORDER BY visit_date, visit_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_visit_cost
FROM Visits
WHERE visit_date IS NOT NULL;


-- 45) Show each patient visit with total visit_cost till that visit.
SELECT
    p.patient_id,
    v.visit_id,
    CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
    v.visit_cost,
    SUM(COALESCE(v.visit_cost,0)) 
        OVER(
            PARTITION BY p.patient_id
            ORDER BY v.visit_date, v.visit_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS Running_Total_visit_cost
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id;


-- 46) Display billing rows with cumulative medicine_cost across all patients.
SELECT 
    p.patient_id,
	b.bill_id,
	CONCAT(p.first_name,' ',p.last_name) AS Full_Name,
	b.created_date,
	b.medicine_cost,
	SUM( COALESCE(b.medicine_cost,0)) 
	OVER(ORDER BY b.created_date, b.bill_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumlitaive_medicine_cost
FROM Billing b
LEFT JOIN patients p
ON b.patient_id = p.patient_id;

-- 47) Calculate running total of visit_cost partitioned by doctor_id.
SELECT 
    v.visit_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Doc_Full_Name,
	v.visit_cost,
	v.visit_date,
	SUM(COALESCE(v.visit_cost,0))
	OVER(PARTITION BY d.doctor_id ORDER BY v.visit_date, v.visit_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_total
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE visit_date IS NOT NULL;


-- 48) Show each billing record with total discount applied across the table.
SELECT
    bill_id,
	discount,
	SUM(COALESCE(discount,0)) OVER() AS Total_discount_applied
FROM Billing;

-- 49) Display visit rows with cumulative cost ordered by visit_date descending.
SELECT
    visit_id,
	visit_cost,
	visit_date,
	SUM(COALESCE(visit_cost,0)) OVER(ORDER BY visit_date DESC,visit_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_cost
FROM Visits
WHERE Visit_date IS NOT NULL;


-- 50) Calculate cumulative consultation_fee per doctor ordered by created_date.
SELECT 
    b.bill_id,
	d.doctor_id,
	CONCAT(d.first_name,' ',d.last_name) AS Full_Name,
	b.created_date,
	SUM(COALESCE(b.consultation_fee,0)) 
	OVER(PARTITION BY d.doctor_id ORDER BY b.created_date, b.bill_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total_per_doc
FROM Billing b
LEFT JOIN Doctors d
ON b.doctor_id = d.doctor_id;
