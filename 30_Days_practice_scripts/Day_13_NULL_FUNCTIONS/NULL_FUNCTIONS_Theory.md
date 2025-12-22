(4) NULL FUNCTIONS
---------------------------------------------------------
NULL represents missing, unknown, or not available data.
It is NOT equal to 0, empty string (' '), or false.

NULL functions are used to handle, compare, and validate
NULL values safely in SQL queries.



Why do we need NULL Functions?
---------------------------------------------------------
- To replace NULL values with meaningful data
- To avoid incorrect calculations
- To prevent NULL results in queries
- To validate missing data in tables



NULL HANDLING FUNCTIONS
=========================================================



**1) ISNULL**
---------------------------------------------------------
The ISNULL function replaces a NULL value with a specified
replacement value.

Syntax:
    ISNULL(expression, replacement_value)


Example 1:

    SELECT ISNULL(NULL, 0) AS Result;

    Output:
    0


Example 2:

    SELECT ISNULL(salary, 0) AS Salary_Value
    FROM employees;

(If salary is NULL → it becomes 0)



**2) COALESCE**
---------------------------------------------------------
The COALESCE function returns the first NON-NULL value
from a list of expressions.

Syntax:

    COALESCE(value1, value2, value3, ...)


Example 1:

    SELECT COALESCE(NULL, NULL, 100) AS Result;

    Output:
    100


Example 2:

    SELECT COALESCE(bonus, incentive, 0) AS Final_Payment
    FROM employees;

(Returns the first available value)



**Difference between ISNULL and COALESCE**
---------------------------------------------------------
- ISNULL accepts only two arguments
- COALESCE can accept multiple arguments
- COALESCE is standard SQL and more flexible



**3) NULLIF**
---------------------------------------------------------
The NULLIF function compares two expressions.
If both are equal, it returns NULL.
If not equal, it returns the first expression.

Syntax:

    NULLIF(expression1, expression2)


Example 1:

    SELECT NULLIF(10, 10) AS Result;

    Output:
    NULL


Example 2:

    SELECT NULLIF(10, 5) AS Result;

    Output:
    10


Real-time use:
    Avoid division by zero
    
    SELECT salary / NULLIF(working_days, 0)
    FROM employees;



NULL VALIDATION
=========================================================



**1) IS NULL**
---------------------------------------------------------
Used to check rows where column value is NULL.

Example:

    SELECT * 
    FROM employees
    WHERE manager_id IS NULL;

(Returns employees without a manager)



**2) IS NOT NULL**
---------------------------------------------------------
Used to check rows where column value is NOT NULL.

Example:

    SELECT * 
    FROM employees
    WHERE salary IS NOT NULL;

(Returns employees with salary data)



SUMMARY
---------------------------------------------------------
- NULL means missing or unknown data
- ISNULL replaces NULL with a given value
- COALESCE returns first non-NULL value
- NULLIF returns NULL when two values match
- IS NULL / IS NOT NULL are used for validation
---------------------------------------------------------

