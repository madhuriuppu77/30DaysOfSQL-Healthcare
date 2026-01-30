

**1. WHAT LAST_VALUE() IS**

1) LAST_VALUE() is a window function that returns the value from the last row in an ordered window frame.
   
2) Each row keeps its identity and can see the last value within its window.

Core idea:

For every row, look at a defined set of rows and return the value from the last row based on ordering and frame.

**2. BASIC SYNTAX**

    LAST_VALUE(column_name) OVER ()
    
    LAST_VALUE(column_name) OVER (
      PARTITION BY partition_column
    )
    
    LAST_VALUE(column_name) OVER (
      PARTITION BY partition_column
      ORDER BY order_column
    )
    
    LAST_VALUE(column_name) OVER (
      PARTITION BY partition_column
      ORDER BY order_column
      frame_clause
    )

**3. PARTITION BY EXPLANATION**

-  **PARTITION BY** divides the dataset into independent groups.
   
    LAST_VALUE() is evaluated separately inside each partition.

Example

Last salary per department

    LAST_VALUE(salary) OVER (
      PARTITION BY department_id
      ORDER BY salary
    )

- **Without PARTITION BY**
  
The entire table is treated as a single partition.

**4. ORDER BY EXPLANATION**

ORDER BY defines the sequence of rows inside the partition.

**ORDER BY date:**

      Last means latest date

**ORDER BY date DESC:**

      Last means earliest date
 
Example:

**Last purchase date per customer**

    LAST_VALUE(order_date) OVER (
      PARTITION BY customer_id
      ORDER BY order_date
    )

Example:

**Oldest transaction per account**

    LAST_VALUE(amount) OVER (
      PARTITION BY account_id
      ORDER BY transaction_date DESC
    )

**5. FRAME CLAUSE EXPLANATION**

1) This is the most important and error prone part of LAST_VALUE.

2) **Default behavior with ORDER BY**,
Most databases use

          RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

          This causes LAST_VALUE to return the current row value, not the true last row of the partition.

          This is why LAST_VALUE is often misunderstood.

3) **Correct and recommended frame**

          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

**Correct pattern:**

    LAST_VALUE(column_name) OVER (
      PARTITION BY partition_column
      ORDER BY order_column
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
    
**Example:**
            Example of wrong result:
            
                LAST_VALUE(salary) OVER (
                  PARTITION BY department_id
                  ORDER BY salary
                )
            
            Result:
            
            For each row, LAST_VALUE equals salary of that row.
            
            Correct version:
            
                LAST_VALUE(salary) OVER (
                  PARTITION BY department_id
                  ORDER BY salary
                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                )
            
            Now it returns the actual last salary in the department.

**6. REAL PROJECT USE CASES**

**Use case 1 Closing balance in finance:**

Get final balance per account

    LAST_VALUE(balance) OVER (
      PARTITION BY account_id
      ORDER BY balance_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**Use case 2 Final order status:**

Get final status of each order

    LAST_VALUE(status) OVER (
      PARTITION BY order_id
      ORDER BY status_change_time
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**Use case 3 Employee exit or latest salary**

Find latest salary of employees

    LAST_VALUE(salary) OVER (
      PARTITION BY employee_id
      ORDER BY effective_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**Use case 4 Subscription churn analysis**

Find last plan used by customer

    LAST_VALUE(plan_type) OVER (
      PARTITION BY customer_id
      ORDER BY plan_change_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**Use case 5 Event lifecycle tracking**

Get final event state

    LAST_VALUE(event_state) OVER (
      PARTITION BY event_id
      ORDER BY event_time
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

**7. LAST_VALUE VS MAX**

**LAST_VALUE:**

    Respects ordering
    Returns last row value based on order

**MAX:**

    Ignores order
    Returns highest value only

**Example:**

    Values 10, 100, 20 ordered by time
    LAST_VALUE returns 20
    MAX returns 100

**8. LAST_VALUE VS FIRST_VALUE**

1) LAST_VALUE with ascending order
   
        Gives last element

2) FIRST_VALUE with descending order
   
        Can give same result

But clarity and intent matter in interviews and code readability.

**9. PERFORMANCE TIPS**

- Always define frame explicitly,
Default frame causes incorrect logic.

- Index PARTITION BY and ORDER BY columns,
Improves window function execution.

- Avoid unnecessary nested window functions,
Compute once and reuse with subqueries if needed.

- Prefer LAST_VALUE over correlated subqueries,
More readable and often faster.

- Ensure ORDER BY is deterministic,
Use tie breakers when necessary.

**10. INTERVIEW TIPS**

1) Most common interview trap:
   
Why LAST_VALUE returns current row value?

Correct answer:

Because default window frame ends at CURRENT ROW.

2) Golden interview sentence
   
        LAST_VALUE requires UNBOUNDED FOLLOWING to see future rows

3) Be ready to explain ROWS vs RANGE difference.

4) Explain business use,
Closing balance, final status, latest record.

**11. IMPORTANT NOTES**

- LAST_VALUE is evaluated per row after FROM and WHERE.
  
- NULL handling depends on database implementation.

- Some databases support IGNORE NULLS

- Without ORDER BY, LAST_VALUE is meaningless,
Always pair with ORDER BY.

- If ORDER BY is not unique, last row among ties is non deterministic
Add tie breaker columns if needed.



