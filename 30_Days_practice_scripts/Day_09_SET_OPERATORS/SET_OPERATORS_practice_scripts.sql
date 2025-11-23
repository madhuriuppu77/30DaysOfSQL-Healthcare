--============================================================
               -- SECTION 1: UNION PRACTICE  
--============================================================

--1. List all patient first_names UNION all doctor first_names.
SELECT first_name FROM patients
UNION ALL
SELECT first_name FROM Doctors;

--2. List all patient cities UNION ALL patient cities (duplicate test).
SELECT city FROM patients
UNION ALL
SELECT city FROM patients;
--3. List doctor departments UNION visit departments.
SELECT department FROM Doctors
UNION
SELECT department FROM Visits;

--4. List doctor departments EXCEPT departments used in Visits.
SELECT department FROM Doctors
EXCEPT
SELECT department FROM Visits;

--5. List patient last_names UNION doctor last_names.
SELECT last_name FROM patients
UNION
SELECT last_name FROM Doctors;

--6. List medication_names UNION diagnosis values.
SELECT medication_name FROM Prescriptions
UNION
SELECT diagnosis FROM Visits;

--7. List visit department values UNION doctor department values.
SELECT department FROM visits
UNION 
SELECT department FROM Doctors;

--8. List patient first_names UNION ALL diagnosis values.
SELECT first_name FROM patients
UNION ALL
SELECT diagnosis FROM Visits;

--9. List patient last_names UNION doctors’ working departments.
SELECT last_name FROM patients
UNION 
SELECT department FROM Visits;

--10. List visit_dates UNION ALL visit_dates (duplicate test).
SELECT visit_date FROM visits
UNION ALL
SELECT visit_date FROM visits;

--11. List patient_ids UNION doctor_ids.
SELECT patient_id FROM patients
UNION
SELECT doctor_id FROM Doctors;

--12. List prescription_ids UNION visit_ids (type conversion).
SELECT prescription_id FROM Prescriptions
UNION
SELECT visit_id FROM visits;

--13. List diagnosis UNION ALL diagnosis (duplicates included).
SELECT diagnosis FROM visits
UNION ALL
SELECT diagnosis FROM visits;

--14. List cities UNION ALL diagnosis values.
SELECT city FROM patients
UNION ALL
SELECT diagnosis FROM Visits;

--15. List diagnosis UNION medication_names without filtering.
SELECT diagnosis FROM visits
UNION
SELECT medication_name FROM Prescriptions;

--16. List doctor first_names UNION ALL patient last_names.
SELECT first_name FROM Doctors
UNION ALL
SELECT last_name FROM Patients;

--17. List patient phone numbers UNION phone numbers of NULL-city patients.
SELECT phone FROM patients
UNION 
SELECT phone FROM patients
WHERE city IS NULL;

--18. List patient full_names UNION doctor full_names.
SELECT CONCAT(first_name,' ',last_name) AS Full_name FROM patients
UNION
SELECT CONCAT(first_name,' ',last_name) AS Full_name FROM Doctors;

--19. List visit departments UNION NULL departments from doctors.
SELECT department FROM visits
UNION 
SELECT department FROM Doctors WHERE department IS NULL;

--20. List all unique medication names UNION diagnosis values.
SELECT DISTINCT medication_name FROM Prescriptions
UNION
SELECT diagnosis FROM Visits;

--============================================================
                --SECTION 2: INTERSECT PRACTICE
--============================================================

--21. List patient cities INTERSECT doctor departments (string match test).
SELECT city FROM patients
INTERSECT
SELECT department FROM Doctors;

--22. List doctor first_names INTERSECT patient first_names.
SELECT first_name FROM Doctors
INTERSECT
SELECT first_name FROM Patients;

--23. List diagnosis INTERSECT medication names.
SELECT diagnosis FROM visits
INTERSECT
SELECT medication_name FROM Prescriptions;

--24. List patient ages INTERSECT ages > 40.
SELECT age FROM patients
INTERSECT
SELECT age FROM patients
WHERE age > 40;

--25. List patients’ cities INTERSECT (‘Chennai’, ‘Hyderabad’, ‘Delhi’, ‘Kochi’).
SELECT city FROM patients
INTERSECT
SELECT city FROM patients
WHERE city IN ('Chennai', 'Hyderabad', 'Delhi', 'Kochi');

--26. List doctor departments INTERSECT visit department values.
SELECT department FROM Doctors
INTERSECT
SELECT department FROM visits;

--27. List diagnosis values INTERSECT patient city values.
SELECT diagnosis FROM visits
INTERSECT
SELECT city FROM patients;

--28. List first_names INTERSECT doctor first_names ending with 'n'.
SELECT first_name FROM Doctors
INTERSECT
SELECT first_name FROM Doctors
WHERE LOWER(first_name) LIKE '%n';

--29. List cities INTERSECT ages > 30 (cross-check string vs number exercise).
SELECT city FROM patients
INTERSECT
SELECT city FROM patients
WHERE age > 30;

--30. List prescription medication_names INTERSECT (‘Aspirin’, ‘Ibuprofen’).
SELECT medication_name FROM Prescriptions
INTERSECT
SELECT medication_name FROM prescriptions
WHERE UPPER(medication_name) IN ('ASPIRIN','IBUPROFEN');

--31. List patient first_names INTERSECT diagnosis values.
SELECT first_name FROM Patients
INTERSECT
SELECT diagnosis FROM visits;

--32. List patient first_names INTERSECT doctor first_names working in NULL department.
SELECT first_name FROM patients
INTERSECT
SELECT first_name FROM Doctors
WHERE department IS NULL;

--33. List cities INTERSECT cities of patients older than 30.
SELECT city FROM Patients
INTERSECT 
SELECT city FROM patients
WHERE age > 30;

--34. List diagnosis INTERSECT medication_name values with non-null dosage.
SELECT diagnosis FROM visits
INTERSECT
SELECT medication_name FROM Prescriptions
WHERE dosage IS NOT NULL;

--35. List patient cities INTERSECT (‘Hyderabad’, ‘Kochi’, ‘Bangalore’, ‘Chennai’).
SELECT city FROM Patients
INTERSECT
SELECT city FROM patients
WHERE city IN ('Hyderabad', 'Kochi', 'Bangalore', 'Chennai');

--============================================================
           --     SECTION 3: EXCEPT PRACTICE
--============================================================

--36. List doctor departments EXCEPT those appearing in Visits.
SELECT department FROM Doctors
EXCEPT 
SELECT department FROM visits;

--37. List medication_names EXCEPT medications with NULL dosage.
SELECT medication_name FROM Prescriptions
EXCEPT
SELECT medication_name FROM prescriptions
WHERE dosage IS NULL;

--38. List patient cities EXCEPT cities containing letter 'a'.
SELECT city FROM patients
EXCEPT
SELECT city FROM patients
WHERE city LIKE '%a%';

--39. List patient first_names EXCEPT names with length < 4.
SELECT first_name FROM patients
EXCEPT 
SELECT first_name FROM patients
WHERE LEN(first_name) < 4;

--40. List doctor last_names EXCEPT those appearing in Patients.
SELECT last_name FROM Doctors
EXCEPT
SELECT last_name FROM patients;

--41. List diagnosis EXCEPT NULL values.
SELECT diagnosis FROM Visits
EXCEPT
SELECT diagnosis FROM Visits
WHERE diagnosis IS NULL;

--42. List patient cities EXCEPT cities of patients with NULL phone numbers.
SELECT city FROM patients
EXCEPT
SELECT city FROM patients
WHERE phone IS NULL;

--43. List medication_names EXCEPT those containing ‘in’.
SELECT medication_name FROM Prescriptions
EXCEPT
SELECT medication_name FROM Prescriptions
WHERE medication_name LIKE '%in%';

--44. List visit_ids EXCEPT prescription visit_ids.
SELECT visit_id FROM visits 
EXCEPT
SELECT visit_id FROM Prescriptions;

--45. List visit departments EXCEPT patient cities.
SELECT department FROM Visits
EXCEPT
SELECT city FROM Patients;

--46. List patient last_names EXCEPT those starting with ‘V’.
SELECT last_name FROM patients
EXCEPT
SELECT last_name FROM patients
WHERE last_name LIKE 'v%';

--47. List doctor first_names EXCEPT patient first_names older than 50.
SELECT first_name FROM Doctors
EXCEPT
SELECT first_name FROM Patients
WHERE age > 50;

--48. List phone numbers EXCEPT numbers ending with '33'.
SELECT phone FROM patients
EXCEPT
SELECT phone FROM patients
WHERE phone LIKE '%33';

--49. List cities of patients older than 40 EXCEPT younger than 30.
SELECT city FROM patients
WHERE age > 40
EXCEPT 
SELECT city FROM patients
WHERE age < 30;

--50. List diagnosis EXCEPT diagnoses recorded before 2024.
SELECT diagnosis FROM Visits
EXCEPT
SELECT diagnosis FROM Visits
WHERE YEAR(visit_date) < 2024;

--51. List medication_names EXCEPT those prescribed by doctor_id = 1.
SELECT medication_name FROM Prescriptions
EXCEPT
SELECT medication_name FROM Prescriptions
WHERE doctor_id= 1;

--52. List doctor last_names EXCEPT those working in NULL departments.
SELECT last_name FROM Doctors
EXCEPT
SELECT last_name FROM Doctors
WHERE department IS NULL;

--53. List diagnosis EXCEPT medication_names starting with 'M'.
SELECT diagnosis FROM Visits
EXCEPT
SELECT medication_name FROM Prescriptions
WHERE UPPER(medication_name) LIKE 'M%';

--54. List departments in Doctors EXCEPT those not in Visits.
SELECT department FROM Doctors
EXCEPT
SELECT department FROM Visits;

--55. List patient last_names EXCEPT patients younger than 35.
SELECT last_name FROM patients
EXCEPT
SELECT last_name FROM patients
WHERE age <35;
--============================================================
       -- SECTION 4: COMBINATION OF UNION + INTERSECT + EXCEPT
--============================================================

--56. List cities of patients UNION cities of doctors INTERSECT known cities.
SELECT city FROM Patients
UNION
(
    SELECT city FROM Patients
    INTERSECT
    SELECT city FROM Patients
    WHERE LOWER(city) IN ('hyderabad','chennai')
);


--57. List medication_names EXCEPT null-dosage meds INTERSECT visit diagnoses.
(
    SELECT medication_name FROM Prescriptions
    WHERE dosage IS NOT NULL
)
INTERSECT
(
    SELECT diagnosis FROM Visits
    WHERE diagnosis IS NOT NULL
);

--58. List doctor departments INTERSECT visit departments UNION ALL city values of Patients.
(
    SELECT department FROM Doctors
    INTERSECT
    SELECT department FROM Visits
)
UNION ALL
SELECT city FROM Patients;


--59. List patient first_names INTERSECT doctor first_names EXCEPT NULL cities.
(
    SELECT first_name FROM patients
    INTERSECT
    SELECT first_name FROM Doctors
)
EXCEPT
SELECT first_name FROM Patients
WHERE city IS NULL;


--60. List diagnosis UNION medication_names EXCEPT NULL results.
(
    SELECT diagnosis AS val FROM Visits
    UNION
    SELECT medication_name AS val FROM Prescriptions
)
EXCEPT
SELECT medication_name FROM Prescriptions
WHERE medication_name IS NULL;


-- 61. List the patient first names that do NOT appear in doctor first names, and from those, return only the ones that also appear as diagnosis names in the Visits table.
( SELECT first_name FROM patients
EXCEPT
SELECT first_name FROM Doctors)
INTERSECT

SELECT diagnosis FROM Visits;


-- 62. Return the full names of patients combined (UNION) with the full names of doctors, and from this combined list, keep only the names that also appear in a table of unique names.
(
    SELECT CONCAT(first_name,' ',last_name) FROM Patients
    UNION 
    SELECT CONCAT(first_name,' ',last_name) FROM Doctors
)
INTERSECT
(
    SELECT CONCAT(first_name,' ',last_name) FROM Patients
    INTERSECT
    SELECT CONCAT(first_name,' ',last_name) FROM Doctors
);

-- 63. Return all departments from Doctors together with all cities from Patients (UNION), but exclude any department or city that contains the letter ‘e’.
(SELECT department FROM Doctors
UNION
SELECT city FROM patients
)
EXCEPT
(SELECT department FROM Doctors
WHERE department LIKE '%e%'
UNION
SELECT city FROM patients
WHERE city LIKE '%e%'
);
-- 64. List all diagnoses that also appear as common city names (INTERSECT), and then add all diagnosis values again to the output using UNION ALL.
(SELECT diagnosis FROM Visits
INTERSECT
SELECT city FROM patients
)
UNION ALL
SELECT diagnosis FROM Visits;


-- 65. List all medication names except ‘Aspirin’ and ‘Ibuprofen’, and then combine (UNION) that result with all diagnosis names.

(
    SELECT medication_name FROM Prescriptions
    EXCEPT
    SELECT medication_name FROM Prescriptions
    WHERE UPPER(medication_name) IN ('ASPIRIN','IBUPROFEN')
)
UNION
SELECT diagnosis FROM Visits;


-- 66. List all doctor departments that are not present in Visit departments, and then append (UNION ALL) the doctor departments again.
(
 SELECT department FROM Doctors
 EXCEPT
 SELECT department FROM Visits
 )

 UNION ALL

 SELECT department FROM Doctors;

-- 67. List all visit dates that do not appear in prescription dates, and then keep only those dates which fall in the year 2024.
(
    SELECT visit_date FROM Visits
    EXCEPT
    SELECT v.visit_date 
    FROM Visits v
    JOIN Prescriptions p ON v.visit_id = p.visit_id
)
INTERSECT
SELECT visit_date FROM Visits
WHERE YEAR(visit_date) = 2024;

-- 68. List all patient cities except Chennai, and then UNION the city Hyderabad, but finally keep only the cities that appear in the overall city list provided.
(
    SELECT city FROM Patients
    EXCEPT
    SELECT 'Chennai'
)
UNION
SELECT 'Hyderabad'
INTERSECT
SELECT city FROM Patients;

-- 69. List all patient IDs together with doctor IDs (UNION), and then exclude the IDs that appear in the Visits table.
(
    SELECT patient_id AS id FROM Patients
    UNION
    SELECT doctor_id AS id FROM Doctors
)
EXCEPT
(
    SELECT patient_id FROM Visits
    UNION
    SELECT doctor_id FROM Visits
);

-- 70. Return all diagnosis values together with all medication names (UNION ALL), and from that combined list exclude any rows where dosage is NULL.
(
    SELECT diagnosis FROM Visits
    UNION ALL
    SELECT medication_name FROM Prescriptions
)
EXCEPT
SELECT medication_name FROM Prescriptions
WHERE dosage IS NULL;
