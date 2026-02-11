
-- 1. Display each patient’s visit along with the total number of visits for that patient using COUNT() OVER().
SELECT
    visit_id,
	patient_id,
	COUNT(visit_id) OVER(PARTITION BY patient_id) AS Total_visits
FROM visits;

-- 2. Show each visit with the average visit_cost across all visits using AVG() OVER().
SELECT
    visit_id,
	visit_cost,
	AVG(visit_cost) OVER() AS Avg_visit_cost
FROM visits;

-- 3. For every billing record, calculate the running total of consultation_fee ordered by created_date.
SELECT
    bill_id,
	consultation_fee,
	created_date,
	SUM(consultation_fee) OVER(ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_total
FROM Billing;

-- 4. Display each patient’s visit and rank their visits by visit_date using ROW_NUMBER().
SELECT
    visit_id,
	patient_id,
	visit_date,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY visit_date) AS Rank_unique
FROM visits;

-- 5. Rank doctors based on total consultation_fee collected using RANK() OVER().
SELECT
    doctor_id,
	Total_consultation_fee,
	RANK() OVER(ORDER BY Total_consultation_fee DESC) AS Rank_doc
FROM
(
SELECT
    doctor_id,
	SUM(COALESCE(consultation_fee,0)) AS Total_consultation_fee
FROM Billing
GROUP BY doctor_id)t;

-- 6. Show dense ranking of doctors based on total medicine_cost using DENSE_RANK().
SELECT
    doctor_id,
	Total_medicine_cost,
	DENSE_RANK() OVER(ORDER BY Total_medicine_cost DESC) AS Dense_rank_rank
FROM
(
SELECT
    doctor_id,
	SUM(COALESCE(medicine_cost,0)) AS Total_medicine_cost
FROM Billing
GROUP BY doctor_id)t;

-- 7. For each department, rank visits by visit_cost using PARTITION BY.
SELECT
    visit_id,
	department,
	visit_cost,
	RANK() OVER(PARTITION BY department ORDER BY visit_cost DESC) AS Rank_visits
FROM visits
WHERE department IS NOT NULL;

-- 8. Display each visit with the maximum visit_cost within the same department.
SELECT
    visit_id,
	department,
	visit_cost,
	MAX(visit_cost) OVER(PARTITION BY department) AS Maximum_visit_cost
FROM visits
WHERE department IS NOT NULL;

-- 9. Show each billing record with the minimum consultation_fee across all billing records.
SELECT
    bill_id,
	consultation_fee,
	MIN(consultation_fee) OVER() AS Min_fee
FROM Billing;

-- 10. Calculate cumulative medicine_cost per patient using SUM() OVER(PARTITION BY patient_id ORDER BY created_date).
SELECT
    patient_id,
	medicine_cost,
	created_date,
	SUM(medicine_cost) OVER(PARTITION BY patient_id ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_medicine_cost
FROM Billing;

-- 11. Display each visit and the previous visit_date for the same patient using LAG().
SELECT
    visit_id,
	patient_id,
	visit_date,
	LAG(visit_date) OVER(PARTITION BY patient_id ORDER BY visit_date) AS Previous_visit_date
FROM visits;

-- 12. Show each visit and the next visit_date for the same patient using LEAD().
SELECT
    visit_id,
	patient_id,
	visit_date,
	LEAD(visit_date) OVER(PARTITION BY patient_id ORDER BY visit_date) AS Next_visit_date
FROM visits;

-- 13. Calculate the difference in days between consecutive visits per patient using LAG().
SELECT
    patient_id,
	visit_id,
	Previous_visit_date,
	Current_visit_date,
	DATEDIFF(DAY,Previous_visit_date ,Current_visit_date) AS Difference_days
FROM
(
SELECT
    patient_id,
	visit_id,
	visit_date AS Current_visit_date,
	LAG(visit_date) OVER(PARTITION BY patient_id ORDER BY visit_date, visit_id) AS Previous_visit_date
FROM visits)t;

-- 14. Display each billing record and previous consultation_fee for the same doctor.
SELECT
    bill_id,
	doctor_id,
	consultation_fee,
	created_date,
	LAG(consultation_fee) OVER(PARTITION BY doctor_id ORDER BY created_date) AS Previous_fee
FROM Billing;

-- 15. Show change in medicine_cost compared to previous billing record per patient.
SELECT
    bill_id,
    patient_id,
    created_date,
    medicine_cost,
    LAG(medicine_cost) OVER(
        PARTITION BY patient_id
        ORDER BY created_date, bill_id
    ) AS Previous_medicine_cost,
    medicine_cost
    - LAG(medicine_cost) OVER(
        PARTITION BY patient_id
        ORDER BY created_date, bill_id
    ) AS Medicine_cost_change
FROM Billing;


-- 16. Identify first visit_date for each patient using FIRST_VALUE().
SELECT
    patient_id,
	visit_id,
	visit_date,
	FIRST_VALUE(visit_date) OVER(PARTITION BY patient_id ORDER BY visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS First_value
FROM visits;

-- 17. Identify last visit_date for each patient using LAST_VALUE() with proper window framing.
SELECT
    patient_id,
	visit_id,
	visit_date,
	LAST_VALUE(visit_date) OVER(PARTITION BY patient_id ORDER BY visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_value
FROM visits;

-- 18. Display each visit with earliest visit_date across all visits.
SELECT
    visit_id,
	visit_date,
	MIN(visit_date) OVER() AS earliest_date
FROM visits;

-- 19. Display each billing record with highest discount given across all records.
SELECT
    bill_id,
	discount,
	MAX(ABS(discount)) OVER() AS Highest_discount
FROM Billing;

-- 20. Show visit_cost difference between current and first visit per patient.
SELECT
    patient_id,
	visit_id,
	Current_visit_cost,
	first_value,
	Current_visit_cost-first_value AS Difference_visit_cost
FROM
(
SELECT
    patient_id,
	visit_id,
	visit_cost AS Current_visit_cost,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_value
FROM visits)t;

-- 21. Calculate moving average of visit_cost for each patient considering last 2 visits.
SELECT
    patient_id,
	visit_cost,
	visit_date,
	AVG(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS Moving_avg
FROM visits;

-- 22. Calculate rolling sum of consultation_fee for each doctor ordered by date.
SELECT
    doctor_id,
	created_date,
	consultation_fee,
	SUM(consultation_fee) OVER(PARTITION BY doctor_id ORDER BY created_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Rolling_sum
FROM Billing;

-- 23. Display visit details with average visit_cost per department.
SELECT
    visit_id,
	visit_cost,
	department,
	AVG(visit_cost) OVER(PARTITION BY department) AS Avg_visit_cost
FROM visits
WHERE department IS NOT NULL;

-- 24. Show billing records with consultation_fee compared to department average using window functions.
SELECT
    b.bill_id,
    d.department,
    b.consultation_fee,
    AVG(b.consultation_fee) OVER(PARTITION BY d.department) AS Avg_fee,
    b.consultation_fee
      - AVG(b.consultation_fee) OVER(PARTITION BY d.department)
      AS Fee_vs_dept_avg
FROM Billing b
JOIN Doctors d
    ON b.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL;

-- 25. Calculate percentage contribution of each billing’s consultation_fee to total consultation_fee.
SELECT
    bill_id,
	Total_fee,
	consultation_fee,
	ROUND(consultation_fee/Total_fee * 100,2) AS Percentage_distribution
FROM
(
SELECT
    bill_id,
	consultation_fee,
	SUM(COALESCE(consultation_fee,0)) OVER() AS Total_fee
FROM Billing
)t;


-- 26. Calculate percentage contribution of medicine_cost per patient.
SELECT
    patient_id,
    medicine_cost,
    Total_medicine_cost,
    ROUND(
        COALESCE(medicine_cost,0) * 100.0
        / NULLIF(Total_medicine_cost,0),
        2
    ) AS Percentage_contribution
FROM
(
    SELECT
        patient_id,
        medicine_cost,
        SUM(COALESCE(medicine_cost,0)) OVER(PARTITION BY patient_id) AS Total_medicine_cost
    FROM Billing
) t;


-- 27. Show each visit and flag it as highest cost visit per patient using window functions.
SELECT
    visit_id,
    patient_id,
    visit_cost,
    CASE
        WHEN visit_cost = MAX(visit_cost) OVER(PARTITION BY patient_id)
        THEN 1
        ELSE 0
    END AS Is_highest_cost_visit
FROM visits;


-- 28. Identify duplicate visit_cost values using COUNT() OVER().
SELECT
    visit_id,
    visit_cost,
    CASE
        WHEN COUNT(*) OVER(PARTITION BY visit_cost) > 1
        THEN 1
        ELSE 0
    END AS Is_duplicate_cost
FROM visits;


-- 29. Display billing records with rank based on discount amount (absolute value).
SELECT
    bill_id,
	discount,
	ABS(discount) AS absolute_value,
	RANK() OVER(ORDER BY ABS(discount)DESC)  AS Rank_abs_discount
FROM Billing;

-- 30. Find top 3 most expensive visits per department using window functions.
SELECT
    visit_id,
    department,
    visit_cost
FROM (
    SELECT
        visit_id,
        department,
        visit_cost,
        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY visit_cost DESC
        ) AS cost_rank
    FROM Visits
    WHERE department IS NOT NULL
) t
WHERE cost_rank <= 3;

-- 31. Find top 2 patients per city based on total visit_cost using window functions.
SELECT * FROM
(
SELECT
    patient_id,
    full_name,
    city,
    total_visit_cost,
    DENSE_RANK() OVER (ORDER BY total_visit_cost DESC) AS rank_
FROM (
    SELECT
        p.patient_id,
        CONCAT(p.first_name, ' ', p.last_name) AS full_name,
        p.city,
        SUM(COALESCE(v.visit_cost, 0)) AS total_visit_cost
    FROM Patients p
    LEFT JOIN Visits v
        ON p.patient_id = v.patient_id
    GROUP BY p.patient_id, p.first_name, p.last_name, p.city
) t)tt
WHERE rank_ <= 2;

    
-- 32. Display billing records with cumulative tax amount calculated using window functions.
SELECT
    bill_id,
    created_date,
    tax_amount,
    SUM(tax_amount) OVER (
        ORDER BY created_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_tax_amount
FROM (
    SELECT
        bill_id,
        created_date,
        (
            (COALESCE(consultation_fee, 0)
           + COALESCE(medicine_cost, 0)
           - COALESCE(discount, 0))
           * COALESCE(tax_percent, 0) / 100
        ) AS tax_amount
    FROM Billing
) t;


-- 33. Show each visit and total visits in the same department.
SELECT
    visit_id,
	department,
	COUNT(visit_id) OVER(PARTITION BY department) AS Total_visits
FROM visits
WHERE department IS NOT NULL;

-- 34. Calculate running total of medicine_cost ordered by created_date.
SELECT
    bill_id,
    medicine_cost,
    created_date,
    SUM(COALESCE(medicine_cost,0)) OVER(
        ORDER BY created_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Total_medicine_cost
FROM Billing;


-- 35. Show visits where visit_cost is above department average using window functions.
SELECT * FROM
(
SELECT
    visit_id,
	visit_cost,
	department,
	AVG(visit_cost) OVER(PARTITION BY department) AS Avg_department
FROM Visits
WHERE department IS NOT NULL)t
WHERE visit_cost > Avg_department;


-- 36. Display each patient’s visit along with visit number using ROW_NUMBER().
SELECT
    visit_id,
	patient_id,
	visit_date,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date) AS Unique_number
FROM Visits;

-- 37. Rank patients by total billing amount using window functions.
SELECT
    patient_id,
	Total_billing_amount,
	RANK() OVER(ORDER BY Total_billing_amount DESC) AS Rank_Total_billing_amount
FROM
(
SELECT
	patient_id,
	SUM(COALESCE(medicine_cost,0)+COALESCE(consultation_fee,0)-COALESCE(discount,0)) AS Total_billing_amount
FROM Billing
GROUP BY patient_id)t;

-- 38. Show billing records with consultation_fee minus average consultation_fee.
SELECT
    bill_id,
	consultation_fee,
	Avg_cosnultation_fee,
	consultation_fee- Avg_cosnultation_fee AS Difference_fee
FROM
(
SELECT
    bill_id,
	consultation_fee,
	AVG(COALESCE(consultation_fee,0)) OVER() AS Avg_cosnultation_fee
FROM Billing)t;


-- 39. Display visit details with maximum visit_cost per patient.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	MAX(visit_cost) OVER(PARTITION BY patient_id) AS Maximum_visit_cost
FROM visits;

-- 40. Identify second highest visit_cost per department using window functions.
SELECT * FROM
(
SELECT
    visit_id,
	visit_cost,
	department,
	DENSE_RANK() OVER(PARTITION BY department ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC) AS Dense_rank_visit_cost
FROM visits
WHERE department IS NOT NULL)t
WHERE Dense_rank_visit_cost = 2;

-- 41. Show each billing record with next discount value using LEAD().
SELECT
    bill_id,
	discount,
	created_date,
	LEAD(discount) OVER(ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date,bill_id) AS Next_discount
FROM Billing;

-- 42. Calculate difference between current and next consultation_fee per doctor.
SELECT
    doctor_id,
    created_date,
    consultation_fee,
    LEAD(consultation_fee) OVER(
        PARTITION BY doctor_id
        ORDER BY created_date, bill_id
    ) AS Next_fee,
    consultation_fee 
    - LEAD(consultation_fee) OVER(
        PARTITION BY doctor_id
        ORDER BY created_date, bill_id
    ) AS Difference_fee
FROM Billing;


-- 43. Show each visit and days since previous visit per patient.
SELECT
    visit_id,
	patient_id,
    Current_visit_date,
	Previous_visit,
	DATEDIFF(DAY,Previous_visit,Current_visit_date) AS Difeerence_days
FROM
(
SELECT
    visit_id,
	patient_id,
	visit_date AS Current_visit_date,
	LAG(visit_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date, visit_id) AS Previous_visit
FROM Visits)t;


-- 44. Display visits along with cumulative visit_cost per patient.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	visit_date,
	SUM(COALESCE(visit_cost,0)) OVER(PARTITION BY patient_id 
	                                ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date, visit_id
									ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_visit_cost
FROM Visits;

-- 45. Show average visit_cost calculated over last 3 visits per patient.
SELECT
    visit_id,
    patient_id,
    visit_cost,
    visit_date,
    AVG(COALESCE(visit_cost,0)) OVER(
        PARTITION BY patient_id
        ORDER BY visit_date, visit_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Moving_avg_last_3_visits
FROM Visits;


-- 46. Identify first billing date per doctor using FIRST_VALUE().
SELECT
    bill_id,
	doctor_id,
	created_date,
	FIRST_VALUE(created_date) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date, bill_id
	                                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS First_date
FROM Billing;

-- 47. Identify most recent billing per patient using LAST_VALUE().
SELECT
    bill_id,
	patient_id,
	created_date,
	LAST_VALUE(created_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date, bill_id
	                                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_date
FROM Billing;

-- 48. Show billing records with ranking by tax_percent.
SELECT
    bill_id,
	tax_percent,
	RANK() OVER(ORDER BY tax_percent DESC)  AS Rank_tax_percent
FROM Billing;

-- 49. Find patients whose visit_cost is highest compared to all other patients.
SELECT
    patient_id,
    visit_cost
FROM
(
    SELECT
        patient_id,
        visit_cost,
        MAX(visit_cost) OVER() AS Max_visit_cost
    FROM Visits
) t
WHERE visit_cost = Max_visit_cost;


-- 50. Calculate median visit_cost using window functions.
-- 50. Calculate median visit_cost using window functions.

WITH OrderedVisits AS
(
    SELECT
        visit_cost,
        ROW_NUMBER() OVER (ORDER BY visit_cost) AS RowNum,
        COUNT(*) OVER () AS TotalRows
    FROM Visits
    WHERE visit_cost IS NOT NULL
)

SELECT
    AVG(visit_cost * 1.0) AS Median_visit_cost
FROM OrderedVisits
WHERE RowNum IN (
        (TotalRows + 1) / 2,      -- middle row (odd case)
        (TotalRows + 2) / 2       -- handles even case
);

-- 51. Display visits with NTILE(4) based on visit_cost.
SELECT
    visit_id,
	visit_cost,
	NTILE(4) OVER(ORDER BY visit_cost DESC) AS Ntile_4
FROM Visits;

-- 52. Segment billing records into 3 buckets based on consultation_fee using NTILE().
SELECT
    bill_id,
	consultation_fee,
	NTILE(3) OVER(ORDER BY CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END, consultation_fee) AS Ntile_3
FROM Billing;

-- 53. Identify patients in top 25% of total visit_cost.
WITH PatientTotals AS
(
    SELECT
        patient_id,
        SUM(COALESCE(visit_cost,0)) AS Total_visit_cost
    FROM Visits
    GROUP BY patient_id
)

SELECT *
FROM
(
    SELECT
        patient_id,
        Total_visit_cost,
        CUME_DIST() OVER(ORDER BY Total_visit_cost DESC) AS Cume_dist
    FROM PatientTotals
)t
WHERE Cume_dist <= 0.25;


-- 54. Show billing records along with row number ordered by medicine_cost.
SELECT
    bill_id,
	created_date,
	medicine_cost,
	ROW_NUMBER() OVER(ORDER BY CASE WHEN medicine_cost IS NULL THEN 1 ELSE 0 END, medicine_cost DESC) AS Rn
FROM Billing;

-- 55. Display billing records with cumulative discount per doctor.
SELECT
    bill_id,
	doctor_id,
	discount,
    SUM(COALESCE(ABS(discount),0)) OVER(PARTITION BY doctor_id 
	                                 ORDER BY CASE WHEN  created_date IS NULL THEN 1 ELSE 0 END,  created_date, bill_id 
									 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_disocunt
FROM Billing;

	                                         

-- 56. Rank visits by visit_cost within each patient.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	RANK() OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC,visit_id) AS Rank_visits
FROM Visits;

-- 57. Show visit records with percent rank of visit_cost.
SELECT
    visit_id,
	visit_cost,
	PERCENT_RANK() OVER( ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC,visit_id) AS Rank_visits
FROM Visits;

-- 58. Display billing records with CUME_DIST() based on consultation_fee.
SELECT
    bill_id,
	consultation_fee,
	created_date,
	CUME_DIST() OVER(ORDER BY CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END, consultation_fee, bill_id) AS Cume_dis
FROM Billing;

-- 59. Identify visits where visit_cost percentile is above 80%.
SELECT *
FROM
(
    SELECT
        visit_id,
        visit_cost,
        PERCENT_RANK() OVER(
            ORDER BY visit_cost
        ) AS Rank_visits
    FROM Visits
    WHERE visit_cost IS NOT NULL
)t
WHERE Rank_visits >= 0.8;


-- 60. Calculate relative rank of billing records by medicine_cost.
SELECT
    bill_id,
	medicine_cost,
	PERCENT_RANK() OVER(ORDER BY CASE WHEN medicine_cost IS NULL THEN 1 ELSE 0 END, medicine_cost) AS Relative_rank
FROM Billing;

-- 61. Display visits with difference between max and min visit_cost per patient.
SELECT
   
    visit_id,
	patient_id,
	visit_cost,
    Max_cost,
	MIN_Cost,
	Max_cost-MIN_Cost AS Difference_cost
FROM
(
SELECT
    visit_id,
	patient_id,
	visit_cost,
	MAX(visit_cost) OVER(PARTITION BY patient_id) AS Max_cost,
	MIN(visit_cost) OVER(PARTITION BY patient_id) AS MIN_Cost
FROM Visits)t;

-- 62. Show billing records with average discount per doctor.
SELECT
    bill_id,
	doctor_id,
	discount,
	AVG(COALESCE(ABS(discount),0)) OVER(PARTITION BY doctor_id) AS Avg_discount
FROM Billing;

-- 63. Display visits with visit_cost compared to patient’s average visit_cost.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	AVG(COALESCE(visit_cost,0)) OVER(PARTITION BY patient_id) AS Avg_visit_cost,
	visit_cost- AVG(COALESCE(visit_cost,0)) OVER(PARTITION BY patient_id) AS Difference_
FROM Visits;

-- 64. Show billing records with total billing amount per patient using window functions.
SELECT
    bill_id,
	patient_id,
	SUM(COALESCE(medicine_cost,0)+COALESCE(consultation_fee,0)-COALESCE(discount,0)) OVER(PARTITION BY patient_id) AS Total_billing_amount
FROM Billing;

-- 65. Identify billing records where consultation_fee is the highest for that doctor.
SELECT * FROM
(
SELECT
    bill_id,
	doctor_id,
	consultation_fee,
	DENSE_RANK() OVER(PARTITION BY doctor_id ORDER BY CASE WHEN consultation_fee IS NULL THEN 1 ELSE 0 END, consultation_fee DESC) AS Rnk
FROM Billing)T
WHERE Rnk = 1;


-- 66. Show visit records with running count of visits per department.
SELECT
    visit_id,
	visit_date,
	department,
	COUNT(visit_id) OVER(PARTITION BY department ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
	                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_count
FROM Visits
WHERE department IS NOT NULL;


-- 67. Calculate cumulative average visit_cost per patient.
SELECT
    patient_id,
	visit_cost,
	AVG(COALESCE(visit_cost,0)) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
	                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_avg
FROM visits;

-- 68. Show billing records with consultation_fee deviation from overall average.
SELECT
    bill_id,
	consultation_fee,
	AVG(COALESCE(consultation_fee,0)) OVER() AS Overall_avg,
	consultation_fee- AVG(COALESCE(consultation_fee,0)) OVER() AS deviation
FROM Billing;

-- 69. Display visit details with lagged visit_cost per patient.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	LAG(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date,visit_id) AS Lagged_visit_cost
FROM visits;

-- 70. Show visit_cost growth trend per patient using window functions.
SELECT
    visit_id,
    patient_id,
    visit_date,
    visit_cost,
    visit_cost 
        - LAG(visit_cost) OVER(
            PARTITION BY patient_id 
            ORDER BY visit_date, visit_id
        ) AS Growth_amount
FROM Visits;


-- 71. Identify patients whose latest visit_cost is higher than their previous visit.
SELECT *
FROM
(
    SELECT
        visit_id,
        patient_id,
        visit_date,
        visit_cost,
        LAG(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date, visit_id) AS Previous_cost,
        ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY visit_date DESC, visit_id DESC) AS rn
    FROM Visits
)t
WHERE rn = 1
  AND visit_cost > Previous_cost;


-- 72. Display visits with first and last visit_cost per patient in the same row.
SELECT
    visit_id,
	patient_id,
	visit_date,
	visit_cost,
	FIRST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date, visit_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS First_cost,
	LAST_VALUE(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date, visit_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_cost
FROM Visits;

-- 73. Show billing records with rolling sum of medicine_cost for last 2 bills.
SELECT
    bill_id,
	created_date,
	medicine_cost,
	SUM(COALESCE(medicine_cost,0)) OVER(PARTITION BY patient_id ORDER BY created_date, bill_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS Rolling_sum
FROM Billing;

-- 74. Rank departments by average visit_cost using window functions.
SELECT 
	department,
	Avg_cost,
	RANK() OVER(ORDER BY Avg_cost DESC) AS RN
FROM
(
SELECT
	department,
	AVG(COALESCE(visit_cost,0)) AS Avg_cost
FROM Visits
WHERE department IS NOT NULL
GROUP BY department)t;

-- 75. Display visit records with department-wise cumulative visit_cost.
SELECT
    visit_id,
	visit_date,
	department,
	visit_cost,
	SUM(COALESCE(visit_cost,0)) OVER(PARTITION BY department ORDER BY visit_date, visit_id 
	                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_visit_cost
FROM visits
WHERE department IS NOT NULL;


-- 76. Identify billing records that contribute to top 50% of revenue.
-- 76. Identify billing records that contribute to top 50% of revenue.

SELECT *
FROM
(
    SELECT
        bill_id,
        doctor_id,
        created_date,
        COALESCE(medicine_cost,0)
        + COALESCE(consultation_fee,0)
        - COALESCE(discount,0) AS revenue,

        SUM(
            COALESCE(medicine_cost,0)
            + COALESCE(consultation_fee,0)
            - COALESCE(discount,0)
        ) OVER (
            ORDER BY 
                COALESCE(medicine_cost,0)
                + COALESCE(consultation_fee,0)
                - COALESCE(discount,0) DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) 
        /
        SUM(
            COALESCE(medicine_cost,0)
            + COALESCE(consultation_fee,0)
            - COALESCE(discount,0)
        ) OVER () AS cumulative_percentage

    FROM Billing
) t
WHERE cumulative_percentage <= 0.50;

-- 77. Display visits with count of visits before and after current visit.

SELECT
    visit_id,
    patient_id,
    visit_date,
    rn - 1 AS visits_before,
    total_visits - rn AS visits_after
FROM
(
    SELECT
        visit_id,
        patient_id,
        visit_date,
        ROW_NUMBER() OVER(
            PARTITION BY patient_id 
            ORDER BY visit_date, visit_id
        ) AS rn,
        COUNT(*) OVER(
            PARTITION BY patient_id
        ) AS total_visits
    FROM Visits
)t;


-- 78. Show visit details with sliding window average of visit_cost.
SELECT
    visit_id,
	visit_date,
	visit_cost,
	AVG(COALESCE(visit_cost,0)) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date, visit_id 
	                                    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS Sliding_window_avg
FROM visits;


-- 79. Calculate patient-wise total visit_cost without using GROUP BY.
SELECT
    visit_id,
	patient_id,
	visit_cost,
	SUM(COALESCE(visit_cost,0)) OVER(PARTITION BY patient_id) AS Total_visit_cost
FROM Visits;

-- 80. Display billing records with doctor-wise max consultation_fee.
SELECT
    bill_id,
	doctor_id,
	consultation_fee,
	MAX(consultation_fee) OVER(PARTITION BY doctor_id) AS Max_fee
FROM Billing;

-- 81. Identify patients whose visit_cost is consistently increasing.
SELECT patient_id
FROM
(
    SELECT
        patient_id,
        visit_cost,
        LAG(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date, visit_id) AS prev_cost
    FROM Visits
) t
WHERE prev_cost IS NOT NULL
GROUP BY patient_id
HAVING COUNT(*) = COUNT(CASE WHEN visit_cost > prev_cost THEN 1 END);

-- 82. Show billing records with rank and dense rank difference.
SELECT
    patient_id,
	Total_revenue,
	RANK() OVER(ORDER BY Total_revenue DESC) AS Rn,
	DENSE_RANK() OVER(ORDER BY Total_revenue DESC) AS Dense_rn
FROM
(
SELECT
    patient_id,
	SUM(COALESCE(medicine_cost,0)+ COALESCE(consultation_fee,0) -COALESCE(discount,0)) AS Total_revenue
FROM Billing
GROUP BY patient_id)t;


-- 83. Display visits where visit_cost equals department maximum.
SELECT * FROM
(
SELECT
    visit_id,
	department,
	visit_cost,
	MAX(visit_cost) OVER(PARTITION BY department) AS Max_department
FROM visits
WHERE department IS NOT NULL)t
WHERE visit_cost = Max_department;

-- 84. Show billing records with cumulative consultation_fee ignoring NULLs.
SELECT
    bill_id,
	created_date,
	patient_id,
	consultation_fee,
	SUM(consultation_fee) OVER(PARTITION BY patient_id ORDER BY created_date, bill_id
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_fee
FROM Billing


-- 85. Calculate doctor-wise running total of medicine_cost.
SELECT
    bill_id,
	created_date,
	doctor_id,
	medicine_cost,
	SUM(medicine_cost) OVER(PARTITION BY doctor_id ORDER BY created_date, bill_id
	                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runnning_medicine_cost
FROM Billing;

-- 86. Show visit records with visit_cost difference from department max.
SELECT
    visit_id,
	department,
	visit_cost,
	MAX(visit_cost) OVER(PARTITION BY department) AS Max_department,
	visit_cost - MAX(visit_cost) OVER(PARTITION BY department) AS Difference_
FROM visits
WHERE department IS NOT NULL

-- 87. Identify visits with lowest visit_cost per patient.
SELECT * FROM
(
SELECT
    visit_id,
	patient_id,
	visit_cost,
	DENSE_RANK() OVER(
    PARTITION BY patient_id 
    ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END,
             visit_cost,
             visit_id) AS dn
FROM Visits)t
WHERE dn = 1;

-- 88. Display billing records with windowed sum of total payable amount.
SELECT
    bill_id,
    patient_id,
    COALESCE(medicine_cost,0) 
    + COALESCE(consultation_fee,0) 
    - COALESCE(discount,0) AS Payable_amount,
    
    SUM(COALESCE(medicine_cost,0) 
        + COALESCE(consultation_fee,0) 
        - COALESCE(discount,0)) 
        OVER(PARTITION BY patient_id) AS Total_revenue
FROM Billing;


-- 89. Rank patients by number of visits using window functions.
SELECT
    patient_id,
	Total_visits,
	RANK() OVER(ORDER BY Total_visits DESC) AS Rn
FROM
(
SELECT
    
	patient_id,
	COUNT(visit_id) AS Total_visits
FROM visits
GROUP BY patient_id)t;


-- 90. Show visit details with average visit_cost per city using window functions.
SELECT 
    v.visit_id,
	p.city,
	AVG(COALESCE(v.visit_cost,0)) OVER(PARTITION BY p.city) AS avg_cost
FROM patients p 
INNER JOIN visits v
ON p.patient_id = v.patient_id
WHERE p.city IS NOT NULL;


-- 91. Identify billing records where consultation_fee is below doctor average.
SELECT
* FROM
(
SELECT
    bill_id,
	doctor_id,
	consultation_fee,
	AVG(COALESCE(consultation_fee,0)) OVER(PARTITION BY doctor_id) AS Avg_doc_fee
FROM Billing)t
WHERE consultation_fee < Avg_doc_fee

-- 92. Show visit records with visit sequence number per patient.
SELECT
    visit_id,
	patient_id,
	visit_date,
	ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY visit_date, visit_id) AS rn
FROM Visits;

-- 93. Display visits with visit_cost percentile within department.
SELECT
    visit_id,
	department,
	visit_cost,
	PERCENT_RANK() OVER(PARTITION BY department ORDER BY visit_cost) AS Percentile_cost
FROM visits
WHERE department IS NOT NULL;

-- 94. Show billing records with difference between consultation_fee and running average.
SELECT
    bill_id,
	consultation_fee,
	Runningavg,
	consultation_fee - Runningavg AS Difference_
FROM
(
SELECT
    bill_id,
	created_date,
	consultation_fee,
	AVG(COALESCE(consultation_fee,0)) OVER(ORDER BY created_date, bill_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Runningavg
FROM Billing)t;


-- 95. Identify top 3 billing records per doctor based on total medicine_cost.
SELECT *
FROM
(
    SELECT
        bill_id,
        doctor_id,
        medicine_cost,
        DENSE_RANK() OVER(
            PARTITION BY doctor_id
            ORDER BY medicine_cost DESC
        ) AS rn
    FROM Billing
)t
WHERE rn <= 3;


-- 96. Display visits with previous and next visit_cost per patient.
SELECT
    visit_id,
	visit_cost,
	visit_date,
	LAG(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date, visit_id) AS previous_cost,
	LEAD(visit_cost) OVER(PARTITION BY patient_id ORDER BY visit_date, visit_id) AS Next_cost
FROM visits;


-- 97. Show billing records with cumulative revenue per month using window functions.
SELECT
    bill_id,
	created_date,
	YEAR(created_date) AS Year_date,
	MONTH(created_date) AS Month_date,
	COALESCE(medicine_cost,0)+COALESCE(consultation_fee,0)-COALESCE(discount,0) AS Total,
	SUM(COALESCE(medicine_cost,0)+COALESCE(consultation_fee,0)-COALESCE(discount,0))
	                             OVER(PARTITION BY YEAR(created_date), MONTH(created_date)
								  ORDER BY created_date, bill_id
								  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_revenue
FROM Billing;

-- 98. Identify patients whose total visit_cost is above overall average.
SELECT DISTINCT
    patient_id,
    Total_visit_cost,
    Overall_avg
FROM
(
    SELECT
        patient_id,
        SUM(visit_cost) OVER(PARTITION BY patient_id) AS Total_visit_cost,
        AVG(visit_cost) OVER() AS Overall_avg
    FROM Visits
)t
WHERE Total_visit_cost > Overall_avg;




-- 99. Display visit records with department-wise rank by visit_cost.
SELECT
    visit_id,
	department,
	visit_cost,
	visit_date,
	RANK() OVER(PARTITION BY department ORDER BY CASE WHEN visit_cost IS NULL THEN 1 ELSE 0 END, visit_cost DESC, visit_id) AS RN
FROM Visits
WHERE department IS NOT NULL;


-- 100. Show billing records with consultation_fee compared to previous bill per doctor.
SELECT
    bill_id,
	doctor_id,
	consultation_fee,
	LAG(consultation_fee) OVER(PARTITION BY doctor_id ORDER BY created_date, bill_id) AS previous_fee,
	consultation_fee- LAG(consultation_fee) OVER(PARTITION BY doctor_id ORDER BY created_date, bill_id) AS Difference_fee
FROM Billing;
