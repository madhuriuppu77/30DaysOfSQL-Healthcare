-- Advanced 30 DQL Practice Questions — Combined Concepts
--  Realistic, Analytical, Multi-Concept Scenarios

--1) Top 5 cities with the highest number of patients who visited in the last 6 months
SELECT TOP 5
    p.city,
    COUNT(DISTINCT v.patient_id) AS total_patients
FROM Visits v
JOIN Patients p
    ON v.patient_id = p.patient_id
WHERE p.city IS NOT NULL
  AND v.visit_date >= DATEADD(MONTH, -6, GETDATE())  -- last 6 months
GROUP BY p.city
ORDER BY total_patients DESC;

--2) Departments with more than 2 visits AND average patient age > 40
SELECT 
    v.department,
    COUNT(v.visit_id) AS total_visits,
    AVG(p.age) AS avg_patient_age
FROM Visits v
LEFT JOIN Patients p
    ON v.patient_id = p.patient_id
WHERE v.department IS NOT NULL
GROUP BY v.department
HAVING COUNT(v.visit_id) > 2
   AND AVG(p.age) > 40
ORDER BY total_visits DESC;

--3) Top 2 doctors who have treated the most unique patients
SELECT TOP 2
    d.doctor_id,
    CONCAT(d.first_name,' ',d.last_name) AS Doctor_Full_name,
    COUNT(DISTINCT p.patient_id) AS total_unique_patients 
FROM Visits v 
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
LEFT JOIN Patients p ON v.patient_id = p.patient_id
GROUP BY d.doctor_id,
         CONCAT(d.first_name,' ',d.last_name) 
ORDER BY COUNT(DISTINCT p.patient_id) DESC;

--4) Departments with more than 2 total visits
SELECT department,
       COUNT(visit_id) AS total_visits 
FROM Visits
WHERE department IS NOT NULL
GROUP BY department
HAVING COUNT(visit_id) > 2;

--5) Doctors’ department and total prescriptions (>=2 prescriptions)
SELECT 
    v.doctor_id, 
    CONCAT(d.first_name,' ',last_name) AS Full_name, 
    v.department,
    COUNT(p.prescription_id) AS total_prescription_count
FROM Visits v 
LEFT JOIN Prescriptions p ON v.visit_id = p.visit_id
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE v.department IS NOT NULL 
GROUP BY v.department,
         v.doctor_id, 
         CONCAT(d.first_name,' ',last_name)
HAVING COUNT(p.prescription_id) >= 2;

--6) Patients aged 40-70 who visited Cardiology or Orthopedics in 2024
SELECT DISTINCT
    v.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    p.age,
    v.department,
    v.visit_date
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
WHERE p.age BETWEEN 40 AND 70
  AND v.department IN ('Cardiology', 'Orthopedics')
  AND YEAR(v.visit_date) = 2024;

--7) Department-wise patient count and average patient age
SELECT v.department,
       COUNT(v.patient_id) AS total_patient_count,
       AVG(p.age) AS avg_age_patient
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
WHERE v.department IS NOT NULL
GROUP BY v.department;

--8) Top medication prescribed in Cardiology with total count
SELECT TOP 1
    p.medication_name,
    COUNT(p.prescription_id) AS total_prescribed
FROM Visits v
LEFT JOIN Prescriptions p ON v.visit_id = p.visit_id
WHERE v.department = 'Cardiology'
  AND p.medication_name IS NOT NULL
GROUP BY p.medication_name
ORDER BY COUNT(p.prescription_id) DESC;

--9) Each city’s number of male and female patients
SELECT city, 
       gender,
       COUNT(patient_id) AS total_patients
FROM Patients 
WHERE city IS NOT NULL 
GROUP BY city, gender;

--10) Doctors who treated at least 2 patients from different cities
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS Doctor_Fullname,
    COUNT(DISTINCT p.city) AS unique_cities_treated
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE p.city IS NOT NULL
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING COUNT(DISTINCT p.city) >= 2;

--11) Top 3 patients by city
SELECT TOP 3 
    city,
    COUNT(patient_id) AS total_patients_count
FROM Patients
WHERE city IS NOT NULL
GROUP BY city
ORDER BY COUNT(patient_id) DESC;

--12) Departments with >=2 doctors and >=2 total visits
SELECT 
    v.department,
    COUNT(DISTINCT v.doctor_id) AS Total_doctors,
    COUNT(v.visit_id) AS Total_visits
FROM Visits v
WHERE v.department IS NOT NULL
GROUP BY v.department
HAVING COUNT(DISTINCT v.doctor_id) >= 2
   AND COUNT(v.visit_id) >= 2;

--13) Doctors whose patients’ average age > 60
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS Doctor_FullName,
    AVG(p.age) AS avg_patient_age
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE p.age IS NOT NULL
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING AVG(p.age) > 60;

--14) Patients who visited more than once, sorted by total visits
SELECT v.patient_id,
       CONCAT(p.first_name,' ',p.last_name) AS Full_name, 
       COUNT(v.visit_id) AS total_visits 
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
GROUP BY v.patient_id, p.first_name, p.last_name
HAVING COUNT(v.visit_id) > 1
ORDER BY COUNT(v.visit_id) DESC;

--15) Top 3 cities generating highest total visits
SELECT TOP 3 
    p.city, 
    COUNT(v.visit_id) AS total_visits 
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
WHERE p.city IS NOT NULL
GROUP BY p.city
ORDER BY COUNT(v.visit_id) DESC;

--16) Doctors who prescribed >=1 unique medications in >=1 department
SELECT 
    v.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_full_name,
    COUNT(DISTINCT p.medication_name) AS unique_medications,
    COUNT(DISTINCT v.department) AS unique_departments
FROM Visits v
JOIN Prescriptions p ON v.visit_id = p.visit_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE v.department IS NOT NULL 
  AND p.medication_name IS NOT NULL
GROUP BY v.doctor_id, d.first_name, d.last_name
HAVING COUNT(DISTINCT p.medication_name) >= 1
   AND COUNT(DISTINCT v.department) >= 1;

--17) Patients older than average age
SELECT 
    patient_id,
    CONCAT(first_name, ' ', last_name) AS Full_name,
    age
FROM Patients
WHERE age > (
    SELECT AVG(age)
    FROM Patients
    WHERE age IS NOT NULL
);

--18) Department with highest and lowest visits
SELECT 
    MAX(total_visits) AS Highest_Visits,
    MIN(total_visits) AS Lowest_Visits
FROM (
    SELECT department, COUNT(visit_id) AS total_visits
    FROM Visits
    WHERE department IS NOT NULL
    GROUP BY department
) AS summary;

--21) Departments where female patients > male patients
SELECT 
    v.department,
    SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END) AS female_count,
    SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) AS male_count
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
WHERE v.department IS NOT NULL
GROUP BY v.department
HAVING SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END) > 
       SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END);

--22) Each doctor’s most recent patient visit date
SELECT d.doctor_id,
       CONCAT(d.First_name,' ',d.last_name) AS Full_doctor_name,
       MAX(v.visit_date) AS most_recent_visit
FROM Visits v
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.First_name, d.last_name;

--23) Patients who visited more than once and age < 50
SELECT * 
FROM (
    SELECT p.patient_id,
           CONCAT(p.first_name,' ',p.last_name) AS Full_name,
           p.age,
           COUNT(v.visit_id) AS total_visits
    FROM Visits v
    LEFT JOIN Patients p ON v.patient_id = p.patient_id
    GROUP BY p.patient_id, p.age, p.first_name, p.last_name
    HAVING COUNT(v.visit_id) > 1
) t
WHERE age < 50;

--24) City-wise total number of visits
SELECT p.city,
       COUNT(v.visit_id) AS total_visits
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
WHERE p.city IS NOT NULL
GROUP BY p.city
ORDER BY COUNT(v.visit_id) DESC;

--25) Top 2 departments with most unique patients
SELECT TOP 2 
    department,
    COUNT(DISTINCT patient_id) AS distinct_patient_count
FROM Visits
WHERE department IS NOT NULL
GROUP BY department
ORDER BY COUNT(DISTINCT patient_id) DESC;

--26) Doctors who never treated patients from “Delhi”
SELECT d.doctor_id, 
       CONCAT(d.first_name,' ',d.last_name) AS Full_name
FROM Visits v
JOIN Doctors d ON v.doctor_id = d.doctor_id
JOIN Patients p ON v.patient_id = p.patient_id
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING SUM(CASE WHEN p.city = 'Delhi' THEN 1 ELSE 0 END) = 0;

--27) Patients who visited both “Cardiology” and “Neurology”
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS Full_name
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
WHERE v.department IN ('Cardiology', 'Neurology')
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(DISTINCT v.department) = 2;

--28) Departments where average age of patients > 45
SELECT v.department,
       AVG(age) AS avg_age_patient
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
WHERE department IS NOT NULL 
  AND age IS NOT NULL
GROUP BY v.department
HAVING AVG(age) > 45;

--29) Each doctor’s total visits, total patients, and average patient age
SELECT d.doctor_id,
       CONCAT(d.first_name,' ',d.last_name) AS Full_doctor_name,
       COUNT(v.visit_id) AS Total_visits,
       COUNT(DISTINCT p.patient_id) AS total_patients,
       AVG(age) AS avg_age_patient
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE age IS NOT NULL
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY COUNT(v.visit_id) DESC;

--30) Top 3 patients with highest visits
SELECT TOP 3 
    p.patient_id,
    CONCAT(p.first_name,' ',p.last_name) AS Full_name, 
    COUNT(v.visit_id) AS total_visits
FROM Visits v
LEFT JOIN Patients p ON v.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY COUNT(v.visit_id) DESC;
