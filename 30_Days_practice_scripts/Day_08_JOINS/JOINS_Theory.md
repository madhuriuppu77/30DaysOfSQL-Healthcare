 SQL JOINS 
---------------------------------------------------------
JOINS are used to combine data from two or more tables
based on a related column (usually a key).

In real databases, data is split across tables.
JOINS help us reconstruct meaningful information.

JOINS are extremely important for:
- Reports
- Analytics
- Real-world SQL projects
- Interviews



KEY CHARACTERISTICS OF JOINS
---------------------------------------------------------
- Combine rows from multiple tables
- Based on a join condition (ON)
- Can return matching, non-matching, or all rows
- Incorrect joins cause duplicates or data loss
- NULL handling is very important in joins



COMMONLY USED TABLES (EXAMPLE)
=================================================

patients
-------------------------------------------------
patient_id | name   | gender
1          | Ramesh | M
2          | Sita   | F
3          | Anil   | M
4          | Meena  | F

visits
-------------------------------------------------
visit_id | patient_id | department
101      | 1          | ENT
102      | 1          | Cardio
103      | 2          | Ortho
104      | 5          | Neuro



TYPES OF SQL JOINS
=================================================
1) INNER JOIN
2) LEFT JOIN (LEFT OUTER JOIN)
3) RIGHT JOIN (RIGHT OUTER JOIN)
4) FULL OUTER JOIN
5) CROSS JOIN
6) SELF JOIN
7) ANTI JOIN (Logical pattern)



---------------------------------------------------------
1) INNER JOIN
---------------------------------------------------------
INNER JOIN returns ONLY matching rows
from both tables.

Syntax:

    SELECT columns
    FROM A
    INNER JOIN B
    ON A.key = B.key;

Example:

    SELECT p.name, v.department
    FROM patients p
    INNER JOIN visits v
    ON p.patient_id = v.patient_id;

Explanation:

- Rows must exist in BOTH tables
- Unmatched rows are excluded
- Most commonly used join



---------------------------------------------------------
2) LEFT JOIN (LEFT OUTER JOIN)
---------------------------------------------------------
LEFT JOIN returns:
- ALL rows from LEFT table
- Matching rows from RIGHT table
- Unmatched RIGHT rows become NULL

Syntax:

    SELECT columns
    FROM A
    LEFT JOIN B
    ON A.key = B.key;

Example:

    SELECT p.name, v.department
    FROM patients p
    LEFT JOIN visits v
    ON p.patient_id = v.patient_id;

Explanation:

- Patients without visits are still shown
- department becomes NULL for them
- Very useful for reports



---------------------------------------------------------
3) RIGHT JOIN (RIGHT OUTER JOIN)
---------------------------------------------------------
RIGHT JOIN returns:
- ALL rows from RIGHT table
- Matching rows from LEFT table
- Unmatched LEFT rows become NULL

Syntax:

    SELECT columns
    FROM A
    RIGHT JOIN B
    ON A.key = B.key;

Example:

    SELECT p.name, v.department
    FROM patients p
    RIGHT JOIN visits v
    ON p.patient_id = v.patient_id;

Explanation:

- Same as LEFT JOIN but reversed
- Rarely used in practice
- LEFT JOIN is preferred (flip tables instead)



---------------------------------------------------------
4) FULL OUTER JOIN
---------------------------------------------------------
FULL JOIN returns:
- ALL rows from BOTH tables
- Matching rows are combined
- Unmatched rows from either side show NULLs

Syntax:

    SELECT columns
    FROM A
    FULL OUTER JOIN B
    ON A.key = B.key;

Example:

    SELECT p.name, v.department
    FROM patients p
    FULL OUTER JOIN visits v
    ON p.patient_id = v.patient_id;

Explanation:

- Shows complete picture
- Used for reconciliation and audits
- Heavy and slow on large datasets



---------------------------------------------------------
5) CROSS JOIN
---------------------------------------------------------
CROSS JOIN returns Cartesian Product
(every row from A × every row from B)

Syntax:

    SELECT columns
    FROM A
    CROSS JOIN B;

Example:

    SELECT p.name, v.department
    FROM patients p
    CROSS JOIN visits v;

Explanation:

- If A has 4 rows and B has 4 rows → 16 rows
- No ON condition
- Very dangerous on large tables

Use cases:
- Generating combinations
- Testing
- Date/number expansions



---------------------------------------------------------
6) SELF JOIN
---------------------------------------------------------
SELF JOIN is joining a table with itself.

Syntax:

    SELECT columns
    FROM table A
    JOIN table B
    ON condition;

Example: Patients living in same city

    SELECT a.name AS Patient1, b.name AS Patient2, a.city
    FROM patients a
    JOIN patients b
    ON a.city = b.city
    AND a.patient_id <> b.patient_id;

Explanation:

- Same table used twice with aliases
- Useful for hierarchy, comparison, duplicates



---------------------------------------------------------
7) ANTI JOIN (VERY IMPORTANT)
---------------------------------------------------------
ANTI JOIN returns rows from LEFT table
that have NO matching rows in RIGHT table.

There is NO direct keyword for Anti Join.
It is implemented logically.

Method 1: LEFT JOIN + IS NULL
--------------------------------
Example: Patients with NO visits

    SELECT p.name
    FROM patients p
    LEFT JOIN visits v
    ON p.patient_id = v.patient_id
    WHERE v.patient_id IS NULL;

Method 2: NOT EXISTS (BEST PRACTICE)
-----------------------------------

    SELECT p.name
    FROM patients p
    WHERE NOT EXISTS (
        SELECT 1
        FROM visits v
        WHERE v.patient_id = p.patient_id
    );

Explanation:

- Used to find missing data
- Very common interview question
- NOT EXISTS is NULL-safe and preferred



---------------------------------------------------------
WHERE vs ON (CRITICAL CONCEPT)
---------------------------------------------------------
Execution order (simplified):
FROM → JOIN (ON) → WHERE → SELECT

Rule:
- ON controls matching
- WHERE filters rows



---------------------------------------------------------
EASY RULES TO REMEMBER (YOUR UNDERSTANDING)
---------------------------------------------------------
1) LEFT JOIN + WHERE on RIGHT table
   → KILLS LEFT JOIN (acts like INNER JOIN)

Example:

    SELECT *
    FROM patients p
    LEFT JOIN visits v ON p.patient_id = v.patient_id
    WHERE v.department = 'ENT';

2) LEFT JOIN + WHERE on LEFT table
   → SAFE (LEFT JOIN preserved)

Example:

    WHERE p.gender = 'F';

3) To filter RIGHT table safely
   → Use AND inside ON clause

Example:

    LEFT JOIN visits v
    ON p.patient_id = v.patient_id
    AND v.department = 'ENT';

4) For unmatched data / NULL
   → Use ANTI JOIN effect

Example:

    WHERE v.patient_id IS NULL;



---------------------------------------------------------
COMMON INTERVIEW MISTAKES
---------------------------------------------------------
- Filtering RIGHT table in WHERE with LEFT JOIN
- Using NOT IN when NULL exists
- Joining on non-key columns
- Missing join condition (Cartesian explosion)
- Using DISTINCT to hide bad joins



---------------------------------------------------------
PRO TIPS & TRICKS
---------------------------------------------------------
TIP 1: Always join on keys, never on names

TIP 2: LEFT JOIN is used more than RIGHT JOIN

TIP 3: FULL JOIN only for reconciliation

TIP 4: CROSS JOIN can crash systems

TIP 5: Always use table aliases

TIP 6: Check one-to-many relationships

TIP 7: NULL handling decides join correctness

TIP 8: NOT EXISTS is best for Anti Joins



---------------------------------------------------------
REAL-WORLD BUSINESS USE CASES
---------------------------------------------------------
- Patients without visits (ANTI JOIN)
- Visit reports (LEFT JOIN)
- Valid relationships only (INNER JOIN)
- Data audits (FULL JOIN)
- Hierarchical data (SELF JOIN)



---------------------------------------------------------
FINAL SUMMARY (VERY IMPORTANT)
---------------------------------------------------------
- INNER JOIN → matching rows only
- LEFT JOIN → all left + matches
- RIGHT JOIN → all right + matches
- FULL JOIN → everything
- CROSS JOIN → combinations
- SELF JOIN → table joined with itself
- ANTI JOIN → missing data
- ON = matching logic
- WHERE = filtering logic


---------------------------------------------------------



