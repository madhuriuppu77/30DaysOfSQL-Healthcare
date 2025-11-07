--############################################################
-- SQL Practice Queries for Healthcare Database
-- Author: Madhuri Uppunuthula
-- Purpose: SQL practice covering SELECT, WHERE, JOINs, GROUP BY, HAVING, Aggregation
--############################################################

--#### Basic SELECT & WHERE (Patient, Doctor, Visit data) ####

--1) List all patient names and their ages.
SELECT first_name, last_name, age 
FROM Patients;

--2) Retrieve all doctors working in the “Cardiology” department.
SELECT * 
FROM Doctors 
WHERE department = 'cardiology';

--3) Show all patients who are older than 60 years.
SELECT * 
FROM Patients 
WHERE age > 60;

--4) Find all visits that happened after January 1, 2024.
SELECT * 
FROM Visits 
WHERE visit_date > '2024-01-01';

--5) Get patient details who live in “Mumbai”.
SELECT * 
FROM Patients 
WHERE city = 'Mumbai';

--6) Show all patients whose gender is “Female”.
SELECT * 
FROM Patients 
WHERE gender = 'F';

--7) Display the names of all doctors whose specialization is “Neurology”.
SELECT * 
FROM Doctors 
WHERE department = 'Neurology';

--8) Retrieve all patients who have NULL phone numbers.
SELECT * 
FROM Patients 
WHERE phone IS NULL;

--9) Find all patients whose age is between 30 and 50.
SELECT * 
FROM Patients 
WHERE age BETWEEN 30 AND 50;

--10) List all doctors whose first name starts with “A”.
SELECT * 
FROM Doctors 
WHERE first_name LIKE 'A%';

--#### DISTINCT & ORDER BY ####

--11) List all unique departments in the hospital.
SELECT DISTINCT department 
FROM Doctors;

--12) Show all unique cities where patients live.
SELECT DISTINCT city 
FROM Patients;

--13) Display all visit dates without duplicates.
SELECT DISTINCT visit_date 
FROM Visits 
WHERE visit_date IS NOT NULL;

--14) Retrieve all medications prescribed, removing duplicates.
SELECT DISTINCT medication_name 
FROM Prescriptions 
WHERE medication_name IS NOT NULL;

--15) List all patient names alphabetically.
SELECT * 
FROM (SELECT CONCAT(first_name, last_name) AS Full_Name FROM Patients) t 
WHERE Full_Name IS NOT NULL  
ORDER BY Full_Name ASC;

--16) Show the top 3 youngest patients.
SELECT TOP 3 * 
FROM Patients 
WHERE age IS NOT NULL 
ORDER BY age ASC;

--17) Display all doctors department with no duplicates.
SELECT DISTINCT department  
FROM Doctors 
WHERE department IS NOT NULL;

--18) List all visits ordered by visit date (most recent first).
SELECT * 
FROM Visits 
WHERE visit_date IS NOT NULL
ORDER BY visit_date DESC;

--19) Show all billing records ordered by amount (descending).
-- (Assuming Billing table exists)
-- SELECT * FROM Billing ORDER BY amount DESC;

--20) Retrieve all patients sorted by city and then by name.
SELECT city, first_name 
FROM Patients 
ORDER BY city ASC, first_name ASC;

--#### Filtering Data (WHERE with AND/OR/IN/LIKE) ####

--21) List all patients from “Delhi” OR “Chennai”.
SELECT * 
FROM Patients 
WHERE city = 'Delhi' OR city = 'Chennai';

--22) Show all patients who are either above 60 OR from “Hyderabad”.
SELECT * 
FROM Patients 
WHERE age > 60 OR city = 'Hyderabad';

--23) Retrieve all doctors who belong to the “Pediatrics” or “Oncology” department.
SELECT * 
FROM Doctors 
WHERE department IN ('Pediatrics', 'Oncology');

--24) Display all patients whose name contains the letter “a”.
SELECT * 
FROM (SELECT LOWER(CONCAT(first_name, last_name)) AS Full_name FROM Patients) t 
WHERE Full_name LIKE '%a%';

--25) Find all visits where the department is NOT “Neurology”.
SELECT * 
FROM Visits 
WHERE department != 'Neurology';

--26) Show all medications prescribed that contain the word “Tab”.
SELECT * 
FROM Prescriptions 
WHERE medication_name LIKE '%Tab%';

--27) Get all billing records where amount > 5000 and payment_status = “Pending”.
-- (Assuming Billing table exists)
-- SELECT * FROM Billing WHERE amount > 5000 AND payment_status = 'Pending';

--28) List all doctors who are from “Cardiology” OR last name ends with Rao.
SELECT * 
FROM Doctors 
WHERE department = 'Cardiology' OR last_name LIKE '%Rao';

--29) Retrieve all patients whose age > 50 AND city = 'Hyderabad'
SELECT * 
FROM Patients 
WHERE age > 50 AND city = 'Hyderabad';

--30) Display all visits that occurred in 2024.
SELECT * 
FROM Visits
WHERE visit_date >= '2024-01-01' AND visit_date < '2025-01-01';

--#### Aggregation & GROUP BY ####

--31) Find the total number of patients.
SELECT COUNT(patient_id) AS Total_number_patients 
FROM Patients;

--32) Count how many visits occurred per department.
SELECT department, COUNT(visit_id) AS Number_of_visits 
FROM Visits 
GROUP BY department;

--33) Show total doctors by each department.
SELECT department, COUNT(doctor_id) AS Total_doctors 
FROM Doctors 
GROUP BY department;

--34) Find the average age of patients per gender.
SELECT gender, AVG(age) AS avg_age
FROM Patients
GROUP BY gender;

--35) Display the number of doctors available per department.
SELECT department, COUNT(doctor_id) AS Total_doctors 
FROM Doctors 
GROUP BY department;

--36) Show total medications prescribed by each doctor.
SELECT v.doctor_id, COUNT(p.medication_name) AS Total_medications
FROM Visits v
LEFT JOIN Prescriptions p
    ON v.visit_id = p.visit_id
GROUP BY v.doctor_id;

--37) Find the minimum and maximum visits per department.
WITH DeptVisitCount AS (
    SELECT department, COUNT(*) AS total_visits
    FROM Visits
    WHERE department IS NOT NULL
    GROUP BY department
)
SELECT MAX(total_visits) AS max_visits, MIN(total_visits) AS min_visits
FROM DeptVisitCount;

--38) Count how many visits each patient made.
SELECT v.patient_id,
       CONCAT(p.first_name, ' ', p.last_name) AS full_name,
       COUNT(v.visit_id) AS total_visits
FROM Visits v
JOIN Patients p
    ON v.patient_id = p.patient_id
GROUP BY v.patient_id, p.first_name, p.last_name
ORDER BY total_visits DESC;

--39) Show total number of male and female patients.
SELECT 
    CASE 
        WHEN gender = 'M' THEN 'Male'
        WHEN gender = 'F' THEN 'Female'
        ELSE 'Unknown'
    END AS Gender_Label,
    COUNT(patient_id) AS Total_Patients
FROM Patients
GROUP BY gender;

--40) Display average patient age per city.
SELECT city, AVG(age) AS avg_age_patient
FROM Patients
WHERE city IS NOT NULL
GROUP BY city;

--41) Show departments where more than 50 visits occurred.
SELECT department, COUNT(visit_id) AS total_visits
FROM Visits
GROUP BY department
HAVING COUNT(visit_id) > 50;

--42) List doctors who have prescribed more than 20 medications.
SELECT d.doctor_id,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       COUNT(p.medication_name) AS total_medications
FROM Visits v
JOIN Doctors d ON v.doctor_id = d.doctor_id
JOIN Prescriptions p ON v.visit_id = p.visit_id
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING COUNT(p.medication_name) > 20
ORDER BY total_medications DESC;

--43) Find cities with more than 2 registered patients.
SELECT city, COUNT(patient_id) AS registered_patients
FROM Patients
GROUP BY city
HAVING COUNT(patient_id) > 1
ORDER BY city;

--44) Show departments where average billing amount exceeds ₹10,000.
-- (Assuming Billing table exists)
-- SELECT department, AVG(amount) AS avg_billing FROM Billing GROUP BY department HAVING AVG(amount) > 10000;

--45) Find doctors who have seen more than 1 unique patients.
SELECT d.doctor_id,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       COUNT(DISTINCT v.patient_id) AS total_unique_patients
FROM Visits v
LEFT JOIN Doctors d
    ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING COUNT(DISTINCT v.patient_id) > 1
ORDER BY total_unique_patients DESC;

--46) List departments with fewer than 2 doctors.
SELECT department, COUNT(doctor_id) AS Total_doctors
FROM Doctors
WHERE department IS NOT NULL
GROUP BY department
HAVING COUNT(doctor_id) < 2
ORDER BY department DESC;

--47) Display patients who have made more than 1 visits.
SELECT v.patient_id,
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       COUNT(v.visit_id) AS total_visits
FROM Visits v
LEFT JOIN Patients p
    ON v.patient_id = p.patient_id
GROUP BY v.patient_id, CONCAT(p.first_name, ' ', p.last_name)
HAVING COUNT(v.visit_id) > 1
ORDER BY total_visits DESC;

--48) Find doctors whose total billed revenue exceeds ₹50,000.
-- (Assuming Billing table exists)
-- SELECT d.doctor_id, CONCAT(d.first_name,' ',d.last_name) AS full_name, SUM(amount) AS total_revenue FROM Billing b JOIN Doctors d ON b.doctor_id = d.doctor_id GROUP BY d.doctor_id, d.first_name,d.last_name HAVING SUM(amount) > 50000;

--49) Show departments having the highest number of prescriptions.
SELECT TOP 1 v.department, COUNT(p.prescription_id) AS total_number_prescriptions
FROM Visits v
LEFT JOIN Prescriptions p
    ON v.visit_id = p.visit_id
WHERE v.department IS NOT NULL
GROUP BY v.department
ORDER BY COUNT(p.prescription_id) DESC;

--50) Display cities with the least number of patients.
SELECT TOP 2 city, COUNT(patient_id) AS Total_patients 
FROM Patients
WHERE city IS NOT NULL
GROUP BY city
ORDER BY COUNT(patient_id) ASC;

--51) List the top 5 departments with the highest number of visits.
SELECT TOP 5 department, COUNT(visit_id) AS total_visits
FROM Visits
WHERE department IS NOT NULL
GROUP BY department
ORDER BY COUNT(visit_id) DESC;

--52) Show the top 3 doctors with the most prescriptions.
SELECT TOP 3 d.doctor_id,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       COUNT(p.prescription_id) AS total_prescriptions
FROM Visits v
LEFT JOIN Prescriptions p ON v.visit_id = p.visit_id
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE p.prescription_id IS NOT NULL
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY COUNT(p.prescription_id) DESC;

--53) Find the top 3 patients with the most hospital visits.
SELECT TOP 3 p.patient_id,
       CONCAT(p.first_name,' ',p.last_name) AS full_name,
       COUNT(v.visit_id) AS Total_visits 
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
GROUP BY p.patient_id, CONCAT(p.first_name,' ',p.last_name)
ORDER BY COUNT(v.visit_id) DESC;

--54) Display the top 3 medications prescribed by frequency.
SELECT TOP 3 medication_name,
       COUNT(*) AS total_times_prescribed
FROM Prescriptions
WHERE medication_name IS NOT NULL
GROUP BY medication_name
ORDER BY COUNT(*) DESC;

--55) Show the 3 cities with the highest patient count.
SELECT TOP 3 city,
       COUNT(patient_id) AS total_patients 
FROM Patients
WHERE city IS NOT NULL 
GROUP BY city
ORDER BY COUNT(patient_id) DESC;

--56) Find the top 5 billing records with the largest amount.
-- (Assuming Billing table exists)
-- SELECT TOP 5 * FROM Billing ORDER BY amount DESC;

--57) Retrieve top 5 departments with the highest total revenue.
-- (Assuming Billing table exists)
-- SELECT TOP 5 department, SUM(amount) AS total_revenue FROM Billing GROUP BY department ORDER BY SUM(amount) DESC;

--58) List the bottom 3 departments by number of visits.
SELECT TOP 3 department, COUNT(visit_id) AS Total_visits 
FROM Visits
WHERE department IS NOT NULL 
GROUP BY department 
ORDER BY COUNT(visit_id) ASC;

--59) Find the top 3 doctors whose patients are mostly above age 50.
SELECT TOP 3 v.doctor_id,
       CONCAT(d.first_name, ' ', d.last_name) AS Doctor_FullName,
       COUNT(*) AS total_patients_above50
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE p.age > 50
GROUP BY v.doctor_id, d.first_name, d.last_name
ORDER BY COUNT(*) DESC;

--60) Show percentage of a doctor’s patients above 50.
SELECT TOP 3 v.doctor_id,
       CONCAT(d.first_name, ' ', d.last_name) AS Doctor_FullName,
       COUNT(CASE WHEN p.age > 50 THEN 1 END) * 100.0 / COUNT(*) AS percent_above_50
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
GROUP BY v.doctor_id, d.first_name, d.last_name
ORDER BY percent_above_50 DESC;

--#### Multi-Column Aggregations & Filtering ####

--61) Show department-wise and gender-wise patient counts.
-- Correct approach using CASE WHEN inside aggregation
SELECT 
    v.department,
    SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END) AS female_count,
    SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) AS male_count
FROM Visits v
JOIN Patients p
    ON v.patient_id = p.patient_id
WHERE v.department IS NOT NULL
GROUP BY v.department;

--62) Find the average billing amount per department and per payment_status.
-- Assuming a Billing table exists
-- SELECT department, payment_status, AVG(amount) AS avg_billing
-- FROM Billing
-- GROUP BY department, payment_status;

--63) Display each doctor’s department and number of unique patients treated.
SELECT 
    v.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS Doctor_FullName,
    d.department, 
    COUNT(DISTINCT v.patient_id) AS Total_unique_patients 
FROM Visits v
LEFT JOIN Doctors d
    ON v.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL
GROUP BY v.doctor_id, d.department, d.first_name, d.last_name;

--64) Count the number of medications prescribed per doctor per department.
SELECT  
    v.doctor_id,
    v.department, 
    COUNT(p.prescription_id) AS total_prescribed
FROM Visits v
LEFT JOIN Prescriptions p
    ON v.visit_id = p.visit_id
WHERE v.department IS NOT NULL
GROUP BY v.doctor_id, v.department;

--65) Show city-wise and gender-wise patient distribution.

-- a) City-wise patient count
SELECT city, COUNT(patient_id) AS total_patients 
FROM Patients 
WHERE city IS NOT NULL
GROUP BY city
ORDER BY COUNT(patient_id) DESC;

-- b) Gender-wise patient count
SELECT gender, COUNT(patient_id) AS total_patients 
FROM Patients 
WHERE gender IS NOT NULL
GROUP BY gender
ORDER BY COUNT(patient_id) DESC;

-- c) Combined city & gender-wise patient distribution
SELECT 
    city,
    gender,
    COUNT(patient_id) AS total_patients
FROM Patients
WHERE city IS NOT NULL AND gender IS NOT NULL
GROUP BY city, gender
ORDER BY city, gender;

--66) Find the total billing amount per doctor per month.
-- Assuming a Billing table exists
-- SELECT doctor_id, YEAR(billing_date) AS year, MONTH(billing_date) AS month, SUM(amount) AS total_billing
-- FROM Billing
-- GROUP BY doctor_id, YEAR(billing_date), MONTH(billing_date);

--67) Show department-wise total visits.
SELECT department, COUNT(visit_id) AS total_visits 
FROM Visits 
WHERE department IS NOT NULL 
GROUP BY department;

--68) Display number of visits per patient.
SELECT patient_id, COUNT(visit_id) AS total_visits
FROM Visits
GROUP BY patient_id
ORDER BY total_visits DESC;

--69) Find total number of prescriptions given in each city by each department.
SELECT  
    p.city,
    v.department,
    COUNT(s.prescription_id) AS total_prescriptions
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
LEFT JOIN Prescriptions s ON v.visit_id = s.visit_id
WHERE v.department IS NOT NULL AND p.city IS NOT NULL
GROUP BY p.city, v.department
ORDER BY COUNT(s.prescription_id) DESC;

--70) Show top doctor per department by total patient visits.
SELECT TOP 1 
    v.doctor_id,
    v.department,
    COUNT(v.visit_id) AS Total_visits,
    CONCAT(d.first_name, ' ', d.last_name) AS Full_name 
FROM Visits v 
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE v.department IS NOT NULL
GROUP BY v.doctor_id, v.department, d.first_name, d.last_name
ORDER BY COUNT(v.visit_id) DESC;

