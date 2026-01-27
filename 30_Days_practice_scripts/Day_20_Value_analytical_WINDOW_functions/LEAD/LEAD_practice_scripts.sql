-- 1) Display next bp_systolic reading for each patient based on reading_date.
SELECT
    patient_id,
	bp_systolic,
	reading_date,
	LEAD(bp_systolic) OVER(PARTITION BY patient_id 
	                       ORDER BY 
						   CASE 
							   WHEN reading_date IS NULL THEN 1 
							   ELSE 0 
						   END, reading_date) AS Lead_rank
FROM VitalReadings;


-- 2) Show next bp_diastolic value for each patient ordered by reading_date.
SELECT
    patient_id,
	bp_diastolic,
	reading_date,
	LEAD(bp_diastolic) OVER(PARTITION BY patient_id 
	                       ORDER BY 
						   CASE 
							   WHEN reading_date IS NULL THEN 1 
							   ELSE 0 
						   END, reading_date) AS next_bp_diastolic
FROM VitalReadings;

-- 3) For each patient, calculate difference between current bp_systolic and next bp_systolic.
SELECT
    patient_id,
    reading_date,
    bp_systolic,
    bp_systolic 
      - LEAD(bp_systolic,1,bp_systolic) 
        OVER (PARTITION BY patient_id ORDER BY reading_date)
      AS difference_reading
FROM VitalReadings;

-- 4) Identify patients whose next bp_systolic is higher than the current reading.
SELECT
    patient_id,
    reading_date,
    bp_systolic,
    LEAD(bp_systolic) 
        OVER (PARTITION BY patient_id ORDER BY reading_date) AS next_bp,
    CASE
        WHEN LEAD(bp_systolic) 
             OVER (PARTITION BY patient_id ORDER BY reading_date)
             > bp_systolic
        THEN 'NEXT_BP_HIGHER'
        ELSE 'NOT_HIGHER'
    END AS bp_status
FROM VitalReadings;

   
-- 5) Find visits where the next visit_cost is lower than the current visit_cost.
SELECT *
FROM (
    SELECT
        visit_id,
        patient_id,
        visit_date,
        visit_cost,
        LEAD(visit_cost, 1, visit_cost)
            OVER (
                PARTITION BY patient_id
                ORDER BY 
                    CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,
                    visit_date
            ) AS next_visit_cost,
        CASE
            WHEN LEAD(visit_cost, 1, visit_cost)
                 OVER (
                     PARTITION BY patient_id
                     ORDER BY 
                         CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,
                         visit_date
                 ) < visit_cost
            THEN 'LOWER_VISIT_COST'
            ELSE 'NOT_LOWER'
        END AS visit_cost_status
    FROM Visits
) t
WHERE visit_cost_status = 'LOWER_VISIT_COST';



-- 6) Display next visit_date for each patient from the Visits table.
SELECT
    visit_id,
	patient_id,
	visit_date,
	LEAD(visit_date,1,visit_date) OVER (PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Next_visit_date
FROM Visits;

-- 7) Calculate number of days between current visit_date and next visit_date per patient.
SELECT
    patient_id,
	visit_date,
	DATEDIFF(DAY, visit_date, LEAD(visit_date,1,visit_date) OVER (PARTITION BY patient_id 
	                                               ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date)) AS Number_of_days
FROM visits;


-- 8) For each patient, flag readings where next bp_systolic drops by more than 5 units.
SELECT
    patient_id,
    bp_systolic,
    reading_date,
    next_bp_systolic,
    next_bp_systolic - bp_systolic AS Difference_bp_systolic,
    CASE 
        WHEN next_bp_systolic - bp_systolic <= -5
        THEN 'DROPPED'
        ELSE 'NOT DROPPED'
    END AS flag_status
FROM (
    SELECT *,
           LEAD(bp_systolic,1,bp_systolic)
               OVER (PARTITION BY patient_id 
                     ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date)
           AS next_bp_systolic
    FROM VitalReadings
) t;


-- 9) Show next consultation_fee for each doctor from Billing table ordered by created_date.
SELECT
    bill_id,
	doctor_id,
	consultation_fee,
	created_date,
	LEAD(consultation_fee,1,consultation_fee) OVER(PARTITION BY doctor_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date ) AS Next_fee
FROM Billing
WHERE consultation_fee IS NOT NULL;


-- 10) Find billing records where next medicine_cost is NULL.
SELECT *
FROM (
    SELECT
        bill_id,
        medicine_cost,
        created_date,
        LEAD(medicine_cost) OVER(
            ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date
        ) AS next_cost,
        LEAD(bill_id) OVER(
            ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date
        ) AS next_row_exists
    FROM Billing
) t
WHERE next_row_exists IS NOT NULL
  AND next_cost IS NULL;


-- 11) Display next discount value per patient ordered by created_date.
SELECT *
FROM (
    SELECT
        patient_id,
        discount,
        created_date,
        LEAD(discount)
            OVER(
                PARTITION BY patient_id
                ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date
            ) AS next_discount
    FROM Billing
) t
WHERE discount IS NOT NULL;


-- 12) Identify records where next discount is more negative than current discount.
SELECT *
FROM (
    SELECT
        bill_id,
        created_date,
        discount AS current_discount,
        LEAD(discount) OVER(
            ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END, created_date
        ) AS next_discount
    FROM Billing
) t
WHERE next_discount IS NOT NULL
  AND current_discount IS NOT NULL
  AND next_discount < current_discount;



-- 13) For each patient, show next visit_status using LEAD().
SELECT
    patient_id,
	visit_status AS Current_visit_status,
	visit_date,
	LEAD(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date) AS next_visit_status
FROM Visits;


-- 14) Detect visits where current visit_status is COMPLETED but next is PENDING.
SELECT * FROM
(
SELECT
    patient_id,
	visit_status AS Current_visit_status,
	visit_date,
	LEAD(visit_status) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date) AS next_visit_status
FROM Visits)t
WHERE Current_visit_status= 'COMPLETED' AND next_visit_status ='PENDING';

-- 15) Show next diagnosis for each patient ordered by visit_date.
SELECT
    patient_id,
	visit_date,
	diagnosis AS Current_diagnosis,
	LEAD(diagnosis) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date) AS Next_diagnosis
FROM Visits;


-- 16) Identify patients whose next diagnosis is NULL.

SELECT *
FROM (
    SELECT
        patient_id,
        visit_date,
        diagnosis AS current_diagnosis,
        LEAD(diagnosis) OVER(
            PARTITION BY patient_id
            ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ) AS next_diagnosis,
        LEAD(visit_date) OVER(
            PARTITION BY patient_id
            ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ) AS next_visit_date
    FROM Visits
) t
WHERE next_visit_date IS NOT NULL
  AND next_diagnosis IS NULL;


-- 17) Display next event_time from DateTimePractice ordered by event_datetime.
SELECT
   record_id,
   event_time,
   event_datetime,
   LEAD(event_time,1,event_time) OVER( ORDER BY CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END,  event_datetime) AS Next_lead
FROM DateTimePractice;


-- 18) Calculate time difference between current and next event_datetime.
SELECT
    record_id,
    event_datetime AS Current_event_datetime,
    LEAD(event_datetime,1,event_datetime) 
        OVER (
            ORDER BY CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END,
                     event_datetime
        ) AS Next_event_datetime,
    DATEDIFF(
        SECOND,
        event_datetime,
        LEAD(event_datetime,1,event_datetime) 
            OVER (
                ORDER BY CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END,
                         event_datetime
            )
    ) AS Diff_seconds
FROM DateTimePractice;

-- 19) Find events where next event happens on a different date.

SELECT *
FROM (
    SELECT
        record_id,
        event_name,
        event_date,
        LEAD(event_date) OVER(
            ORDER BY event_date
        ) AS next_event_date
    FROM DateTimePractice
) t
WHERE next_event_date IS NOT NULL
  AND event_date <> next_event_date;


-- 20) Show next bp_systolic reading using LEAD with offset 2 for each patient.
SELECT
	patient_id,
	bp_systolic,
	reading_date,
	LEAD(bp_systolic,2) OVER(PARTITION BY patient_id ORDER BY reading_date) AS Next_bp_systolic
FROM VitalReadings


-- 21) For each patient, compare bp_systolic with bp_systolic two readings ahead.
SELECT
    patient_id,
    bp_systolic AS current_bp,
    LEAD(bp_systolic,2) OVER(
        PARTITION BY patient_id ORDER BY reading_date
    ) AS bp_after_2_readings,
    bp_systolic
      - LEAD(bp_systolic,2) OVER(
            PARTITION BY patient_id ORDER BY reading_date
        ) AS bp_difference
FROM VitalReadings;


-- 22) Display next billing created_date per patient.
SELECT
    bill_id,
	patient_id,
	created_date,
	LEAD(created_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Next_created_date
FROM Billing;


-- 23) Find patients whose next billing record occurs more than 10 days later.
SELECT * FROM
(
SELECT
    patient_id,
	bill_id,
	created_date AS Current_create_date,
	LEAD(created_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Next_create_date,
	DATEDIFF(DAY,created_date, LEAD(created_date) 
	OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date)) AS Datediff_day
FROM Billing)t
WHERE Datediff_day > 10;

-- 24) Identify visit records where next visit_cost increases by more than 100.
SELECT *
FROM (
    SELECT
        patient_id,
        visit_id,
        visit_date,
        visit_cost AS current_visit_cost,
        LEAD(visit_cost) OVER(
            PARTITION BY patient_id
            ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ) AS next_visit_cost,
        LEAD(visit_cost) OVER(
            PARTITION BY patient_id
            ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ) - visit_cost AS cost_diff
    FROM Visits
) t
WHERE cost_diff > 100;

-- 25) Show next doctor_id per patient from Visits table.
SELECT
    patient_id,
    doctor_id AS current_doctor_id,
    visit_date,
    LEAD(doctor_id) OVER(
        PARTITION BY patient_id
        ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
    ) AS next_doctor_id
FROM Visits;

-- 26) Detect patients who visited a different doctor in the next visit.
SELECT *
FROM (
    SELECT
        patient_id,
        visit_id,
        visit_date,
        doctor_id AS current_doctor,
        LEAD(doctor_id) OVER (
            PARTITION BY patient_id
            ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END, visit_date
        ) AS next_doctor
    FROM Visits
) t
WHERE next_doctor IS NOT NULL
  AND current_doctor <> next_doctor;


-- 27) Display next department visited by each patient.
SELECT
    visit_id,
	patient_id,
	department,
	visit_date,
	LEAD(department) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Next_department
FROM Visits;


-- 28) Find visits where department changes in the next visit.
SELECT * FROM
(
SELECT
    visit_id,
	patient_id,
	department,
	visit_date,
	LEAD(department) OVER(PARTITION BY patient_id ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Next_department
FROM Visits)t
WHERE Next_department IS NOT NULL AND department <>  Next_department;

-- 29) For each patient, mark last reading using LEAD() returning NULL.
SELECT *,
       CASE 
           WHEN Next_reading IS NULL THEN 'LAST_READING'
           ELSE 'NOT_LAST'
       END AS reading_flag
FROM (
    SELECT
        patient_id,
        reading_id,
        reading_date,
        LEAD(reading_date) OVER(
            PARTITION BY patient_id 
            ORDER BY reading_date
        ) AS Next_reading
    FROM VitalReadings
) t;


-- 30) Replace NULL from LEAD(bp_systolic) with 0 using default value.
SELECT
    reading_id,
	patient_id,
	bp_systolic,
	LEAD(bp_systolic,1,0) OVER(PARTITION BY patient_id ORDER BY reading_date) AS Next_bp
FROM VitalReadings;


-- 31) Identify patients whose bp_systolic consistently decreases compared to next reading.
SELECT
    patient_id,
    reading_date,
    Current_bp_sys,
    Next_bp_sys,
    CASE
        WHEN Next_bp_sys < Current_bp_sys THEN 'DECREASE'
        WHEN Next_bp_sys > Current_bp_sys THEN 'INCREASE'
        ELSE 'NO_CHANGE'
    END AS bp_status
FROM (
    SELECT
        patient_id,
        reading_date,
        bp_systolic AS Current_bp_sys,
        LEAD(bp_systolic) OVER(
            PARTITION BY patient_id 
            ORDER BY reading_date
        ) AS Next_bp_sys
    FROM VitalReadings
) t
WHERE Next_bp_sys IS NOT NULL;



-- 32) Show next medicine_cost per patient ordered by created_date.
SELECT
    patient_id,
	medicine_cost,
	created_date,
	LEAD(medicine_cost) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Next_medicine_cost
FROM Billing;


-- 33) Detect billing rows where next consultation_fee is NULL.
SELECT *
FROM (
    SELECT
        patient_id,
        consultation_fee,
        created_date,
        LEAD(consultation_fee) OVER(
            PARTITION BY patient_id 
            ORDER BY created_date
        ) AS next_consultation_fee
    FROM Billing
) t
WHERE next_consultation_fee IS NULL
  AND consultation_fee IS NOT NULL;


-- 34) Calculate percentage change between current and next consultation_fee.
SELECT
    patient_id,
    created_date,
    current_fee,
    next_fee,
    CASE
        WHEN current_fee IS NULL
             OR next_fee IS NULL
             OR current_fee = 0
        THEN NULL
        ELSE ((next_fee - current_fee) * 100.0) / current_fee
    END AS percentage_change
FROM (
    SELECT
        patient_id,
        created_date,
        consultation_fee AS current_fee,
        LEAD(consultation_fee) OVER(
            PARTITION BY patient_id
            ORDER BY created_date
        ) AS next_fee
    FROM Billing
) t;


-- 35) Display next tax_percent for each patient in Billing table.
SELECT
    patient_id,
	created_date,
	tax_percent,
	LEAD(tax_percent) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS Next_tax_percent
FROM Billing;


-- 36) Identify patients whose next tax_percent is higher than current.
SELECT
    patient_id,
    created_date,
    tax_percent AS current_tax,
    next_tax_percent
FROM (
    SELECT
        patient_id,
        created_date,
        tax_percent,
        LEAD(tax_percent) OVER(
            PARTITION BY patient_id 
            ORDER BY created_date
        ) AS next_tax_percent
    FROM Billing
) t
WHERE next_tax_percent > tax_percent;


-- 37) Show next reading_date for each patient from VitalReadings.
SELECT
    patient_id,
	reading_date,
	LEAD(reading_date) OVER(PARTITION BY patient_id  ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Next_reading_date
FROM VitalReadings;


-- 38) Calculate gap in days between current and next bp reading.
SELECT
    patient_id,
	reading_date AS Current_reading,	 
	LEAD(reading_date) OVER(PARTITION BY patient_id 
	ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date) AS Next_reading,
	DATEDIFF(DAY, reading_date, LEAD(reading_date) OVER(PARTITION BY patient_id 
	                             ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date)) AS Diff_reading_bp
FROM VitalReadings;

	

-- 39) Identify readings where gap between readings exceeds 3 days.
SELECT * FROM
(
SELECT
    patient_id,
	reading_date AS Current_reading,	 
	LEAD(reading_date) OVER(PARTITION BY patient_id 
	ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date) AS Next_reading,
	DATEDIFF(DAY, reading_date, LEAD(reading_date) OVER(PARTITION BY patient_id 
	                             ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END, reading_date)) AS Diff_reading_bp
FROM VitalReadings)t
WHERE Diff_reading_bp > 3;

-- 40) Show next bp_diastolic and compare trend (increase/decrease).
SELECT
    patient_id,
    reading_date,
    Current_diastolic,
    Next_diastolic,
    CASE
        WHEN Next_diastolic IS NULL THEN 'No next reading'
        WHEN Next_diastolic > Current_diastolic THEN 'Increase'
        WHEN Next_diastolic < Current_diastolic THEN 'Decrease'
        ELSE 'No change'
    END AS bp_status
FROM (
    SELECT
        patient_id,
        reading_date,
        bp_diastolic AS Current_diastolic,
        LEAD(bp_diastolic) OVER (
            PARTITION BY patient_id
            ORDER BY reading_date
        ) AS Next_diastolic
    FROM VitalReadings
) t;


-- 41) Detect patients whose next bp_diastolic improves (decreases).
SELECT * FROM
(
SELECT
    patient_id,
    reading_date,
    Current_diastolic,
    Next_diastolic,
    CASE
        WHEN Next_diastolic IS NULL THEN 'No next reading'
        WHEN Next_diastolic > Current_diastolic THEN 'Increase'
        WHEN Next_diastolic < Current_diastolic THEN 'Decrease'
        ELSE 'No change'
    END AS bp_status
FROM (
    SELECT
        patient_id,
        reading_date,
        bp_diastolic AS Current_diastolic,
        LEAD(bp_diastolic) OVER (
            PARTITION BY patient_id
            ORDER BY reading_date
        ) AS Next_diastolic
    FROM VitalReadings
) t)t
WHERE bp_status = 'Decrease';


-- 42) Display next visit_cost using LEAD without PARTITION and observe incorrect grouping.
SELECT
    visit_id,
	visit_cost,
	visit_date,
	LEAD(visit_cost) OVER(ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Next_visit_cost
FROM Visits;


-- 43) Correct the above by partitioning by patient_id.
SELECT
    visit_id,
	visit_cost,
	visit_date,
	LEAD(visit_cost) OVER(PARTITION  BY patient_id  ORDER BY CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,visit_date) AS Next_visit_cost
FROM Visits;

-- 44) Use LEAD to identify last visit per patient.
SELECT visit_id, patient_id, visit_date
FROM (
    SELECT
        visit_id,
        patient_id,
        visit_date,
        LEAD(visit_date) OVER (
            PARTITION BY patient_id
            ORDER BY 
                CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END,
                visit_date
        ) AS Next_visit_date
    FROM Visits
) t
WHERE Next_visit_date IS NULL
  AND visit_date IS NOT NULL;

-- 45) Identify last billing record per patient using LEAD.
SELECT
    bill_id,
	patient_id,
	Current_created_date
FROM
(
SELECT
    bill_id,
	patient_id,
	created_date AS Current_created_date,
	LEAD(created_date) OVER(PARTITION BY patient_id ORDER BY CASE WHEN created_date IS NULL THEN 1 ELSE 0 END,created_date) AS next_Created_date
FROM Billing)t
WHERE Current_created_date IS NOT NULL AND next_Created_date IS NULL;

-- 46) Show next event_name for each event ordered by event_datetime.

SELECT
    record_id,
	event_name,
	event_datetime,
	LEAD(event_name) OVER(ORDER BY CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END, event_datetime) AS Next_event
FROM DateTimePractice;


-- 47) Detect system events that occur immediately after a night event.
SELECT *
FROM (
    SELECT
        record_id,
        event_name AS Current_event,
        event_datetime AS Current_event_datetime,
        LEAD(event_name) OVER (
            ORDER BY CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END, event_datetime
        ) AS Next_event,
        LEAD(event_datetime) OVER (
            ORDER BY CASE WHEN event_datetime IS NULL THEN 1 ELSE 0 END, event_datetime
        ) AS Next_event_datetime,
        CAST(event_datetime AS TIME) AS event_time
    FROM DateTimePractice
) t
WHERE CAST(event_time AS TIME) >= '18:00:00' 
   OR CAST(event_time AS TIME) < '06:00:00';

-- 48) Compare current bp_systolic with next two readings using nested LEAD.
SELECT
    reading_id,
	patient_id,
	reading_date,
	bp_systolic AS Current_bp_systolic,
	LEAD(bp_systolic,2) OVER (PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Next_bp_systolic
FROM VitalReadings;


-- 49) Identify patients whose next bp_systolic is NULL (last reading).
SELECT * FROM
(
SELECT
    reading_id,
	patient_id,
	reading_date,
	bp_systolic AS Current_bp_systolic,
	LEAD(bp_systolic) OVER (PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Next_bp_systolic
FROM VitalReadings)t
WHERE Next_bp_systolic IS NULL ;


-- 50) Using LEAD, flag records where no future data exists for the patient.
SELECT * FROM
(
SELECT
    reading_id,
	patient_id,
	reading_date AS Current_date_reading,
	LEAD(reading_date) OVER (PARTITION BY patient_id ORDER BY CASE WHEN reading_date IS NULL THEN 1 ELSE 0 END,reading_date) AS Next_reading_date
FROM VitalReadings)t
WHERE Next_reading_date IS NULL ;
