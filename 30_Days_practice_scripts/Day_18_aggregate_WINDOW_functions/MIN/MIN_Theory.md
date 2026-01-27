MIN() WINDOW FUNCTION —  NOTES

**1. WHAT MIN() OVER() IS:**
   
MIN() as a window function returns the minimum value over a defined window of rows
without collapsing rows.
Each row keeps its identity and gets an additional column showing the minimum.

Key idea:

GROUP BY reduces rows.

MIN() OVER() preserves rows.

**2. BASIC SYNTAX**

   MIN() WINDOW FUNCTION SYNTAX NAMING AND PURPOSE

    MIN(column_name) OVER()
  
Name: Global minimum window

Purpose: Finds the minimum value across the entire table and shows it on every row.

Use cases:

- Compare each row against overall minimum
- Dashboard metrics
- Benchmarking rows against global best/worst

Mental model: “What is the minimum value in this table?”

     MIN(column_name) OVER(PARTITION BY column1)
     
Name: Partition-level minimum window

Purpose: Finds the minimum value per group defined by column1 without collapsing rows.

Use cases:

- Minimum per patient
- Minimum per doctor
- Minimum per department
  
Mental model: “What is the minimum value for THIS group?”

     MIN(column_name) OVER(PARTITION BY column1, column2)
     
Name: Multi-dimensional partition minimum window

Purpose: Finds the minimum value per unique combination of column1 and column2.

Use cases:

- Minimum cost per department per status
- Minimum sales per region per month
  
Mental model: “What is the minimum for THIS specific combination?”

     MIN(column_name) OVER(
          PARTITION BY column1
          ORDER BY column2
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       )
       
Name: Running (cumulative) minimum window

Purpose: Calculates the minimum so far, row by row, based on an order (usually date/time).

Use cases:
- Tracking lowest value over time
- Medical readings history
- Financial drawdowns
- Trend analysis
- 
Mental model: “What is the minimum up to THIS point in time?”

**Senior-Level Insight:**

Adding ORDER BY changes meaning:

- Without ORDER BY → static minimum per group
- With ORDER BY → dynamic minimum over time
 
Bugs often occur when ORDER BY is used unintentionally.

**3. HOW MIN() WORKS INTERNALLY**

Step 1: FROM and JOIN

Step 2: WHERE filtering

Step 3: Window partitioning

Step 4: Window ordering if present

Step 5: MIN calculation per window

Step 6: SELECT output

Important:

WHERE runs before window functions.

Window functions run after filtering but before final SELECT output.

**4. GLOBAL MIN VS PARTITIONED MIN**
   
Global minimum across table:

    MIN(value) OVER()

Minimum per group:

    MIN(value) OVER(PARTITION BY group_column)

Multi-level grouping:

    MIN(value) OVER(PARTITION BY col1, col2)

**5. RUNNING MINIMUM**

Used when ORDER BY is present in OVER clause

    MIN(value) OVER(
      PARTITION BY entity_id
      ORDER BY date_column
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )

Meaning:

    Minimum so far, row by row, based on order

**6. FILTERING ROWS THAT MATCH MIN**

Window functions cannot be used directly in WHERE

    Use subquery or CTE

    SELECT *
    FROM (
      SELECT value,
             MIN(value) OVER(PARTITION BY group_col) AS min_value
      FROM table_name
    ) t
    WHERE value = min_value

**7. NULL HANDLING**

MIN ignores NULL values by default.

No need to filter NULL unless business logic requires.

Danger zone:

    Using COALESCE(value, 0) can create fake minimums.
    Only use COALESCE if 0 is a valid business value.

Correct approach:

    Filter NULLs if needed.
    WHERE value IS NOT NULL.

**8. MIN WITH EXPRESSIONS**

     MIN(column1 + column2) OVER(PARTITION BY group_col)

Be careful:

    If either column is NULL, result becomes NULL
Use explicit logic if needed

      CASE WHEN column1 IS NOT NULL AND column2 IS NOT NULL
      THEN column1 + column2
      END

**9. MIN WITH DATES AND TIMES**

    MIN(date_column) OVER()
    
Returns earliest date

    MIN(time_column) OVER(PARTITION BY date_column)
    
Returns earliest time per day

    MIN(datetime_column) OVER(PARTITION BY date_column)
    
Returns earliest datetime per date

**10. MIN VS GROUP BY**

GROUP BY:

Returns one row per group.

Cannot show row-level data.

MIN() OVER():

Returns min while keeping all rows.

Required for analytics and comparisons.

**11. MIN VS RANK PATTERNS**

MIN returns value

RANK returns position

To get rows with minimum value:

    Use MIN() OVER() + filter

or
    
    use ROW_NUMBER ordered ascending and filter row_number = 1

**12. HOW MIN RELATES TO AVG AND OTHER AGGREGATES**

MIN, MAX, AVG, SUM, COUNT follow same window rules

Difference is only calculation logic

AVG with window:

    AVG(value) OVER(PARTITION BY group_col)
    
Returns group average per row

Common combo:

Compare value vs MIN or AVG:

    value - MIN(value) OVER()
    value - AVG(value) OVER()

Used in analytics and reporting heavily.

**13. COMMON SENIOR-DEVELOPER PITFALLS**

Using GROUP BY when window is required.

Using COALESCE blindly with MIN.

Forgetting WHERE runs before window.

Expecting MIN to remove duplicates.

Using ORDER BY without ROWS clause unintentionally.

Filtering on window alias in WHERE instead of subquery.

**14. INTERVIEW-LEVEL TIPS**

Say this clearly
Window functions calculate aggregates without collapsing rows

Explain execution order confidently:

FROM

JOIN

WHERE

WINDOW FUNCTIONS

SELECT

**15. PROJECT-LEVEL INDUSTRY USAGE**

Healthcare

Lowest reading per patient
Earliest diagnosis date

Finance

Minimum transaction amount per account
Lowest balance per month

E-commerce

Minimum order value per customer
Cheapest product per category

HR

Minimum salary per department
Earliest joining date

**16. PERFORMANCE NOTES**

Window functions are computed after filtering.

Partitioning on high-cardinality columns increases cost.

Indexes help filtering, not window calculation directly.

Avoid unnecessary ORDER BY in window.

**17. WHEN NOT TO USE MIN() OVER()**

When only one row per group is required.

When aggregation result only is needed.
Use GROUP BY instead

**18. FINAL GOLDEN RULES**

Use MIN() OVER() when row context matters.

Never collapse rows unless required.

Avoid fake minimums from COALESCE.

Use subquery to filter on window results.

Understand business meaning before NULL handling.



