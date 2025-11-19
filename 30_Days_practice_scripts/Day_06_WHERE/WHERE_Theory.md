# COMPLETE EXPLANATION OF WHERE (FILTERING DATA) IN SQL
(Microsoft SQL Server — FULL NOTES)

## What is the WHERE Clause:

The WHERE clause is used to filter rows from a table based on certain conditions.

**It works in SELECT, UPDATE, DELETE.**

Example:
SELECT * FROM patients
WHERE age > 30;

## Comparison Operators:
Used to compare values.

Operator	Meaning:
1) **=	Equal to**
2) **<> or !=	Not equal**
3) **>	Greater than**
4) **<	Less than**
5) **>=	Greater than or equal**
6) **<=	Less than or equal**

Example:
SELECT * FROM patients
WHERE age >= 50;

## Logical Operators:

Used to combine multiple conditions.

**AND:** 
**All conditions must be TRUE.**

SELECT * FROM patients
WHERE city = 'Hyderabad' AND age > 40;

**OR:**
**At least one condition is TRUE.**

SELECT * FROM patients
WHERE city = 'Hyderabad' OR city = 'Chennai';

**NOT:**
**Negates a condition.**

SELECT * FROM patients
WHERE NOT city = 'Delhi';

## Range Filtering — BETWEEN:

Checks if value is inside a range (inclusive).

SELECT * FROM patients
WHERE age BETWEEN 30 AND 50;

**Same as:**

age >= 30 AND age <= 50

## Set Filtering — IN / NOT IN:

**Checks if a value is in a list.**

SELECT * FROM doctors
WHERE department IN ('Cardiology','Neurology');

Exclude:
WHERE city NOT IN ('Hyderabad','Delhi');

## Pattern Matching — LIKE:

Used to match patterns in text.

**1) Starts with:**
first_name LIKE 'A%'

**2) Ends with:**
last_name LIKE '%n'

**3) Contains:**
city LIKE '%ra%'

**4) Single character wildcard:**
first_name LIKE '_a%'

## NULL Handling — IS NULL / IS NOT NULL:

Because NULL means unknown, comparison operators don’t work.

SELECT * FROM patients
WHERE phone IS NULL;

SELECT * FROM patients
WHERE phone IS NOT NULL;

## Combined Conditions (Advanced Filtering):

Multiple AND + OR. 
Use parentheses to avoid confusion.

SELECT * FROM patients
WHERE (city = 'Chennai' OR city = 'Mumbai')
AND age > 40;

## Case-Insensitive Filtering:

SQL Server by default is case-insensitive, but you can force lower/upper:

WHERE LOWER(first_name) = 'ram'

## Filter Calculated / Derived Values:

SELECT first_name, LEN(first_name) AS name_length
FROM patients
WHERE LEN(first_name) > 5;

## Date Filtering

SELECT * FROM visits
WHERE visit_date >= '2024-01-01';

**Range:**

SELECT * FROM visits
WHERE visit_date BETWEEN '2024-03-01' AND '2024-04-30';

## Filtering With Functions
Examples:
1) LEN(), 
2) UPPER(),
3) LOWER(),
4) CAST(),
5) CONVERT()
 
SELECT * FROM prescriptions
WHERE LEN(medication_name) > 5;

## WHERE Cannot Be Used With Aggregates
You cannot filter aggregates (COUNT, SUM…) in WHERE.

**Wrong:**
SELECT department, COUNT(*)
FROM doctors
WHERE COUNT(*) > 5;

**Correct: use HAVING**
SELECT department, COUNT(*)
FROM doctors
GROUP BY department
HAVING COUNT(*) > 5;

## Filtering With Multiple Data Types

**Filtering text:**
WHERE department = 'Cardiology'.

**Filtering numbers:**
WHERE age >= 45.

**Filtering dates:**
WHERE appointment_date < '2024-06-01'.

## WHERE in UPDATE and DELETE
**UPDATE:**

UPDATE patients
SET age = age + 1
WHERE city = 'Hyderabad';


**DELETE:**

DELETE FROM visits
WHERE visit_id < 10;

## Summary Table
1) Concept	Example.
2) Comparison	age > 30.
3) Logical	age > 30 AND city = 'Hyd'.
4) LIKE	name LIKE 'A%'.
5) IN	city IN ('Hyd','Chennai').
6) BETWEEN	age BETWEEN 20 AND 40.
7) NULL	phone IS NULL.

## Final Notes
1) The WHERE clause is the heart of SQL filtering.
2) Almost 70% of all SQL problems use WHERE.
3) WHERE helps select the exact data you want.
4) Works with text, numbers, dates, NULL.
5) Supports patterns, ranges, lists, logic.
6) Becomes powerful when combined with functions.

