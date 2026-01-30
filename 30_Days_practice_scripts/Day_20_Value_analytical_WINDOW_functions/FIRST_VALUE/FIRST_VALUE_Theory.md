

**1. WHAT FIRST_VALUE() IS**

1) FIRST_VALUE() is a window function that returns the first value in an ordered window frame.

2) It does not collapse rows like GROUP BY.

3) Each row keeps its identity while seeing the first value of its window.

**Core idea:**

For every row, look at a defined set of rows and return the value from the first row in that set based on ordering.

**2. BASIC SYNTAX**

    FIRST_VALUE(column_name) OVER ()
    
    FIRST_VALUE(column_name) OVER (
      PARTITION BY partition_column
    )
    
    FIRST_VALUE(column_name) OVER (
      PARTITION BY partition_column
      ORDER BY order_column
    )
    
    FIRST_VALUE(column_name) OVER (
      PARTITION BY partition_column
      ORDER BY order_column
      frame_clause
    )

**3. PARTITION BY EXPLANATION**

 **PARTITION BY** splits data into independent groups.

   FIRST_VALUE() restarts for each partition.

Example:

Get first salary per department

    FIRST_VALUE(salary) OVER (
      PARTITION BY department_id
      ORDER BY salary
    )

Each department is processed separately.

**Without PARTITION BY:**

    The entire table is treated as one group.

**4. ORDER BY EXPLANATION**

ORDER BY defines what first means.

**ORDER BY date:**

    First means earliest date.

**ORDER BY date DESC:**

    First means latest date.

Example:

**1) First purchase date per customer**

    FIRST_VALUE(order_date) OVER (
      PARTITION BY customer_id
      ORDER BY order_date
    )

Example:

**2) Most recent transaction per account**

    FIRST_VALUE(amount) OVER (
      PARTITION BY account_id
      ORDER BY transaction_date DESC
    )

**5. FRAME CLAUSE EXPLANATION**

This is the most critical and commonly misunderstood part.

- Default behavior when ORDER BY is present
  
- Many databases default to

      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

      This can change results unexpectedly.

-Recommended explicit frame for FIRST_VALUE

      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

      This ensures the first value is taken from the entire partition, not just up to the current row.

**Correct pattern:**

    FIRST_VALUE(column_name) OVER (
      PARTITION BY partition_column
      ORDER BY order_column
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

Example: showing problem without frame:

    FIRST_VALUE(salary) OVER (
      PARTITION BY department_id
      ORDER BY salary
    )

If salaries are ordered ascending, current row might restrict visibility.

Correct version:

    FIRST_VALUE(salary) OVER (
      PARTITION BY department_id
      ORDER BY salary
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**6. REAL PROJECT USE CASES**

**Use case 1 Baseline comparison:**

Compare each transaction to the first transaction of the customer

    FIRST_VALUE(amount) OVER (
      PARTITION BY customer_id
      ORDER BY transaction_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_purchase_amount

**Use case 2 Initial status tracking:**

Get first status of an order lifecycle

    FIRST_VALUE(status) OVER (
      PARTITION BY order_id
      ORDER BY status_change_time
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**Use case 3 Salary growth analysis:**

Compare current salary with starting salary

    salary - FIRST_VALUE(salary) OVER (
      PARTITION BY employee_id
      ORDER BY effective_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS salary_growth

**Use case 4 Cohort analysis:**

Find cohort start date for each user

    FIRST_VALUE(signup_date) OVER (
      PARTITION BY user_id
      ORDER BY signup_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**Use case 5 Financial opening balance**

Get opening balance per account

    FIRST_VALUE(balance) OVER (
      PARTITION BY account_id
      ORDER BY balance_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**7. FIRST_VALUE VS MIN**

**FIRST_VALUE:**

    Respects ORDER BY
    Returns value from the first row in order
    Can return non minimum values

**MIN:**

    Ignores order
    Returns smallest value only

**Example:**

    If values are 100, 50, 200 ordered by date
    FIRST_VALUE returns 100
    MIN returns 50

**8. FIRST_VALUE VS ROW_NUMBER**

    - ROW_NUMBER gives position
    - FIRST_VALUE gives value

1) To get first row using ROW_NUMBER.

        CASE
          WHEN ROW_NUMBER() OVER (PARTITION BY x ORDER BY y) = 1
          THEN value
        END

2) FIRST_VALUE is simpler and faster for value retrieval.

**9. PERFORMANCE TIPS**

1) Always define ORDER BY intentionally,
Implicit ordering leads to non deterministic results.

2) Always specify frame clause,
Avoid default RANGE behavior surprises.

3) Index columns used in PARTITION BY and ORDER BY,
Especially for large datasets.

4) Avoid unnecessary DISTINCT before FIRST_VALUE,
Window functions operate after FROM and WHERE.

5) Use FIRST_VALUE instead of subqueries,
It avoids repeated scans and improves readability.

**10. INTERVIEW TIPS**

**Common interview question:**

1) Why FIRST_VALUE gives wrong results sometimes?

Correct answer:

    Because default window frame ends at CURRENT ROW, not full partition.

2) Key sentence interviewers like:

     FIRST_VALUE depends heavily on ORDER BY and frame definition

3) Be ready to explain difference between FIRST_VALUE and MIN.
   
4) Be ready to explain ROWS vs RANGE

Best practice to mention:

     Always use ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING with FIRST_VALUE

**11. IMPORTANT NOTES**

- FIRST_VALUE is evaluated after WHERE but before ORDER BY of final query.
  
- NULLs are treated based on ordering rules of the database.

- Some databases support IGNORE NULLS and RESPECT NULLS.

- Check database documentation for NULL handling.

    If deterministic first row matters, ORDER BY must be unique
    Otherwise first row among ties is arbitrary



