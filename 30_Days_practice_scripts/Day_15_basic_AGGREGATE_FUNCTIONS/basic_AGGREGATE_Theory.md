 MULTIPLE ROW FUNCTIONS (AGGREGATE FUNCTION)
---------------------------------------------------------
Multiple row functions are also called AGGREGATE FUNCTIONS.

They work on a group of rows and return ONE single result
for the entire group (or per group when GROUP BY is used).

These functions are extremely important for:
- Reports
- Analytics
- Interviews
- Real-world SQL projects



KEY CHARACTERISTICS OF AGGREGATE FUNCTIONS
---------------------------------------------------------
- They operate on multiple rows
- They return a single summarized value
- They IGNORE NULL values (very important!)
- They are commonly used with GROUP BY and HAVING
- They cannot be used directly in WHERE clause



BASIC AGGREGATE FUNCTIONS (NOT WINDOW FUNCTIONS)
=================================================
1) COUNT
2) SUM
3) AVG
4) MIN
5) MAX



---------------------------------------------------------
 1) COUNT FUNCTION
---------------------------------------------------------
COUNT is used to count the number of rows.

Syntax:

    COUNT(*)
    COUNT(column_name)
    COUNT(DISTINCT column_name)



**COUNT(*)**
---------------------------------------------------------
Counts total number of rows (includes NULL values)

Example:

    SELECT COUNT(*) AS Total_Employees
    FROM employees;

Explanation:

- Counts every row in the table
- NULL values do not matter



**COUNT(column_name)**
---------------------------------------------------------
Counts only NON-NULL values in a column

Example:

    SELECT COUNT(salary) AS Salary_Count
    FROM employees;

Explanation:

- Rows where salary is NULL are ignored



**COUNT(DISTINCT column_name)**
---------------------------------------------------------
Counts unique non-NULL values

Example:

    SELECT COUNT(DISTINCT department) AS Dept_Count
    FROM employees;



---------------------------------------------------------
2) SUM FUNCTION
---------------------------------------------------------
SUM is used to calculate the total of numeric values.

Syntax:

    SUM(column_name)



Example:

    SELECT SUM(salary) AS Total_Salary
    FROM employees;

Explanation:

- Adds all salary values
- NULL salaries are ignored
- Works only on numeric columns



---------------------------------------------------------
3) AVG FUNCTION
---------------------------------------------------------
AVG calculates the average (mean) value.

Syntax:

    AVG(column_name)



Example:

    SELECT AVG(salary) AS Average_Salary
    FROM employees;

Explanation:

- AVG = SUM(salary) / COUNT(salary)
- NULL values are ignored
- Result is usually a decimal



IMPORTANT NOTE:
---------------------------------------------------------
AVG does NOT count NULL values in denominator.
This can change results significantly.



---------------------------------------------------------
4) MIN FUNCTION
---------------------------------------------------------
MIN returns the smallest value from a column.

Syntax:

    MIN(column_name)



Example:

    SELECT MIN(salary) AS Minimum_Salary
    FROM employees;

Explanation:

- Works on numbers, dates, and strings
- NULL values are ignored
- For strings → alphabetical minimum



---------------------------------------------------------
5) MAX FUNCTION
---------------------------------------------------------
MAX returns the largest value from a column.

Syntax:

    MAX(column_name)



Example:

    SELECT MAX(salary) AS Maximum_Salary
    FROM employees;

Explanation:

- Works on numbers, dates, and strings
- NULL values are ignored
- For strings → alphabetical maximum



---------------------------------------------------------
AGGREGATE FUNCTIONS WITH GROUP BY
---------------------------------------------------------
GROUP BY is used to apply aggregates per category.

Example:

    SELECT department, AVG(salary) AS Avg_Salary
    FROM employees
    GROUP BY department;

Explanation:

- Data is grouped by department
- AVG is calculated per department



---------------------------------------------------------
AGGREGATE FUNCTIONS WITH HAVING
---------------------------------------------------------
HAVING filters aggregated results.

Example:

    SELECT department, COUNT(*) AS Emp_Count
    FROM employees
    GROUP BY department
    HAVING COUNT(*) > 5;

Explanation:

- WHERE filters rows
- HAVING filters groups



---------------------------------------------------------
IMPORTANT RULES (VERY IMPORTANT FOR INTERVIEWS)
---------------------------------------------------------
1) WHERE cannot use aggregate functions
2) HAVING can use aggregate functions
3) GROUP BY columns must appear in SELECT
4) Aggregate functions ignore NULL values
5) Non-aggregated columns must be in GROUP BY



---------------------------------------------------------
COMMON INTERVIEW TRICKS & TIPS
---------------------------------------------------------
TIP 1:

COUNT(*) vs COUNT(column)
- COUNT(*) counts rows
- COUNT(column) skips NULLs

TIP 2:

AVG is affected by NULL values
- AVG ignores NULL
- Use ISNULL/COALESCE if needed

Example:

    SELECT AVG(ISNULL(salary,0)) FROM employees;

TIP 3:

MIN/MAX on dates
- MIN → earliest date
- MAX → latest date

Example:

    SELECT MAX(join_date) FROM employees;

TIP 4:

COUNT with CASE (Conditional Aggregation)

Example:

    SELECT
        COUNT(CASE WHEN gender = 'Male' THEN 1 END) AS Male_Count,
        COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS Female_Count
    FROM employees;



---------------------------------------------------------
REAL-TIME BUSINESS EXAMPLES
---------------------------------------------------------
1) Total sales of company
   
    SELECT SUM(amount) FROM sales;

3) Highest transaction
   
    SELECT MAX(amount) FROM sales;

5) Average order value
   
    SELECT AVG(amount) FROM orders;

7) Number of active customers
   
    SELECT COUNT(DISTINCT customer_id) FROM orders;



---------------------------------------------------------
SUMMARY (VERY IMPORTANT)
---------------------------------------------------------
- Aggregate functions summarize data
- COUNT, SUM, AVG, MIN, MAX are core SQL skills
- NULL handling is critical
- GROUP BY + HAVING are tightly connected
- Mastering aggregates = strong SQL foundation
---------------------------------------------------------

