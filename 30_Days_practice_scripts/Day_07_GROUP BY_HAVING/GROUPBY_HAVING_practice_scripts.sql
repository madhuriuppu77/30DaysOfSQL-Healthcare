------- GROUP BY + HAVING SQL QUESTIONS (Healthcare Domain)-

--1. Count how many patients exist in each city.
SELECT * FROM Patients

SELECT city, COUNT(patient_id) AS Total_patients_percity FROM Patients
WHERE city IS NOT NULL
GROUP BY city
ORDER BY Total_patients_percity DESC ;

--2. Show number of male and female patients in the system.
SELECT 
gender,
COUNT(patient_id) AS Total_number_patients
FROM patients
GROUP BY gender

--3. Group patients by age and count how many people share the same age.
SELECT * FROM patients
SELECT age, COUNT(*) AS total_patients
FROM patients
WHERE age IS NOT NULL
GROUP BY age;

--4. Find cities having more than 2 patients.
SELECT 
city,
COUNT(patient_id) AS Total_patients_per_city
FROM Patients
WHERE city IS NOT NULL
GROUP BY city
HAVING COUNT(patient_id) >= 2;

--5. Show doctor count in each department.
SELECT department, COUNT(doctor_id) AS Total_doctors_per_department FROM Doctors
WHERE department IS NOT NULL
GROUP BY department;

--6. Display departments that have at least 2 doctors.
SELECT department, COUNT(doctor_id) AS Total_doctors_per_department FROM Doctors
WHERE department IS NOT NULL
GROUP BY department
HAVING COUNT(doctor_id) > 2;

--7. Count visits per patient.
SELECT 
patient_id,
COUNT(visit_id) AS Total_visits_per_pateint
FROM Visits
GROUP BY patient_id
ORDER BY COUNT(visit_id) DESC;

--8. Return only patients who have more than 2 total visits.
SELECT 
patient_id,
COUNT(visit_id) AS Total_visits_per_pateint
FROM Visits
GROUP BY patient_id
HAVING COUNT(visit_id) > 2

--9. Count visits per doctor.
SELECT 
doctor_id,
COUNT(visit_id) AS Total_visits_per_doctor
FROM visits 
GROUP BY doctor_id

--10. Show doctors who handled at least 2 visits.
SELECT 
doctor_id,
COUNT(visit_id) AS Total_visits_per_doctor
FROM visits 
GROUP BY doctor_id
HAVING COUNT(visit_id) >= 2;

--11. Count how many prescriptions each medication has.
SELECT 
medication_name,
COUNT(prescription_id) AS Total_prescriptions_each_medication
FROM prescriptions
WHERE medication_name IS NOT NULL
GROUP BY medication_name;

--12. Show medications prescribed more than 5 times.
SELECT 
medication_name,
COUNT(prescription_id) AS Total_prescriptions_each_medication
FROM prescriptions
WHERE medication_name IS NOT NULL
GROUP BY medication_name
HAVING COUNT(prescription_id)> 5;

--13. Count visits per diagnosis.
SELECT 
diagnosis,
COUNT(visit_id) AS Total_visits_perdiagnosis
FROM Visits
WHERE diagnosis IS NOT NULL
GROUP BY diagnosis

--14. Return only diagnoses that appear more than once.
SELECT 
diagnosis,
COUNT(visit_id) AS Total_visits_perdiagnosis
FROM Visits
WHERE diagnosis IS NOT NULL
GROUP BY diagnosis
HAVING COUNT(visit_id) > 1; 

--15. Show each department and count how many visits belong to each.
SELECT 
department,
COUNT(visit_id) AS Total_visits_per_department
FROM Visits
WHERE department IS NOT NULL
GROUP BY department;

--16. Show departments having more than 3 visits.
SELECT 
department,
COUNT(visit_id) AS Total_visits_per_department
FROM Visits
WHERE department IS NOT NULL
GROUP BY department
HAVING COUNT(visit_id) > 3;

--17. Group patients by gender and show avg age.
SELECT 
gender,
AVG(age) AS Avg_age_per_gender
FROM patients
WHERE age IS NOT NULL
GROUP BY gender;

--18. Return genders where avg age is above 40.
SELECT 
gender,
AVG(age) AS Avg_age_per_gender
FROM patients
WHERE age IS NOT NULL
GROUP BY gender
HAVING AVG(age) > 40;

--19. Show each city and the minimum patient age.
SELECT
city,
MIN(age) AS minimum_patient_age
FROM patients
WHERE age IS NOT NULL AND city IS NOT NULL
GROUP BY city;

--20. Show cities where minimum age is below 20.
SELECT
city,
MIN(age) AS minimum_patient_age
FROM patients
WHERE age IS NOT NULL AND city IS NOT NULL
GROUP BY city
HAVING MIN(age) < 20;

--21. Show each medication and maximum dosage length.
SELECT 
medication_name,
MAX(dosage) AS max_dosage_length
FROM prescriptions
WHERE medication_name IS NOT NULL AND dosage IS NOT NULL
GROUP BY medication_name;
 -- CORRECT QUERY IS ABOVE ONE WRONG
 SELECT 
    medication_name,
    MAX(LEN(dosage)) AS max_dosage_length
FROM prescriptions
WHERE medication_name IS NOT NULL 
  AND dosage IS NOT NULL
GROUP BY medication_name;

--22. Return medications where dosage length exceeds 3 characters.
SELECT 
medication_name,
len(MAX(dosage)) AS max_dosage_length
FROM prescriptions
WHERE medication_name IS NOT NULL AND dosage IS NOT NULL
GROUP BY medication_name
HAVING len(MAX(dosage)) > 3;

--CORRECT QUERY IS 
SELECT 
    medication_name,
    MAX(LEN(dosage)) AS max_dosage_length
FROM prescriptions
WHERE medication_name IS NOT NULL 
  AND dosage IS NOT NULL
GROUP BY medication_name
HAVING MAX(LEN(dosage)) > 3;


--23. Count total number of prescriptions per visit.
SELECT 
visit_id,
COUNT(prescription_id) AS Total_prescriptions_per_visit
FROM Prescriptions
GROUP BY visit_id;

--24. Show visits that have at least 2 prescriptions.
SELECT 
visit_id,
COUNT(prescription_id) AS Total_prescriptions_per_visit
FROM Prescriptions
GROUP BY visit_id
HAVING COUNT(prescription_id) >= 2;

--25. Count patients grouped by the first letter of their city name.
SELECT 
    LEFT(city, 1) AS First_Letter,
    COUNT(patient_id) AS Total_patients
FROM patients
WHERE city IS NOT NULL
GROUP BY LEFT(city, 1)
ORDER BY First_Letter;
/* EXplanation:
xplanation (simple)

LEFT(city,1) → Extracts first letter of the city

GROUP BY LEFT(city,1) → Groups by that letter

Then count how many patients belong to each letter group

Example:

If cities are:
Hyderabad
Delhi
Dubai
Chennai
First letters are:
H
D
D
C */

--26. Show first letters having more than 1 patient.
 SELECT 
 LEFT(first_name, 1) AS first_letter_firstname,
 COUNT(patient_id) AS Total_patients
 FROM patients
 GROUP BY LEFT(first_name, 1)
 HAVING COUNT(patient_id) > 1;
 --CORRECT QUERY IS 

 SELECT 
    LEFT(first_name, 1) AS first_letter_firstname,
    COUNT(*) AS Total_patients
FROM patients
GROUP BY LEFT(first_name, 1)
HAVING COUNT(*) > 1;


--27. Count doctors grouped by the first letter of their last name.
SELECT 
LEFT(last_name, 1) AS first_letter_of_doc_lastname,
COUNT(doctor_id) AS Total_doctors
FROM Doctors
GROUP BY LEFT(last_name, 1)
ORDER BY COUNT(doctor_id) DESC;

--28. Show letters that have at least 3 doctors.
SELECT 
LEFT(first_name, 1) AS first_letter_of_doc_lastname,
COUNT(doctor_id) AS Total_doctors
FROM Doctors
GROUP BY LEFT(first_name, 1)-- WRONG QUERY 
HAVING COUNT(doctor_id) >= 3;
-- CORRECT QUERY IS BELOW
SELECT 
    LEFT(last_name, 1) AS first_letter_of_doc_lastname,
    COUNT(doctor_id) AS Total_doctors
FROM Doctors
GROUP BY LEFT(last_name, 1)
HAVING COUNT(doctor_id) >= 3;


--29. Show total visits per month.

SELECT 
MONTH(visit_date) AS per_month,
COUNT(visit_id) AS Total_visits
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY MONTH(visit_date)
ORDER BY COUNT(visit_id) DESC;

--30. Show months with more than 2 visits.
SELECT 
MONTH(visit_date) AS per_month,
COUNT(visit_id) AS Total_visits
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY MONTH(visit_date)
HAVING COUNT(visit_id) > 2;

--31. Show highest age per gender.
SELECT 
gender,
MAX(age) AS highest_age
FROM patients
WHERE age IS NOT NULL
group by gender

--32. Show genders where max age exceeds 60.
SELECT 
gender,
MAX(age) AS highest_age
FROM patients
WHERE age IS NOT NULL
group by gender
HAVING MAX(age) > 60;

--33. Count diagnoses grouped by length of diagnosis text.
SELECT 
    LEN(diagnosis) AS diagnosis_length,
    COUNT(diagnosis) AS total_diagnoses
FROM visits
WHERE diagnosis IS NOT NULL
GROUP BY LEN(diagnosis)
ORDER BY COUNT(diagnosis) DESC;



--34. Show diagnosis lengths with more than 2 visits.
SELECT 
LEN(diagnosis) AS length_of_chardaig,
COUNT(visit_id) AS Total_visits_per_daichar
FROM visits
WHERE diagnosis IS NOT NULL
GROUP BY LEN(diagnosis)
HAVING COUNT(visit_id) > 2;

--35. Show average age per city.
SELECT 
city,
AVG( age) AS avg_age_percity
FROM patients
WHERE age IS NOT NULL AND city IS NOT NULL
GROUP BY city;

--36. Show cities where average age is above 35.
SELECT 
city,
AVG( age) AS avg_age_percity
FROM patients
WHERE age IS NOT NULL AND city IS NOT NULL
GROUP BY city
HAVING AVG( age) > 35;

--37. Group medications by last character of their name.
SELECT 
RIGHT(medication_name, 1) AS last_char,
COUNT(medication_name) AS toatl_medication
FROM Prescriptions
WHERE medication_name IS NOT NULL
GROUP BY RIGHT(medication_name, 1);

--38. Show last characters with more than 2 medications.
SELECT 
RIGHT(medication_name, 1) AS last_char,
COUNT(medication_name) AS toatl_medication
FROM Prescriptions
WHERE medication_name IS NOT NULL
GROUP BY RIGHT(medication_name, 1)
HAVING COUNT(medication_name) > 2;

--39. Count visits per doctor, grouping by doctor_id.
SELECT
doctor_id,
COUNT(visit_id) AS toatl_visits
FROM Visits
GROUP BY doctor_id;

--40. Show doctor_ids whose visit count is below 3.
SELECT
doctor_id,
COUNT(visit_id) AS toatl_visits
FROM Visits
GROUP BY doctor_id
HAVING COUNT(visit_id) < 3;

--41. Show prescriptions grouped by dosage.
SELECT 
dosage,
COUNT( prescription_id) AS Total_prescritpion
FROM Prescriptions
WHERE dosage IS NOT NULL
GROUP BY dosage;

--42. Show dosage values used more than 1 times.
SELECT 
dosage,
COUNT( prescription_id) AS Total_prescritpion
FROM Prescriptions
WHERE dosage IS NOT NULL
GROUP BY dosage
HAVING COUNT( prescription_id) > 1;

--43. Count patients by city, ignoring NULL cities.
SELECT
city,
COUNT(patient_id) AS total_patients_percity
FROM Patients
WHERE city IS NOT NULL
GROUP BY city;

--44. Show cities where patient count is above 1.
SELECT
city,
COUNT(patient_id) AS total_patients_percity
FROM Patients
WHERE city IS NOT NULL
GROUP BY city
HAVING COUNT(patient_id)> 1;

--45. Group patients by gender and show count of NULL phone numbers.
SELECT 
gender,
COUNT(patient_id) AS  total_patients
FROM patients
WHERE phone IS NULL
GROUP BY gender
--46. Show gender groups having at least 1 NULL phone.
SELECT 
gender,
COUNT(patient_id) AS  total_patients
FROM patients
WHERE phone IS NULL
GROUP BY gender
HAVING COUNT(patient_id) >= 1;

--47. Group doctors by department and show avg doctor_id.
SELECT
department,
AVG(doctor_id) AS avg_doc_id
FROM Doctors
WHERE department IS NOT NULL
GROUP BY department;

--48. Show departments where avg doctor_id > 3.
SELECT
department,
AVG(doctor_id) AS avg_doc_id
FROM Doctors
WHERE department IS NOT NULL
GROUP BY department
HAVING AVG(doctor_id)> 3;

--49. Group visits by patient_id and show earliest visit date.
SELECT 
patient_id,
MIN(visit_date) AS maximum_visit_date
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY patient_id;


--50. Show patient_ids whose earliest visit is after '2024-01-01'.
SELECT 
patient_id,
MIN(visit_date) AS maximum_visit_date
FROM Visits
WHERE visit_date IS NOT NULL
GROUP BY patient_id
HAVING MIN(visit_date) > '2024-01-01';

/* What Are MIN and MAX in SQL?
Think of MIN and MAX as tools that help you find:

MIN → the smallest value
MAX → the biggest value

They work on numbers, dates, text (alphabetically), and more.
*/
--51. Count prescriptions grouped by first letter of medication.
SELECT
LEFT(medication_name,1) AS first_letter_of_medication_name,
COUNT(prescription_id) AS Total_prescriptions
FROM Prescriptions
WHERE medication_name IS NOT NULL
GROUP BY LEFT(medication_name,1);

--52. Show letters where count > 2.
SELECT
LEFT(medication_name,1) AS first_letter_of_medication_name,
COUNT(prescription_id) AS Total_prescriptions
FROM Prescriptions
WHERE medication_name IS NOT NULL
GROUP BY LEFT(medication_name,1)
HAVING COUNT(prescription_id) > 2;

--53. Count patients grouped by age bracket (age/10).
/*
What does “Count patients grouped by age bracket (age/10)” mean?
We are dividing ages into groups of 10 years.
This is called age brackets.
| Age | Age Bracket (age/10) |
| --- | -------------------- |
| 5   | 0 (0–9)              |
| 12  | 1 (10–19)            |
| 18  | 1 (10–19)            |
| 25  | 2 (20–29)            |
| 37  | 3 (30–39)            |
| 45  | 4 (40–49)            |
| 58  | 5 (50–59)            |
We take age / 10, and SQL uses the integer result (but we must FLOOR it).

So:

Ages 0–9 → bracket = 0
Ages 10–19 → bracket = 1
Ages 20–29 → bracket = 2
Ages 30–39 → bracket = 3
Ages 40–49 → bracket = 4
Ages 50–59 → bracket = 5
This helps you count how many people fall into each age range.
*/
SELECT 
    FLOOR(age / 10) AS age_bracket,
    COUNT(patient_id) AS total_patients
FROM patients
WHERE age IS NOT NULL
GROUP BY FLOOR(age / 10)
ORDER BY age_bracket;


--54. Show brackets having > 1 patients.
SELECT 
    FLOOR(age / 10) AS age_bracket,
    COUNT(patient_id) AS total_patients
FROM patients
WHERE age IS NOT NULL
GROUP BY FLOOR(age / 10)
HAVING COUNT(patient_id) > 1
ORDER BY age_bracket;

--55. Show diagnosis categories grouped by first two letters.
SELECT 
LEFT(diagnosis, 2) AS two_first_char_of_diagnosis,
COUNT(visit_id) AS total_visits
FROM Visits
WHERE diagnosis IS NOT NULL
GROUP BY LEFT(diagnosis, 2); 
--56. Show categories with at least 2 visits.
SELECT 
LEFT(diagnosis, 2) AS two_first_char_of_diagnosis,
COUNT(visit_id) AS total_visits
FROM Visits
WHERE diagnosis IS NOT NULL
GROUP BY LEFT(diagnosis, 2)
HAVING COUNT(visit_id)>= 2;

--57. Count doctors where department is NULL grouped by first_name 1st char
SELECT
LEFT (first_name, 1) AS doc_firstchar,
COUNT(*) AS doc_null
FROM Doctors
WHERE department IS NULL
GROUP BY LEFT (first_name, 1);

--58. Show groups with count < 1.
SELECT
LEFT (first_name, 1) AS doc_firstchar,
COUNT(*) AS doc_null
FROM Doctors
WHERE department IS NULL -- WRONG QUERY
GROUP BY LEFT (first_name, 1)
HAVING COUNT(*) < 1;

-- CORRECT QUERY
--58. Show groups with exactly 1 doctor having NULL department.
SELECT
    LEFT(first_name, 1) AS doc_firstchar,
    COUNT(*) AS doc_null
FROM Doctors
WHERE department IS NULL
GROUP BY LEFT(first_name, 1)
HAVING COUNT(*) = 1;

--59. Count visits grouped by year of visit_date.
SELECT
YEAR(visit_date) AS visit_year,
COUNT(visit_id) AS total_visits
FROM visits
WHERE visit_date IS NOT NULL
GROUP BY YEAR(visit_date);

--60. Show years with more visits than 5.
SELECT
YEAR(visit_date) AS visit_year,
COUNT(visit_id) AS total_visits
FROM visits
WHERE visit_date IS NOT NULL
GROUP BY YEAR(visit_date)
HAVING COUNT(visit_id) > 5;

--61. Count prescriptions grouped by visit_id where dosage IS NOT NULL.
SELECT
visit_id,
COUNT(prescription_id) AS Total_prescription
FROM Prescriptions
WHERE dosage IS NOT NULL
GROUP BY visit_id;

--62. Show visit_ids where such prescriptions exceed 1.
SELECT
visit_id,
COUNT(prescription_id) AS Total_prescription
FROM Prescriptions
WHERE dosage IS NOT NULL
GROUP BY visit_id
HAVING COUNT(prescription_id) > 1;

--63. Count patients grouped by first_name length.
SELECT
LEN(first_name) AS total_length_firstname,
COUNT(patient_id) AS total_patients
FROM patients
GROUP BY LEN(first_name);

--64. Show name lengths having more than 2 patients.
SELECT
LEN(first_name) AS total_length_firstname,
COUNT(patient_id) AS total_patients
FROM patients
GROUP BY LEN(first_name)
HAVING COUNT(patient_id) > 2;

--65. Show visits grouped by doctor_id and count only NULL diagnoses.
SELECT 
doctor_id,
COUNT(*) AS Total_null_diagnosis
FROM Visits
WHERE diagnosis IS NULL
GROUP BY doctor_id;

--66. Show doctor_ids having at least 1 NULL diagnosis.
SELECT 
doctor_id,
COUNT(*) AS Total_null_diagnosis
FROM Visits
WHERE diagnosis IS NULL
GROUP BY doctor_id
HAVING COUNT(*)>= 1;

--67. Group cities by last letter and count patients.
SELECT
RIGHT(city,1) AS city_last_letter,
COUNT(patient_id) AS total_patients
FROM Patients
WHERE city IS NOT NULL
GROUP BY RIGHT(city,1);

--68. Show letters with more than 1 city entry.
SELECT
RIGHT(city,1) AS city_last_letter,
COUNT(patient_id) AS total_patients
FROM Patients
WHERE city IS NOT NULL
GROUP BY RIGHT(city,1)
HAVING COUNT(patient_id)> 1;

--69. Group prescriptions by medication_name and show the shortest dosage.
SELECT
medication_name,
MIN(dosage) AS shortest_dosage
FROM Prescriptions
WHERE medication_name IS NOT NULL AND dosage IS NOT NULL
GROUP BY medication_name;


--70. Show medications whose shortest dosage is exactly '50mg'.
SELECT
medication_name,
MIN(dosage) AS shortest_dosage
FROM Prescriptions
WHERE medication_name IS NOT NULL AND dosage IS NOT NULL
GROUP BY medication_name
HAVING MIN(dosage) = '50mg';
