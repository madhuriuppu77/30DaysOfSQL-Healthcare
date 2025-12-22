
(1) What is exactly a Function and why do we need it?
----------------------------------------------------------
A function in SQL is a ready-made operation provided by the
database that performs a specific task and returns a result.

Think of a function like a machine:
- Input is given
- SQL processes it
- Output is returned

Why we need functions:
- To clean data (remove spaces, change case)
- To transform data (combine columns, extract text)
- To calculate values easily
- To make queries shorter and cleaner

Example:
SELECT UPPER('sql');

Output: 'SQL'


(2) Definition of Function
---------------------------------------------------------
A SQL function is a built-in, reusable feature that:
- Accepts input values
- Performs an operation
- Returns a single result

Functions help avoid writing complex logic again and again.




(3) Categories of SQL Functions
---------------------------------------------------------
SQL functions are divided into two main categories:

1) Single Row Functions
- Work on each row individually
- Return one result per row
- Commonly used in SELECT, WHERE, ORDER BY

Example:
SELECT UPPER(name) FROM employees;
(If there are 5 rows, output will be 5 rows)

2) Multiple Row (Aggregate) Functions
- Work on multiple rows together
- Return a single result for many rows

Example:
SELECT COUNT(*) FROM employees;
(Even if table has 100 rows, output is one value)



(4) Nested Functions
---------------------------------------------------------
A nested function means using one function inside another.

- The inner function executes first
- Its result is passed to the outer function

Example:
SELECT UPPER(TRIM('  sql  '));

Execution flow:
1) TRIM('  sql  ')  → 'sql'
2) UPPER('sql')     → 'SQL'




(5) Types of SQL Functions
---------------------------------------------------------
1) SINGLE ROW FUNCTIONS

**1) STRING FUNCTIONS**
---------------------------------------------------------
String functions work on text data types such as
CHAR, VARCHAR, and TEXT.


**A) MANIPULATION FUNCTIONS:**

These functions modify string values

**1) CONCAT:**
Joins two or more strings into one

    SELECT CONCAT('SQL', ' ', 'Functions') AS Result;

    Output: SQL Functions 

**2) UPPER:**
Converts all characters to uppercase 

    SELECT UPPER('sql') AS Result;
    
    Output: SQL

**3) LOWER:**
Converts all characters to lowercase

    SELECT LOWER('SQL') AS Result;
   
    Output: sql

**4) TRIM:**
Removes spaces from beginning and end

    SELECT TRIM('  SQL  ') AS Result;
   
    Output: SQL 

**5) REPLACE:**
Replaces part of a string with another value

    SELECT REPLACE('SQL Server', 'Server', 'Functions') AS Result;
   
    Output: SQL Functions 



**B) CALCULATION FUNCTION:**
Measures length of string


**1) LEN:**
Returns number of characters in a string

    SELECT LEN('SQL') AS Length;

    Output: 3 


**C) EXTRACTION FUNCTIONS:**
Extract part of a string

 **1) LEFT:**
Extracts characters from left side 

    SELECT LEFT('SQLServer', 3) AS Result;

    Output: SQL 

 **2) RIGHT:**
Extracts characters from right side 

    SELECT RIGHT('SQLServer', 6) AS Result;

    Output: Server 

 **3) SUBSTRING:**
Extracts characters from middle of string 

    SELECT SUBSTRING('SQLServer', 4, 6) AS Result;

    Output: Server 



SUMMARY
---------------------------------------------------------
- Manipulation functions change text values
- Calculation functions measure text values
- Extraction functions pull part of a string
