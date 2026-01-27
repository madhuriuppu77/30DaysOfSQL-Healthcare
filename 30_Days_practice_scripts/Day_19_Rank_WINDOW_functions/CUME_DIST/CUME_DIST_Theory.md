

**WHAT IS CUME_DIST**

-CUME_DIST is a window function that calculates the cumulative distribution of a value within a result set.

-It shows the proportion of rows that have values less than or equal to the current row.

-The output is always between 0 and 1.

-It never returns NULL.

**CONCEPTUAL FORMULA**

    number of rows less than or equal to current row
    divided by
    total number of rows in the window

**WHY CUME_DIST IS USED**

It answers percentile style questions such as,

    Which rows fall in the top 10 percent,
    Which records are below the median,
    How a value compares relative to the entire dataset.

**BASIC SYNTAX**

    CUME_DIST() OVER (ORDER BY column_name)

**ORDER BY BEHAVIOR**

Ascending order:

    Smaller values produce smaller cumulative distribution
    Larger values approach 1

Descending order:

    Larger values produce smaller cumulative distribution
    Useful for top performer analysis

Example:

    SELECT
        patient_id,
        age,
        CUME_DIST() OVER (ORDER BY age) AS cume_dist_value
    FROM Patients

**HANDLING TIES**

If multiple rows have the same value.

All those rows receive the same cumulative distribution.

The distribution jumps instead of increasing gradually.

Example values

20 30 30 40

    CUME_DIST results
    20 -> 0.25
    30 -> 0.75
    30 -> 0.75
    40 -> 1.00

**PARTITION BY USAGE**

Partitioning resets the cumulative distribution for each group

Syntax

    CUME_DIST() OVER (
        PARTITION BY group_column
        ORDER BY value_column
    )

Example

    SELECT
        patient_id,
        gender,
        age,
        CUME_DIST() OVER (
            PARTITION BY gender
            ORDER BY age
        ) AS age_distribution
    FROM Patients

**FRAME CLAUSE SUPPORT**

CUME_DIST does not support ROWS or RANGE frame clauses,
It is a ranking window function.

The database engine automatically defines the frame.

Invalid usage example

    CUME_DIST() OVER (
        ORDER BY age
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )

**NULL HANDLING**

-By default NULL values are ordered last.

-To control NULL placement use CASE expressions.

Example

    CUME_DIST() OVER (
        ORDER BY
            CASE WHEN age IS NULL THEN 1 ELSE 0 END,
            age
    )

Or 

    exclude NULLs using WHERE clause

**REAL PROJECT USE CASES**

Customer segmentation:

Identify customers in top or bottom spending percentiles

Example

    SELECT *
    FROM (
        SELECT
            customer_id,
            total_spend,
            CUME_DIST() OVER (ORDER BY total_spend DESC) AS spend_distribution
        FROM Customers
    ) t
    WHERE spend_distribution <= 0.10

Healthcare risk analysis:

Identify patients with high vital readings

Example

    SELECT
        patient_id,
        bp_systolic,
        CUME_DIST() OVER (ORDER BY bp_systolic) AS bp_distribution
    FROM VitalReadings

Salary benchmarking:

Find employees below or above company median

Example

    SELECT *
    FROM (
        SELECT
            emp_id,
            salary,
            CUME_DIST() OVER (ORDER BY salary) AS salary_distribution
        FROM Employees
    ) t
    WHERE salary_distribution <= 0.50

Fraud detection:

Identify top percentile transactions

**PERFORMANCE CONSIDERATIONS**

CUME_DIST requires sorting which can be expensive.

Large partitions increase memory usage.

Indexes on ORDER BY columns may help.

Avoid using functions in ORDER BY when possible.

Smaller partitions perform better than one large partition.

**COMMON INTERVIEW POINTS**

CUME_DIST always returns values between 0 and 1.

It includes the current row in calculation.

It handles ties by assigning the same cumulative value.

It cannot be used with GROUP BY directly.

It cannot use frame clauses.

Filtering must be done using subqueries or CTEs.

**WHEN NOT TO USE CUME_DIST**

When exact ranking is required use RANK or DENSE_RANK.

When equal sized buckets are needed use NTILE.

When row comparison is needed use LAG or LEAD.

**ONE LINE INTERVIEW SUMMARY**

CUME_DIST calculates the cumulative proportion of rows less than or equal to the current row within an ordered partition without collapsing rows

