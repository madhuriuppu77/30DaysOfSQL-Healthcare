
**1. WHAT IS MIN() AS A WINDOW FUNCTION**

1) MIN() as a window function returns the minimum value from a set of rows
defined by a window while keeping all original rows intact.

2) It is used when analytical minimum values are needed alongside row level data
GROUP BY reduces rows.

3) MIN() OVER() preserves row level detail and adds analytical insight.

**2. BASIC SYNTAX**

      MIN(column_name) OVER()
      MIN(column_name) OVER (PARTITION BY column1)
      MIN(column_name) OVER (PARTITION BY column1, column2)
      MIN(column_name) OVER (PARTITION BY column1 ORDER BY column2)

**3. PARTITION BY IN MIN()**

1) PARTITION BY divides data into logical groups.
   
2) MIN() is calculated independently for each partition.

**Example scenarios:**

1) Average and minimum salary analysis per department.
   
2) Minimum order value per customer.
   
3) Minimum treatment cost per department.

**Example meaning:**

     MIN(salary) OVER (PARTITION BY department_id)
    
Every employee row shows the department minimum salary.

**Important note:**

     PARTITION BY never reduces rows
 
**4. ORDER BY IN MIN()**

1) ORDER BY defines the sequence of rows inside each partition.

**)When ORDER BY is present,
MIN() becomes cumulative by default.

Example:

      MIN(order_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
      )

-This produces the minimum value seen so far

**)Without ORDER BY,
MIN returns the same value for all rows in the partition

**5. FRAME CLAUSE IN MIN()**

Frame clause controls which rows are included relative to the current row.

**Default behavior:**

**With ORDER BY:**

     RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

**Without ORDER BY:**

     Entire partition is considered

**Explicit frame syntax:**

      MIN(amount) OVER (
        PARTITION BY account_id
        ORDER BY transaction_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      )

**Common frame patterns:**

Running minimum

     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

Full partition minimum even with ORDER BY

     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

Moving window minimum

     ROWS BETWEEN 3 PRECEDING AND CURRENT ROW

ROWS is row based and predictable

     RANGE is value based and may include duplicates

Best practice is to prefer ROWS unless business logic requires RANGE

**6. MIN() WITH NULL VALUES**

1) MIN ignores NULL values by default,
Only non NULL values are considered.

2) If all values are NULL,
MIN returns NULL.

3) Handling NULL explicitly,
Use COALESCE when required.

**7. REAL PROJECT USE CASES**

**Finance and Banking:**

      Minimum account balance tracking
      Risk threshold monitoring
      Fraud detection signals

**E commerce:**

      Lowest order value analysis
      Discount effectiveness analysis
      Price floor validation

**Healthcare:**

      Minimum treatment cost per patient
      Lowest length of stay detection
      Department wise minimum billing

**HR and Payroll:**

      Minimum salary compliance checks
      Entry level compensation analysis
      Pay band validation

**Telecom and Utilities:**

      Minimum usage detection
      Baseline consumption analysis
      Billing floor enforcement

**8. MIN() VS GROUP BY MIN()**

**GROUP BY MIN:**

1) Returns one row per group.
2) Used for summary reporting.

**MIN() OVER:**

1) Returns one row per input row.
2) Used for analytical reporting.

**Rule:**

     Use MIN() OVER() when row level detail is required.

**9. PERFORMANCE CONSIDERATIONS**

-Avoid unnecessary ORDER BY.

-Sorting increases query cost.

-Partition carefully to avoid large memory usage.

-Prefer ROWS over RANGE for predictable behavior.

-Filter early using WHERE to reduce dataset.

-Index PARTITION BY and ORDER BY columns for better performance.

**10. COMMON MISTAKES**

-Expecting MIN() OVER() to reduce rows.

-Forgetting ORDER BY makes MIN cumulative.

-Using RANGE unintentionally with duplicates.

-Misinterpreting NULL handling.

**11. INTERVIEW LEVEL INSIGHTS**

-MIN() OVER() is an analytical window function.

-PARTITION BY defines grouping without collapsing rows.

-ORDER BY enables running minimum calculations.

-Frame clause controls calculation boundaries.

-ROWS provides deterministic results.

**Typical interview questions:**

-Difference between MIN() OVER() and GROUP BY MIN().

-How to calculate running minimum.

-How NULL values affect MIN().

-When to use frame clauses.

**Strong interview line:**

      MIN window functions help detect lower bounds and thresholds
      while preserving transactional level data

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






