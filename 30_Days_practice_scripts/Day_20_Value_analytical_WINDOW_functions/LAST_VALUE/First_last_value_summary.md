**Explanation for frame in first and last value:**

**Your table**
| patient_id | value |
| ---------- | ----- |
| 1          | 20    |
| 1          | 30    |
| 1          | 40    |

We want FIRST_VALUE(value) and LAST_VALUE(value) for each row for patient_id = 1.

**Step 1: FIRST_VALUE()**

**Default frame:**

      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
     
- Row 1: window = [20] → first value = 20 

- Row 2: window = [20, 30] → first value = 20 

- Row 3: window = [20, 30, 40] → first value = 20 

**Observation:** FIRST_VALUE always works with default frame, because the first value in the frame is always the first row in the partition.

**Step 2: LAST_VALUE()**

**with default frame**

**Default frame is same as FIRST_VALUE:**

       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW


- Row 1: window = [20] → last value = 20 

- Row 2: window = [20, 30] → last value = 30 

- Row 3: window = [20, 30, 40] → last value = 40 

 **Looks fine here** — but imagine you are calculating this across a bigger dataset and want the last value of the patient, not “up to current row”.

Problem arises when you use LAST_VALUE() in analytics with moving rows, for example with ORDER BY and you expect every row to know the true last value in the partition:

Row 1: window default = [20] → last = 20 (wrong) but actual last for patient = 40

Row 2: window default = [20, 30] → last = 30 (wrong) actual last = 40

Row 3: window default = [20, 30, 40] → last = 40 (right) actual last = 40

Notice for row 1 and 2, LAST_VALUE gives “current frame last”, not the true last value of patient 1.

**Step 3: Fixing LAST_VALUE() frame**

**Use:**

       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING


**Now,** frame is static for all rows in partition → from first row to last row of patient 1:

       Window frame = [20, 30, 40]  for row 1, row 2, row 3


Row 1: last value = 40 

Row 2: last value = 40 

Row 3: last value = 40 

Now, all rows correctly see the true last value.

| Row | Frame (default) | LAST_VALUE (default) | Frame (fixed) | LAST_VALUE (fixed) |
| --- | --------------- | -------------------- | ------------- | ------------------ |
| 1   | [20]            | 20                   | [20,30,40]    | 40                 |
| 2   | [20,30]         | 30                   | [20,30,40]    | 40                 |
| 3   | [20,30,40]      | 40                   | [20,30,40]    | 40                 |

Key takeaway:

- FIRST_VALUE works fine with default frame because the first row of the frame = first row of partition.

- LAST_VALUE needs frame to include the whole partition if you want the true last value, otherwise it just gives last row of current frame (up to current row).
