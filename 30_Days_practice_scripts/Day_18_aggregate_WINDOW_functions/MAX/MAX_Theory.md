

**1. WHAT IS MAX() AS A WINDOW FUNCTION**

1) MAX() as a window function returns the maximum value from a set of rows
defined by a window while keeping all original rows intact.

2) It is used when analytical maximum values are required alongside row level data
GROUP BY reduces rows.

3) MAX() OVER() preserves row level detail and adds analytical insight.

**2. BASIC SYNTAX**

        MAX(column_name) OVER()
        MAX(column_name) OVER (PARTITION BY column1)
        MAX(column_name) OVER (PARTITION BY column1, column2)
        MAX(column_name) OVER (PARTITION BY column1 ORDER BY column2)

**3. PARTITION BY IN MAX()**

1) PARTITION BY divides data into logical groups.
   
2) MAX() is calculated independently for each partition.

**Example scenarios:**

        Highest salary per department
        Maximum order value per customer
        Maximum treatment cost per department

Example meaning:

     MAX(salary) OVER (PARTITION BY department_id)

Every employee row shows the department maximum salary.

**Important note:**

     PARTITION BY never reduces rows.

**4. ORDER BY IN MAX()**

ORDER BY defines the sequence of rows inside each partition.

**When ORDER BY is present:**

     MAX() becomes cumulative by default

Example:

        MAX(order_amount) OVER (
          PARTITION BY customer_id
          ORDER BY order_date
        )
        
        This produces the maximum value seen so far

**Without ORDER BY:**

     MAX returns the same value for all rows in the partition

**5. FRAME CLAUSE IN MAX()**

Frame clause controls which rows are included relative to the current row.

Default behavior:

**With ORDER BY:**

     RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

**Without ORDER BY:**

     Entire partition is considered

Explicit frame syntax:

        MAX(amount) OVER (
          PARTITION BY account_id
          ORDER BY transaction_date
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )

**Common frame patterns:**

Running maximum

     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

Full partition maximum even with ORDER BY

     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

Moving window maximum

     ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
     

1) ROWS is row based and predictable.

2) RANGE is value based and may include duplicates.

        Best practice is to prefer ROWS unless business logic requires RANGE

**6. MAX() WITH NULL VALUES**

1) MAX ignores NULL values by default,
Only non NULL values are considered.

2) If all values are NULL
MAX returns NULL.

3) Handling NULL explicitly,
Use COALESCE when required.

**7. REAL PROJECT USE CASES**
   
Finance and Banking:

        Peak account balance tracking
        Risk exposure monitoring
        Fraud spike detection

E commerce:

        Highest order value analysis
        Revenue spike identification
        Pricing ceiling validation

Healthcare:

        Maximum treatment cost per patient
        Longest length of stay detection
        Department wise peak billing

HR and Payroll:

        Highest salary benchmarking
        Top performer compensation analysis
        Pay band ceiling checks

Telecom and Utilities:

        Peak usage detection
        Maximum consumption analysis
        Billing cap enforcement

**8. MAX() VS GROUP BY MAX()**

**GROUP BY MAX:**

1) Returns one row per group.
2) Used for summary reporting.

**MAX() OVER:**

1) Returns one row per input row.
2) Used for analytical reporting.

**Rule:**

     Use MAX() OVER() when row level detail is required.

**9. PERFORMANCE CONSIDERATIONS**

-Avoid unnecessary ORDER BY.

-Sorting increases query cost.

-Partition carefully to avoid large memory usage.

-Prefer ROWS over RANGE for predictable behavior.

-Filter early using WHERE to reduce dataset.

-Index PARTITION BY and ORDER BY columns for better performance.

**10. COMMON MISTAKES**

-Expecting MAX() OVER() to reduce rows.

-Forgetting ORDER BY makes MAX cumulative.

-Using RANGE unintentionally with duplicates.

-Misinterpreting NULL handling.

**11. INTERVIEW LEVEL INSIGHTS**

-MAX() OVER() is an analytical window function.

-PARTITION BY defines grouping without collapsing rows.

-ORDER BY enables running maximum calculations.

-Frame clause controls calculation boundaries.

-ROWS provides deterministic results.

**Typical interview questions:**

-Difference between MAX() OVER() and GROUP BY MAX().

-How to calculate running maximum.

-How NULL values affect MAX().

-When to use frame clauses.

**Strong interview line:**

        MAX window functions help detect peaks and upper bounds,
        while preserving transactional level data.

**12. SQL EXECUTION ORDER CONTEXT**

**Logical execution order:**

FROM

WHERE

GROUP BY

HAVING

SELECT

WINDOW FUNCTIONS

ORDER BY

LIMIT

      This explains why window functions cannot be used in WHERE clause




