
**1. WHAT IS AVG() AS A WINDOW FUNCTION**

AVG() as a window function calculates the average of numeric values
over a defined window while keeping all original rows.

**Key idea:**

1) GROUP BY reduces rows.

2) AVG() OVER() preserves row level detail and adds analytical insight.

It is used when business needs both detailed data and aggregated
average metrics in the same result set.

**2. BASIC SYNTAX**

    AVG(column_name) OVER()

    AVG(column_name) OVER (PARTITION BY column1)

    AVG(column_name) OVER (
      PARTITION BY column1, column2
    )

    AVG(column_name) OVER (
      PARTITION BY column1
      ORDER BY column2
    )

**3. PARTITION BY IN AVG()**

1) PARTITION BY divides data into logical groups.

2) AVG() is calculated independently for each partition.

**Example scenarios:**

Average salary per department.

Average order value per customer.

Average treatment cost per hospital department.

**Example meaning:**

    AVG(salary) OVER (PARTITION BY department_id)
    
Every employee row shows department average salary.

**Important note:**

    PARTITION BY never reduces rows.

**4. ORDER BY IN AVG()**

ORDER BY defines the sequence of rows inside each partition.

**When ORDER BY is present:**

    AVG() becomes cumulative by default.

Example:

    AVG(order_amount) OVER (
      PARTITION BY customer_id
      ORDER BY order_date
    )

This produces a running average over time.

**Without ORDER BY:**

    AVG returns the same value for all rows in the partition.

**5. FRAME CLAUSE IN AVG()**

Frame clause controls which rows are included relative to the current row.

**Default behavior:**

**With ORDER BY:**

    RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

**Without ORDER BY:**

    Entire partition is considered.

**Explicit frame syntax:**

    AVG(amount) OVER (
      PARTITION BY account_id
      ORDER BY transaction_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )

**Common frame patterns:**

Running average:

    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

Full partition average even with ORDER BY:

    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING.

Moving average:

    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW.

ROWS is row based and predictable:

    RANGE is value based and may include duplicates.

Best practice:

    Prefer ROWS unless business logic requires RANGE.

**6. AVG() WITH NULL VALUES**
   
1) AVG ignores NULL values by default,
Only non NULL numeric values are used.

2) If all values are NULL,
AVG returns NULL.

3) Handling NULL explicitly,
Use COALESCE when required.

**7. REAL PROJECT USE CASES**

**1)Finance and Banking:**

-Average account balance trend.

-Rolling transaction average.

-Customer spending behavior.

**2)E commerce:**

-Average order value.

-Moving explaining price sensitivity.

-Category wise pricing analysis.

**3)Healthcare:**

-Average length of stay.

-Average treatment cost per patient.

-Department wise care cost trends.

**4)HR and Payroll:**

-Average salary per team.

-Performance based compensation analysis.

-Hiring trend evaluation.

**5)Telecom and Utilities:**

-Average usage per customer.

-Rolling consumption analysis.

-Billing stability monitoring.

**8. AVG() VS GROUP BY AVG()**

**GROUP BY AVG():**

    Returns one row per group.
    Used for summary reporting.

**AVG() OVER():**

    Returns one row per input row.
    Used for analytical reporting.

**Rule**:

     Use AVG() OVER() when row level detail is required.

**9. PERFORMANCE CONSIDERATIONS**
    
1) Avoid unnecessary ORDER BY,
Sorting increases query cost.

2) Partition carefully,
Large partitions consume more memory.

3) Prefer ROWS over RANGE,
ROWS gives deterministic performance.

4) Filter early using WHERE,
Reduces rows before window calculation.

5) Index PARTITION BY and ORDER BY columns,
Improves performance on large tables.

**10. COMMON MISTAKES**

-Expecting AVG() OVER() to reduce rows.

-Forgetting ORDER BY creates running average.

-Using RANGE unintentionally with duplicates.

-Misinterpreting NULL handling.

**11. INTERVIEW LEVEL INSIGHTS**

**Key points to explain:**

-AVG() OVER() is an analytical function.

-PARTITION BY defines grouping without collapsing rows.

-ORDER BY enables running averages.

-Frame clause controls the calculation window.

-ROWS provides predictable results.

**Typical interview questions:**

-How to calculate running average.

-Difference between AVG() OVER() and GROUP BY AVG().

-Explain moving average use cases.

-Handling NULL values in AVG.

**Strong interview line:**

    AVG window functions help analyze trends and patterns
    while preserving transactional level data.

**12. SQL EXECUTION ORDER CONTEXT**

Logical execution order:

FROM.

WHERE.

GROUP BY.

HAVING.

SELECT.

WINDOW FUNCTIONS.

ORDER BY.

LIMIT.

    This explains why window functions cannot be used in WHERE clause.






