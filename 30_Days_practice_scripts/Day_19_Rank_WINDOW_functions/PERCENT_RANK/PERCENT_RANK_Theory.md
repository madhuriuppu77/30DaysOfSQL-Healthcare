
**1) WHAT IS PERCENT_RANK**

PERCENT_RANK is a window function that returns the relative position of a row within an ordered dataset.

The output is a decimal value between 0 and 1.

Formula used internally:

    (rank - 1) / (total_rows - 1)

Important points:

-Lowest value always gets 0

-Highest value always gets 1

-Values in between are evenly distributed

-If only one row exists, result is 0

PERCENT_RANK does not show percentage directly.

    0.25 means 25 percent of rows are below this row.


**2) BASIC SYNTAX**

    PERCENT_RANK() OVER (ORDER BY column)

This calculates percent rank across the entire result set.


**3) ORDER BY BEHAVIOR**

ORDER BY controls ranking direction.

Ascending order:

    Lowest value → 0
    Highest value → 1

Descending order:

    Highest value → 0
    Lowest value → 1

Example:

    PERCENT_RANK() OVER (ORDER BY salary DESC)

Used when top performers should have rank 0.


**4) PARTITIONING BEHAVIOR**

PARTITION BY divides data into independent groups.

Ranking restarts for each partition.

Syntax:

    PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary)

Meaning:

    Employees are ranked relative only to others in the same department.
    Percent rank does not compare across departments.

Common partitions:

-department

-city

-gender

-year

-month

-doctor_id

-patient_id


**5) FRAME CLAUSES (ROWS / RANGE)**

PERCENT_RANK ignores frame clauses,
It always operates on the full partition.

These clauses have no effect:

    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

Why:

    PERCENT_RANK is a ranking function, not an aggregate.
    It must see all rows in the partition to compute total_rows.
  

**6) HANDLING NULL VALUES**

NULLs are included unless filtered explicitly.

Best practice:

    Control NULL position using CASE inside ORDER BY.

Example:

    ORDER BY CASE WHEN amount IS NULL THEN 1 ELSE 0 END, amount

This pushes NULL values to the end.

Alternative:

    Filter NULLs using WHERE clause when business logic requires it.


**7) TIES AND DUPLICATES**

PERCENT_RANK uses RANK logic internally.

If multiple rows have the same value:

They receive the same percent_rank,
Gaps appear in ranking positions.

Example:

      Values: 100, 100, 200
      Ranks: 1, 1, 3
      Percent ranks:
      (1-1)/(3-1) = 0
      (1-1)/(3-1) = 0
      (3-1)/(3-1) = 1


**8) DIFFERENCE FROM SIMILAR FUNCTIONS**

PERCENT_RANK:

    Based on rank position
    Lowest = 0, Highest = 1
    Sensitive to row count
    Best for relative position analysis

CUME_DIST:

    Based on cumulative distribution
    Shows proportion of rows less than or equal to current row
    Last row always 1
    Better for percentile-style reporting

NTILE:

    Splits rows into equal buckets
    Returns bucket number
    Used for segmentation

RANK / DENSE_RANK:

    Return integer ranks
    Not normalized
    Used when exact rank is needed


**9) REAL PROJECT USE CASES**

Use case 1: Customer spending analysis:

    Rank customers by total purchase amount to identify top spenders relative to others.

Use case 2: Healthcare analytics:

    Rank patients by total billing within each city or hospital.

Use case 3: Employee performance:

    Rank employees within departments by performance score.

Use case 4: Risk scoring:

    Rank accounts by risk score to determine relative exposure.

Use case 5: Monitoring trends:

    Rank monthly revenue within each year to detect high-performing months.

Use case 6: Resource utilization:

    Rank doctors by number of patients handled relative to peers.

Use case 7: Anomaly detection:

    Very high or very low percent ranks highlight outliers.


**10) PERFORMANCE CONSIDERATIONS**

PERCENT_RANK requires sorting,
Sorting is the most expensive operation.

**Performance tips:**

-Index columns used in ORDER BY

-Reduce data before ranking using WHERE filters

-Aggregate first, rank later

-Avoid unnecessary PARTITION BY columns

-Avoid ranking huge datasets without filters

-Use proper data types to reduce memory usage

Example optimization:

Instead of ranking raw rows, aggregate first:

Compute total revenue per doctor,
Then apply PERCENT_RANK on aggregated result.


**11) COMMON MISTAKES**

-Expecting percent values like 25 or 30 instead of 0.25 or 0.30

-Forgetting ORDER BY

-Using frame clauses expecting different results

-Ranking raw data instead of aggregated metrics

-Not handling NULLs explicitly

-Misinterpreting descending order results

-Using PERCENT_RANK when CUME_DIST is required


**12) INTERVIEW TIPS**

Always explain:

-What is being ranked

-Relative to what group

-Why partitioning is needed

-Why ordering direction was chosen

Strong interview explanation:

“I first aggregated the business metric, then applied PERCENT_RANK to measure relative position within each logical group, handling NULLs explicitly.”

**Interview questions often test:**

-Understanding of normalization

-Difference between percent_rank and cume_dist

-Partitioned ranking logic

-NULL handling

-Business interpretation of output

Rule of thumb:

    Use PERCENT_RANK when comparison relative to peers matters more than absolute rank.


**13) WHEN TO USE PERCENT_RANK**

Use when:

-You want relative position

-You want values between 0 and 1

-You want easy comparison across groups

-You want normalized ranking

Avoid when:

-Exact rank numbers are required

-Bucketed segmentation is required

-Cumulative percentage is required


**14) FINAL SUMMARY**

-PERCENT_RANK measures relative position.

-It is deterministic, normalized, and partition-aware.

-It is best used for analytical insights, benchmarking, and peer comparison.

-Understanding ordering, partitioning, NULL handling, and performance makes it interview-ready and production-ready.

