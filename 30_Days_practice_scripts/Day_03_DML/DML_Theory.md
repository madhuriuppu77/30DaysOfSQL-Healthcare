
#  DML (Data Manipulation Language) – Theory

DML (Data Manipulation Language) consists of SQL commands used to **view, insert, update, and delete data** stored inside database tables.
These commands work only on **table records** and **do not modify database structure** such as table schema, columns, or keys.
Since DML affects actual data, operations can be **rolled back or committed** using transactions.

------------------------------------------------------------
##  Core Purpose of DML
------------------------------------------------------------
- To **retrieve** data
- To **add** new records
- To **modify** existing records
- To **remove** unwanted records
- To **synchronize** data between multiple sources (advanced)

DML focuses on **data manipulation** — not structure.
DML never creates tables — it only manipulates the data inside them.

------------------------------------------------------------
##  Common DML Commands
------------------------------------------------------------
| Command | Purpose | Description |
|---------|----------|-------------|
| SELECT  | Read     | Retrieves data from table(s) |
| INSERT  | Add      | Inserts new rows into a table |
| UPDATE  | Modify   | Changes existing row values |
| DELETE  | Remove   | Deletes rows based on condition |
| MERGE   | Sync     | Inserts/Updates/Deletes in one statement |

------------------------------------------------------------
##  Quick Syntax Examples
------------------------------------------------------------

-- SELECT
SELECT column1, column2
FROM table_name
WHERE condition;


-- INSERT
INSERT INTO table_name (column1, column2)
VALUES (value1, value2);


-- UPDATE
UPDATE table_name
SET column1 = value1
WHERE condition;


-- DELETE
DELETE FROM table_name
WHERE condition;


-- MERGE (Basic Structure)
MERGE target_table AS T
USING source_table AS S
ON T.key_col = S.key_col
WHEN MATCHED THEN
    UPDATE SET T.col1 = S.col1
WHEN NOT MATCHED THEN
    INSERT (col1, col2)
    VALUES (S.col1, S.col2)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


------------------------------------------------------------
##  Important Notes
------------------------------------------------------------
- DML operations can be rolled back using transactions.
- Always use WHERE clause with UPDATE and DELETE.
- SELECT is the only non-destructive DML command.
- MERGE is used for synchronization tasks (ETL / warehousing).

------------------------------------------------------------
##  Summary Table
------------------------------------------------------------
| Category | Affects | Rollback | Example Commands |
|----------|---------|-----------|------------------|
| DML      | Data    | Yes       | SELECT, INSERT, UPDATE, DELETE, MERGE |
| DDL      | Structure | No      | CREATE, ALTER, DROP, TRUNCATE |

------------------------------------------------------------
END OF DML THEORY
------------------------------------------------------------


```
