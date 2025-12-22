 CASE WHEN EXPRESSION
---------------------------------------------------------
CASE WHEN is a conditional expression in SQL.
It works like IF–ELSE logic in programming languages.

It allows us to apply conditions and return different
results based on those conditions.



Why do we need CASE WHEN?
---------------------------------------------------------
- To apply conditional logic in SELECT queries
- To categorize or label data
- To create derived columns
- To replace complex IF-ELSE logic in SQL



CASE WHEN TYPES
=========================================================
There are two types of CASE expressions:
1) Simple CASE
2) Searched CASE



(1) SIMPLE CASE EXPRESSION
---------------------------------------------------------
Compares one expression with multiple values.


Syntax:

    CASE expression
        WHEN value1 THEN result1
        WHEN value2 THEN result2
        ELSE default_result
    END



Example:
---------------------------------------------------------
Classify day type using number

    SELECT 
        CASE day_number
            WHEN 1 THEN 'Sunday'
            WHEN 2 THEN 'Monday'
            WHEN 3 THEN 'Tuesday'
            ELSE 'Other Day'
        END AS Day_Name
    FROM calendar;

Explanation:
- SQL checks day_number value
- Matches WHEN condition
- Returns corresponding result



(2) SEARCHED CASE EXPRESSION
---------------------------------------------------------
Evaluates multiple conditions using logical expressions.


Syntax:

    CASE
        WHEN condition1 THEN result1
        WHEN condition2 THEN result2
        ELSE default_result
    END



Example 1: Salary Category
---------------------------------------------------------
    SELECT 
        name,
        salary,
        CASE
            WHEN salary >= 80000 THEN 'High Salary'
            WHEN salary >= 40000 THEN 'Medium Salary'
            ELSE 'Low Salary'
        END AS Salary_Category
    FROM employees;

Explanation:
- SQL checks conditions top to bottom
- First true condition is executed
- ELSE is optional but recommended



Example 2: Pass / Fail Result
---------------------------------------------------------
    SELECT 
        student_name,
        marks,
        CASE
            WHEN marks >= 50 THEN 'Pass'
            ELSE 'Fail'
        END AS Result
    FROM students;



CASE WHEN WITH MULTIPLE CONDITIONS
---------------------------------------------------------
    SELECT
        order_id,
        order_amount,
        CASE
            WHEN order_amount >= 10000 THEN 'Platinum'
            WHEN order_amount >= 5000 THEN 'Gold'
            WHEN order_amount >= 2000 THEN 'Silver'
            ELSE 'Regular'
        END AS Customer_Type
    FROM orders;



CASE WHEN IN WHERE CLAUSE
---------------------------------------------------------
Used to apply conditional filtering

    SELECT *
    FROM employees
    WHERE 
        CASE 
            WHEN department = 'HR' THEN salary > 30000
            ELSE salary > 50000
        END = 1;



CASE WHEN WITH AGGREGATE FUNCTIONS
---------------------------------------------------------
Used for conditional aggregation

    SELECT
        COUNT(
            CASE 
                WHEN gender = 'Male' THEN 1
            END
        ) AS Male_Count,
        COUNT(
            CASE 
                WHEN gender = 'Female' THEN 1
            END
        ) AS Female_Count
    FROM employees;



IMPORTANT POINTS
---------------------------------------------------------
- CASE WHEN is an expression, not a statement
- It always returns a single value
- ELSE part is optional (returns NULL if omitted)
- Conditions are checked in order
- First matching condition is applied



SUMMARY
---------------------------------------------------------
- CASE WHEN adds IF–ELSE logic to SQL
- Used to categorize, label, and transform data
- Supports both simple and searched conditions
- Works with SELECT, WHERE, ORDER BY, and aggregates
---------------------------------------------------------

