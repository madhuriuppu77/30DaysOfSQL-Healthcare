

**1) WHAT ROW_NUMBER() IS**

ROW_NUMBER() is a window function that assigns a unique sequential number to each row in a result set.

The numbering is based on the order you define and optionally resets for each group.

Key idea:

- Every row gets a unique number

- No ties, even if values are the same

- Numbering can restart using PARTITION BY

Syntax shape:

    ROW_NUMBER() OVER (window_definition)


**2) BASIC SYNTAX**

    ROW_NUMBER() OVER (ORDER BY column)

Meaning:

- Assigns numbers globally

- Entire result set is treated as one group

- Order decides numbering

Example logic:

    Smallest value gets 1 (ASC)
    Largest value gets 1 (DESC)


**3) PARTITION BY (RESETTING ROW NUMBERS)**

    ROW_NUMBER() OVER (
        PARTITION BY column1
        ORDER BY column2
    )

Meaning:

- Data is split into groups using PARTITION BY

- ROW_NUMBER resets to 1 for each group

- ORDER BY decides sequence inside each group

Think of PARTITION BY as:

    GROUP BY without collapsing rows

Common use:

- First row per group

- Latest record per customer

- Top N per category


**4) ORDER BY (MOST IMPORTANT PART)**

ORDER BY decides:

    - Who gets row_number = 1
    - Whether earliest, latest, highest, lowest comes first

Examples:

    ORDER BY date ASC   -> earliest first
    ORDER BY date DESC  -> latest first
    ORDER BY amount DESC -> highest amount first

Wrong ORDER BY = wrong result

    ROW_NUMBER logic is meaningless without ORDER BY


**5) HANDLING NULLS (VERY IMPORTANT)**

Default behavior:

- NULL ordering is database-dependent

- Can cause wrong first or last records

Correct approach:

    Use CASE WHEN in ORDER BY

    ORDER BY
        CASE WHEN column IS NULL THEN 1 ELSE 0 END,
        column

Meaning:

- Push NULLs to the bottom

- Then sort actual values

Why not WHERE?

WHERE removes rows

CASE WHEN preserves rows and controls order


**6) FRAME CLAUSE (ROWS / RANGE)**

ROW_NUMBER does NOT need a frame clause.

ROW_NUMBER always works row by row and ignores frame definitions.

Even if you write:

    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

    It will be ignored.

Important interview point:

    - ROW_NUMBER does not use frame clauses
    - SUM, AVG, COUNT do use frame clauses


**7) FIRST RECORD PER GROUP**

Pattern:

    SELECT *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY group_column
                ORDER BY sort_column ASC
            ) AS rn
        FROM table
    ) t
    WHERE rn = 1;

Use cases:

- First visit per patient

- Earliest order per customer

- First employee per department


**8) LATEST / MOST RECENT RECORD PER GROUP**

Pattern:

    ROW_NUMBER() OVER (
        PARTITION BY group_column
        ORDER BY date_column DESC
    )
    
    Then filter rn = 1

    Mnemonic:
    ASC  -> earliest
    DESC -> latest


**9) TOP N PER GROUP**

Example: Top 3 salaries per department

    ROW_NUMBER() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    )
    
    Then filter:
    WHERE rn <= 3

ROW_NUMBER vs RANK:

    - ROW_NUMBER gives exactly N rows
    - RANK may give more due to ties


**10) REMOVING DUPLICATES**

Pattern:

    ROW_NUMBER() OVER (
        PARTITION BY duplicate_columns
        ORDER BY preferred_column
    )

    Then:
    WHERE rn > 1  -> duplicates
    WHERE rn = 1  -> keep one record

Real use:

- Remove duplicate billing records

- Remove repeated visits

- Deduplicate customer data


**11) PAGINATION**

Pattern:

   ROW_NUMBER() OVER (ORDER BY column)

    Then:
    WHERE rn BETWEEN 1 AND 10
    WHERE rn BETWEEN 11 AND 20

Used in:

- APIs

- Reports

- UI pagination



**12) REAL PROJECT USE CASES**

Healthcare:

- First visit per patient

- Latest vitals per patient

- Highest bill per patient

Finance:

- Latest transaction per account

- Top spending customers

- Duplicate transaction cleanup

E-commerce:

- First order per user

- Top products per category

- Recent price per product

HR:

- Latest salary per employee

- First hire per department

**13) PERFORMANCE TIPS**

1. Index columns used in PARTITION BY and ORDER BY

2. Avoid unnecessary ORDER BY columns

3. Filter rows early using WHERE if data is not needed

4. Use ROW_NUMBER only when row-level detail is required

5. For simple aggregations, GROUP BY is faster


**14) COMMON MISTAKES**

1. Using PARTITION BY on a unique column,
   Example: PARTITION BY visit_id
   
   This resets row_number for every row and is useless.


3. Forgetting ORDER BY,
   ROW_NUMBER without ORDER BY is logically meaningless


4. Filtering NULLs when order control is needed,
   Use CASE WHEN instead of WHERE


5. Using ROW_NUMBER instead of RANK when ties matter



**15) INTERVIEW MEMORY TRICKS**

First record:

    ASC + rn = 1

Latest record:

    DESC + rn = 1

Top N:

    DESC + rn <= N

Duplicates:

    PARTITION BY duplicate columns + rn > 1

Pagination:

    Global ORDER BY + rn range


**16) WHEN TO USE ROW_NUMBER**

Use ROW_NUMBER when:

- You need exact ordering

- You need exactly one row

- You want deterministic results

- You want to remove duplicates

Do NOT use ROW_NUMBER when:

- You want ties preserved (use RANK)

- You want aggregated output only (use GROUP BY)


**FINAL SUMMARY**

ROW_NUMBER:

- Assigns unique sequence numbers

- Supports partitioning and ordering

- Ignores frame clauses

- Excellent for first, last, top-N, duplicates, pagination

- Critical skill for SQL interviews and real projects

