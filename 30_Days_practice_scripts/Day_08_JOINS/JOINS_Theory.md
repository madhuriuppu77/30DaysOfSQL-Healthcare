
  ##      SQL JOINS — COMPLETE EXPLANATION 


**1) ALL TYPES OF JOINS**
----------------------

A) INNER JOIN
--------------
• Returns only matching rows from both tables.
• Removes all non-matched data.
• Most strict type of join.

SYNTAX:
SELECT *
FROM A
INNER JOIN B
    ON A.key = B.key;

USE CASE:
- When you want clean, valid, connected data (Patients WITH visits).

--------------------------------------------------------------

B) LEFT JOIN  (MOST USED JOIN IN THE REAL WORLD)
-------------------------------------------------
• Returns ALL rows from LEFT table + matched rows from RIGHT.

• Unmatched RIGHT rows become NULL.

• Most powerful join for reporting & healthcare analytics.

SYNTAX:
SELECT *
FROM A
LEFT JOIN B
    ON A.key = B.key;

USE CASE:
- Find patients with OR without visits.
- Find missing data.
- Create reports even if right table is incomplete.

--------------------------------------------------------------

C) RIGHT JOIN
--------------
• Opposite of LEFT JOIN.

• Returns all rows from RIGHT table + matched rows from LEFT.

• Very rarely used because LEFT JOIN does the same job by swapping tables.

SYNTAX:
SELECT *
FROM A
RIGHT JOIN B
    ON A.key = B.key;

--------------------------------------------------------------

D) FULL OUTER JOIN
-------------------
• Returns ALL rows from BOTH tables.

• Matched + unmatched from left + unmatched from right.

SYNTAX:
SELECT *
FROM A
FULL JOIN B
    ON A.key = B.key;

USE CASE:
- Data comparison
- Quality checks
- Identifying mismatches across systems

--------------------------------------------------------------

E) CROSS JOIN
--------------
• Cartesian product (every row from A × every row from B).

• Used only for special cases.

SYNTAX:
SELECT *
FROM A
CROSS JOIN B;

USE CASE:
- Calendar creation
- Generating combinations
- Synthetic test data

--------------------------------------------------------------

F) SELF JOIN
-------------
• A table joined with itself.

• Useful for hierarchical data (employees reporting to managers).

SYNTAX:
SELECT e.emp_name, m.emp_name AS manager
FROM Employees e
JOIN Employees m
    ON e.manager_id = m.emp_id;

--------------------------------------------------------------


**2) FREQUENTLY USED JOINS**
------------------------

RANK 1 → LEFT JOIN
-------------------
Why?  
• Because REAL-WORLD DATA always has missing values.  

• Left join never loses the primary table.  

• Used in 70–80% of analytics queries.

Examples:
- Patients WITHOUT visits

- Doctors WITHOUT prescriptions

- Visits WITHOUT billing entries

--------------------------------------------------------------

RANK 2 → INNER JOIN
-------------------
Why?  
• Used when you want only valid matched data.  

Examples:
- Doctors WITH visits
- Prescriptions WITH visit details

--------------------------------------------------------------

RANK 3 → FULL JOIN
-------------------
Why?  
• Used during audits or data reconciliation.  


**3) WHEN TO USE JOINS & WHEN NOT TO USE**
---------------------------------------

A) USE JOINS WHEN:
-------------------
• Data lives across multiple tables
  (Patients, Visits, Doctors, Prescriptions)
  
• You need to combine information to answer a business question

• You want complete reports (LEFT JOIN)

• You want only clean matched data (INNER JOIN)

• You want mismatch detection (FULL JOIN)

• You follow relationships: 1-to-many, many-to-one

Examples:
- Visits + Patients
- Visits + Doctors
- Patient history report
- Medication summary
- Dashboard building

-------------------------------------------------------

B) DO **NOT** USE JOINS WHEN:
------------------------------
• The required data is already in a single table

• You can use a subquery instead (performance benefit)

• You are filtering inside one table (WHERE is enough)

• When you mistakenly join tables without keys → duplicates explosion

• You are joining huge tables unnecessarily (performance damage)

Examples:
- Counting rows in one table   → no join
- Filtering one table          → no join
- Using join for no reason     → performance killer

-------------------------------------------------------------


**4) PRO TIPS, TRICKS & THINGS MOST PEOPLE IGNORE**
-------------------------------------------------

TIP 1: ALWAYS JOIN ON KEYS (NEVER on names)
-------------------------------------------
Bad:
ON p.name = d.name   (duplicates + wrong matches)

Good:
ON p.patient_id = v.patient_id

----------------------------------------------------

TIP 2: WHEN USING LEFT JOIN, FILTER RIGHT TABLE IN ON CLAUSE
-------------------------------------------------------------
Bad (accidental INNER JOIN):
SELECT *
FROM A
LEFT JOIN B ON A.id = B.id
WHERE B.status = 'Active';

Good:
SELECT *
FROM A
LEFT JOIN B ON A.id = B.id AND B.status = 'Active';

----------------------------------------------------

TIP 3: USE DISTINCT ONLY WHEN NEEDED (IT HIDES PROBLEMS)
---------------------------------------------------------
If duplicates appear → fix JOIN logic instead of using DISTINCT blindly.

----------------------------------------------------

TIP 4: KNOW THAT LEFT JOIN DOES NOT FILTER NULLS
------------------------------------------------
You must manually check them:
WHERE B.key IS NULL   → unmatched data

----------------------------------------------------

TIP 5: USE TABLE ALIASES ALWAYS
-------------------------------
Makes queries readable and avoids confusion.

----------------------------------------------------

TIP 6: FULL OUTER JOIN IS HEAVY
-------------------------------
Use only for reconciliation.  
It is slow on large healthcare datasets.

----------------------------------------------------

TIP 7: CROSS JOIN CAN CRASH SERVERS
-----------------------------------
It multiplies rows × rows.  
Be careful.

----------------------------------------------------

TIP 8: BEWARE OF DUPLICATE ROWS
-------------------------------
If the right table has multiple matching rows, result multiplies.
Use:
- DISTINCT
- GROUP BY
- or check 1-to-many relationships

----------------------------------------------------

TIP 9: JOIN ORDER DOES NOT CHANGE RESULTS (BUT AFFECTS PERFORMANCE)
-------------------------------------------------------------------
Query optimizer rearranges joins internally..

----------------------------------------------------

TIP 10: LEFT JOIN > RIGHT JOIN
-------------------------------
RIGHT JOIN is almost never needed.
Flip the tables instead.

--------------------------------------------------------------


SUMMARY
--------
• INNER JOIN → only matches  
• LEFT JOIN → everything from left  
• RIGHT JOIN → everything from right  
• FULL JOIN → everything from both  
• CROSS JOIN → combinations  
• SELF JOIN → hierarchical  

Frequently used: LEFT > INNER > FULL  
Avoid: RIGHT JOIN unless required  

Tricks: join only on keys, filter in ON clause, avoid accidental inner joins, handle NULLs correctly.
