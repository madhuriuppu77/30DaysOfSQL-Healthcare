-- =====================================================================
-- SQL WHERE CLAUSE PRACTICE QUESTIONS (TOTAL = 83)
-- Dataset: Patients, Doctors, Visits, Prescriptions
-- =====================================================================

--------------------------------------------------------
-- PART 1: INDIVIDUAL FILTERING (50 Questions)
--------------------------------------------------------

-- A) Comparison Operators (10)
--1.  Fetch all patients whose age is greater than 40.
SELECT * 
FROM patients 
WHERE age >40;

--2.  Get details of patients whose gender is 'F'.
SELECT * 
FROM patients 
WHERE gender = 'F';

--3.  Retrieve doctors not equal to 'Cardiology' department.
SELECT * 
FROM  Doctors
WHERE department != 'Cardiology';

--4.  Show visits where diagnosis is 'Fracture'.
SELECT * FROM Visits
WHERE diagnosis = 'Fracture';

--5.  Fetch patients whose city is 'Hyderabad'.
SELECT * FROM Patients
WHERE city = 'Hyderabad';

--6.  List visits where doctor_id = 1.
SELECT * FROM Visits
WHERE doctor_id = 1;

--7.  Show prescriptions where dosage is '50mg'.
SELECT * FROM Prescriptions
WHERE dosage = '50mg';

--8.  Get doctors where department = 'Neurology'.
SELECT * FROM Doctors
WHERE department = 'Neurology';
--9.  Show patients less than 35 years age.
SELECT * FROM patients 
WHERE age < 35;

--10. Retrieve visits where visit_id >= 5.
SELECT * FROM Visits
WHERE visit_id >= 5;

-- B) Logical Operators (10)
--11. Show male patients above 40 years old.
SELECT * FROM Patients
WHERE gender = 'M' AND age > 40;

--12. Get patients who are from Hyderabad OR Chennai.
SELECT * FROM Patients
WHERE city = 'Hyderabad' OR city = 'Chennai';
-- we can write either way:
SELECT * FROM Patients
WHERE city IN ('Hyderabad','Chennai');

--13. Fetch doctor records where department is Cardiology AND last_name starts with 'S'.
SELECT * FROM Doctors
WHERE department ='Cardiology' AND last_name LIKE 'S%';

--14. List patients not from Bangalore.
SELECT *  FROM Patients 
WHERE NOT city = 'Bangalore';

--15. Display visits where diagnosis IS NOT NULL AND department IS NOT NULL.
SELECT * FROM Visits
WHERE diagnosis IS NOT NULL AND department IS NOT NULL;

--16. Fetch patients whose age > 30 OR city IS NULL.
SELECT * FROM Patients
WHERE age >30  OR city IS NOT NULL--- THIS IS WRONG 

SELECT * FROM Patients
WHERE age > 30 OR city IS NULL;--- THIS IS CORRECT


--17. Get doctors who do not belong to Neurology AND not Dermatology.
SELECT * FROM Doctors
WHERE NOT department = 'Neurology' AND department= 'Dermatology';--THIS IS WRONG

SELECT * FROM Doctors
WHERE department NOT IN ('Neurology', 'Dermatology');---THIS IS CORRECT

 
--18. Fetch prescriptions where medication_name is NOT NULL AND dosage IS NULL.
SELECT * FROM Prescriptions
WHERE medication_name IS NOT NULL AND dosage IS NULL;

--19. Show visits where patient_id = 1 OR patient_id = 5.
SELECT * FROM visits
WHERE patient_id = 1 OR patient_id = 5;
--OR you can also write like this:
SELECT * FROM visits
WHERE patient_id IN (1, 5);

--20. Retrieve patients whose gender = 'F' AND age < 60.
SELECT* FROM Patients
WHERE gender ='F' AND age < 60;

-- C) Range Operator BETWEEN (5)
--21. Fetch patients whose age is BETWEEN 30 AND 50.
SELECT * FROM patients
WHERE age BETWEEN 30 AND 50;

--22. Show visits where visit_id BETWEEN 3 AND 7.
SELECT * FROM Visits
WHERE visit_id BETWEEN 3 AND 7;

--23. Get prescriptions where prescription_id BETWEEN 4 AND 9.
SELECT * FROM Prescriptions
WHERE prescription_id BETWEEN 4 AND 9;

--24. Retrieve doctors where doctor_id BETWEEN 2 AND 4.
SELECT * FROM Doctors
WHERE doctor_id BETWEEN 2 AND 4;

--25. Find patients whose phone number starts with digit BETWEEN '7' AND '9'.
SELECT * FROM Patients
WHERE phone LIKE (BETWEEN 7 AND 9);---- wrong query

SELECT * FROM Patients
WHERE phone LIKE '[7-9]%';---- correct query


-- D) Membership IN & NOT IN (7)
--26. Fetch patients whose city is IN ('Hyderabad','Chennai').
SELECT * FROM patients
WHERE city IN ('Hyderabad','Chennai');

--27. Display doctors whose department is IN ('Cardiology','Neurology').
SELECT * FROM Doctors
WHERE department IN ('Cardiology','Neurology');

--28. Get visits where patient_id IN (1,3,5,7).
SELECT * FROM Visits
WHERE patient_id IN (1,3,5,7);

--29. Show prescriptions where medication_name IN ('Paracetamol','Ibuprofen').
SELECT * FROM Prescriptions
WHERE medication_name IN ('Paracetamol','Ibuprofen');

--30. Fetch patients where city NOT IN ('Bangalore','Delhi').
SELECT * FROM patients 
WHERE city NOT IN ('Bangalore','Delhi');

--31. Show doctors where department NOT IN ('Dermatology','Orthopedics').
SELECT * FROM Doctors
WHERE department NOT IN ('Dermatology','Orthopedics');

--32. Get visits where diagnosis NOT IN ('Migraine','Allergy').
SELECT * FROM visits
WHERE diagnosis NOT IN ('Migraine','Allergy');

-- E) LIKE Pattern Matching (10)
--33. Fetch patients whose first_name starts with 'R'.
SELECT * FROM patients
WHERE first_name LIKE 'R%';

--34. Show doctors whose last_name ends with 'a'.
SELECT * FROM Doctors
WHERE last_name LIKE '%a';

--35. Retrieve patients where city contains 'a'.
SELECT * FROM patients
WHERE city LIKE '%a%';

--36. Fetch doctors whose department contains 'o'.
SELECT * FROM Doctors
WHERE department LIKE '%o%';

--37. Show diagnoses that start with 'C'.
SELECT * FROM visits
WHERE diagnosis LIKE 'C%';

--38. Fetch medication names that end with 'in'.
SELECT * FROM Prescriptions
WHERE medication_name LIKE '%in';

--39. Get visits where diagnosis contains 'Pain'.
SELECT * FROM Visits
WHERE diagnosis LIKE '%pain%';-- This is casesenstive
--- OR we can write like query by adding function LOWER
SELECT *
FROM Visits
WHERE LOWER(diagnosis) LIKE '%pain%';


--40. Retrieve patients whose phone begins with '9'.
SELECT * FROM patients
WHERE phone LIKE '9%';
--41. Show doctors whose first_name has 5 characters.
SELECT * FROM Doctors
WHERE LEN(first_name) =5;

--42. Fetch patients whose last_name starts with P or R.
SELECT * FROM patients
WHERE last_name LIKE 'p%' OR last_name LIKE 'R%' ;

-- F) NULL Handling (5)
--43. Fetch patients whose age IS NULL.
SELECT * FROM patients
WHERE age IS NULL;

--44. Fetch patients whose city IS NULL.
SELECT * FROM patients
WHERE city IS NULL;

--45. Show visits where visit_date IS NULL.
SELECT * FROM visits
WHERE visit_date IS NULL;

--46. Display prescriptions where medication_name IS NULL.
SELECT * FROM Prescriptions
WHERE medication_name IS NULL;

--47. Fetch doctors where department IS NULL.
SELECT * FROM Doctors
WHERE department IS NULL;

-- G) Extra Comparison / Logical (3)
--48. Fetch patients where age <= 50 AND gender = 'M'.
SELECT * FROM patients
WHERE  age <= 50 AND gender = 'M';

--49. Get visits where diagnosis <> 'Back Pain'.
SELECT * FROM visits
WHERE diagnosis <> 'Back pain';

--50. Show doctors where first_name != 'Kiran' AND department <> 'Cardiology'.

SELECT * FROM Doctors
WHERE first_name != 'kiran' AND department <> 'cardiology';

--------------------------------------------------------
-- PART 2: COMBINED FILTERING & COMPLEX CONDITIONS (30)
--------------------------------------------------------

--51. List male patients who are neither too young nor too old and belong to a city known as Telangana’s capital.
SELECT * FROM patients
WHERE LOWER(gender) = 'M' AND age BETWEEN 15 AND 60 AND LOWER(city) = 'Hyderabad';

--52. Retrieve visit records where the disease description contains the letter 'a' somewhere and the doctor assigned belongs to the first three IDs.
SELECT * FROM visits
WHERE doctor_id IN (1,2,3) AND diagnosis LIKE '%a%';
 -- Another way of correct query (both query is correct)
 SELECT *
FROM visits
WHERE LOWER(diagnosis) LIKE '%a%'
  AND doctor_id BETWEEN 1 AND 3;

--53. Show prescriptions where dosage is properly filled and the drug name contains the letters 'ol'.
SELECT * FROM Prescriptions
WHERE dosage IS NOT NULL AND medication_name LIKE '%ol%';

--54. Pull patient list that excludes those from the city known for pearls and only includes ones older than early adulthood.
SELECT * FROM patients
WHERE LOWER(city) NOT IN ('Hyderabad') AND age >18;

--55. Display doctors whose surname begins with 'S' or are part of bone or nervous system related medical departments.
SELECT * FROM Doctors
WHERE (last_name LIKE'S%') OR (LOWER(department) ='neurology' OR LOWER(department) ='orthopedics');
-- You can write in both ways
SELECT *
FROM Doctors
WHERE last_name LIKE 'S%'
   OR LOWER(department) IN ('neurology', 'orthopedics');

--56. Show visit information where the medical department and diagnosis match each other or diagnosis has not yet been entered.
SELECT * FROM Visits
WHERE department = diagnosis OR diagnosis IS NULL;

-- OR
SELECT *
FROM Visits
WHERE LOWER(TRIM(department)) = LOWER(TRIM(diagnosis))
   OR diagnosis IS NULL;

--57. Get female patients whose first name has at least two characters before 'a'.
SELECT * FROM patients
WHERE LOWER(gender)='f' AND first_name LIKE '%a';

--Correct SQL Logic

--We want 'a' to appear at index >= 3, meaning at least two characters before it.

SELECT *
FROM patients
WHERE LOWER(gender) = 'f'
  AND LOWER(first_name) LIKE '__%a%';

/*Explanation

_ = one character

__ = two characters required before the first a

% = any characters afterwards*/
--58. Get prescriptions where the medicine name ends in 'in' and dosage quantity is equal to or more than medium dosage.
SELECT * FROM Prescriptions
WHERE medication_name LIKE '%in%' AND dosage <= '30mg';

SELECT *
FROM Prescriptions
WHERE LOWER(medication_name) LIKE '%in'
  AND dosage >= '10mg';


--59. Return doctors who are not part of any department containing the letter 'o'.
SELECT * FROM Doctors
WHERE  department NOT LIKE '%o%';

/*Handling NULLs — If some doctors do not have department assigned (NULL), they won’t appear because NULL NOT LIKE returns unknown, not true.
If you want to include doctors with no department, add: */

SELECT *
FROM Doctors
WHERE (department IS NULL)
   OR (LOWER(department) NOT LIKE '%o%');

--60. Fetch visit records excluding patient IDs belonging to even-number pattern and ensure visit date is recorded.
/*We use the modulus operator (% in most SQL engines):

number % 2 = 0  → even
number % 2 = 1  → odd */

SELECT * FROM visits
WHERE visit_date IS NOT NULL AND (patient_id % 2) = 0 ;

--61. List patients whose age is beyond mid-30s or those with phone number unavailable, but city name must start with 'C'.
SELECT * FROM patients
WHERE (age >30 OR phone IS NULL) AND lower(city) LIKE 'c%';

--62. Find doctors whose first names consist of exactly five characters and do not belong to any medical division.
SELECT * FROM Doctors
WHERE UPPER(LEN(TRIM(first_name)))= 5 AND DEPARTMENT IS NULL;

--Here UPPER works only string but here it wont work because we are using len function right!!

SELECT *
FROM Doctors
WHERE LEN(TRIM(first_name)) = 5
  AND Department IS NULL;

--63. Extract visit records occurring between early March and late April 2024, involving diagnoses containing the vowel 'e'.
SELECT * FROM Visits
WHERE visit_date BETWEEN '2024-03-01' AND '2024-04-30' AND diagnosis LIKE '%e%';

--64. Retrieve prescriptions where medication starts with the letter 'P' and ends in milligrams with a zero.
SELECT * FROM Prescriptions
WHERE LOWER(medication_name) LIKE 'p%' AND dosage LIKE '%0mg';

SELECT * FROM Prescriptions
WHERE LOWER(medication_name) LIKE 'p%'
  AND dosage LIKE '%0mg';


--65. List all patients not staying in Telangana’s capital and who are not younger than 30.
SELECT * FROM patients
WHERE city <> 'Hyderabad' AND age >= 30;

--66. Show doctors belonging either to heart or nervous specialist department and have first name ending or containing 'a'.
SELECT * FROM Doctors
WHERE (department ='cardiology' OR  department ='neurology') 
AND (first_name LIKE '%a%' OR first_name LIKE '%a%');

-- or you can write like this

SELECT *
FROM Doctors
WHERE department IN ('cardiology', 'neurology')
  AND (first_name LIKE '%a%' OR first_name LIKE '%a');

--67. Return all visit records where either diagnosis or department details are missing.
SELECT * FROM visits
WHERE diagnosis IS NULL OR department IS NULL;

--68. Retrieve prescriptions where any of the primary medical detail fields have missing values.
SELECT * FROM Prescriptions
WHERE prescription_id IS NULL;
/* But prescription_id will NEVER be NULL because it’s the primary key of the table.
Typically the primary medical detail fields in a Prescriptions table are:

patient_id

doctor_id

medication_name

dosage

(These may vary by your system, but usually these 4 are considered essential.)*/

SELECT *
FROM Prescriptions
WHERE 
    visit_id IS NULL
   OR medication_name IS NULL
   OR dosage IS NULL;


--69. Fetch patients whose phone begins with the highest digit and whose age matches any of these: mid-30s, mid-40s, early-70s.
SELECT * FROM patients
WHERE phone LIKE '9%' AND 
(age BETWEEN 35 AND 37
 OR age BETWEEN 45 AND 47
 OR age BETWEEN 70 AND 72);

--70. Get doctors with IDs between 2–5 and whose surname ends with 'a'.
SELECT * FROM Doctors
WHERE (doctor_id BETWEEN 2 AND 5) AND LOWER(last_name) LIKE '%a';

--71. Display visits where diagnosis does not contain the vowel 'e' and visit date must not be missing.
SELECT * FROM Visits
WHERE diagnosis NOT LIKE '%e%' 
AND visit_date IS NOT NULL;

--72. Fetch patients having long first names (five or more characters).
SELECT * FROM Patients
WHERE LEN(TRIM(first_name)) >= 5;

--73. Show visit data where either department starts with 'C' or diagnosis contains 'g', but exclude visits handled by doctor ID 2.
SELECT * FROM Visits
WHERE (UPPER(department) LIKE 'C%' OR UPPER(diagnosis) LIKE '%G%')
AND doctor_id <> 2;

--74. Get prescriptions belonging to middle-range visit IDs and exclude certain painkillers or anti-inflammatory drugs.
SELECT * FROM Prescriptions
WHERE visit_id IN (4,5,6,7,8) 
AND (medication_name NOT IN ('ibuprofen', 'Aspirin','Amlodipine'));

--75. Retrieve patients who either have missing location & contact OR belong to senior citizen age category.
SELECT * FROM patients
WHERE (city IS NULL AND phone IS NULL) OR age > 50;

--76. Pull doctors whose department ends with 'ology' and belong to specific doctor IDs set.
SELECT * FROM Doctors
WHERE department LIKE '%ology' AND doctor_id IN (1,2,3,4);

--77. Fetch visit records that occurred before April 2024 or diagnoses ending with 'Pain'.
SELECT * FROM Visits
WHERE visit_date <' April 2024' OR LOWER(diagnosis) LIKE '%pain';

--correct query above is wrong because dates should not written in above format so correct is 
SELECT *
FROM Visits
WHERE visit_date < '2024-04-01'
   OR LOWER(diagnosis) LIKE '%pain';

--78. Display prescriptions where medicine ends with 'in' and dosage ends with zero milligrams, or dosage is missing.

SELECT * FROM Prescriptions
WHERE LOWER(medication_name) LIKE '%in'
AND dosage LIKE '%0mg' OR dosage IS NULL;
 /* Problem:
AND + OR without parentheses causes wrong logic.
SQL evaluates:
A AND B OR C
 (A AND B) OR C   (correct)

But many people expect:
A AND (B OR C)

You want either of these:

medicine ends with ‘in’ AND dosage ends with ‘0mg’

OR dosage is missing

So parentheses are required.

 Correct version:
*/
SELECT *
FROM Prescriptions
WHERE (
        LOWER(medication_name) LIKE '%in'
        AND LOWER(dosage) LIKE '%0mg'
      )
   OR dosage IS NULL;

--79. Get patients whose names contain 'a', surname begins with 'P', and city’s second character is 'o'.
SELECT * FROM patients
WHERE LOWER(first_name) LIKE '%a%'
AND LOWER(last_name) LIKE 'p%'
AND LOWER(city) LIKE '_o%';

--80. List doctors whose first name doesn’t start with 'A' and department not related to heart or nervous system.

SELECT * FROM Doctors
WHERE LOWER(first_name) NOT LIKE 'a%' 
AND department NOT IN('cardiology' , 'neurology');

--------------------------------------------------------
-- BONUS EXTRA QUESTIONS (3)
--------------------------------------------------------

--81.  Fetch patients whose first_name and last_name are both NOT NULL.
SELECT * FROM patients
WHERE first_name IS NOT NULL AND last_name IS NOT NULL;

--82.  Show visits where visit_date is in the year 2024 (use YEAR(visit_date)).
SELECT * FROM Visits
WHERE YEAR(visit_date) = '2024';

--83.  Get prescriptions where dosage contains a numeric digit using LIKE '%[0-9]%'.
SELECT * FROM Prescriptions
WHERE dosage LIKE '%[0-9]%';
-- =====================================================================
-- END OF 83 QUESTIONS
-- =====================================================================
