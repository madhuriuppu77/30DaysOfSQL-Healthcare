

**1) WHAT NTILE IS**

NTILE(n) is a window function that divides rows into n approximately equal groups
after sorting the data. Each row is assigned a bucket number starting from 1.

Key idea:

NTILE distributes rows evenly across buckets, not based on value ranges,
but based on row count after ORDER BY.

Example:

    If you have 10 rows and NTILE(3)
    Buckets will be:
    Bucket 1 → 4 rows
    Bucket 2 → 3 rows
    Bucket 3 → 3 rows

Extra rows always go to lower numbered buckets.

**2) BASIC SYNTAX**

    NTILE(n) OVER (ORDER BY column)

With partitioning:

    NTILE(n) OVER (PARTITION BY column ORDER BY column)

General form:

    NTILE(n) OVER (
      PARTITION BY partition_column
      ORDER BY sort_column
    )

**3) HOW NTILE WORKS INTERNALLY**

Step 1: Apply PARTITION BY

Data is logically split into independent groups

Step 2: Apply ORDER BY

Rows inside each partition are sorted

Step 3: Assign row numbers

Database assigns row numbers internally

Step 4: Distribute rows

Rows are divided into n buckets as evenly as possible

Important:

    NTILE is row-count based, not value-based

**4) PARTITION BY IN NTILE**

Partitioning means NTILE restarts for each group.

Example:

Divide patients into 3 age groups per city

    SELECT
      patient_id,
      city,
      age,
      NTILE(3) OVER (PARTITION BY city ORDER BY age DESC) AS age_bucket
    FROM Patients;

Each city gets its own 3 buckets.

Without PARTITION BY:

All rows across all cities are bucketed together.

**5) ORDER BY IN NTILE**

ORDER BY controls which rows fall into higher or lower buckets.

Ascending:

    Lower values → lower buckets

Descending:

    Higher values → lower buckets

Example:

Top spenders first

    NTILE(4) OVER (ORDER BY total_amount DESC)

**6) NULL HANDLING IN NTILE**

NTILE does not ignore NULLs automatically,
NULLs participate in ordering.

Best practice:

    Push NULLs to the end or remove them explicitly.

Push NULLs last:

    ORDER BY CASE WHEN col IS NULL THEN 1 ELSE 0 END, col DESC

Ignore NULLs:
 
    WHERE col IS NOT NULL

7) FRAME CLAUSES AND NTILE

NTILE does not support frame clauses like

    ROWS BETWEEN or RANGE BETWEEN.

Why:

     NTILE operates on the full partition after sorting.
     Frames are row-by-row calculations, NTILE is distribution-based.

This is valid:

    NTILE(4) OVER (PARTITION BY dept ORDER BY salary DESC)

This is invalid:

    NTILE(4) OVER (
      PARTITION BY dept
      ORDER BY salary
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )

**8) REAL PROJECT USE CASES**

Customer segmentation:

Divide customers into quartiles based on spending

    SELECT
      customer_id,
      NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_segment
    FROM Customers;

Healthcare risk grouping:

Split patients into risk tiers by number of visits

    SELECT
      patient_id,
      NTILE(3) OVER (ORDER BY visit_count DESC) AS risk_group
    FROM Patient_Stats;

Sales performance:

Bucket sales reps into performance tiers per region

    SELECT
      rep_id,
      region,
      NTILE(5) OVER (PARTITION BY region ORDER BY revenue DESC) AS performance_band
    FROM Sales;

Billing analysis:

Top, middle, bottom revenue doctors per department

    SELECT
      doctor_id,
      department,
      NTILE(3) OVER (PARTITION BY department ORDER BY total_billing DESC) AS revenue_group
    FROM Doctor_Billing;

**9) NTILE VS OTHER WINDOW FUNCTIONS**

NTILE:

    Equal row distribution
    Used for segmentation

RANK:

    Same values get same rank
    Gaps in ranking

DENSE_RANK:

    Same values get same rank
    No gaps

ROW_NUMBER:

    Unique sequential numbering
    No grouping

Use NTILE when you need percentiles or buckets.

**10) PERFORMANCE CONSIDERATIONS**

ORDER BY is expensive,
Ensure sort columns are indexed where possible.

PARTITION BY increases cost,
More partitions = more sorting.

Use NTILE after aggregation,
Aggregate first, then apply NTILE.

Good:

    Aggregate → NTILE

Bad:

    NTILE on raw transactional data

Avoid NTILE on very large partitions if possible

**11) COMMON MISTAKES**

Using NTILE without ORDER BY,
This is invalid SQL.

Expecting equal value ranges,
NTILE distributes rows, not values.

Forgetting NULL handling,
Leads to skewed buckets.

Using NTILE when percentile is needed,
Use PERCENTILE_CONT instead.

**12) INTERVIEW TIPS**

Explain NTILE as row-based distribution,
Not value-based grouping.

Mention extra rows go to lower buckets.

Always talk about ORDER BY importance.

State that NTILE does not support frame clauses.

Be ready to explain difference vs RANK and ROW_NUMBER.

Say when NTILE is preferred,
Segmentation, quartiles, deciles, bucketing.

**13) WHEN NOT TO USE NTILE**

When you need exact percentiles.

When value ranges matter.

When partitions are extremely skewed.

When NULLs dominate the dataset.

**14) ONE-LINE SUMMARY**

NTILE is used to evenly distribute rows into fixed buckets after sorting,
commonly used for segmentation, quartiles, and ranking bands in analytics.

