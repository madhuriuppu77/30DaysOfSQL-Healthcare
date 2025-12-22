(2) NUMBER FUNCTIONS / NUMERIC FUNCTIONS
---------------------------------------------------------
Number functions are used to work with numeric data types
such as INT, DECIMAL, NUMERIC, and FLOAT.

They help us transform numeric values inside our data
without modifying the actual stored values in the table.



Why do we need Number Functions?
---------------------------------------------------------
- To control decimal precision
- To handle negative values
- To perform clean mathematical transformations
- To make numeric results easier to understand



**A) ROUND FUNCTION**
---------------------------------------------------------
The ROUND function is used to round a number to a specified
number of decimal places.

Syntax:
    ROUND(number, decimal_places)


Example 1:

    SELECT ROUND(12.5678, 2) AS Rounded_Value;

    Output: 12.57
    
Example 2:

    SELECT ROUND(12.4, 0) AS Rounded_Value;

    Output:  12
   
Example 3:

    SELECT ROUND(-15.678, 1) AS Rounded_Value;

    Output:-15.7
    

**B) ABS FUNCTION**
---------------------------------------------------------
The ABS (Absolute) function returns the positive value
of a number by removing the negative sign.

Syntax:
    ABS(number)


Example 1:

    SELECT ABS(-25) AS Absolute_Value;
    
    Output: 25
    
Example 2:

    SELECT ABS(18) AS Absolute_Value;
    
    Output: 18
   
Example 3:

    SELECT ABS(-12.75) AS Absolute_Value;
    
    Output: 12.75
   


REAL-TIME USAGE EXAMPLES
---------------------------------------------------------
Example 1: Rounding salary values

    SELECT ROUND(45678.789, 2) AS Salary_Rounded;

Example 2: Getting positive difference value

    SELECT ABS(-1000) AS Difference_Value;



SUMMARY
---------------------------------------------------------
- ROUND controls decimal precision
- ABS removes negative sign from numbers
- Both are single row number functions
- They return one result per row
---------------------------------------------------------

