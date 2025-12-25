**(1)WINDOW FUNCTIONS** 

**WHAT ARE WINDOW FUNCTIONS?**

Window functions perform calculations across a set of rows  
related to the current row WITHOUT collapsing rows.

They allow us to calculate aggregates, rankings, comparisons,  
and analytical values while still keeping each individual row.

Window functions work on a "window" of rows defined by the  
OVER() clause.


**WHY DO WE NEED WINDOW FUNCTIONS?**

- To keep row-level details while applying aggregations  
- To avoid losing granularity  
- To perform running totals and moving averages  
- To rank rows within a group  
- To compare current row with previous or next rows  
- To answer analytical business questions  


---

**(2) GROUP BY – FOUNDATION CONCEPT**

**WHAT IS GROUP BY?**

GROUP BY is used to aggregate data and return one row per group.

When GROUP BY is used:
- Rows are collapsed  
- Granularity is reduced  
- Only grouped columns and aggregated values remain  


**GROUP BY EXAMPLE**

    SELECT
        category,
        SUM(sales) AS total_sales
    FROM sales_data
    GROUP BY category;


**IMPORTANT RULE**

Every column in SELECT must be either:
- Part of GROUP BY  
- Or wrapped inside an aggregate function  


---

**(3) WINDOW FUNCTIONS vs GROUP BY**

**KEY DIFFERENCES**

GROUP BY:
- Reduces number of rows  
- Loses row-level detail  
- Produces summary results  

WINDOW FUNCTIONS:
- Preserve all rows  
- Add analytical insights  
- Do not reduce dataset size  


**SIDE BY SIDE COMPARISON**

GROUP BY:

    SELECT category, SUM(sales)
    FROM sales_data
    GROUP BY category;

WINDOW FUNCTION:

    SELECT
        order_id,
        category,
        sales,
        SUM(sales) OVER(PARTITION BY category)
    FROM sales_data;


---

**(4) WHY GROUP BY IS NOT ENOUGH**

**BUSINESS PROBLEM**

"Show each order along with category total sales"

GROUP BY FAILS because:
- It collapses rows  
- It cannot retain order-level detail  


**WINDOW FUNCTION SOLUTION**

    SELECT
        order_id,
        category,
        sales,
        SUM(sales) OVER(PARTITION BY category) AS category_total
    FROM sales_data;


---

**(5) OUTPUT ROW COUNT & GRANULARITY**

**GROUP BY OUTPUT**

Number of output rows is defined by unique combinations  
of grouped dimensions.


**WINDOW FUNCTION OUTPUT**

Number of output rows remains the same as input rows.


**KEY INSIGHT**

GROUP BY defines granularity  
WINDOW FUNCTIONS preserve granularity  


---

**(6) ADDING MORE COLUMNS TO GROUP BY – GRANULARITY ISSUE**

**COMMON WRONG THINKING**

"If I select 3 columns, I must add all 3 to GROUP BY"


**PROBLEMATIC QUERY**

    SELECT
        category,
        region,
        order_date,
        SUM(sales)
    FROM sales_data
    GROUP BY category, region, order_date;


**WHY THIS IS WRONG**

- Granularity explodes  
- Business meaning changes  
- Aggregation becomes meaningless  


**CORRECT WINDOW APPROACH**

    SELECT
        category,
        region,
        order_date,
        sales,
        SUM(sales) OVER(PARTITION BY category) AS category_total
    FROM sales_data;


---

**(7) GROUP BY LIMITATION – AGGREGATION + DETAILS**

**LIMITATION**

GROUP BY cannot:
- Aggregate data  
- And show row-level details at the same time  


**WINDOW FUNCTION FIX**

    SELECT
        order_id,
        sales,
        SUM(sales) OVER() AS total_sales
    FROM sales_data;


---

**(8) WINDOW FUNCTION SYNTAX**

**GENERAL SYNTAX**

    FUNCTION(expression)
    OVER (
        PARTITION BY ...
        ORDER BY ...
        FRAME
    )


**COMPONENTS**

1) Function  
2) Expression  
3) OVER clause  


---

**(9) FUNCTION – FIRST PART OF WINDOW SYNTAX**

**RULE**

Window function must start with a function.


**EXAMPLES**

    SUM(sales)
    AVG(sales)
    COUNT(*)
    RANK()
    ROW_NUMBER()
    LEAD(sales)
    LAG(sales)


---

**(10) TYPES OF WINDOW FUNCTIONS**

**(1) AGGREGATE WINDOW FUNCTIONS**

- SUM()  
- AVG()  
- MIN()  
- MAX()  
- COUNT()  

Example:

    AVG(sales) OVER(PARTITION BY category)


**(2) RANK FUNCTIONS**

- ROW_NUMBER()  
- RANK()  
- DENSE_RANK()  
- NTILE(n)  

Example:

    RANK() OVER(PARTITION BY category ORDER BY sales DESC)


**(3) VALUE (ANALYTICAL) FUNCTIONS**

- LEAD()  
- LAG()  
- FIRST_VALUE()  
- LAST_VALUE()  

Example:

    LAG(sales, 1, 0)
    OVER(PARTITION BY category ORDER BY order_date)


---

**(11) EXPRESSION INSIDE WINDOW FUNCTIONS**

**WHAT IS AN EXPRESSION?**

Expression is the value or argument passed to a function.


**POSSIBLE TYPES**

1) EMPTY  

     RANK()

3) NUMBER  

    NTILE(2)

5) MULTIPLE ARGUMENTS  

   LEAD(sales, 2, 10)

7) CONDITIONAL LOGIC  

   SUM(
        CASE
            WHEN region = 'South' THEN sales
            ELSE 0
        END
    ) OVER(PARTITION BY category)


---

**(12) DATA TYPES ALLOWED IN EXPRESSIONS**

**DATA TYPE RULES**

- SUM, AVG → Numeric only  
- COUNT → Any data type  
- RANK → No arguments  
- LEAD / LAG → Any data type  
- ORDER BY → Comparable data types  
- FRAME offsets → Integer only  


---

**(13) OVER CLAUSE – IDENTIFYING WINDOW FUNCTION**

**WHY OVER IS REQUIRED**

Without OVER:

    SUM(sales) → Aggregate function  

With OVER:

    SUM(sales) OVER() → Window function  


**EXAMPLE**

    SELECT
        sales,
        SUM(sales) OVER() AS total_sales
    FROM sales_data;


---

**(14) PARTITION BY – DEFINING WINDOWS**

**WHAT IS PARTITION BY?**

PARTITION BY divides the dataset into logical windows.


**TYPES**

1) NO PARTITION
    
   SUM(sales) OVER()

2) SINGLE COLUMN
   
    SUM(sales) OVER(PARTITION BY category)

3) MULTIPLE COLUMNS  

     SUM(sales) OVER(PARTITION BY category, region)


**IS PARTITION BY OPTIONAL?**

Yes.  
No error occurs if omitted.  


---

**(15) ORDER BY IN WINDOW FUNCTIONS**

**PURPOSE**

Defines the sequence of rows inside a partition.


**MANDATORY FOR**

- ROW_NUMBER()  
- RANK()  
- DENSE_RANK()  
- LEAD()  
- LAG()  
- Running totals  


**OPTIONAL FOR**

- SUM()  
- AVG()  
(when no frame is specified)


---

**(16) WINDOW FRAME – MOST ADVANCED CONCEPT**

**DEFINITION**

Frame defines a subset of rows inside a partition  
used for the calculation.


**FRAME TYPES**

1) ROWS  
2) RANGE  


**FRAME BOUNDARIES**

LOWER:
- UNBOUNDED PRECEDING  
- N PRECEDING  
- CURRENT ROW  

UPPER:
- CURRENT ROW  
- N FOLLOWING  
- UNBOUNDED FOLLOWING  


**EXAMPLES**

1) CURRENT ROW → 2 FOLLOWING  
    ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING

2) 2 PRECEDING → 2 FOLLOWING  
    ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING

3) CURRENT → UNBOUNDED FOLLOWING  
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

4) 2 PRECEDING → CURRENT ROW  
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW

5) UNBOUNDED PRECEDING → CURRENT ROW  
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

6) UNBOUNDED PRECEDING → UNBOUNDED FOLLOWING  
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING


**DEFAULT FRAME**

RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  
(when ORDER BY is present)


**FRAME REQUIRES ORDER BY?**

Yes.  
Frame has no meaning without order.  


---

**(17) WINDOW FUNCTION RULES**

- Cannot be used in WHERE  
- Cannot be nested  
- OVER clause is mandatory  
- Executed after WHERE  
- Allowed in SELECT and ORDER BY only  


---

**(18) WHERE WINDOW FUNCTIONS CAN BE USED**

ALLOWED:
- SELECT  
- ORDER BY  

NOT ALLOWED:
- WHERE  
- GROUP BY  
- HAVING (directly)  

WORKAROUND:
- Subquery  
- CTE  


---

**(19) IMPORTANT ADVANCED USE CASES**

- Top-N per group  
- Running totals  
- Moving averages  
- De-duplication  
- Trend analysis  
- Gap detection  
- Percent contribution  


---

**(20) FINAL SUMMARY**

GROUP BY:
- Aggregates data  
- Reduces rows  
- Loses detail  

WINDOW FUNCTIONS:
- Analyze data  
- Preserve rows  
- Combine detail + aggregation  

ONE LINE TO REMEMBER:  
WINDOW FUNCTIONS = AGGREGATION WITHOUT LOSING GRANULARITY



