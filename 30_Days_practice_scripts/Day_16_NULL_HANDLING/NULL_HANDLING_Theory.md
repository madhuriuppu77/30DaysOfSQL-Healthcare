 **NULL HANDLING** 

(1) WHAT IS NULL?
---------------------------------------------------------
NULL represents missing, unknown, or not applicable data.

NULL is NOT:

- 0 
- Empty string ('') 
- FALSE
- A space (' ')
  

Examples:

    salary = NULL   → Salary is unknown
    
    salary = 0      → Salary is known and zero

Key idea:

    NULL means "we do not know the value"



(2) SQL THREE-VALUED LOGIC
---------------------------------------------------------
SQL does NOT use only TRUE or FALSE.

It uses:

- TRUE
- FALSE
- UNKNOWN (caused by NULL)

Example:

    salary = 50000  → TRUE / FALSE
    salary = NULL   → UNKNOWN

Important rule:

    WHERE clause keeps ONLY rows that evaluate to TRUE
    FALSE and UNKNOWN rows are filtered out



(3) COMPARING NULL VALUES
---------------------------------------------------------
NEVER compare NULL using = or !=

WRONG:

    column = NULL
    column != NULL
    column <> NULL

CORRECT:

    column IS NULL
    column IS NOT NULL

Example:

    SELECT *
    FROM employees
    WHERE manager_id IS NULL;



(4) NULL IN WHERE CLAUSE (FILTERING BEHAVIOR)
---------------------------------------------------------
Any comparison with NULL returns UNKNOWN.

Example:

    SELECT *
    FROM employees
    WHERE salary > 30000;

Rows with salary = NULL are EXCLUDED automatically.

To include NULL values:

    WHERE salary > 30000
       OR salary IS NULL



(5) NULL IN SELECT STATEMENT
---------------------------------------------------------
NULL appears explicitly as NULL in output.

Example:

    SELECT name, bonus
    FROM employees;

If bonus is missing → NULL is displayed



(6) NULL IN AGGREGATE FUNCTIONS
---------------------------------------------------------
Aggregate functions IGNORE NULL values.

Functions that ignore NULL:

- SUM()
- AVG()
- COUNT(column)
- MIN()
- MAX()

Example data:

    salary
    ------
    5000
    NULL
    7000

Queries:

    SELECT SUM(salary)   → 12000
    SELECT AVG(salary)   → 6000
    SELECT COUNT(salary) → 2
    SELECT COUNT(*)      → 3

Key difference:

    COUNT(*) counts rows
    COUNT(column) counts non-NULL values



(7) NULL IN GROUP BY
---------------------------------------------------------
All NULL values form ONE group.

Example:

    SELECT department, COUNT(*)
    FROM employees
    GROUP BY department;

All rows where department IS NULL are grouped together



(8) NULL IN ORDER BY
---------------------------------------------------------
NULL ordering depends on database.

Explicit control:

    ORDER BY salary NULLS FIRST
    ORDER BY salary NULLS LAST



(9) NULL IN JOINs
---------------------------------------------------------
INNER JOIN:

- Rows with NULL join keys are excluded

LEFT JOIN:

- Left table rows are preserved
- Missing right table data becomes NULL

Example:

    Patients LEFT JOIN Visits
    If no visit → visit columns become NULL



(10) LEFT JOIN + WHERE (VERY IMPORTANT)
---------------------------------------------------------
Filtering on right table in WHERE breaks LEFT JOIN.

WRONG:

    LEFT JOIN visits
    WHERE visits.dept = 'CARDIO'

CORRECT:

    LEFT JOIN visits
    ON p.id = v.id
   AND v.dept = 'CARDIO'

OR:
    WHERE v.dept = 'CARDIO'
       OR v.dept IS NULL



(11) NULL IN ANTI JOIN (A NOT IN B)
---------------------------------------------------------
Goal: rows present in A but not in B

WRONG:

    WHERE id NOT IN (SELECT id FROM B);

If subquery contains NULL → no rows returned

CORRECT:

    WHERE NOT EXISTS (
        SELECT 1
        FROM B
        WHERE B.id = A.id
    );

OR:
    LEFT JOIN + IS NULL



(12) NOT IN vs NOT EXISTS (NULL TRAP)
---------------------------------------------------------
NOT IN fails when NULL exists in subquery.

Always prefer:
    NOT EXISTS



(13) NULL HANDLING FUNCTIONS
=========================================================

**1) COALESCE**
---------------------------------------------------------
Returns the first NON-NULL value.

Syntax:

    COALESCE(val1, val2, val3, ...)

Example:

    SELECT COALESCE(bonus, incentive, 0)
    FROM employees;



**2) ISNULL / IFNULL / NVL**
---------------------------------------------------------
ISNULL (SQL Server)
IFNULL (MySQL)
NVL    (Oracle)

Example:

    SELECT ISNULL(salary, 0)
    FROM employees;



**3) NULLIF**
---------------------------------------------------------
Returns NULL if two values are equal.

Syntax:

    NULLIF(value1, value2)

Example:

    SELECT NULLIF(10, 10); → NULL
    SELECT NULLIF(10, 5);  → 10

Real use:
    Prevent division by zero
    salary / NULLIF(days, 0)



(14) NULL IN CALCULATIONS
---------------------------------------------------------
Any arithmetic with NULL results in NULL.

Example:

    salary + bonus → NULL if bonus is NULL

Fix:

    salary + COALESCE(bonus, 0)



(15) NULL IN CASE EXPRESSIONS
---------------------------------------------------------
CASE does NOT match NULL with =

WRONG:

    CASE WHEN col = NULL THEN 0

CORRECT:

    CASE WHEN col IS NULL THEN 0 ELSE col END



(16) NULL IN DISTINCT
---------------------------------------------------------
DISTINCT treats all NULLs as one unique value.

Example:

    SELECT DISTINCT department
    FROM employees;

NULL appears only once



(17) NULL AND UNIQUE CONSTRAINTS
---------------------------------------------------------
Most databases allow multiple NULLs in UNIQUE columns.

Reason:

    NULL ≠ NULL



(18) NULL IN INDEXES
---------------------------------------------------------
Some databases do not index NULL values.

Impact:

- Query performance
- Execution plans



(19) NULL IN CHECK CONSTRAINTS
---------------------------------------------------------
CHECK constraints ignore NULL.

Example:

    CHECK (salary > 0)

salary = NULL passes the constraint



(20) NULL IN HAVING
---------------------------------------------------------
HAVING filters after aggregation.

If aggregate result is NULL → condition fails



(21) NULL IN SUBQUERIES
---------------------------------------------------------
Scalar subquery returning NULL causes UNKNOWN.

Safer alternatives:

- EXISTS
- COALESCE



(22) NULL AND BOOLEAN LOGIC
---------------------------------------------------------

TRUE  AND NULL → NULL

FALSE AND NULL → FALSE

TRUE  OR  NULL → TRUE

FALSE OR  NULL → NULL

NOT NULL       → NULL



(23) IS DISTINCT FROM (NULL-SAFE COMPARISON)
---------------------------------------------------------
Safely compares values including NULL.

Example:

    col IS DISTINCT FROM 10
    col IS NOT DISTINCT FROM 10



(24) NULL IN SET OPERATORS
---------------------------------------------------------
UNION:

- NULL duplicates removed

INTERSECT:

- NULL matches NULL

EXCEPT:

- NULL treated as equal



(25) NULL IN WINDOW FUNCTIONS
---------------------------------------------------------
Aggregate window functions ignore NULL.
ROW_NUMBER unaffected.
ORDER BY NULL behavior applies.



(26) NULL IN JSON DATA
---------------------------------------------------------
JSON null ≠ SQL NULL

Example:

    {"age": null}  → JSON null
    column IS NULL → SQL null

Must be checked separately



(27) EMPTY STRING vs NULL
---------------------------------------------------------
Oracle:

    '' is treated as NULL

PostgreSQL / MySQL:

    '' ≠ NULL

Safe check:

    col IS NULL OR col = ''



(28) NULL IN UPDATE STATEMENTS
---------------------------------------------------------
Set NULL explicitly:

    UPDATE table SET col = NULL;

Update missing values:

    WHERE col IS NULL



(29) NULL IN DELETE STATEMENTS
---------------------------------------------------------
Dangerous case:

    DELETE WHERE col <> 'X';

This deletes NULL rows too.

Safe:
    AND col IS NOT NULL



(30) NULL AND FOREIGN KEYS
---------------------------------------------------------
NULL foreign key means optional relationship.
Affects joins and data integrity logic.



(31) NULL IN ETL / DATA MIGRATION
---------------------------------------------------------
Common issues:
- Empty fields → NULL
- Wrong defaults
- NULL vs 0 confusion

Best practice:
    Normalize NULL early



(32) NULL DEFAULT VALUES (DESIGN)
---------------------------------------------------------
BAD:

    salary DEFAULT 0

GOOD:

    salary NULL

NULL exposes missing data
0 hides data issues



(33) NULL & PERFORMANCE
---------------------------------------------------------
Indexes may skip NULL.
Statistics may misestimate data.

Solutions:
- Partial indexes
- Explicit NULL filtering



(34) NULL & DATA QUALITY
---------------------------------------------------------
NULL indicates:
- Missing data
- Invalid data
- Incomplete data

Treat NULL as a signal, not a problem



(35) EXPERT NULL-HANDLING RULES
---------------------------------------------------------
- Assume columns can be NULL
- Never use = NULL
- Prefer EXISTS over IN
- Push filters into JOIN
- Always test with NULL data



(36) FINAL SUMMARY
---------------------------------------------------------
- NULL means UNKNOWN
- NULL breaks assumptions
- NULL causes silent bugs
- Proper NULL handling = expert SQL
- Wrong results? CHECK NULL FIRST
---------------------------------------------------------


