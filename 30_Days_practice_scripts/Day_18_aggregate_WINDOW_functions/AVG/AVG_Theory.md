SQL WINDOW FUNCTION AVG() — COMPLETE CLEAN NOTES

**1) WHAT IS AVG() AS A WINDOW FUNCTION**

- AVG() is an aggregate function.
- With OVER(), it becomes a window (analytic) function.
- It calculates averages without collapsing rows.
- Each row keeps its identity.

Difference:

- GROUP BY reduces rows
- AVG() OVER() keeps all rows

**2) BASIC SYNTAX**
   
      AVG(column_name) OVER (
          PARTITION BY partition_column
          ORDER BY order_column
          ROWS or RANGE frame_definition
      )

Common forms:

**• Overall average:**

  AVG(col) OVER()

**• Group-wise average:**

  AVG(col) OVER(PARTITION BY group_col)

**• Running average:**

  AVG(col) OVER(PARTITION BY group_col ORDER BY date_col
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

**• Moving average:**

  AVG(col) OVER(PARTITION BY group_col ORDER BY date_col
                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
                
**3) HOW AVG() WORKS INTERNALLY**

AVG(col) = SUM(col) / COUNT(col)

- NULL values are ignored
- COUNT(col) counts only non-null values
- If all values are NULL, result is NULL

**4) AVG() WITH PARTITION BY**

- Used for group-wise averages without GROUP BY
- Shows group average on every row

Example use cases:

- Average salary per department
- Average visit cost per doctor
- Average marks per class

**5) AVG() WITH ORDER BY**

- ORDER BY enables running or moving averages

**Running average:**

AVG(cost) OVER(ORDER BY date
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

**Moving average (last N rows):**

AVG(cost) OVER(ORDER BY date
               ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

**6) ROWS VS RANGE**

ROWS

- Row-based
- Predictable
- Recommended

RANGE

- Value-based
- Can behave unexpectedly with duplicates

Best practice:

Always prefer ROWS unless RANGE is required

**7) FILTERING WITH AVG()**

- Window functions cannot be used in WHERE

Wrong:

    WHERE cost > AVG(cost) OVER()

Correct:

    Use subquery or CTE

**8) AVG() WITH EXPRESSIONS**

You can average calculated values:

    AVG(consultation_fee + medicine_cost - discount) OVER()

Common in:

- Revenue calculations
- Profit analysis
- Net billing amounts

**9) NULL HANDLING**

AVG ignores NULL values.

To include NULL as zero:

    AVG(COALESCE(col, 0)) OVER()

Warning:

NULL and zero have different business meanings

**10) AVG() WITH DISTINCT**

    AVG(DISTINCT col) OVER()

Used when duplicate values must be ignored
Rare but interview-relevant

**11) AVG() WITH OTHER WINDOW FUNCTIONS**

Common combinations:

  - AVG + ROW_NUMBER
  - AVG + LAG
  - AVG + COUNT

Example:

value - AVG(value) OVER() gives deviation from average

**12) REAL WORLD USE CASES**

Healthcare:

- Average BP over last N readings
- Average treatment cost per patient

Finance:

- Moving averages of stock prices
- Average transaction amount

E-commerce:

- Average order value
- Average discount per category

HR:

- Average salary per role
- Average experience per department

**13) SENIOR LEVEL PRACTICES**

- Always use deterministic ORDER BY columns
- Avoid PARTITION BY on unique keys
- Use ROWS instead of RANGE
- Use CASE inside AVG for conditional averages

Example:

    AVG(CASE WHEN status = 'Completed' THEN cost END) OVER()

**14) INTERVIEW TIPS**

- AVG ignores NULL values
- Window functions do not reduce rows
- ORDER BY inside OVER does not sort final output
- WHERE cannot use window function results
- Use subquery or CTE for filtering

Strong interview line:

    AVG() OVER() provides analytical averages while preserving row-level detail

**15) PROJECT LEVEL BEST PRACTICES**

- Use moving averages for trend smoothing
- Validate window frame definitions carefully
- Index PARTITION BY and ORDER BY columns
- Avoid unnecessary window calculations on large datasets

**16) COMMON MISTAKES**

- Using PARTITION BY primary key
- Forgetting ORDER BY for running averages
- Using window functions in WHERE
- Confusing GROUP BY with OVER()
- Accidentally using RANGE

**17) WHEN NOT TO USE AVG() WINDOW FUNCTION**

- When only aggregated output is required
- When row-level context is not needed

**18) GOLDEN RULES**

- OVER() means analytics
- PARTITION BY defines grouping
- ORDER BY defines sequence
- ROWS defines the frame safely
- AVG equals SUM divided by COUNT



