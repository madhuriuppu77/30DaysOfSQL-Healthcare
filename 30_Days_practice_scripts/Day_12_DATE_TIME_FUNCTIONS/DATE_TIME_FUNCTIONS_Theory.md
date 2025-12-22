(3) DATE AND TIME FUNCTIONS
---------------------------------------------------------
Date and Time functions are used to work with date and time
data types such as DATE, TIME, DATETIME, and TIMESTAMP.

They help us extract, format, calculate, and validate
date and time values in SQL.



DATE & TIME SOURCES IN SQL
---------------------------------------------------------
In SQL, dates can come from three main sources:

a) Date column from a table

   Example:
   
       SELECT order_date FROM orders;

b) Hardcoded constant string value

   Example:
   
       SELECT '2025-12-22' AS Order_Date;

c) GETDATE() function

   Returns the current system date and time
   
   Example:
   
       SELECT GETDATE() AS Current_Date_Time;



DATE AND TIME FUNCTIONS OVERVIEW
=========================================================



(1) PART EXTRACTION FUNCTIONS
---------------------------------------------------------
These functions are used to extract specific parts
from a date or time value.



**1) DAY**
Returns the day number from a date


    SELECT DAY('2025-12-22') AS Day_Value;

    Output:
        22



**2) MONTH**
Returns the month number from a date


    SELECT MONTH('2025-12-22') AS Month_Value;

    Output:
        12



**3) YEAR**
Returns the year from a date


    SELECT YEAR('2025-12-22') AS Year_Value;

    Output:
        2025



**4) DATEPART**
Returns a specific part of a date based on input


    SELECT DATEPART(WEEKDAY, '2025-12-22') AS DatePart_Value;

    Output:
        (Numeric value of weekday)



**5) DATENAME**
Returns the name of a date part as text


    SELECT DATENAME(MONTH, '2025-12-22') AS Month_Name;

    Output:
        December



**6) DATETRUNC**
Truncates date to a specified precision

    SELECT DATETRUNC(MONTH, '2025-12-22') AS Truncated_Date;

    Output:
        2025-12-01



**7) EOMONTH**
Returns the last day of the month

    SELECT EOMONTH('2025-02-15') AS End_Of_Month;

    Output:
        2025-02-28



(2) FORMAT & CASTING FUNCTIONS
---------------------------------------------------------
Used to change how date values are displayed
or converted between data types.



**1) FORMAT**
Formats date into a specific pattern

    SELECT FORMAT('2025-12-22', 'dd-MM-yyyy') AS Formatted_Date;

    Output:
        22-12-2025



**2) CONVERT**
Converts date to another data type with style

    SELECT CONVERT(VARCHAR, '2025-12-22', 103) AS Converted_Date;

    Output:
        22/12/2025



**3) CAST**
Converts one data type into another

    SELECT CAST(GETDATE() AS DATE) AS Casted_Date;

    Output:
        Current date without time



(3) CALCULATION FUNCTIONS
---------------------------------------------------------
Used to perform calculations on date values.



**1) DATEADD**
Adds or subtracts a time interval from a date

    SELECT DATEADD(DAY, 10, '2025-12-22') AS Added_Date;

    Output:
        2026-01-01



**2) DATEDIFF**
Returns the difference between two dates

    SELECT DATEDIFF(DAY, '2025-01-01', '2025-12-22') AS Date_Difference;

    Output:
        Number of days between dates



(4) VALIDATION FUNCTION
---------------------------------------------------------
Used to check whether a value is a valid date.



**1) ISDATE**
Returns 1 if value is a valid date, else 0

    SELECT ISDATE('2025-12-22') AS Is_Valid_Date;

    Output:
        1



SUMMARY
---------------------------------------------------------
- Date values can come from tables, constants, or GETDATE()
- Part extraction functions pull specific date components
- Format & casting functions change date appearance or type
- Calculation functions perform date arithmetic
- ISDATE validates date values
---------------------------------------------------------

