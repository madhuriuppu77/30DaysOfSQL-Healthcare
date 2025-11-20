## GROUP BY AND HAVING — COMPLETE SHORT THEORY (SQL EXPERT LEVEL, SIMPLE & EFFECTIVE)

**1) WHAT IS GROUP BY?**
- GROUP BY is used to group rows that have the same values into summary rows.
- It converts multiple rows into one group.
- It is always used with aggregate functions like COUNT(), SUM(), MIN(), MAX(), AVG().
- Without GROUP BY → you get one single aggregated result.
- With GROUP BY → you get aggregated results per group.

**2) WHAT IS HAVING?**
- HAVING filters groups AFTER grouping.
- WHERE filters rows BEFORE grouping.
- HAVING is used only when the condition involves aggregate functions (COUNT, MIN, MAX, SUM, AVG).

**3) WHERE TO USE / WHERE NOT TO USE:**

**USE WHERE:**
- To filter individual rows before grouping.
- To apply conditions on normal columns (NOT aggregates).
Example:
WHERE age > 30
WHERE city = 'Delhi'

**DO NOT USE WHERE:**
- With aggregate functions (COUNT, MIN, MAX, SUM, AVG).
Example (wrong):
WHERE COUNT(patient_id) > 5   -- invalid

**USE HAVING:**
- To filter groups after GROUP BY.
- When comparing aggregate values.
Example:
HAVING COUNT(patient_id) > 5
HAVING MIN(dosage) = '50mg'

**DO NOT USE HAVING:**
- To filter normal rows (that should be in WHERE).
Example (wrong):
HAVING city = 'Mumbai'

**4) TIPS AND TRICKS:**
- ORDER OF EXECUTION: WHERE → GROUP BY → HAVING → SELECT
- If condition is on raw data → use WHERE.
- If condition is on grouped data → use HAVING.
- Always put GROUP BY columns exactly as they appear in SELECT (except aggregates).
- You can use HAVING without WHERE, but usually both are needed.
- WHERE reduces the data early → improves performance.
- HAVING should contain only logic that depends on grouped results.
- If you get an error “column not in GROUP BY” → add it to GROUP BY or wrap with aggregate.

**5) WHERE MOST PEOPLE GO WRONG:**
- **Using HAVING to filter normal rows instead of WHERE.**
  Wrong: HAVING city = 'Hyderabad'
  Correct: WHERE city = 'Hyderabad'

- **Using WHERE with aggregate functions.**
  Wrong: WHERE COUNT(*) > 1
  Correct: HAVING COUNT(*) > 1

- **Selecting columns not included in GROUP BY.**
  Wrong:
    SELECT age, city, COUNT(*)
    FROM patients
    GROUP BY age;  -- city missing
  Correct:
    GROUP BY age, city

- Forgetting that HAVING works only after GROUP BY.
- Forgetting that WHERE removes data early, affecting final group results.
- Using HAVING when filtering NULL values in normal columns (should use WHERE).

**FINAL SHORT SUMMARY:**
- WHERE filters rows before grouping.
- GROUP BY groups rows.
- HAVING filters grouped results after grouping.
- Use WHERE for non-aggregated conditions.
- Use HAVING for aggregated conditions.
