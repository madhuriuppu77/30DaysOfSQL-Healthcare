/* ============================================================
    PART 1: 50 MIXED-TOPIC SQL QUESTIONS
   (Each mixes 2–3 concepts: DATE FUNCTIONS, CAST, CONVERT, FORMAT, GROUP BY, JOINS, etc.)
   ============================================================ */

-- 1. Get the number of visits per month using DATETRUNC(month, visit_date) and FORMAT() to show month name.
SELECT
    DATETRUNC(MONTH, visit_date) AS visit_month,
    FORMAT(DATETRUNC(MONTH, visit_date),'MMMM') AS month_name,
    COUNT(*) AS total_visits
FROM Visits
GROUP BY DATETRUNC(MONTH, visit_date),
         FORMAT(DATETRUNC(MONTH, visit_date),'MMMM')
ORDER BY visit_month;

-- 2. Show total billing amount per patient by grouping on YEAR(created_date) and using CAST() on tax_percent(FLOAT).
SELECT
    patient_id,
    YEAR(created_date) AS bill_year,
    SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0) - COALESCE(discount,0)) AS total_billing
FROM Billing
GROUP BY patient_id, YEAR(created_date);


-- 3. List patients who visited in the same week using DATETRUNC(week, visit_date) + COUNT().
SELECT
    DATETRUNC(WEEK, visit_date) AS visit_date_week,
	COUNT(visit_id) Total_visits_per_week
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATETRUNC(WEEK, visit_date);

-- 4. Show doctor-wise visit count but only for visits in the last month using EOMONTH().
SELECT
    doctor_id,
    COUNT(*) AS total_visits_last_month
FROM Visits
WHERE visit_date >= DATEADD(MONTH, -1, EOMONTH(GETDATE()))
  AND visit_date < EOMONTH(GETDATE())
GROUP BY doctor_id;



-- 5. Group visits by DATEPART(weekday, visit_date) and show day names using DATENAME().
SELECT
    DATENAME(WEEKDAY, visit_date) AS weekday_name,
    COUNT(*) AS total_visits
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATENAME(WEEKDAY, visit_date);
  
  

-- 6. Show visits where visit_date converted to VARCHAR matches ‘2024%’
SELECT
    visit_id,
    visit_date,
    CONVERT(VARCHAR(10), visit_date, 112) AS converted_visit_date
FROM Visits
WHERE visit_date IS NOT NULL
  AND CONVERT(VARCHAR(10), visit_date, 112) LIKE '2024%';

-- 7. Display billing summary with medicine_cost formatted using FORMAT(medicine_cost,'#,##0.00').
SELECT
    bill_id,
    FORMAT(
        SUM(
            COALESCE(consultation_fee, 0)
            + COALESCE(medicine_cost, 0)
            - COALESCE(discount, 0)
        ),
        '#,##0.00'
    ) AS total_billing
FROM Billing
GROUP BY bill_id;

-- 8. Identify invalid dates in Visits by checking ISDATE(CONVERT(VARCHAR, visit_date)).
SELECT
    visit_id,
	visit_date,
	ISDATE(CONVERT(VARCHAR(10), visit_date)) AS is_date_valid
FROM Visits
WHERE ISDATE(CONVERT(VARCHAR(10), visit_date))= 1;

-- 9. Group bills by DATETRUNC(year, created_date) and calculate avg consultation_fee.
SELECT
    DATETRUNC(year,created_date) AS Datetrunc_created_date,
    COUNT(bill_id) AS total_bills_per_year,
	AVG(consultation_fee) AS avg_consultation
FROM Billing
GROUP BY DATETRUNC(year,created_date);

-- 10. Show total number of visits each quarter using DATETRUNC(quarter, visit_date).
SELECT
    DATETRUNC(QUARTER, visit_date) AS quarter_visit_date,
	COUNT(visit_id) AS Total_visits_per_quater
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATETRUNC(QUARTER, visit_date);

-- 11. Show weekday distribution of bills using DATEPART(weekday, created_date).
SELECT
   
	 DATEPART(WEEKDAY, created_date) AS weekday_bills,
	 COUNT(bill_id) AS total_bills_per_weekday
FROM Billing
GROUP BY DATEPART(WEEKDAY, created_date)
ORDER BY COUNT(bill_id) DESC;


-- 12. Find patients whose visits fall on last day of the month using visit_date = EOMONTH(visit_date).
SELECT * FROM Visits
WHERE visit_date= EOMONTH(visit_date);

-- 13. Display visit details where diagnosis is NULL and visit_date is formatted as ‘dd-MMM-yyyy’.
SELECT
    visit_id,
	patient_id,
	doctor_id,
	department,
	diagnosis,
	visit_date,
	FORMAT(visit_date,'dd-MMM-yyyy') AS Formatted_date
FROM Visits
WHERE diagnosis IS NULL;

-- 14. Group Billing by EOMONTH(created_date) and calculate total revenue.
SELECT
    COUNT(bill_id) AS Total_bills_per_end_of_month,
	SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0) - COALESCE(discount,0)) AS total_revenue,
	EOMONTH(created_date) AS End_of_month_createddate
FROM Billing
GROUP BY EOMONTH(created_date);

-- 15. Show doctor-wise count of visits for YEAR 2024 using YEAR(visit_date).
SELECT
    doctor_id,
    YEAR(visit_date) AS year_visit_date,
    COUNT(visit_id) AS Total_visits_per_doc
FROM Visits
WHERE YEAR(visit_date) = 2024
GROUP BY doctor_id, YEAR(visit_date);

-- 16. List bills where discount is negative and convert discount to INT.
SELECT
    bill_id,
    discount,
    CONVERT(INT, discount) AS converted_discount
FROM Billing
WHERE discount < 0;

-- 17. Get all visits where visit_date is within same week as '2024-03-12' using DATEPART(week).
SELECT *
FROM Visits
WHERE DATEPART(WEEK, visit_date) = DATEPART(WEEK, '2024-03-12')
  AND YEAR(visit_date) = YEAR('2024-03-12');

-- 18. Show the earliest and latest visit per patient using MIN() and MAX() with CAST().
SELECT
    patient_id,
	CAST(MIN(visit_date) AS DATE) AS earliest_date,
	CAST(MAX(visit_date) AS DATE) AS latest_date
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY patient_id;

-- 19. Count visits per patient where visit_date is after DATETRUNC(month, GETDATE()).
SELECT
    patient_id,
    COUNT(visit_id) AS Total_visits_per_patient
FROM Visits
WHERE visit_date > DATETRUNC(month, GETDATE())
GROUP BY patient_id;


-- 20. Show bills created in weekends using DATENAME(weekday, created_date).
SELECT
    bill_id,
    DATENAME(WEEKDAY, created_date) AS weekday_created_date
FROM Billing
WHERE DATENAME(WEEKDAY, created_date) IN ('Saturday', 'Sunday');


-- 21. Display visit_date using FORMAT(visit_date,'dddd, dd-MMM-yyyy').
SELECT 
    visit_id,
	visit_date,
	FORMAT(visit_date,'dddd, dd-MMM-yyyy') AS formatted_visit_date
FROM Visits
WHERE visit_date IS NOT NULL;

-- 22. List patients whose visit_date is not a valid date string using ISDATE().
SELECT
    patient_id,
	ISDATE(CONVERT(VARCHAR(20),visit_date)) AS is_visit_date_valid
FROM Visits
WHERE visit_date IS NOT NULL AND ISDATE(CONVERT(VARCHAR(20),visit_date))= 0;


-- 23. Calculate monthly total medicine cost using GROUP BY MONTH(created_date).
SELECT
    MONTH(created_date) AS month_created_date,
	SUM(medicine_cost) AS Total_medicine_cost_permonth
FROM Billing
GROUP BY MONTH(created_date);

SELECT
    FORMAT(created_date,'MMMM') AS month_created_date,
	SUM(medicine_cost) AS Total_medicine_cost_permonth
FROM Billing
GROUP BY FORMAT(created_date,'MMMM') ;

-- 24. Show  doctor_id and number of bills grouped by DATETRUNC(month, created_date).
SELECT
    doctor_id,
	COUNT(bill_id) AS Total_number_bills_per_datetruncmonth,
	DATETRUNC(month,created_date) AS datetrunc_month_created_date
FROM Billing
GROUP BY DATETRUNC(month,created_date),doctor_id;


-- 25. Get visits where MONTH(visit_date) = MONTH(GETDATE()) using CAST().
SELECT * FROM Visits
WHERE MONTH(CAST(visit_date AS DATE))= MONTH(CAST(GETDATE() AS DATE));

-- 26. Show average consultation fee for each year using YEAR(created_date).
SELECT
    YEAR(created_date) AS year_created_date,
	AVG(consultation_fee) AS avg_consultation_fee
FROM Billing
GROUP BY YEAR(created_date);

-- 27. Display number of visits per doctor using INNER JOIN + DATEPART(month).
SELECT
    d.doctor_id,
    COUNT(v.visit_id) AS number_of_visits_perdoc,
	DATEPART(MONTH, v.visit_date) AS Datepart_month
FROM Visits v
INNER JOIN Doctors d
ON v.doctor_id= d.doctor_id
WHERE v.visit_date IS NOT NULL
GROUP BY d.doctor_id, DATEPART(MONTH, v.visit_date);

-- 28. Show all billing rows where created_date formatted in ‘MMM-yyyy’ equals ‘Mar-2024’.
SELECT
    bill_id,
	created_date,
	FORMAT(created_date,'MMM-yyyy') AS Formatted_date
FROM Billing
WHERE FORMAT(created_date,'MMM-yyyy')='Mar-2024';
  
-- 29. Extract first day of month from visit_date using DATEADD and EOMONTH.
SELECT
    visit_id,
    visit_date,
    DATEADD(DAY, 1, EOMONTH(visit_date, -1)) AS first_day_month
FROM Visits
WHERE visit_date IS NOT NULL;

-- 30. Group visits by month and show month in TEXT using DATENAME(month, visit_date).
SELECT
    DATENAME(MONTH, visit_date) AS month_name,
    YEAR(visit_date) AS year_visit,
    COUNT(visit_id) AS total_visits_per_month
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY YEAR(visit_date), DATENAME(MONTH, visit_date);

-- 31. Show bills where tax_percent cast to INT is greater than 10.
SELECT * FROM Billing
WHERE CAST(tax_percent AS INT) > 10;

-- 32. Get visit count where visit_date is in first week of month using DATEPART(week).
SELECT
    COUNT(visit_id) AS Total_visits_per_1stweek_month
FROM Visits
WHERE visit_date IS NOT NULL
  AND DAY(visit_date) <= 7;

-- 33. Show all visits where FORMAT(visit_date,'yyyy-MM') = '2024-03'.
SELECT * FROM Visits
WHERE FORMAT(visit_date,'yyyy-MM') = '2024-03';

-- 34. List doctors with visits between two EOMONTH() boundaries.
SELECT *
FROM Visits
WHERE visit_date BETWEEN DATEADD(DAY, 1, EOMONTH('2024-02-01'))  -- first day of March
                    AND EOMONTH('2024-03-01');                  -- last day of March

-- 35. Find total visits per quarter using DATETRUNC(quarter, visit_date).
SELECT
    DATETRUNC(quarter, visit_date) AS Datetrunc_quarter,
	COUNT(visit_id) AS Total_visits_per_quarter
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATETRUNC(quarter, visit_date);

-- 36. Identify duplicate visit days using DATETRUNC(day, visit_date) + COUNT()>1.
SELECT
    DATETRUNC(day, visit_date) AS Datetrunc_visit_date,
    COUNT(visit_id) AS Total_visits_duplicates
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATETRUNC(day, visit_date)
HAVING COUNT(visit_id) > 1;
  
-- 37. Find patients whose bill date = today’s DATE() using CONVERT(date, GETDATE()).
SELECT *
FROM Billing
WHERE CONVERT(date, created_date) = CONVERT(date, GETDATE());

-- 38. Convert visit_date to VARCHAR(11) and show all visits.
SELECT 
    visit_id,
	visit_date,
	CONVERT(VARCHAR(11),visit_date) AS Converted_visit_date
FROM Visits
WHERE visit_date IS NOT NULL;

-- 39. Show yearly medicine cost using YEAR(created_date) + SUM().
SELECT
    YEAR(created_date) AS Yearly_created_date,
	SUM(medicine_cost) AS Yearly_medicine_cost
FROM Billing
GROUP BY YEAR(created_date);

-- 40. List patients who visited in last 7 days using DATEDIFF(day, visit_date, GETDATE()).
SELECT
    visit_id,
    visit_date,
    DATEDIFF(DAY, visit_date, GETDATE()) AS Datediff_visited
FROM Visits
WHERE visit_date IS NOT NULL
  AND DATEDIFF(DAY, visit_date, GETDATE()) BETWEEN 0 AND 7;

-- 41. Show doctor-wise max consultation fee using GROUP BY doctor_id.
SELECT
    doctor_id,
	MAX(consultation_fee) AS Maximum_consulttaion_fee_perdoc
FROM Billing
GROUP BY doctor_id;

-- 42. Format created_date like “2024 / Feb / 14” using FORMAT().
SELECT
    bill_id,
    created_date,
    FORMAT(created_date, 'yyyy / MMM / dd') AS Formatted_date
FROM Billing;

-- 43. Show visits where visit_date converted to DATE is after '2024-03-01'.
SELECT * FROM Visits
WHERE CONVERT(DATE, visit_date) > CONVERT(DATE, '2024-03-01');

-- 44. Identify invalid bill dates using ISDATE(created_date).
SELECT
    bill_id,
	created_date,
	ISDATE(created_date) AS is_valid
FROM Billing
WHERE ISDATE(created_date) = 0;


-- 45. Count visits for each DATETRUNC(week, visit_date) period.
SELECT
    DATETRUNC(week, visit_date) AS Datetrunc_visit_date,
	COUNT(visit_id) AS Total_visits_per_week
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATETRUNC(week, visit_date);

-- 46. Show revenue summary per month using CONCAT(FORMAT(created_date,'MMM'),' ',YEAR(created_date)).
SELECT
    CONCAT(FORMAT(created_date,'MMM'),' ',YEAR(created_date)) AS Formatted_date,
	SUM(COALESCE(consultation_fee,0) + COALESCE(medicine_cost,0) - COALESCE(discount,0)) AS total_revenue
FROM Billing
GROUP BY CONCAT(FORMAT(created_date,'MMM'),' ',YEAR(created_date));

-- 47. Show all patients who visited on Monday using DATENAME(weekday, visit_date).
SELECT * FROM Visits
WHERE DATENAME(weekday, visit_date)='Monday';

-- 48. List all events where event_datetime truncated to hour equals ‘2024-03-12 23:00’.
SELECT *
FROM DateTimePractice
WHERE DATETRUNC(hour, event_datetime) = '2024-03-12 23:00:00';


-- 49. Convert medicine_cost to VARCHAR and combine with billing date.
SELECT
    Bill_id,
	medicine_cost,
	created_date,
	CONCAT(CONVERT(VARCHAR(20), medicine_cost),' ',created_date) AS medicine_cost_created_date
FROM Billing;

-- 50. Group by month using DATETRUNC(month, visit_date) and show diagnosis count.
SELECT
    DATETRUNC(month, visit_date) AS Datetrunc_visit_date,
	COUNT(diagnosis) AS diagnosis_per_month
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATETRUNC(month, visit_date);



/* ============================================================
    PART 2: INDIVIDUAL TOPIC QUESTIONS
   (Each topic has exactly 10 questions)
   ============================================================ */

--------------------------------------------------------------
--  DAY() : 10 INTERVIEW QUESTIONS
--------------------------------------------------------------

-- 1. Retrieve all visits that happened on the 15th day of any month using DAY(visit_date).
SELECT * FROM Visits
WHERE DAY(visit_date)= 15;

-- 2. List patients whose registration or visit date has DAY() equal to DAY(GETDATE()).
SELECT p.*, v.visit_date FROM Patients p
LEFT JOIN Visits v
ON p.patient_id= v.patient_id
WHERE DAY(visit_date)= DAY(GETDATE());

-- 3. Show visit_id and day number extracted from visit_date using DAY().
SELECT
	visit_id,
	visit_date,
	DAY(visit_date) AS DAY_visit_date
FROM Visits;

-- 4. Count how many visits occurred on each day of the month (use GROUP BY DAY(visit_date)).
SELECT
    DAY(visit_date) AS day_visit_date,
	COUNT(visit_id) AS total_visits_per_day
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DAY(visit_date);


-- 5. Find all bills created on weekends by checking if DAY(created_date) matches typical weekend dates (like 6, 7, 13, 14 etc.).


SELECT
     bill_id,
	 consultation_fee,
	 medicine_cost,
	 discount,
	 tax_percent
     created_date,
	 DAY(created_date) AS Day_created_date
FROM Billing
WHERE DAY(created_date) IN ( 6,7,13,14,20,21, 21,28);



-- 6. Return all visits where DAY(visit_date) is between 1 and 10.
SELECT * FROM Visits
WHERE DAY(visit_date) BETWEEN 1 AND 10;

-- 7. Show patients who visited twice on the same day number across different months.
SELECT
	DAY(v.visit_date) AS Day_visit_date,
	COUNT(v.visit_id) AS total_visits_per_day   
FROM Patients p
LEFT JOIN Visits v
ON p.patient_id = v.patient_id
WHERE v.visit_date IS NOT NULL
GROUP BY DAY(v.visit_date)
HAVING COUNT(v.visit_id) = 2;

   
-- 8. Display the earliest and latest visit for each day number using MIN() and MAX() over DAY(visit_date).
SELECT
    DAY(visit_date) AS day_visit_date,
	MIN(visit_date) AS earliest_visit,
	MAX(visit_date) AS latest_visit
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DAY(visit_date);


-- 9. Find total billing amounts for each day number extracted from created_date.
SELECT 
    DAY(created_date) AS DAY_create_date,
	SUM(consultation_fee+ medicine_cost- discount) AS Total_billing_each_day
FROM Billing
GROUP BY DAY(created_date);

-- 10. Identify all events from DateTimePractice where DAY(event_datetime) = 1 (first day of month).
SELECT * FROM DateTimePractice
WHERE DAY(event_datetime) = 1;



---------------------------------------------------------------
--  YEAR(): 10 QUESTIONS
---------------------------------------------------------------
-- 1. Show visits that happened in YEAR(visit_date) = 2024.
SELECT * FROM Visits
WHERE YEAR(visit_date) =2024;

-- 2. Count visits per YEAR(visit_date).
SELECT
    YEAR(visit_date) AS Year_visit_date,
	COUNT(visit_id) AS Total_visits_per_year
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY YEAR(visit_date);

-- 3. Show bills grouped by YEAR(created_date).
SELECT
	YEAR(created_date) AS Year_created_date,
	COUNT(bill_id) AS Total_bills_per_year
FROM Billing
GROUP BY YEAR(created_date);


-- 4. Find earliest visit per YEAR.
SELECT
    YEAR(visit_date) AS visits_per_year,
	MIN(visit_date) AS earliest_year
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY YEAR(visit_date);

-- 5. Compare YEAR(visit_date) and YEAR(created_date).
SELECT
    YEAR(v.visit_date) AS YEAR_visit_date,
	YEAR(b.created_date) AS YEAR_created_date
FROM Visits v
JOIN Billing b
    ON v.patient_id = b.patient_id
WHERE YEAR(v.visit_date) = YEAR(b.created_date);


-- 6. List visits older than 2 years using YEAR().
SELECT 
    *
FROM Visits
WHERE YEAR(GETDATE()) - YEAR(visit_date) > 2;

-- 7. Show patients with multiple visits in the same YEAR.
SELECT patient_id, YEAR(visit_date) AS visit_year,
       COUNT(*) AS total_visits
FROM Visits
GROUP BY patient_id, YEAR(visit_date)
HAVING COUNT(*) > 1;

-- 8. Extract YEAR(event_datetime).
SELECT
    YEAR(event_datetime) AS extract_year
FROM DateTimePractice;

-- 9. Group events per YEAR(event_date).
SELECT
    YEAR(event_date) AS Year_event_date,
	COUNT(record_id) AS Total_events_per_year
FROM DateTimePractice
GROUP BY YEAR(event_date);

-- 10. Show revenue per YEAR using SUM().
SELECT 
    YEAR(created_date) AS Year_created_date,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS revenue
FROM Billing
GROUP BY YEAR(created_date);

    


---------------------------------------------------------------
--  MONTH(): 10 QUESTIONS
---------------------------------------------------------------
-- 1. Show visits from MONTH(visit_date) = 3.
SELECT * FROM Visits
WHERE MONTH(visit_date) = 3;

-- 2. Count visits per MONTH.
SELECT
    MONTH(visit_date) AS Month_visit_date,
	COUNT(visit_id) AS Total_visits_per_month
FROM Visits
WHERE Visit_date IS NOT NULL
GROUP BY MONTH(visit_date);

-- 3. Group bills by MONTH(created_date).
SELECT
    MONTH(created_date) AS Month_created_date,
	COUNT(bill_id) AS total_bills_per_month
FROM Billing
GROUP BY MONTH(created_date);

-- 4. Compare MONTH(created_date) = MONTH(GETDATE()).
SELECT * FROM Billing
WHERE MONTH(created_date) = MONTH(GETDATE());

-- 5. Show month names with DATENAME(month, visit_date).
SELECT
   visit_id,
   visit_date,
   DATENAME(MONTH, visit_date) AS month_name
FROM Visits
WHERE Visit_date IS NOT NULL;

-- 6. Filter visits from last 3 months.
SELECT * FROM Visits
WHERE visit_date >= DATEADD(MONTH, -3, GETDATE());


-- 7. Find patient with most visits in each month.
SELECT
    MONTH(visit_date) AS month_no,
    patient_id,
    COUNT(*) AS total_visits
FROM Visits
GROUP BY MONTH(visit_date), patient_id
HAVING COUNT(*) = (
    SELECT MAX(visit_count)
    FROM (
        SELECT patient_id, COUNT(*) AS visit_count
        FROM Visits v2
        WHERE MONTH(v2.visit_date) = MONTH(Visits.visit_date)
        GROUP BY patient_id
    ) x
);


-- 8. Extract MONTH(event_datetime).
SELECT 
   
    MONTH(event_datetime) AS Month_event_datetime
FROM DateTimePractice;

-- 9. Group events by MONTH(event_date).

SELECT
    MONTH(event_date) AS Month_event_date,
	COUNT(record_id) AS Total_events_per_event_date
FROM DateTimePractice
GROUP BY MONTH(event_date);

-- 10. Show number of bills each month.
SELECT
    MONTH(created_date) AS Month_create_time,
	COUNT(bill_id) AS Total_bills_per_month
FROM Billing
GROUP BY MONTH(created_date);


---------------------------------------------------------------
--  DATEPART(): 10 QUESTIONS
---------------------------------------------------------------
-- 1. Find weekday of each visit using DATEPART(weekday, visit_date).
SELECT
    DATEPART(weekday, visit_date) AS Datepart_visit_date,
	COUNT(visit_id) AS Total_visits_per_weekday
FROM Visits
WHERE Visit_date IS NOT NULL
GROUP BY DATEPART(weekday, visit_date);

-- 2. Count visits per weekday.
SELECT
    DATEPART(weekday, visit_date) AS Datepart_visit_date,
	COUNT(visit_date) AS Total_visits_per_weekday
FROM Visits
WHERE Visit_date IS NOT NULL
GROUP BY DATEPART(weekday, visit_date);

-- 3. Group bills per quarter using DATEPART(quarter, created_date).
SELECT
    DATEPART(quarter, created_date) AS Datepart_created_date,
	COUNT(bill_id) AS Total_bills_per_quarter
FROM Billing
GROUP BY DATEPART(quarter, created_date);

-- 4. Find which week of year each visit falls in.
SELECT
    visit_id,
	DATEPART(WEEK, visit_date) AS Datepart_week
FROM Visits;

-- 5. Show visits on weekend (DATEPART(weekday)=1 or 7).
SELECT * FROM Visits
WHERE DATENAME(weekday, visit_date) IN ('Saturday', 'Sunday');


-- 6. Extract hour from event_datetime.
SELECT
    event_datetime,
	DATEPART(hour, event_datetime) AS Hour_event_datetime
FROM DateTimePractice;

-- 7. Extract minute from event_time.
SELECT
    event_datetime,
	DATEPART(MINUTE, event_datetime) AS Minute_event_datetime
FROM DateTimePractice;

-- 8.  COUNT viists by week number.
SELECT
    DATEPART(WEEK, visit_date) AS Week_visit_date,
	COUNT(visit_id) AS Total_visits_per_week
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY  DATEPART(WEEK, visit_date);
 
-- 9. Compare DATEPART(month) with MONTH() of visits.
SELECT * FROM Visits
WHERE DATEPART(MONTH, visit_date) = MONTH(visit_date);

-- 10. Filter visits from week 10.
SELECT * FROM Visits
WHERE DATEPART(WEEK, visit_date)= 10;


---------------------------------------------------------------
--  DATENAME(): 10 QUESTIONS
---------------------------------------------------------------
-- 1. Show weekday name of each visit.
SELECT 
    visit_id,
	visit_date,
	DATENAME(WEEKDAY, visit_date) AS Datename_visit_date
FROM Visits;

-- 2. Show month name for visit_date.
SELECT 
    visit_id,
	visit_date,
	DATENAME(MONTH, visit_date) AS Datename_visit_date
FROM Visits;

-- 3. Show day name for created_date.
SELECT 
    bill_id,
	created_date,
	DATENAME(WEEKDAY, created_date) AS Datename_createddate
FROM Billing;

-- 4. Group visits by DATENAME(weekday,visit_date).
SELECT
    DATENAME(weekday, visit_date) AS Datename_visitdate,
	COUNT(visit_id) AS Total_visits_per_weekday
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATENAME(weekday,visit_date);

-- 5. Show month name of billing date.
SELECT
    bill_id,
	created_date,
	DATENAME(MONTH,created_date) AS Datename_month
FROM Billing;

-- 6. List visits made on Monday.
SELECT
    *
FROM Visits
WHERE DATENAME(WEEKDAY, visit_date) ='Monday';

-- 7. Show full datetime with month name.

SELECT
    record_id,
	event_name,
	event_time,
	event_date,
	DATENAME(MONTH, event_datetime) AS Datename_month
FROM DateTimePractice;

-- 8. Get quarter name using DATENAME(quarter,...) in viists
SELECT 
    visit_id,
    visit_date,
    DATENAME(QUARTER, visit_date) AS Datename_quarter
FROM Visits;

-- 9. Compare DATENAME(month) = 'March'.
SELECT * FROM Visits
WHERE DATENAME(MONTH, Visit_date)= 'March';


-- 10. Find visit counts by weekday name.
SELECT
    DATENAME(WEEKDAY, visit_date) AS Datename_visit_date,
	COUNT(visit_id) AS Total_visits_per_weekday
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY DATENAME(WEEKDAY, visit_date);


---------------------------------------------------------------
--  DATETRUNC(): 10 QUESTIONS
---------------------------------------------------------------
-- 1. Truncate visit_date to month.
SELECT
    visit_id,
    visit_date,
    DATETRUNC(MONTH, visit_date) AS DATETRUNC_month
FROM Visits;

-- 2. Group by DATETRUNC(week,visit_date).
SELECT
    DATETRUNC(WEEK, visit_date) AS Week_start,
    COUNT(visit_id) AS Total_visits
FROM Visits
GROUP BY DATETRUNC(WEEK, visit_date);

-- 3. Truncate created_date to year.
SELECT
    bill_id,
	created_date,
	DATETRUNC(YEAR, created_date) AS DATETRUNC_createddate
FROM Billing;

-- 4. Compare DATETRUNC(day,visit_date) = visit_date.
SELECT
    visit_id,
	visit_date,
	DATETRUNC(DAY, visit_date) AS DATEtrunc_day
FROM Visits
WHERE DATETRUNC(DAY, visit_date)= visit_date;

-- 5. Find visits per quarter.
SELECT
    DATETRUNC(QUARTER, visit_date) AS DATETRUNC_visitdate,
    COUNT(visit_id) AS Total_visits_per_quater
FROM visits
WHERE visit_date IS NOT NULL
GROUP BY DATETRUNC(QUARTER, visit_date);

-- 6. Group revenue by DATETRUNC(month,created_date).
SELECT
    DATETRUNC(MONTH, created_date) AS DATETRUNC_month,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_revenu
FROM Billing
GROUP BY DATETRUNC(MONTH, created_date);


-- 7. Show DATETRUNC(hour,event_datetime).
SELECT
    event_datetime,
	DATETRUNC(hour,event_datetime) AS DATETRUNC_hour
FROM DateTimePractice;

-- 8. Filter rows where DATETRUNC(month,visit_date)='2024-03-01'.
SELECT
 * FROM Visits
WHERE DATETRUNC(month, visit_date) =  2024-03-01;


-- 9. Count visits per DATETRUNC(day,visit_date).
SELECT
    DATETRUNC(DAY, visit_date) AS DATETRUNC_day,
	COUNT(visit_id) AS Total_visits_per_day
FROM Visits
WHERE Visit_date IS NOT NULL
GROUP BY DATETRUNC(DAY, visit_date);

-- 10. Use DATETRUNC(year,event_date) to group events.
SELECT  
    DATETRUNC(year,event_date) AS Datetrunc_year,
	COUNT(record_id) AS Total_records_per_year

FROM DateTimePractice
GROUP BY DATETRUNC(year,event_date);

    


---------------------------------------------------------------
--  EOMONTH(): 10 QUESTIONS
---------------------------------------------------------------
-- 1. Show end-of-month for each visit_date.
SELECT
    visit_id,
	visit_date,
	EOMONTH(visit_date) AS End_of_month
FROM Visits;

-- 2. Show EOMONTH(created_date).
SELECT
    Bill_id,
	created_date,
	EOMONTH(created_date) AS END_OF_MONTH
FROM Billing;

-- 3. Find visits that occurred on month end.
SELECT * FROM Visits
WHERE visit_date= EOMONTH(visit_date);

-- 4. Add 1 month using EOMONTH(visit_date,1).
SELECT 
    visit_id,
	visit_date,
	EOMONTH(visit_date,1) AS end_of_month_1
FROM Visits;

-- 5. Subtract 1 month using EOMONTH(visit_date,-1).
SELECT 
    visit_id,
	visit_date,
	EOMONTH(visit_date,-1) AS end_of_month_1
FROM Visits;

-- 6. Group visits by EOMONTH(visit_date).
SELECT
    EOMONTH(visit_date) AS end_of_month_date,
	COUNT(visit_id) AS Total_visits_per_endofmonth
FROM Visits
WHERE Visit_date IS NOT NULL
GROUP BY EOMONTH(visit_date);

-- 7. Group bills by EOMONTH(created_date).
SELECT
    EOMONTH(created_date) AS End_of_month,
	COUNT(bill_id) AS Total_bills_per_endofmonth
FROM Billing
GROUP BY EOMONTH(created_date);


-- 8. Compare visit_date = EOMONTH(visit_date).
SELECT * FROM Visits
WHERE visit_date = EOMONTH(visit_date);

-- 9. Filter bills created in last month using EOMONTH().
SELECT * FROM Billing
WHERE created_date >= EOMONTH(GETDATE(), -1) + 1
AND   created_date <  EOMONTH(GETDATE()) + 1;


-- 10. Calculate revenue per EOMONTH(created_date).
SELECT
    EOMONTH(created_date) AS end_of_month_createddate,
	SUM(COALESCE(consultation_fee,0)+ COALESCE(medicine_cost,0)- COALESCE(discount,0)) AS Total_revenu
FROM Billing
GROUP BY  EOMONTH(created_date);

---------------------------------------------------------------
--  CAST(): 10 QUESTIONS
---------------------------------------------------------------
-- 1. Cast visit_date to VARCHAR(20).
SELECT
    visit_id,
	visit_date,
	CAST(visit_date AS VARCHAR(20)) AS cast_visitdate
FROM Visits
WHERE visit_date IS NOT NULL;

-- 2. Cast created_date to DATETIME.
SELECT
     bill_id,
	 created_date,
	 CAST(created_date AS DATETIME) Cast_createddate
FROM Billing;

-- 3. Cast consultation_fee to INT.
SELECT
    Bill_id,
	consultation_fee,
	CAST(consultation_fee AS INT) AS Cast_consultation_fee
FROM Billing;

-- 4. Cast discount to VARCHAR.
SELECT
    Bill_id,
	discount,
	CAST(discount AS VARCHAR(20)) AS Cast_discount
FROM Billing;

-- 5. Cast tax_percent to INT.
SELECT
    Bill_id,
	tax_percent,
	CAST(tax_percent AS INT) AS Cast_dicount
FROM Billing;

-- 6. Cast medicine_cost to FLOAT.
SELECT
    Bill_id,
	medicine_cost,
	CAST(medicine_cost AS FLOAT) Cast_medicine_cost
FROM Billing;

-- 7. Cast diagnosis to NVARCHAR(200).
SELECT  
    patient_id,
	diagnosis,
	CAST(diagnosis AS NVARCHAR(200)) AS Cast_diagnosis
FROM Visits;

-- 8. Cast patient_id to VARCHAR for concatenation.
SELECT
    patient_id,
	CAST(patient_id AS VARCHAR(10)) AS cast_patient_id
FROM Patients;

-- 9. Cast created_date to DATE and group.
SELECT
    bill_id,
	created_date,
	CAST(created_date AS DATE) AS Cast_created_date
FROM Billing;

-- 10. Cast event_time to VARCHAR.
SELECT
    record_id,
	event_time,
	CAST(event_time AS VARCHAR(10))
FROM DateTimePractice;


/*
---------------------------------------------------------------
--  CONVERT(): 10 QUESTIONS
CHAR      → Fixed-length string
VARCHAR   → Variable-length string
NVARCHAR  → Variable-length string (supports Unicode – all languages/emojis)

---------------------------------------------------------------*/
-- 1. Convert visit_date to format 103 (dd/mm/yyyy).
SELECT
    visit_id,
	visit_date,
	CONVERT(VARCHAR, visit_date, 103) AS convert_visit_date
FROM Visits
WHERE visit_date IS NOT NULL;

-- 2. Convert created_date to format 101 (mm/dd/yyyy).
SELECT
    Bill_id,
	created_date,
	CONVERT(VARCHAR,created_date, 101) AS convert_date_101
FROM Billing;

-- 3. Convert visit_date to style 113.
SELECT
    visit_id,
	visit_date,
	CONVERT(VARCHAR, visit_date, 113) AS convert_date_113
FROM Visits;

-- 4. Convert created_date to style 120.
SELECT
    Bill_id,
	created_date,
	CONVERT(VARCHAR, created_date, 120) AS convert_date_120
FROM Billing;

-- 5. Convert consultation_fee to VARCHAR.
SELECT
    Bill_id,
	consultation_fee,
	CONVERT(VARCHAR,consultation_fee) AS convert_fee
FROM Billing;

-- 6. Convert diagnosis to CHAR(20).
SELECT
    visit_id,
	diagnosis,
	CONVERT(CHAR(20), diagnosis) AS convert_diagnosis
FROM Visits;

-- 7. Convert doctor_id to VARCHAR.
SELECT
    doctor_id,
	CONVERT(VARCHAR, doctor_id) AS Convert_doctor_id
FROM Doctors;


-- 8. Show visit_date in style 105.
SELECT
    visit_id,
	visit_date,
	CONVERT(VARCHAR, visit_date, 105) AS convert_visit_id105
FROM Visits;
-- 9. Convert created_date to style 107.

SELECT 
    Bill_id,
	created_date,
	CONVERT(VARCHAR, created_date, 107) AS Convert_created_date107
FROM Billing;

-- 10. Convert visit_date to datetime2.
SELECT
    visit_id,
	CONVERT(DATETIME2, visit_date) AS convert_visit_date
FROM Visits;



---------------------------------------------------------------
--  FORMAT(): 10 QUESTIONS
---------------------------------------------------------------
-- 1. Format visit_date as 'Monday, 14 February 2024'.
SELECT 
    visit_id,
	visit_date,
    FORMAT(visit_date, 'dddd, dd MMMM yyyy') AS formatted_date
FROM Visits;

-- 2. Format bill_date as 'MMM-yyyy'.
SELECT
    bill_id,
    created_date,
	FORMAT(created_date,'MMM-yyyy') AS formatted_date
FROM Billing;

-- 3. Format visit_date as 'dd-MMM'.
SELECT
    visit_date,
	FORMAT(visit_date,'dd-MMM') AS formatted_date
FROM Visits;

-- 4. Format created_date as 'yyyy/MM'.
SELECT
    created_date,
	FORMAT(created_date, 'yyyy/MM') AS formatted_date
FROM Billing;

-- 5. Format visit_date month name.
SELECT
    visit_date,
	FORMAT(visit_date,'MMMM') AS formatted_date
FROM Visits;

-- 6. Format visit_date weekday short name.
SELECT
    visit_date,
	FORMAT(visit_date, 'dddd') AS formatted_date
FROM Visits;

-- 7. Format consultation_fee as '₹#,##0.00'.
SELECT
    Bill_id,
	consultation_fee,
    FORMAT(consultation_fee,'₹#,##0.00') AS formatted_fee
FROM Billing;

-- 8. Format medicine_cost to '0,000.00'.
SELECT
    Bill_id,
	FORMAT(medicine_cost, '0,000.00') AS formatted_cost
FROM Billing;

-- 9. Format tax_percent as '5%'.
SELECT
    tax_percent,
    CONCAT(tax_percent, '%') AS formatted_percent
FROM Billing;

-- 10. Format event_datetime to 'dd/MM/yyyy hh:mm tt'.
SELECT FORMAT(event_datetime, 'dd/MM/yyyy hh:mm tt') AS formatted_date FROM DateTimePractice;



---------------------------------------------------------------
--  ISDATE(): 10 QUESTIONS
---------------------------------------------------------------
----------------------------------------------------------------
-- EXPLANATION OF ALL ISDATE() QUESTIONS
---------------------------------------------------------------

---------------------------------------------------------------
-- 1. Check if visit_date is valid using ISDATE().
---------------------------------------------------------------
--  Error: ISDATE(date) gives: Argument data type date is invalid
--  Reason: ISDATE() only accepts VARCHAR/NVARCHAR.
-- So you must convert DATE → VARCHAR first.

SELECT 
    visit_id,
    visit_date,
    ISDATE(CONVERT(VARCHAR(50), visit_date)) AS is_valid_date
FROM Visits;

-- This will ALWAYS return 1 for real date columns,
-- because SQL already stores them as valid dates.
---------------------------------------------------------------


---------------------------------------------------------------
-- 2. Check if created_date is valid.
---------------------------------------------------------------
-- Same rule applies: convert to varchar first.

SELECT 
    bill_id,
    created_date,
    ISDATE(CONVERT(VARCHAR(50), created_date)) AS is_valid_date
FROM Billing;
---------------------------------------------------------------


---------------------------------------------------------------
-- 3. Test if diagnosis contains date-like strings.
---------------------------------------------------------------
-- If Diagnosis column is VARCHAR and sometimes stores dates
-- Example: “2024-04-12 fever”
-- We can check which values look like date.

SELECT
    diagnosis,
    ISDATE(diagnosis) AS is_date_like
FROM Patients;
---------------------------------------------------------------


---------------------------------------------------------------
-- 4. Find invalid date rows in Billing.
---------------------------------------------------------------
-- If created_date was VARCHAR in your table, this checks invalid dates.
-- But if created_date is DATE type → always valid.

SELECT 
    bill_id,
    created_date
FROM Billing
WHERE ISDATE(CONVERT(VARCHAR(50), created_date)) = 0;
---------------------------------------------------------------


---------------------------------------------------------------
-- 5. Identify NULL or invalid visit_date.
---------------------------------------------------------------
-- Useful when visit_date is VARCHAR.
-- If visit_date is DATE → invalid values cannot exist.

SELECT 
    visit_id,
    visit_date
FROM Visits
WHERE visit_date IS NULL
   OR ISDATE(CONVERT(VARCHAR(50), visit_date)) = 0;
---------------------------------------------------------------


---------------------------------------------------------------
-- 6. Test ISDATE(phone).
---------------------------------------------------------------
-- Phone will return 0 because it's not a date.

SELECT
    patient_id,
    phone,
    ISDATE(phone) AS valid_phone   -- mostly 0
FROM Patients;
---------------------------------------------------------------


---------------------------------------------------------------
-- 7. Validate string '2024-13-01'.
---------------------------------------------------------------
--  Your code had error because:
--     CONVERT(VARCHAR, 2024-13-01) subtracts numbers (2024 - 13 - 1 = 2010)
--     Not a date.

-- Correct way: Put it as a string.

SELECT 
    '2024-13-01' AS input_value,
    ISDATE('2024-13-01') AS is_valid;   -- returns 0 (invalid: month 13)
FROM Visits;

-- If you want to check against your table:
SELECT 
    visit_id,
    visit_date,
    ISDATE('2024-13-01') AS is_valid
FROM Visits
WHERE visit_date = '2024-13-01';  -- will return no rows (invalid date)
---------------------------------------------------------------


---------------------------------------------------------------
-- 8. Validate 'Feb 30 2024'.
---------------------------------------------------------------
SELECT
    'Feb 30 2024' AS input_value,
    ISDATE('Feb 30 2024') AS is_valid  -- returns 0 (Feb 30 does not exist)
FROM Visits;

---------------------------------------------------------------


---------------------------------------------------------------
-- 9. Test ISDATE(CONVERT(VARCHAR,created_date)).
---------------------------------------------------------------
-- Same as Q2, checking if created_date is valid.

SELECT 
    bill_id,
    created_date,
    ISDATE(CONVERT(VARCHAR(50), created_date)) AS is_valid_date
FROM Billing;
---------------------------------------------------------------


---------------------------------------------------------------
-- 10. Validate '2024/02/14'.
---------------------------------------------------------------
-- This is a valid date in most SQL settings.

SELECT
    '2024/02/14' AS input_value,
    ISDATE('2024/02/14') AS is_valid-- likely returns 1
FROM Visits;
---------------------------------------------------------------


-------------------------------------------------
--  DATEADD() — 10 QUESTIONS
-------------------------------------------------
-- 1. Add 1 day to visit_date.
SELECT
    visit_id,
    visit_date,
    DATEADD(DAY, 1, visit_date) AS dateadd_1_visit_date
FROM Visits;


-- 2. Add 2 months to visit_date.
SELECT
    visit_id,
    visit_date,
    DATEADD(MONTH, 2, visit_date) AS dateadd_2_months_visit_date
FROM Visits;

-- 3. Add 10 years to visit_date.
SELECT
    visit_id,
	visit_date,
	DATEADD(YEAR, 10, visit_date) AS dateadad_10_years_visit_date
FROM Visits;

-- 4. Add 30 minutes to timestamp.
SELECT
    record_id,
	event_datetime,
	DATEADD(MINUTE, 30, event_datetime) AS DATEADD_event_datetime
FROM DateTimePractice;

-- 5. Add 6 hours to TIESTAMP.
SELECT
    record_id,
	event_datetime,
	DATEADD(HOUR, 6, event_datetime) AS DATEADD_event_datetime
FROM DateTimePractice;

-- 6. Add -1 month (subtract month).
SELECT
    visit_id,
	visit_date,
	DATEADD(MONTH, -1, visit_date) AS DATEADD_visitdate
FROM Visits;

-- 7. Add 15 seconds to a datetime.
SELECT
    record_id,
	event_datetime,
	DATEADD(SECOND, 15, event_datetime) AS DATEADD_event_datetime
FROM DateTimePractice;


-- 8. Extend subscription by 90 days in visits.
SELECT 
    visit_id,
	visit_date,
	DATEADD(DAY, 90, visit_date) AS DATEADD_90_visit_day
FROM Visits;


-- 9. Add 5 months(billing) safely handling overflow.
SELECT
    Bill_id,
	created_date,
	DATEADD(MONTH, 5, created_date) AS DATEADD_created_date
FROM Billing;

-- 10. Add 1 quarter to a date.
SELECT
    Bill_id,
	created_date,
	DATEADD(QUARTER, 1, created_date) AS Dateadd_created_date
FROM Billing;



-------------------------------------------------
--  DATEDIFF() — 10 QUESTIONS
-------------------------------------------------
-- 1. Find days between two dates(visit_date todays date and end of month).
--------------------------------------------------------------
--  DATEDIFF() — 10 QUESTIONS (Corrected & Explained)
--------------------------------------------------------------

-- 1. Find days between visit_date and end of that month.
-- EOMONTH(visit_date) gives last day of the month.
SELECT
    visit_id,
    visit_date,
    DATEDIFF(DAY, visit_date, EOMONTH(visit_date)) AS Days_to_month_end
FROM Visits
WHERE visit_date IS NOT NULL;


-- 2. Calculate time difference in hours.
-- event_time MUST be a datetime for this to work.
SELECT
    record_id,
    event_datetime,
    DATEDIFF(HOUR, event_time, event_datetime) AS Hours_difference
FROM DateTimePractice;


-- 3. Calculate difference in minutes.
SELECT
    record_id,
    event_datetime,
    DATEDIFF(MINUTE, event_time, event_datetime) AS Minutes_difference
FROM DateTimePractice;


-- 4. Find months between visit_date and today.
SELECT
    visit_id,
    visit_date,
    DATEDIFF(MONTH, visit_date, GETDATE()) AS Months_difference
FROM Visits;


-- 5. Calculate age in years using DOB (assuming column is date_of_birth)
-- Your query was wrong because age column is numeric, not date.
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS Full_name,
    city,
    date_of_birth,
    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS Age_in_years
FROM Patients;


-- 6. Find difference in weeks.
SELECT
    visit_id,
    visit_date,
    DATEDIFF(WEEK, visit_date, GETDATE()) AS Weeks_difference
FROM Visits;


-- 7. Find seconds between timestamps.
SELECT
    record_id,
    event_datetime,
    DATEDIFF(SECOND, event_time, event_datetime) AS Seconds_difference
FROM DateTimePractice;


-- 8. Compare DAY(visit_date) and today using negative DATEDIFF.
-- Negative result means visit_date is in the future.
SELECT
    visit_id,
    visit_date,
    DATEDIFF(DAY, visit_date, GETDATE()) AS Day_difference
FROM Visits;


-- 9. Check if event occurred within 24 hours.
SELECT
    record_id,
    event_datetime,
    DATEDIFF(HOUR, event_time, event_datetime) AS Hours_difference
FROM DateTimePractice
WHERE DATEDIFF(HOUR, event_time, event_datetime) = 24;


-- 10. Calculate exact age in days from DOB.
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS Full_name,
    city,
    date_of_birth,
    DATEDIFF(DAY, date_of_birth, GETDATE()) AS Age_in_days
FROM Patients;

    

