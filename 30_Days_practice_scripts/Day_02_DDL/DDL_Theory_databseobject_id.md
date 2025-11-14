**Before learning DDL (CREATE/ALTER/DROP), it is essential to understand what a database object is and how SQL Server tracks objects internally using object_id. This knowledge prevents errors, improves debugging, and forms the foundation for everything you will learn next — not just DDL, but all of SQL.**


**What is a “database object”?**:A database object is any named thing you create inside a database: tables, views, indexes, stored procedures, functions, constraints, synonyms, sequences, triggers, etc. These are schema-scoped (they belong to a schema) and SQL Server tracks them in system catalog views so you can discover, manage and query metadata about them. 


**Why this matters before creating tables**: planning your objects (tables, keys, constraints, indexes, schemas) ensures data integrity, performance, maintainability and security. You should design columns, choose data types, set keys & constraints, decide schemas, and name objects consistently before you run DDL.

**What is object_id and why is it important?**:object_id is an integer identifier that SQL Server assigns to each schema-scoped object in a database. It’s unique within that database. System catalog views (like sys.objects, sys.tables, sys.columns) use object_id to link metadata rows together. 

**Why use object_id instead of names?**
1)Faster joins and lookups — integers are quicker to compare than strings.
2)Reliable references inside system catalog queries — you can join sys.columns ➜ sys.objects by object_id to get columns for a specific object.
3)Resilient to name collisions — object names changeable by sp_rename, but object_id remains the same for that object. (Use OBJECT_NAME(object_id) to see the name for a given id.) 
****Example: 1)find an object’s id and type:***
SELECT object_id, name, type, type_desc
FROM sys.objects
WHERE name = 'Patient_Visits';
****2)Get the name from an id:***
SELECT OBJECT_NAME(123456);  -- returns the object name for object_id 123456

**Common type / type_desc codes in sys.objects (what U, V, P, etc. mean)**
**sys.objects has a type and type_desc column. type is a short code; type_desc is readable. Here are the common ones you’ll see:
1)U — User table (regular table you create). 
2)S — System base table (internal). 
3)V — View. 
4)P — SQL stored procedure. 
5)TR — Trigger (DML trigger). 
6)FN — Scalar function; IF = inline table-valued function; TF = table-valued function. 
7)D — Default (constraint) or default object.
8)C — CHECK constraint.
9)F — FOREIGN KEY constraint.
10)PK — PRIMARY KEY (constraint).
11)UQ — UNIQUE constraint.
12)SN — Synonym.
13)SO — Sequence object.
14)TT — User table type (table type / table valued parameter).

(There are more codes; the sys.objects docs / catalog views list the full set.) 

**Quick query to list distinct types in your DB:**

SELECT DISTINCT [type], type_desc
FROM sys.objects
ORDER BY [type];

**Before creating tables — what you should think about (practical checklist)**
**1)Schema and naming**: Decide schema(s) (dbo, Archive, sales, etc.). Use schema.object naming for clarity (e.g., Archive.Patient_Visits). Schemas help organize and secure objects.
**2)Columns & data types**: Pick types that fit values (use DATE for DOB, INT for IDs, DECIMAL(10,2) for money, VARCHAR(n) sized appropriately).
**3)Keys**:
3)1):Primary key (uniquely identifies rows). Decide natural key vs surrogate (IDENTITY or SEQUENCE).
3)2)Foreign keys to enforce relationships (referential integrity).
**4)Constraints**:
NOT NULL, UNIQUE, CHECK, DEFAULT.
**5)Indexes**:Add indexes for columns used in WHERE/JOIN/ORDER BY to improve read performance; avoid excessive indexes that slow writes.
**6)Identity vs Sequence**:IDENTITY is column-level and tied to a table. SEQUENCE is a separate object you can share across tables; use NEXT VALUE FOR to get values.
**7)Partitioning / archiving strategy**:If data grows large, plan schemas or partitioning (e.g., move old data to Archive schema).
**8)Permissions**:Decide who can SELECT, INSERT, UPDATE, ALTER, DROP. Schema separation can simplify permission management.
**9)Backups & maintenance**:Don’t forget backup plan and index/statistics maintenance.

**Practical catalog queries you’ll use often**:
**1)List all user tables:**
SELECT name, object_id
FROM sys.objects
WHERE type = 'U';
**2)Find all foreign keys and their parent table:**
SELECT fk.name AS ForeignKeyName,
       OBJECT_NAME(fk.parent_object_id) AS ParentTable,
       OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable
FROM sys.foreign_keys fk;

**3)List columns for a table by object_id:**
SELECT c.name, t.name AS type_name, c.max_length, c.is_nullable
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.Patients');

****Why you sometimes get “object not found” errors (common causes)**
**1)Wrong schema:** Patient_Visits might be in Archive schema so you must refer Archive.Patient_Visits. If you omit schema SQL Server assumes the default schema for the user (often dbo).
**2)Case / spelling:** object names must match exactly (SQL Server is usually case-insensitive but object names can be case-sensitive depending on collation).
**3)Object was moved/renamed:** object still has same object_id, but name changed — use sys.objects or OBJECT_ID() to verify.
**4)Lack of permissions:** you may not have permission to see or alter the object. Use your DBA account or ask for permissions.

**Example: to see schema name + table name:**

SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.name LIKE '%Patient%';

**Short examples tying concepts to the DDL that i wrote earlier (check my practice scripts of DDL):**

1)You moved tables into Archive schema — that’s why ALTER TABLE Patient_Visits ... failed; SQL Server looked for dbo.Patient_Visits unless you wrote Archive.Patient_Visits. Use sys.tables + sys.schemas to confirm schema before running ALTER TABLE.

2)Dropping FK: you must ALTER TABLE <schema>.ParentTable DROP CONSTRAINT <fk_name>; — parent table must be referenced with its schema.

3)Creating Patients_Backup using SELECT ... INTO creates a new table (type U) — check sys.objects to see it appear with type = 'U'.

**Final short cheat-sheet (copy/paste)**
-- **Find object and its id/type**:
SELECT object_id, name, type, type_desc
FROM sys.objects
WHERE name = 'Patient_Visits';

-- **Find schema of a table**:
SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.name = 'Patient_Visits';

**-- List foreign keys + parent table**:
SELECT fk.name AS ForeignKeyName,
       OBJECT_NAME(fk.parent_object_id) AS ParentTable,
       OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable
FROM sys.foreign_keys fk;

**-- Show distinct object types in this DB**:
SELECT DISTINCT [type], type_desc FROM sys.objects ORDER BY [type];

