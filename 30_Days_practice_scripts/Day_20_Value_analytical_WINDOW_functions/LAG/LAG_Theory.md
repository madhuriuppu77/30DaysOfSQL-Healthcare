

**1) WHAT LAG() IS**

1) LAG() is a window function used to access data from a previous row within the same result set without using self joins.

2) It allows comparison of current row values with values from earlier rows.

**Common purpose:**

-Compare current vs previous values

-Detect changes or trends

-Calculate differences and growth

-Track historical state

**2) BASIC SYNTAX**

    LAG(expression)
    
    LAG(expression, offset)
    
    LAG(expression, offset, default_value)

**Used with OVER clause:**

    LAG(expression, offset, default_value) OVER (
      PARTITION BY column1
      ORDER BY column2
    )

**3) MEANING OF EACH PARAMETER**

expression:

    Column or expression whose previous value is needed

offset:

    How many rows back to look
    Default is 1

default_value:

    Value returned when no previous row exists
    Default is NULL

**4) PARTITION BY WITH LAG()**

1) Partitioning divides the dataset into independent groups.
   
2) LAG() only looks at previous rows within the same partition.

**Example:**

Compare each employee salary with previous salary in same department

    SELECT
      emp_id,
      dept,
      salary,
      LAG(salary) OVER (PARTITION BY dept ORDER BY emp_id) AS prev_salary
    FROM employees;

Each department restarts the LAG calculation.

**Use cases:**

-Month over month sales per product.

-Daily balance per bank account.

-Employee promotion history per employee.

**5) ORDER BY WITH LAG()**

1) ORDER BY defines the sequence of rows.

2) Without ORDER BY, LAG() has no meaning.

**Example:**

Compare current day sales with previous day sales

    SELECT
      order_date,
      sales,
      LAG(sales) OVER (ORDER BY order_date) AS prev_day_sales
    FROM daily_sales;

1) Correct ordering is critical.

2) Wrong ORDER BY gives wrong previous values.

**6) OFFSET EXAMPLES**

**Previous row:**

    LAG(value, 1)

**Two rows back:**

    LAG(value, 2)

**Previous month:**

    LAG(monthly_sales, 1) OVER (PARTITION BY product ORDER BY month)

**7) DEFAULT VALUE USAGE**

When there is no previous row, LAG returns NULL by default.

**Example with default:**

    LAG(sales, 1, 0) OVER (ORDER BY order_date)

**Useful when:**

-Avoiding NULL checks

-First row calculations

-Running differences

**8) FRAME CLAUSE AND LAG()**

**Important concept:**

1) LAG() does not use frame clauses for row selection.

2) LAG() always accesses a specific row offset relative to current row.

3) Frame clauses like ROWS BETWEEN do not affect LAG behavior.

**This means:**

    1) Frame clause is ignored by LAG.
    2) Offset is absolute position based on ORDER BY.

**Interview trap:**

    Frame clause does not change LAG results

**9) REAL PROJECT USE CASES**

**A) SALES TREND ANALYSIS:**

Calculate day over day sales change

    SELECT
      order_date,
      sales,
      sales - LAG(sales) OVER (ORDER BY order_date) AS daily_growth
    FROM daily_sales;

**B) FINANCIAL BALANCE TRACKING:**

Track previous balance for transactions

    SELECT
      txn_date,
      balance,
      LAG(balance) OVER (PARTITION BY account_id ORDER BY txn_date) AS prev_balance
    FROM bank_transactions;

**C) USER ACTIVITY MONITORING:**

Detect login gaps

    SELECT
      user_id,
      login_time,
      login_time - LAG(login_time) OVER (PARTITION BY user_id ORDER BY login_time) AS gap_time
    FROM user_logins;

**D) PRICE CHANGE DETECTION:**

Detect price updates

    SELECT
      product_id,
      price_date,
      price,
      CASE
        WHEN price <> LAG(price) OVER (PARTITION BY product_id ORDER BY price_date)
        THEN 'PRICE_CHANGED'
        ELSE 'NO_CHANGE'
      END AS price_status
    FROM product_prices;

**10) LAG VS SELF JOIN**

**LAG advantages:**

-Cleaner syntax

-Better readability

-Less error prone

-Optimized by query planner

**Self join drawbacks:**

-Complex joins

-Performance overhead

-Harder maintenance

**11) PERFORMANCE TIPS**

-Always index columns used in ORDER BY and PARTITION BY

-Avoid unnecessary columns in SELECT

-Filter rows before applying LAG when possible

-Use appropriate partitioning to reduce window size

-Avoid over partitioning which increases computation

**12) COMMON MISTAKES**

-Using LAG without ORDER BY

-Expecting frame clause to affect LAG

-Wrong ordering column

-Forgetting PARTITION BY

-Not handling NULL values

-Assuming LAG skips NULL rows it does not

**13) INTERVIEW QUESTIONS AND ANSWERS**

Q What is LAG used for?

A Access previous row data within a result set

Q Does LAG require ORDER BY?

A Yes always

Q Does frame clause affect LAG?

A No

Q Difference between LAG and LEAD?

A LAG looks backward LEAD looks forward

Q Can LAG replace self joins?

A Yes in many analytical scenarios

Q What happens for first row?

A Returns NULL or default value

**14) IMPORTANT NOTES**

-LAG is evaluated after WHERE and before ORDER BY of final output

-Works only with window functions not aggregates

-NULL values are treated as normal values

-Supports numeric date and string expressions

-Available in most modern SQL engines

**15) WHEN TO USE LAG**

Comparisons with previous records:

    Trend analysis
    Change detection
    Time series analysis
    Historical comparisons


