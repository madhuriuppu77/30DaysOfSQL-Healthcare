
   ## SQL SET OPERATORS


**1) Types of SET Operators:**

SQL provides operators to combine the results of two or more queries.

These operators work on result sets and follow the rule:

"Each query must return the same number of columns with compatible data types."

**a) UNION**

Combines the result sets of two queries into a single result set.

Removes duplicate rows by default.

Syntax:
SELECT column_list FROM table1
UNION
SELECT column_list FROM table2;

**b) UNION ALL**

Combines result sets including duplicates.

Faster than UNION because it does not perform distinct elimination.

Syntax:
SELECT column_list FROM table1
UNION ALL
SELECT column_list FROM table2;

**c) INTERSECT**

Returns only the rows that appear in both result sets.

Eliminates duplicates automatically.

Syntax:
SELECT column_list FROM table1
INTERSECT
SELECT column_list FROM table2;

**d) EXCEPT (or MINUS in some databases like Oracle)**

Returns rows from the first query that do NOT exist in the second query.

Duplicates are removed automatically.

Syntax:
SELECT column_list FROM table1
EXCEPT
SELECT column_list FROM table2;


**2) Frequently Used SET Operators:**

**Most commonly used in practice:**

**UNION**: Merging two or more tables, reports, or queries without duplicates.

**UNION ALL**: For performance when duplicates are acceptable or intentional.

**INTERSECT**: Useful to find common elements between two datasets (e.g., customers buying both product A and B).

**EXCEPT**: Used for difference queries, like "find customers who did not place any order last month."


**Usage frequency in real-world projects (rough estimate):**

UNION / UNION ALL: ~60% of set operator use

INTERSECT: ~20%

EXCEPT / MINUS: ~20%


**3) Where to Use and Where Not to Use:**

**When to Use:**

1. When combining two queries with compatible columns.
2. When you need distinct or filtered lists across multiple tables.
3. When comparing datasets to find common or missing data.
4. When creating reports that merge multiple sources.

When NOT to Use:

1. Do not use SET operators for complex joins involving multiple conditions across tables — use JOINs instead.
2. Avoid on large tables without proper indexing because UNION and INTERSECT require sorting or hashing to eliminate duplicates.
3. Do not expect row-level control; SET operators work on the entire result set, not individual rows.


**4) Tricks & Tips Often Ignored:**

a) UNION ALL is faster than UNION. Use UNION ALL if duplicates do not matter.

b) Column order matters: SELECT col1, col2 != SELECT col2, col1

c) Data types must be compatible: INT vs VARCHAR mismatch causes errors.

d) Use parentheses to control operator precedence:

   (Query1 UNION Query2) INTERSECT Query3
   
e) Combine SET operators with ORDER BY by placing ORDER BY at the end of the final result.

f) Aliases can help readability, especially with calculated columns.

g) Avoid unnecessary EXCEPT/INTERSECT if the same result can be achieved with JOIN + WHERE.

h) Always test NULL behavior: INTERSECT and EXCEPT treat NULLs carefully (may exclude or include unexpectedly).


**Summary:**

SET operators are powerful tools for combining and comparing result sets.

Use them for reporting, data comparison, de-duplication, and merging datasets.

Focus on UNION / UNION ALL for most tasks; INTERSECT and EXCEPT are situational but very useful.
