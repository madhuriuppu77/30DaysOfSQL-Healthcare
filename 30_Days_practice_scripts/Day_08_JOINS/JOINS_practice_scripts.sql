-------------------------------------
--  INNER JOIN QUESTIONS (1–10)
-------------------------------------

--1. List all visits with patient names using INNER JOIN.
SELECT v.*,p.first_name,p.last_name FROM
visits v
INNER JOIN Patients p
ON v.patient_id = p.patient_id;

--2. Show visit details along with doctor first_name using INNER JOIN.
SELECT v.*,d.first_name FROM
visits v
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id;

--3. Display prescriptions with corresponding patient names.

SELECT pr.*, CONCAT(pt.first_name,' ',pt.last_name) AS full_name
FROM Prescriptions pr
INNER JOIN Visits v
  ON pr.visit_id = v.visit_id
INNER JOIN Patients pt
  ON v.patient_id = pt.patient_id;


--4. Show prescriptions with doctor names.
SELECT p.*, CONCAT (d.first_name,' ',d.last_name) AS Full_name  FROM Visits v
INNER JOIN Prescriptions p
ON v.visit_id = p.visit_id
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id;

--5. List all visits with patient and doctor names together.
SELECT v.*, CONCAT (d.first_name,' ',d.last_name) AS Doctors_Full_name,
CONCAT (p.first_name,' ',p.last_name) AS Patients_Full_name
FROM Visits v
INNER JOIN Patients p
ON v.patient_id = p.patient_id
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id;

--6. Show only visits where patient_id and doctor_id both match valid records.
SELECT * FROM visits v
INNER JOIN patients p
ON v.patient_id= p.patient_id
INNER JOIN Doctors d
ON v.doctor_id = d.doctor_id;

--7. Display prescription details for visits that have a diagnosis.
SELECT p.*, v.diagnosis FROM Prescriptions P
INNER JOIN Visits v
ON p.visit_id = v.visit_id;

--8. Join patients and visits to show each patient’s visit count (no aggregation required).
SELECT * FROM Visits v
INNER JOIN Patients p
ON v.patient_id = p.patient_id;

--9. Show medicines prescribed for each patient.
SELECT pt.*, p.medication_name FROM Visits v
INNER JOIN Prescriptions p
ON v.visit_id = p.visit_id
INNER JOIN patients pt
ON v.patient_id= pt.patient_id;

--10. Show all visits and prescriptions for each visit.
SELECT v.*, p.* FROM Visits v
INNER JOIN Prescriptions p
ON v.visit_id = p.visit_id;

-------------------------------------
--  LEFT JOIN QUESTIONS (11–20)
-------------------------------------

--11. List all patients and their visits, including patients with no visits.
SELECT * FROM Patients p
LEFT JOIN Visits v
ON p.patient_id= v.patient_id;

SELECT * FROM patients;
SELECT * FROM Prescriptions;
SELECT * FROM Visits;
SELECT * FROM Doctors;
--12. List all doctors and their visits, including doctors with no visits.

SELECT * FROM Doctors d
LEFT JOIN Visits v
ON d.doctor_id= v.doctor_id;
--13. Show all visits and prescriptions, including visits with no prescription.
SELECT * FROM Visits v
LEFT JOIN Prescriptions p
ON v.visit_id = p.visit_id;

--14. Display all patients and prescriptions, including patients with none.
SELECT * FROM Visits v
LEFT JOIN Patients pt
ON v.patient_id = pt.patient_id
LEFT JOIN Prescriptions p
ON v.visit_id = p.visit_id;

--15. Show doctor names and diagnoses, even when diagnosis is NULL.
SELECT CONCAT(d.first_name, ' ',d.last_name) AS doc_full_name, v.diagnosis FROM  Doctors d
LEFT JOIN Visits v
ON d.doctor_id= v.doctor_id;

--16. List all visits and medication name if available.
SELECT v.*, p.medication_name FROM Visits v
LEFT JOIN Prescriptions p
ON v.visit_id= p.visit_id;

--17. Show all patients and their diagnoses, even if they never visited.
SELECT p.*, v.diagnosis FROM patients P
LEFT JOIN Visits v
ON p.patient_id= v.patient_id;

--18. Display patients and count of visits, including zero-visit patients.
SELECT p.patient_id,
CONCAT(p.first_name, ' ',p.last_name) AS patient_fullname, 
COUNT(v.visit_id) AS total_visits_perpatients 
FROM patients p
LEFT JOIN visits v
ON p.patient_id=v.patient_id
GROUP BY  p.patient_id,
p.first_name,
p.last_name
SELECT * FROM Visits
--19. List doctors and prescriptions written by them, if any.
SELECT * FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
LEFT JOIN Prescriptions p
ON v.visit_id= p.visit_id;

--20. Show visits and assigned doctors, including visits where doctor_id is NULL.
SELECT * FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL;

-------------------------------------
--  RIGHT JOIN QUESTIONS (21–25)
-------------------------------------

--21. Show all visits and corresponding patient info using RIGHT JOIN.
SELECT * FROM patients p
RIGHT JOIN visits v
ON p.patient_id= v.patient_id;

--22. Display all prescriptions and related visits using RIGHT JOIN.
SELECT * FROM visits v
RIGHT JOIN Prescriptions p
ON v.visit_id= p.visit_id;

--23. List all doctors and visits using RIGHT JOIN.
SELECT * FROM  visits v
RIGHT JOIN  Doctors d
ON v.doctor_id = d.doctor_id;

--24. Show all prescriptions with patient names using RIGHT JOIN.
SELECT pt.*,CONCAT (p.first_name, ' ', p.last_name) AS Full_name FROM visits v
RIGHT JOIN prescriptions pt
ON v.visit_id= pt.visit_id
RIGHT JOIN Patients p
ON v.patient_id= p.patient_id;
/* RIGHT JOIN is NOT suitable for this question
The question should be rewritten.*/

SELECT p.*, CONCAT(pt.first_name, ' ', pt.last_name) AS full_name
FROM Prescriptions p
LEFT JOIN Visits v
ON p.visit_id = v.visit_id
LEFT JOIN Patients pt
ON v.patient_id = pt.patient_id;


--25. Display all visits and medication_name, even if medication missing.
SELECT v.*,p.medication_name FROM Prescriptions p
RIGHT JOIN visits v
ON p.visit_id=v.visit_id;

-------------------------------------
--  FULL JOIN QUESTIONS (26–30)
-------------------------------------
SELECT * FROM patients;
SELECT * FROM Visits;
--26. List all patients and all visits, even unrelated (FULL JOIN).
SELECT * FROM patients p
FULL JOIN visits v
ON p.patient_id = v.patient_id;

--27. Show all doctors and all visits, matched or unmatched.
SELECT * FROM Doctors d
FULL JOIN Visits v
ON d.doctor_id= v.doctor_id;
--28. Display all prescriptions and all visits, unmatched included.
SELECT * FROM visits v
FULL JOIN Prescriptions p
ON v.visit_id= p.visit_id;

--29. Show all patients and doctors whether or not they have interactions.
SELECT p.*,d.* FROM visits v
FULL JOIN patients p
ON v.patient_id= p.patient_id -----------WRONG QUERY
FULL JOIN Doctors d
ON v.doctor_id= d.doctor_id;

SELECT p.*, d.*
FROM patients p
FULL JOIN visits v
    ON p.patient_id = v.patient_id ---------CORRECT QUERY
FULL JOIN doctors d
    ON v.doctor_id = d.doctor_id;


--30. List all medication names with all patients, match where possible.
SELECT p.*,pr.medication_name FROM visits v
FULL JOIN patients p
ON v.patient_id = p.patient_id-----------WRONG QUERY
FULL JOIN prescriptions pr
ON v.visit_id= pr.visit_id;

SELECT p.*, pr.medication_name
FROM patients p
FULL JOIN visits v
    ON p.patient_id = v.patient_id----------CORRECT QUERY
FULL JOIN prescriptions pr
    ON v.visit_id = pr.visit_id;



-------------------------------------
--  MULTI-TABLE JOIN QUESTIONS (31–40)
-------------------------------------

--31. Show visit_id, patient_name, doctor_name in one result.
SELECT v.visit_id,CONCAT (p.first_name,' ',p.last_name) AS patient_fullname,
CONCAT (d.first_name,' ',d.last_name) AS doctor_fullname
FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id;

--32. Display patient name, diagnosis, medication_name.
SELECT CONCAT (p.first_name,' ',p.last_name) AS patient_fullname,
v.diagnosis,
pr.medication_name
FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN Prescriptions pr
ON v.visit_id = pr.visit_id;

--33. Show patient city, visit diagnosis, and doctor name.
SELECT
CONCAT (d.first_name,' ',d.last_name) AS doctor_fullname,
v.diagnosis,p.city
FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id;

--34. List prescriptions with patient and doctor names.
SELECT pr.*,CONCAT (p.first_name,' ',p.last_name) AS patient_fullname,
CONCAT (d.first_name,' ',d.last_name) AS doctor_fullname FROM Visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN Prescriptions pr
ON v.visit_id = pr.visit_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id;

--35. Show patient age, visit_date, medication_name.
SELECT p.age,v.visit_date,pr.medication_name FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN prescriptions pr
ON v.visit_id= pr.visit_id;

--36. List doctor names with number of visits per doctor.
SELECT
d.doctor_id,
COUNT(v.visit_id) AS total_visits_per_doctor,
CONCAT (d.first_name,' ',d.last_name) AS doctor_fullname
FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
GROUP BY d.doctor_id,
d.first_name,d.last_name;

--37. Show patients and doctors connected through visits.
SELECT p.*, d.* FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id;

--38. Show all visits with prescriptions and doctor details.
SELECT * FROM visits v
FULL JOIN Prescriptions p
ON v.visit_id= p.visit_id---- wrong qwuery
FULL JOIN Doctors d
ON v.doctor_id= d.doctor_id;

SELECT *
FROM visits v
LEFT JOIN Prescriptions pr ON v.visit_id = pr.visit_id
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id;


--39. Display patients with their doctors and count of prescriptions.
SELECT p.patient_id,d.doctor_id,COUNT(pr.prescription_id) AS total_number_of_prescriptions FROM visits v
LEFT JOIN patients p
ON v.patient_id= p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
LEFT JOIN Prescriptions pr
ON v.visit_id= pr.visit_id
GROUP BY d.doctor_id, p.patient_id;

--40. Show medications prescribed by each doctor to each patient.
SELECT p.*,d.*,pr.medication_name AS total_number_of_prescriptions FROM visits v
LEFT JOIN patients p
ON v.patient_id= p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
LEFT JOIN Prescriptions pr
ON v.visit_id= pr.visit_id;
 -- correct an improvised version of abover query is 

 SELECT p.patient_id,
       d.doctor_id,
       STRING_AGG(pr.medication_name, ', ') AS medications
FROM visits v
LEFT JOIN patients p ON v.patient_id = p.patient_id
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
LEFT JOIN Prescriptions pr ON v.visit_id = pr.visit_id
GROUP BY p.patient_id, d.doctor_id;


-------------------------------------
--  JOIN + WHERE QUESTIONS (41–45)
-------------------------------------

--41. Show visits only for patients older than 40.
SELECT v.* FROM visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
WHERE p.age > 40;

--42. Display prescriptions written by doctors with NULL department.
SELECT pr.* 
FROM visits v
LEFT JOIN Prescriptions pr
ON v.visit_id = pr.visit_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE d.department IS NULL;


--43. List only visits from 2024 with doctor names.
SELECT v.* ,CONCAT(d.first_name,' ',d.last_name) AS Full_name FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
WHERE YEAR(v.visit_date)= 2024;

--44. Show medications prescribed where diagnosis contains 'A'.
SELECT * FROM visits v
LEFT JOIN Prescriptions p
ON v.visit_id= p.visit_id
WHERE UPPER(v.diagnosis) LIKE '%A%';

--45. List patients whose doctor name starts with 'S'.
SELECT p.* FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE LOWER(d.first_name) LIKE 's%'; 

-------------------------------------
--  JOIN + GROUP BY QUESTIONS (46–55)
-------------------------------------

--46. Count visits per patient using INNER JOIN.
SELECT p.patient_id, COUNT(v.visit_id) AS Total_visits_per_patient FROM visits v
INNER JOIN patients p
ON v.patient_id= p.patient_id
GROUP BY p.patient_id;

--47. Count prescriptions per doctor.
SELECT d.doctor_id,COUNT(p.prescription_id) AS total_prescriptions_per_doctor FROM visits v
LEFT JOIN Prescriptions p
ON v.visit_id= p.visit_id
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
GROUP BY d.doctor_id;

--48. Count prescriptions per patient.
SELECT p.patient_id,COUNT(pr.prescription_id) AS total_prescriptions_per_patient FROM Visits v
LEFT JOIN Prescriptions pr
ON v.visit_id= pr.visit_id
LEFT JOIN patients p
ON v.patient_id =p.patient_id
GROUP BY p.patient_id;

--49. Count visits per doctor, including zero-visit doctors.
SELECT d.doctor_id,COUNT(visit_id) AS Total_visits_per_doc FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id;

--50. Count visits grouped by doctor department.
SELECT d.department,COUNT(visit_id) AS Total_visits_per_doc FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE d.department IS NOT NULL
GROUP BY d.department;

--51. Find average age of patients per doctor.
SELECT d.doctor_id,AVG(p.age) AS avg_age_of_patient_per_doc FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE p.age IS NOT NULL
GROUP BY d.doctor_id;

-- CORRECT QUERY IS 

SELECT d.doctor_id,
       AVG(p.age) AS avg_age_of_patient_per_doc
FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
RIGHT JOIN Doctors d
ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id;


--52. Count medications prescribed per diagnosis.
SELECT v.diagnosis,COUNT(p.medication_name) AS total_medication_per_diagnosis FROM visits v
LEFT JOIN Prescriptions p
ON v.visit_id= p.visit_id
WHERE diagnosis IS NOT NULL
GROUP BY v.diagnosis;

--Incorrect — using LEFT JOIN + WHERE removes NULL diagnosis rows, making it same as INNER JOIN.

--Correct:

SELECT v.diagnosis,
       COUNT(p.prescription_id) AS total_medication_per_diagnosis
FROM visits v
LEFT JOIN Prescriptions p
ON v.visit_id = p.visit_id
GROUP BY v.diagnosis;


--(If you want to exclude NULL diagnosis, use HAVING v.diagnosis IS NOT NULL.)

--53. Count total prescriptions per city.
SELECT p.city,COUNT(pr.prescription_id) AS total_prescriptions_per_city FROM Visits v
LEFT JOIN Prescriptions pr
ON v.visit_id= pr.visit_id
LEFT JOIN patients p
ON v.patient_id = p.patient_id
WHERE p.city IS NOT NULL
GROUP BY p.city;

--54. Count distinct medications per patient.
SELECT p.patient_id, COUNT(DISTINCT pr.medication_name) AS total_distinct_medication_perpatient FROM Visits v
LEFT JOIN Prescriptions pr
ON v.visit_id= pr.visit_id
LEFT JOIN patients p
ON v.patient_id = p.patient_id
WHERE pr.medication_name IS NOT NULL
GROUP BY p.patient_id;


--55. Count visits per year with doctor names.
SELECT 
YEAR(v.visit_date) AS visit_date_year, 
CONCAT(d.first_name,' ',d.last_name) AS doctor_fullname,
COUNT(v.visit_id) AS Total_visits_per_year
FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
WHERE visit_date IS NOT NULL----WRONG QUERY
GROUP BY YEAR(v.visit_date),
d.first_name,
d.last_name
ORDER BY COUNT(v.visit_id) DESC;

SELECT 
YEAR(v.visit_date) AS visit_year,
CONCAT(d.first_name,' ',d.last_name) AS doctor_fullname,
COUNT(v.visit_id) AS total_visits_per_year
FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id-----CORRECT QUERY
GROUP BY 
      YEAR(v.visit_date),
      d.doctor_id,
      d.first_name,
      d.last_name
ORDER BY total_visits_per_year DESC;


-------------------------------------
--  JOIN + HAVING QUESTIONS (56–60)
-------------------------------------

--56. Show doctors who handled more than 1 visits.
SELECT d.doctor_id, COUNT(v.visit_id) AS Total_visits_perdoc FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id
HAVING COUNT(v.visit_id)> 1;

--57. Show patients with more than 1 prescriptions.
SELECT p.patient_id,COUNT(pr.prescription_id) AS total_prescriptions_per_patient FROM Visits v
LEFT JOIN Prescriptions pr
ON v.visit_id= pr.visit_id
LEFT JOIN patients p
ON v.patient_id =p.patient_id
GROUP BY p.patient_id
HAVING COUNT(pr.prescription_id)> 1;

--58. Show cities with at least 1 patients having prescriptions.
SELECT p.city,COUNT(pr.prescription_id) AS total_prescriptions_percity FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN prescriptions pr
ON v.visit_id= pr.visit_id
GROUP BY  p.city
HAVING COUNT(pr.prescription_id)>= 1;

--59. Show diagnoses with more than 1 prescriptions.
SELECT v.diagnosis,COUNT(pr.prescription_id) AS Total_prescription_per_diag FROM visits v
LEFT JOIN Prescriptions pr
ON v.visit_id = pr.visit_id 
WHERE diagnosis IS NOT NULL
GROUP BY  v.diagnosis
HAVING COUNT(pr.prescription_id) > 1;

--60. Show doctors who wrote prescriptions with dosage > 2 entries.
SELECT d.doctor_id, COUNT(pr.dosage) AS Total_dosage_per_doc FROM visits v
LEFT JOIN prescriptions pr
ON v.visit_id= pr.visit_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE dosage IS NOT NULL
GROUP BY d.doctor_id;
-------------------------------------
--  JOIN + ORDER BY QUESTIONS (61–65)
-------------------------------------

--61. List visits with doctor names ordered by visit_date.
SELECT v.*, CONCAT(d.first_name,' ',d.last_name) AS Full_name FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
ORDER BY visit_date DESC;

--62. Show prescriptions ordered by patient age.
SELECT pr.*,p.age FROM visits V
LEFT JOIN Prescriptions pr
ON v.visit_id = pr.visit_id
LEFT JOIN patients p
ON v.patient_id = p.patient_id
WHERE p.age IS NOT NULL
ORDER BY p.age DESC;

--63. List doctors with visit counts ordered descending.
SELECT d.doctor_id,COUNT(v.visit_id) AS Total_visits_per_doc FROM visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id 
ORDER BY COUNT(v.visit_id) DESC;

--64. Show patients with medication counts ordered descending.
SELECT 
    p.patient_id, 
    COUNT(pr.prescription_id) AS medication_count 
FROM visits v
LEFT JOIN prescriptions pr
    ON v.visit_id = pr.visit_id
LEFT JOIN patients p
    ON v.patient_id = p.patient_id
GROUP BY p.patient_id
ORDER BY medication_count DESC;


--65. Show doctor–patient pairs sorted alphabetically.
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    v.patient_id
FROM Visits v
INNER JOIN Doctors d
    ON v.doctor_id = d.doctor_id
ORDER BY doctor_name ASC;
 


-------------------------------------
--  ADVANCED JOIN QUESTIONS (66–70)
-------------------------------------

--66. Show the most frequently prescribed medication with doctor details.
SELECT d.doctor_id,
CONCAT(d.first_name,' ',d.last_name) AS doc_full_name,
COUNT(p.medication_name) AS total_medication,
p.medication_name FROM visits v
LEFT JOIN prescriptions p
ON v.visit_id = p.visit_id------ wrong query
LEFT JOIN Doctors d
 ON v.doctor_id = d.doctor_id
WHERE medication_name IS NOT NULL
GROUP BY d.doctor_id,d.first_name,d.last_name,p.medication_name;

SELECT TOP 1
    p.medication_name,
    COUNT(*) AS total_times_prescribed,
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_fullname
FROM visits v
LEFT JOIN prescriptions p
    ON v.visit_id = p.visit_id
LEFT JOIN doctors d
    ON v.doctor_id = d.doctor_id
WHERE p.medication_name IS NOT NULL---- correct query
GROUP BY 
    p.medication_name,
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY 
    COUNT(*) DESC;


--67. Display each patient’s latest visit date with doctor name.
SELECT 
    p.patient_id,
    v.visit_date AS latest_visit_date,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_fullname
FROM Patients p
LEFT JOIN Visits v
    ON p.patient_id = v.patient_id
LEFT JOIN Doctors d
    ON v.doctor_id = d.doctor_id
WHERE v.visit_date = (
        SELECT MAX(v2.visit_date)
        FROM Visits v2
        WHERE v2.patient_id = p.patient_id
    );



--68. Show doctors who treat patients from more than one city.
SELECT d.doctor_id, CONCAT(d.first_name,' ',d.last_name) AS Ful_name_doc,COUNT(DISTINCT city) AS total_cities_perdoc FROM visits v
LEFT JOIN patients p
ON v.patient_id = p.patient_id
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE city IS NOT NULL
GROUP BY d.doctor_id,d.first_name,d.last_name
HAVING COUNT(DISTINCT city) > 1;

--69. List patients who received prescriptions from more than one doctor.
SELECT p.patient_id,
       COUNT(DISTINCT d.doctor_id) AS total_doctors
FROM visits v
LEFT JOIN patients p ON v.patient_id = p.patient_id
LEFT JOIN Prescriptions pr ON v.visit_id = pr.visit_id
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
GROUP BY p.patient_id
HAVING COUNT(DISTINCT d.doctor_id) > 1;

--70. Show doctors who never wrote any prescriptions.
SELECT d.doctor_id,
       d.first_name,
       d.last_name
FROM Doctors d
LEFT JOIN Visits v 
    ON d.doctor_id = v.doctor_id
LEFT JOIN Prescriptions pr
    ON v.visit_id = pr.visit_id
WHERE pr.prescription_id IS NULL;
