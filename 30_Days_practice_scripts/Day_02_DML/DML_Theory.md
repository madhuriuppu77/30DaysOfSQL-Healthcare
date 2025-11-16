```
#  DML (Data Manipulation Language) – Theory

DML (Data Manipulation Language) consists of SQL commands used to **view, insert, update, and delete data** stored inside database tables.
These commands work only on **table records** and **do not modify database structure** such as table schema, columns, or keys.
Since DML affects actual data, operations can be **rolled back or committed** using transactions.

---

##  Core Purpose of DML
- To **retrieve** data
- To **add** new records
- To **modify** existing records
- To **remove** unwanted records
- To **synchronize** data between multiple sources (advanced)

DML focuses on **data manipulation** — not structure.
DML never creates tables — it only manipulates the data inside them

---

##  Common DML Commands

| Command | Purpose | Description |
|---------|----------|-------------|
| `SELECT` | Read | Retrieves data from table(s) |
| `INSERT` | Add | Inserts new rows into a table |
| `UPDATE` | Modify | Changes existing row values |
| `DELETE` | Remove | Deletes rows based on condition |
| `MERGE` | Sync | Inserts/Updates/Deletes in one statement |

---

##  Quick Syntax Examples

### `SELECT`
```sql
SELECT column1, column2
FROM table_name
WHERE condition;

```
