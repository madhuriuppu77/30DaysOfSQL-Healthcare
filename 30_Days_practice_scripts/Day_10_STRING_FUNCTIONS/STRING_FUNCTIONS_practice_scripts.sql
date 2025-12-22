--------------------------- STRING FUNCTIONS QUESTIONS ---------------------------

-- CONCAT()
-- 1. Write a query to CONCAT first_name and last_name of all patients.
SELECT 
CONCAT(first_name,' ',last_name) AS Full_name
FROM Patients;

-- 2. Create a CONCAT output showing full doctor name and department.
SELECT 
CONCAT(first_name, ' ',last_name) AS Full_name,
department
FROM Doctors;

-- 3. CONCAT city with phone number for patient contact display.
SELECT
CONCAT(city,'--',phone) AS patient_contact
FROM Patients;

-- 4. CONCAT visit_id with diagnosis for labeling.
SELECT
CONCAT(visit_id,'-',diagnosis) AS visit_diag
FROM visits;

-- 5. CONCAT doctor_id with department.
SELECT
CONCAT(doctor_id,'-',department) AS doc_department
FROM Doctors;

-- 6. Generate name-like CONCAT(first_name,'.',last_name).
SELECT
CONCAT(first_name,'.',last_name) AS Full_name
FROM Patients;

-- 7. CONCAT city, '-', patient_id into a unique location key.
SELECT
CONCAT(city,'-',patient_id) AS unique_location_key
FROM Patients;

-- 8. CONCAT dosage with medication_name for formatted output.
SELECT
CONCAT(dosage,'-',medication_name) AS dosage_medication_name
FROM Prescriptions;

-- 9. CONCAT full patient name with age.
SELECT
CONCAT(age,' ',CONCAT(first_name,' ',last_name)) AS name_with_age
FROM Patients;

-- 10. CONCAT first letter of first_name and last_name into initials.
SELECT
CONCAT(LEFT(first_name, 1),' ',LEFT(last_name, 1)) AS patient_initial_name
FROM Patients;

--------------------------- UPPER() / LOWER() QUESTIONS ---------------------------

-- 11. Display all doctor names in UPPERCASE.
SELECT 
UPPER(CONCAT(first_name,' ',last_name)) AS Upper_full_name
FROM Doctors;

-- 12. Show all patient cities in LOWERCASE.
SELECT
UPPER(city) AS UPPER_CITY
FROM Patients;

-- 13. Convert diagnosis to UPPERCASE for uniformity.
SELECT
UPPER(diagnosis) AS uppercase_diagnosis
FROM Visits;

-- 14. Convert medication names to LOWERCASE.
SELECT
LOWER(medication_name) AS Lower_medication_name
FROM Prescriptions;

-- 15. Case-insensitive comparison of city names using LOWER.
SELECT
LOWER(city) AS lower_city
FROM Patients;

-- 16. Identify names starting with 'm' using LOWER + LIKE.
SELECT
LOWER(CONCAT(first_name,' ',last_name)) AS Full_name
FROM patients
WHERE LOWER(CONCAT(first_name,' ',last_name)) LIKE 'm%';

-- 17. UPPERCASE only the first letter of diagnosis.
SELECT 
UPPER(LEFT(diagnosis, 1)) + LOWER(SUBSTRING(diagnosis, 2, LEN(diagnosis)-1)) AS Proper_Diagnosis
FROM Visits;
 /*
 Explanation:

1)LEFT(diagnosis, 1) → gets the first character.

2)UPPER(...) → converts first character to uppercase.

3)SUBSTRING(diagnosis, 2, LEN(diagnosis)-1) → gets the rest of the string.

4)LOWER(...) → ensures the rest is lowercase.

5)Concatenate (+) → combines them into a properly capitalized word.
*/

-- 18. Convert entire CONCAT name string into upper case.
SELECT
UPPER(CONCAT(first_name,' ',last_name)) AS Full_name
FROM Patients;
-- 19. Lowercase department names for consistent formatting.
SELECT
LOWER(department) AS LOWER_department
FROM Visits;

-- 20. Convert doctor last names to uppercase.
SELECT 
UPPER(last_name) AS Doc_last_name
FROM Doctors;

--------------------------- TRIM / LTRIM / RTRIM QUESTIONS ---------------------------

-- 21. Trim extra spaces around patient first_name.
SELECT 
TRIM(first_name) AS trim_first_name
FROM Patients;

-- 22. Trim department names for clean formatting.
SELECT
TRIM(department) AS trim_department
FROM Visits;

-- 23. Remove trailing spaces from diagnosis.
SELECT 
LTRIM(diagnosis) AS Ltrim_diagnosis
FROM visits;

-- 24. Trim NULL-safe medication names.
SELECT
TRIM(medication_name) AS trim_medication_name
FROM Prescriptions;

-- 25. Trim phone numbers containing leading spaces.
SELECT
RTRIM(phone) AS trim_phone
FROM Patients;

-- 26. TRIM city name before comparing with 'Chennai'.
SELECT 
TRIM(city) AS trim_city
FROM patients
WHERE city= 'Chennai';

-- 27. Remove left spaces from last_name using LTRIM.
SELECT
LTRIM(last_name) AS last_name
FROM patients;

-- 28. Remove right spaces from first_name using RTRIM.
SELECT
RTRIM(first_name) AS first_name
FROM Patients;

-- 29. Trim spaces from full CONCAT name.
SELECT
TRIM(CONCAT(first_name, ' ',last_name)) AS Full_name
FROM Patients

-- 30. Trim special characters NAMES DOCTORS using TRIM .
SELECT
TRIM(CONCAT(first_name, ' ',last_name)) AS Doc_full_name
FROM Doctors;


--------------------------- REPLACE() QUESTIONS ---------------------------

-- 31. Replace 'Hyderabad' with 'HYD' in city.
SELECT
REPLACE(city,'Hyderabad','HYD') AS city
FROM patients;

-- 32. Replace 'Pain' with 'Issue' in diagnosis.
SELECT
REPLACE (diagnosis,'pain','Issue') AS Diagnosis
FROM Visits;

-- 33. Replace NULL city values with 'UnknownCity' using REPLACE + ISNULL logic.
SELECT 
COALESCE(city, 'UnknownCity') AS city
FROM Patients;


-- 34. Replace  3 TO 2 digits from phone numbers.
SELECT 
REPLACE (phone,'3','2') AS phone
FROM Patients;


-- 35. Replace 'mg' from dosage values.
SELECT
REPLACE(dosage,'mg','') AS dosage
FROM Prescriptions;

-- 36. Replace vowels in first_name with '*'.
SELECT 
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(first_name, 'a', '*'),
                'e', '*'),
            'i', '*'),
        'o', '*'),
    'u', '*') AS first_name_replaced
FROM Patients;

-- 37. Replace multiple spaces in names using nested REPLACE.
SELECT
REPLACE (CONCAT(first_name,' ',last_name),' ',' ') AS full_name
FROM Patients;

-- 38. Replace spaces with underscores in last_name.
SELECT
REPLACE(last_name,'','_') AS Full_name
FROM Patients;

-- 39. Replace all 'a' with '@' in patient names.
SELECT
REPLACE(LOWER(CONCAT(first_name,' ',last_name)), 'a','@') AS patient_name
FROM Patients;

-- 40. Replace 'ology' with 'Dept' in department names.
SELECT
REPLACE(department,'ology','Dept') AS Department
FROM Doctors;


--------------------------- LEN() QUESTIONS ---------------------------

-- 41. Find patients whose first_name length > 4.
SELECT
first_name,
LEN(TRIM(first_name)) AS first_name
FROM Patients
WHERE LEN(TRIM(first_name))> 4;

-- 42. Compare length of first_name and last_name.
SELECT
first_name,
last_name,
LEN(TRIM(first_name)) AS length_first_name,
LEN(TRIM(last_name)) AS length_last_name
FROM
Patients
WHERE LEN(TRIM(first_name)) = LEN(TRIM(last_name));

-- 43. Show medication names where LEN > 6.
SELECT
medication_name,
LEN(TRIM(medication_name)) AS length_medication_name
FROM Prescriptions
WHERE LEN(TRIM(medication_name))> 6;

-- 44. Use LEN to extract second half of diagnosis.
SELECT
    diagnosis,
    SUBSTRING(diagnosis, (LEN(diagnosis) / 2) + 1, LEN(diagnosis)) AS second_half
FROM Visits;


-- 45. Identify doctors whose department name is longer than 5 chars.
SELECT
doctor_id,
CONCAT(first_name,' ',last_name) AS Doc_Full_name,
LEN(TRIM(department)) AS length_of_department
FROM Doctors
WHERE LEN(TRIM(department)) > 5;

-- 46. Filter cities where LEN(city) = 3.
SELECT
city,
LEN(TRIM(city)) AS LEN_city
FROM Patients
WHERE LEN(TRIM(city)) =3;

-- 47. Show phone numbers where LEN < 10.
SELECT
phone,
LEN(TRIM(phone)) AS len_phone
FROM Patients
WHERE LEN(TRIM(phone)) < 10;

-- 48. Check if diagnosis length equals 5.
SELECT
diagnosis,
LEN(TRIM(diagnosis)) AS len_diagnosis
FROM Visits
WHERE LEN(TRIM(diagnosis)) = 5;

-- 49. Calculate length of CONCAT(first_name,last_name).
SELECT
CONCAT(first_name,'',last_name) AS Full_name,
LEN(CONCAT(first_name,'',last_name)) AS lenth_full_name
FROM Patients
-- either query works but more better we dont use spaces

SELECT
    CONCAT(first_name, last_name) AS Full_name,
    LEN(CONCAT(first_name, last_name)) AS length_full_name
FROM Patients;


-- 50. Use LEN to extract last character of city name.
SELECT
city,
RIGHT(city,1) AS city_last_char
FROM Patients
WHERE city IS NOT NULL;

SELECT
    city,
    SUBSTRING(city, LEN(city), 1) AS city_last_char
FROM Patients
WHERE city IS NOT NULL;


--------------------------- LEFT() QUESTIONS ---------------------------

-- 51. Extract LEFT 3 chars from doctor department.
SELECT
department,
LEFT(department, 3) AS Doc_department_exctract
FROM Doctors
WHERE department IS NOT NULL;

-- 52. Get first letter of patient first_name.
SELECT
first_name,
LEFT(first_name,1) AS first_name_extract
FROM Patients;

-- 53. Find names starting with vowel using LEFT.
SELECT
CONCAT(first_name,' ',last_name) AS Full_name,
LEFT(CONCAT(first_name,' ',last_name),1) AS extract_vowel_name
FROM patients
WHERE LOWER(LEFT(CONCAT(first_name,' ',last_name),1)) IN ( 'a','i','e','o','u');


-- 54. Extract LEFT(phone,4).
SELECT
phone,
LEFT(phone, 4) AS extract_phne
FROM Patients;

-- 55. Extract LEFT(city,2) and compare with RIGHT(city,2).
SELECT
city,
LEFT(city,2) AS extract_left_city,
RIGHT(city, 2) AS extract_right_city
FROM Patients
WHERE city IS NOT NULL
AND LEFT(city,2) = RIGHT(city, 2);

-- 56. LEFT-3 ,medication_name with characters using CONCAT.
SELECT
medication_name,
CONCAT(LEFT(medication_name,3),'-',medication_name) AS extract_medication_name
FROM Prescriptions
WHERE medication_name IS NOT NULL;

-- 57. LEFT 5 chars of diagnosis.
SELECT
diagnosis,
LEFT(diagnosis, 5) AS extract_diagnosis
FROM Visits
WHERE diagnosis IS NOT NULL;

-- 58. Compare LEFT(first_name,1) to LEFT(last_name,1).
SELECT
first_name,
last_name,
LEFT(first_name,1) AS first_name_extract,
LEFT(last_name,1) AS last_name_extract
FROM Patients
WHERE LEFT(first_name,1)= LEFT(last_name,1);

-- 59. Create initials with LEFT(first_name,1).
SELECT
first_name,
UPPER(LEFT(first_name,1)) AS initials_first_name
FROM Patients;

-- 60. Filter diagnosis starting with 'H' using LEFT.

SELECT
    diagnosis,
    UPPER(LEFT(diagnosis,1)) AS extract_diag
FROM visits
WHERE UPPER(LEFT(diagnosis,1)) = 'H';


--------------------------- RIGHT() QUESTIONS ---------------------------

-- 61. Extract RIGHT 2 digits of phone numbers.
SELECT
phone,
RIGHT(phone,2) AS Extract_phone
FROM Patients;

-- 62. Show departments ending with 'gy' using RIGHT.
SELECT 
department,
RIGHT(department, 2) AS Extract_department
FROM Visits
WHERE department IS NOT NULL AND RIGHT(department, 2)= 'gy';

-- 63. Extract RIGHT(city,3).
SELECT
city,
RIGHT(city, 3) AS extract_city
FROM Patients
WHERE city IS NOT NULL;

-- 64. Extract RIGHT(last_name,2).
SELECT
last_name,
RIGHT(last_name,2) AS last_name_extract
FROM Patients;

-- 65. Extract last character of diagnosis using RIGHT.
SELECT
diagnosis,
RIGHT(diagnosis,1) AS extract_last_char_diag
FROM Visits
WHERE diagnosis IS NOT NULL;


-- 66. Compare RIGHT(city,1) with vowel list.
SELECT
city,
RIGHT(city,1) AS city_right_extract
FROM Patients
WHERE RIGHT(city,1) IN ( 'a','i','e','o','u');

-- 67. RIGHT-3 department short codes.
SELECT
department,
RIGHT(department,3) AS extract_department_right
FROM Visits
WHERE department IS NOT NULL;

-- 68. Extract RIGHT(first_name, LEN(first_name)-1).
SELECT 
first_name,
RIGHT(first_name,LEN(first_name)-1) AS extract__char
FROM Patients;


-- 69. Extract last 3 letters of medication_name.
SELECT
medication_name,
RIGHT(medication_name, 3) AS Extract_last_3
FROM Prescriptions;

-- 70. Identify cities ending with 'i' using RIGHT.
SELECT
city,
RIGHT(city,1) AS last_ending_with_i
FROM Patients
WHERE RIGHT(city,1)='i';

--------------------------- SUBSTRING() QUESTIONS ---------------------------

-- 71. Extract month from visit_date using SUBSTRING.
SELECT
    visit_date,
    SUBSTRING(CONVERT(VARCHAR(10), visit_date, 120), 6, 2) AS extract_month
FROM Visits;


-- 72. Extract middle character from first_name.
SELECT
first_name,
SUBSTRING(first_name,LEN(first_name)/2+1,1) AS extract_middle_char
FROM Patients;

-- 73. Extract numeric part from dosage.
SELECT LEFT(dosage,LEN(dosage)-2) FROM Prescriptions;-- i wrote only with left function
SELECT
dosage,
SUBSTRING(LEFT(dosage,LEN(dosage)-2), 1, 3) AS substring_extraction_numeric-- this one with substring wrong
FROM Prescriptions;

SELECT
    dosage,
    SUBSTRING(dosage, 1, LEN(dosage)-2) AS numeric_part-- correct one using substring
FROM Prescriptions;

-- 74. SUBSTRING last_name from 2nd char to 4 chars.
SELECT
first_name,
SUBSTRING(last_name, 2, 3) AS Character_first_name
FROM Patients;

-- 75. Extract only the first word of diagnosis.
SELECT
diagnosis,
SUBSTRING(diagnosis, 1,1) AS first_word_diag-- wrong query
FROM Visits
WHERE diagnosis IS NOT NULL;

SELECT
    diagnosis,
    SUBSTRING(diagnosis, 1, CHARINDEX(' ', diagnosis + ' ') - 1) AS first_word-- correct query
FROM Visits;


-- 76. Extract year from visit_date.
SELECT
YEAR(visit_date) AS extract_year,
visit_date
FROM Visits;
-- 77. Extract first 2 letters prefix from CONCAT name.
SELECT
CONCAT(first_name,' ',last_name) AS Full_name,
SUBSTRING(CONCAT(first_name,' ',last_name),1 ,2) AS extract_2char_fullname
FROM Patients;

-- 78. Extract second half of medication_name.
SELECT
medication_name,
RIGHT(medication_name,LEN(medication_name)/2) AS extract_lasthalf
FROM Prescriptions;

SELECT
medication_name,
SUBSTRING(RIGHT(medication_name,LEN(medication_name)/2), 1, 100) AS extract_lasthalf
FROM Prescriptions;

-- 79. Extract 'Cardio' from 'Cardiology'.
SELECT
department,
LEFT(department,LEN(department)-4) AS extract_department
FROM Visits;

SELECT 
department,
SUBSTRING(LEFT(department,LEN(department)-4),1,100) AS extract_department
FROM Visits
WHERE department ='Cardiology';

-- 80. Extract characters from position 3–7 in city.
SELECT
city,
SUBSTRING(city,3,5) AS extract_city
FROM Patients;

---- 50 interview style questions
-- 1. Write a query to get patients whose trimmed first_name length (using TRIM + LEN) is more than 6 and convert it to uppercase.
SELECT
first_name,
LEN(TRIM(first_name)) AS len_of_first_name,
UPPER(first_name) AS upper_case_letters
FROM Patients
WHERE LEN(TRIM(first_name))> 6;

-- 2. Fetch doctor names where LEFT(first_name, 2) equals RIGHT(last_name, 2), ignoring case using LOWER().
SELECT
CONCAT(first_name,' ',last_name) AS Full_name,
LEFT(first_name,2) AS first_name_starting_char,
RIGHT(last_name,2) AS last_name_ending_char------- wrong query
FROM Doctors
WHERE LOWER(LEFT(first_name,2))= LOWER(RIGHT(last_name,2)); 

SELECT
    first_name,
    last_name,
    LEFT(first_name,2) AS first_name_starting_char,-- correct query
    RIGHT(last_name,2) AS last_name_ending_char
FROM Doctors
WHERE LOWER(LEFT(first_name,2)) = LOWER(RIGHT(last_name,2));


-- 3. From Patients, concatenate UPPER(first_name) and LOWER(last_name) with a hyphen between them.
SELECT
CONCAT(first_name,' ',last_name) AS full_name,
CONCAT(UPPER(first_name),'-',LOWER(last_name)) AS full_name_concat
FROM 
Patients;

-- 4. Return visits where department name after TRIM and UPPER begins with 'CA'.
SELECT
department,
TRIM((UPPER(LEFT(department,2))+RIGHT(department,LEN(department)-2))) AS department_visit
FROM Visits
WHERE UPPER(department)LIKE 'CA%';

SELECT
    department,
    TRIM(UPPER(department)) AS department_trim_upper
FROM Visits
WHERE UPPER(LTRIM(RTRIM(department))) LIKE 'CA%';


-- 5. Find patients whose REPLACE(first_name, 'a', '*') still contains more than 5 characters using LEN().
SELECT
first_name,
LEN(REPLACE(first_name,'a','*')) AS first_name_char
FROM Patients
WHERE LEN(REPLACE(first_name,'a','*'))> 5;

-- 6. Display prescriptions where SUBSTRING(medication_name, 1, 3) matches 'met' ignoring case with LOWER().
SELECT
medication_name,
LOWER(SUBSTRING(medication_name,1,3)) AS extract_medication_name
FROM Prescriptions
WHERE LOWER(SUBSTRING(medication_name,1,3)) ='met';

-- 7. Select doctors where LTRIM(RTRIM(first_name)) equals CONCAT(LEFT(last_name,3), RIGHT(last_name,2)).
SELECT 
first_name,
LTRIM(RTRIM(first_name)) AS trim_first_name,
CONCAT(LEFT(last_name,3),RIGHT(last_name,2)) AS concat_last_name
FROM Doctors
WHERE LTRIM(RTRIM(first_name))= CONCAT(LEFT(last_name,3),RIGHT(last_name,2));

-- 8. Retrieve patient records where first_name after REPLACE vowels → '' still starts with ''.

SELECT
first_name,
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(first_name,'a',''),'e',''),'i',''),'o',''),'u','') AS extract_first_name
FROM Patients;

SELECT
    first_name,
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(first_name,'a',''),'e',''),'i',''),'o',''),'u','') AS no_vowels
FROM Patients
WHERE LEFT(
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(first_name,'a',''),'e',''),'i',''),'o',''),'u',''), 1-- correct query
) <> '';


-- 9. Show visits where department name converted to LOWER ends with RIGHT(patient_NAME, 2).


SELECT
    CONCAT(p.first_name,' ',p.last_name) AS Full_name,
    v.department
FROM Visits v
JOIN Patients p
    ON v.patient_id = p.patient_id
WHERE RIGHT(LOWER(v.department), 2) =
      RIGHT(LOWER(CONCAT(p.first_name, p.last_name)), 2);



-- 10. Filter patients where CONCAT(first_name, last_name) has more than 2 characters after removing spaces with REPLACE().
SELECT
CONCAT(first_name,' ',last_name) AS Full_name,
LEN(REPLACE(CONCAT(first_name,' ',last_name),' ','')) AS lenght_of_char
FROM Patients
WHERE 
LEN(REPLACE(CONCAT(first_name,' ',last_name),' ','')) > 2;

-- 11. Select prescriptions where medication_name after TRIM contains 'XR' and its LEN is < 8.
SELECT
medication_name,
LEN(TRIM(medication_name)) AS medi_name_length
FROM Prescriptions
WHERE (medication_name IS NOT NULL)
AND (UPPER(medication_name) LIKE '%XR%' AND LEN(TRIM(medication_name))< 8);

-- 12. Find doctors whose first three letters of department (SUBSTRING + UPPER) match 'CAR'.
SELECT
department,
UPPER(SUBSTRING(department,1,3)) AS extract_department
FROM Doctors
WHERE UPPER(SUBSTRING(department,1,3)) ='CAR';

-- 13. Return patients where LEFT(TRIM(city),1) is equal to UPPER(RIGHT(city,1)).
SELECT
city,
LEFT(TRIM(city),1) AS city_left,
UPPER(RIGHT(city,1)) AS upper_city_char
FROM Patients
WHERE UPPER(LEFT(TRIM(city),1))= UPPER(RIGHT(city,1));


-- 14. Getdoctors names in which doctor_NAME length > 9 after removing spaces using REPLACE(NAME,' ','').
SELECT
first_name,
last_name,
CONCAT(first_name,' ',last_name) AS Full_name,
LEN(REPLACE(CONCAT(first_name,' ',last_name),' ','')) AS lenght_of_char
FROM Doctors
WHERE LEN(REPLACE(CONCAT(first_name,' ',last_name),' ','')) >9;


-- 15. Identify patients whose LOWER(first_name) equals REPLACE(LOWER(last_name),'a','').
SELECT
first_name,
last_name,
LOWER(first_name) AS first_name_lower,
REPLACE(LOWER(last_name),'a','') AS replace_char
FROM Patients
WHERE LOWER(first_name) = REPLACE(LOWER(last_name),'a','');

-- 16. Fetch prescriptions where RIGHT(medication_name,4) replaced with 'XXXX' equals LEFT(medication_name,4).
SELECT 
    medication_name,
    REPLACE(medication_name, RIGHT(medication_name,4), 'XXXX') AS replaced_value,
    LEFT(medication_name,4) AS left_value
FROM Prescriptions
WHERE medication_name LIKE CONCAT(LEFT(medication_name,4),'%');


-- 17. Show doctors where LEN(LTRIM(name)) + LEN(RTRIM(department)) > 15.

SELECT
    CONCAT(first_name, last_name) AS Full_name,
    department,
    LEN(LTRIM(CONCAT(first_name,last_name))) AS len_name,
    LEN(RTRIM(department)) AS len_department
FROM Doctors
WHERE LEN(LTRIM(CONCAT(first_name,last_name))) 
    + LEN(RTRIM(department)) > 15;



-- 18. Retrieve patients where SUBSTRING(first_name,2,3) equals SUBSTRING(last_name,1,3) in lowercase.
SELECT
first_name,
last_name,
LOWER(SUBSTRING(first_name,2,3)) AS substring_first_name,
LOWER(SUBSTRING(last_name,1,3)) AS substring_last_name
FROM Patients
WHERE LOWER(SUBSTRING(first_name,2,3))= LOWER(SUBSTRING(last_name,1,3));

-- 19. Display visits where department after TRIM and REPLACE('-', '') starts with 'Neuro'.
SELECT
department,
TRIM(REPLACE(department,'-','')) AS trim_department
FROM Visits
WHERE TRIM(REPLACE(department,'-','')) LIKE 'Neuro%';

-- 20. Filter patients where CONCAT(LEFT(first_name,1), RIGHT(last_name,1)) equals 'AK'.
SELECT
first_name,
last_name,
CONCAT(LEFT(first_name,1), RIGHT(last_name,1)) AS Concat_full_name
FROM Patients
WHERE UPPER(CONCAT(LEFT(first_name,1), RIGHT(last_name,1))) ='AK'

-- 21. Show prescriptions where UPPER(REPLACE(medication_name,'-','')) contains 'SR'.
SELECT
medication_name,
UPPER(REPLACE(medication_name,'-','')) AS upper_medication_name
FROM Prescriptions
WHERE UPPER(REPLACE(medication_name,'-','')) LIKE '%SR%';

-- 22. Select doctor names where LEN(TRIM(CONCAT(first_name,last_name))) < 10.
SELECT
first_name,
last_name,
LEN(TRIM(CONCAT(first_name,last_name))) AS len_full_name
FROM Doctors
WHERE LEN(TRIM(CONCAT(first_name,last_name)))< 10;

-- 23. Return patients where first_name and last_name after LOWER match except the first character.
SELECT
first_name,
last_name,
LOWER(SUBSTRING(first_name, 2, 100)) AS first_name_substring,
LOWER(SUBSTRING(last_name, 2, 100)) AS last_name_substring
FROM Patients
WHERE LOWER(SUBSTRING(first_name, 2, 100)) = LOWER(SUBSTRING(last_name, 2, 100));

-- 24. List visits where SUBSTRING(department,1,1) = SUBSTRING(CONCAT('X',doctor_id),1,1).
SELECT
department,
doctor_id,
SUBSTRING(department,1,1) AS department_substring,
SUBSTRING(CONCAT('X',doctor_id),1,1) AS doctor_id_substring
FROM Visits
WHERE SUBSTRING(department,1,1) = SUBSTRING(CONCAT('X',doctor_id),1,1);

-- 25. Show patients whose first_name after REPLACE vowels with '' has LEN < 3.
SELECT
first_name,
LEN(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(first_name,'a',''), 'e',''), 'i',''), 'o',''), 'u',''))) AS len_first_name
FROM Patients
WHERE
LEN(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(first_name,'a',''), 'e',''), 'i',''), 'o',''), 'u',''))) < 3;




-- 26. Retrieve prescriptions where LEFT(medication_name,2) = LOWER(RIGHT(medication_name,2)).
SELECT 
medication_name,
LOWER(LEFT(medication_name,2)) AS left_medication_name,
LOWER(RIGHT(medication_name,2)) AS right_medication_name
FROM Prescriptions
WHERE medication_name IS NOT NULL AND
LOWER(LEFT(medication_name,2))= LOWER(RIGHT(medication_name,2));

-- 27. Find doctors where last_name after UPPER and TRIM contains the first_name's last 2 letters.
SELECT
first_name,
last_name,
UPPER(TRIM(last_name)) AS upper_last_name,
UPPER(RIGHT(first_name, 2)) Upper_first_name_char
FROM Doctors
WHERE UPPER(TRIM(last_name)) LIKE '% UPPER(RIGHT(first_name, 2))%';-- this basicalyy searches for text correct version is below

SELECT
    first_name,
    last_name
FROM Doctors
WHERE UPPER(TRIM(last_name)) LIKE CONCAT('%', UPPER(RIGHT(first_name,2)), '%');


-- 28. Select patients where city with spaces removed begins with RIGHT(name,2).
SELECT
city,
CONCAT(first_name,'',last_name) AS Full_name,
TRIM(city) AS trim_city,
RIGHT(CONCAT(first_name,'',last_name),2) + TRIM(city) AS name_city-- this is wrong
FROM Patients 
WHERE city IS NOT NULL;

SELECT
    city,
    CONCAT(first_name,last_name) AS Full_name,
    REPLACE(city,' ','') AS city_no_space,
    RIGHT(CONCAT(first_name,last_name),2) AS last2-- this is correct
FROM Patients
WHERE REPLACE(city,' ','') LIKE CONCAT(
        RIGHT(CONCAT(first_name,last_name),2), '%'
      );


-- 29. Display visits where doctor_name after LOWER and REPLACE('.', '') ends with 'urgent'.
SELECT 
CONCAT(first_name,'',last_name) AS Full_name,
LOWER(REPLACE(CONCAT(first_name,'',last_name),'.','')) AS replace_fullname 
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id = d.doctor_id
WHERE LOWER(REPLACE(CONCAT(first_name,'',last_name),'.','')) LIKE '%urgent';

-- 30. Return prescriptions where medication_name reversed manually using SUBSTRING + LEN logic (concept test).
SELECT
    medication_name,
    REVERSE(medication_name) AS reversed_builtin,   -- built-in
    SUBSTRING(medication_name, LEN(medication_name), 1) +
    SUBSTRING(medication_name, LEN(medication_name)-1, 1) +
    SUBSTRING(medication_name, LEN(medication_name)-2, 1) +
    SUBSTRING(medication_name, LEN(medication_name)-3, 1)
    AS reverse_manual
FROM Prescriptions;

-- 31. Fetch patients where CONCAT(LEFT(first_name,2), RIGHT(last_name,2)) equals SUBSTRING(city,1,4).
SELECT
first_name,
last_name,
city,
CONCAT(LEFT(first_name,2), RIGHT(last_name,2)) AS concat_name,
SUBSTRING(city,1,4) AS substring_city
FROM Patients
WHERE city IS NOT NULL AND
CONCAT(LEFT(first_name,2), RIGHT(last_name,2)) = SUBSTRING(city,1,4);



-- 32. Show doctors whose trimmed first_name length equals the length of department minus 2.
SELECT
first_name,
department,
LEN(TRIM(LOWER(first_name))) AS first_name_len,
LEN(TRIM(LOWER(department)))-2 AS department_len
FROM Doctors
WHERE department IS NOT NULL
AND LEN(TRIM(LOWER(first_name))) = LEN(TRIM(LOWER(department)))-2;


-- 33. Select prescriptions where medication_name after TRIM and UPPER starts with REPLACE(dosage,'mg','').

SELECT
medication_name,
dosage,
TRIM(UPPER(medication_name)) AS trim_upper_medication_name,
REPLACE(dosage,'mg','') replace_dosage,
CONCAT(REPLACE(dosage,'mg',''),'',TRIM(UPPER(medication_name))) AS trim_start_full
FROM Prescriptions
WHERE medication_name IS NOT NULL AND dosage IS NOT NULL;

--corrected version

SELECT
    medication_name,
    dosage,
    TRIM(UPPER(medication_name)) AS trim_upper_medication_name,
    REPLACE(dosage,'mg','') AS num_dosage
FROM Prescriptions
WHERE 
    medication_name IS NOT NULL 
    AND dosage IS NOT NULL
    AND TRIM(UPPER(medication_name))
        LIKE CONCAT(REPLACE(dosage,'mg',''), '%');


-- 34. List patients where SUBSTRING(phone, LEN(phone)-3, 4) equals '9999'.
SELECT
phone,
SUBSTRING(phone, LEN(phone)-3, 4) AS substring_phone
FROM Patients
WHERE SUBSTRING(phone, LEN(phone)-3, 4) ='9999';

-- 35. Return visits where LOWER(department) contains LEFT(patient_name,3).
SELECT
CONCAT(p.first_name,'',p.last_name) AS Full_name,
v.department,
LOWER(v.department) AS Lower_department,
LEFT(CONCAT(p.first_name,'',p.last_name),3) AS left_3_name_patient
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id= p.patient_id
WHERE department IS NOT NULL AND 
LOWER(v.department) = LEFT(CONCAT(p.first_name,'',p.last_name),3);

-- coorect version

SELECT
    CONCAT(p.first_name,'',p.last_name) AS Full_name,
    v.department,
    LOWER(v.department) AS lower_department,
    LEFT(CONCAT(p.first_name,'',p.last_name),3) AS left_3_name
FROM Visits v
LEFT JOIN Patients p
ON v.patient_id = p.patient_id
WHERE v.department IS NOT NULL
  AND LOWER(v.department) LIKE '%' + LEFT(CONCAT(p.first_name,'',p.last_name),3) + '%';



-- 36. Filter doctors whose last_name after REPLACE vowels → '' has the same LEN as first_name.
SELECT
first_name,
last_name,
LEN(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(last_name,'a',''), 'e',''), 'i',''), 'o',''), 'u',''))) AS len_last_name,
LEN(LOWER(first_name)) AS len_first_name
FROM Doctors
WHERE
LEN(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(last_name,'a',''), 'e',''), 'i',''), 'o',''), 'u','')))= LEN(LOWER(first_name));

-- 37. Show patients where first_name and last_name after LTRIM + RTRIM concatenation ends with 'an'.
SELECT
first_name,
last_name,
RTRIM(LTRIM(CONCAT(first_name,'',last_name))) AS Full_name
FROM Patients
WHERE LOWER(RTRIM(LTRIM(CONCAT(first_name,'',last_name)))) LIKE '%an';

-- 38. Get prescriptions where RIGHT(UPPER(medication_name),3) equals 'HCL'.
SELECT
medication_name,
RIGHT(UPPER(medication_name),3) AS right_upper_medication_name
FROM Prescriptions
WHERE medication_name IS NOT NULL AND  RIGHT(UPPER(medication_name),3)='HCL';

-- 39. Retrieve visits where TRIM(department) length is NOT equal to RIGHT(visit_id,1).
SELECT
department,
LEN(TRIM(department)) AS LEN_Trim_department,
RIGHT(visit_id,1) AS visit_id
FROM Visits
WHERE department IS NOT NULL
AND LEN(TRIM(department)) != RIGHT(visit_id,1);

/* RIGHT(visit_id,1) returns a string, not a number.
Better to CAST.
*/
-- Corrected:
SELECT
    department,
    LEN(TRIM(department)) AS dept_len,
    RIGHT(visit_id,1) AS last_digit
FROM Visits
WHERE department IS NOT NULL
  AND LEN(TRIM(department)) != CAST(RIGHT(visit_id,1) AS INT);
-- 40. Select patients where city converted to LOWER begins with the same three letters as name.
SELECT
CONCAT(first_name,'',last_name) AS Full_name,
city,
LEFT(LOWER(city),3) AS lower_left_city_3,
LEFT((LOWER(CONCAT(first_name,'',last_name))),3) AS lower_left_name_3
FROM Patients
WHERE city IS NOT NULL
AND LEFT(LOWER(city),3)= LEFT((LOWER(CONCAT(first_name,'',last_name))),3);

-- 41. Display doctors where LEFT(UPPER(first_name),1) = RIGHT(LOWER(last_name),1).
SELECT 
first_name,
last_name,
LEFT(UPPER(first_name),1) AS Left_upper_name,
RIGHT(LOWER(last_name),1) AS right_lower_name
FROM Doctors
WHERE LEFT(UPPER(first_name),1)= RIGHT(LOWER(last_name),1);

-- 42. Show patients where REPLACE(city,'a','') still contains 'pur'.
SELECT
city,
REPLACE(city,'a','') AS city_replace---wrong query
FROM Patients
WHERE REPLACE(city,'a','') ='pur';

SELECT
    city,
    REPLACE(city,'a','') AS city_replace ---correct query
FROM Patients
WHERE REPLACE(LOWER(city),'a','') LIKE '%pur%';


-- 43. Return visits where SUBSTRING(doctor_name,1,5) after TRIM = 'check'.
SELECT
CONCAT(first_name,'',last_name) AS Full_name,
SUBSTRING(TRIM(CONCAT(first_name,'',last_name)), 1,5) AS Trim_names
FROM Doctors
WHERE SUBSTRING(TRIM(CONCAT(first_name,'',last_name)), 1,5)='check';

-- 44. Select prescriptions where medication_name without spaces (REPLACE) starts with LEFT(medication_name,2).
SELECT
medication_name,
REPLACE(medication_name,' ','') AS replace_medication_name_xtraspace,---wrong query
LEFT(medication_name,2) AS left_medication_name
FROM Prescriptions
WHERE medication_name IS NOT NULL
AND REPLACE(medication_name,' ','') != LEFT(medication_name,2);

SELECT
    medication_name,
    REPLACE(medication_name,' ','') AS medication_clean,---correct query
    LEFT(medication_name,2) AS left_medication_name
FROM Prescriptions
WHERE
    LEFT(REPLACE(medication_name,' ',''),
         2) = LEFT(medication_name,2);



-- 45. Fetch doctors whose department after REPLACE('Dept',' ','') matches TRIM(departent).
SELECT 
department,
REPLACE(department,' ','') AS replace_department,
TRIM(department) AS Trim_department
FROM Doctors
WHERE department IS NOT NULL
AND REPLACE(department,' ','')= TRIM(department);



-- 46. Identify patients where first_name's last three letters equal REPLACE(last_name,'a','') first three letters.
SELECT
first_name,
last_name,
RIGHT(first_name,3) AS Right_first_name,
LEFT(REPLACE(last_name,'a',''),3) AS Left_last_name
FROM Patients
WHERE LOWER(RIGHT(first_name,3))= LOWER(LEFT(REPLACE(last_name,'a',''),3));

-- 47. Retrieve visits where UPPER(department) contains LEFT(CONCAT('x',doctor_id),1).
SELECT 
v.department,
UPPER(v.department) AS upper_department,
d.doctor_id,
LEFT(CONCAT('X',d.doctor_id),1) AS doctor_id_LEFT--------wrong query
FROM Visits v
LEFT JOIN Doctors d
ON v.doctor_id= d.doctor_id
WHERE v.department IS NOT NULL AND
UPPER(v.department)= LEFT(CONCAT('X',d.doctor_id),1);

SELECT 
    v.department,
    UPPER(v.department) AS upper_department,
    d.doctor_id,
    LEFT(CONCAT('X', d.doctor_id),1) AS doctor_id_LEFT-----correct query
FROM Visits v
LEFT JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE UPPER(LEFT(v.department,1)) = LEFT(CONCAT('X', d.doctor_id),1);



-- 48. Show prescriptions where LEN(REPLACE(medication_name,'-','')) = LEN(medication_name) - 1.
SELECT
medication_name,
LEN(REPLACE(medication_name,'-','')) AS medication_name_replace,
(LEN(medication_name)) - 1 AS medication_name_2
FROM Prescriptions
WHERE medication_name IS NOT NULL AND
LEN(REPLACE(medication_name,'-',''))= (LEN(medication_name)) - 1

-- 49. Select patients where CONCAT(first_name,last_name) ends with RIGHT(city,2).L
SELECT
    first_name,
    last_name,
    city,
    CONCAT(first_name,' ',last_name) AS Full_name
FROM Patients
WHERE city IS NOT NULL
  AND RIGHT(CONCAT(first_name,' ',last_name), 2) = RIGHT(city,2);


-- 50. Fetch visits where SUBSTRING(doctor_notes,5,3) after LOWER equals RIGHT(department,3).

SELECT 
    d.first_name,
    d.last_name,
    SUBSTRING(CONCAT(d.first_name,'',d.last_name),5,3) AS name_sub,
    RIGHT(v.department,3) AS dept_sub
FROM Visits v
LEFT JOIN Doctors d
    ON v.doctor_id = d.doctor_id
WHERE LOWER(SUBSTRING(CONCAT(d.first_name,'',d.last_name),5,3))
      = LOWER(RIGHT(v.department,3));
