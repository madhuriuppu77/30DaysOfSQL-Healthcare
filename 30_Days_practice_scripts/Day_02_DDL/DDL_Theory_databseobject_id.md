

**Before learning DDL (CREATE/ALTER/DROP), it is essential to understand what a database object is and how SQL Server tracks objects internally using object_id. This knowledge prevents errors, improves debugging, and forms the foundation for everything you will learn next — not just DDL, but all of SQL.**

**What is a “database object”?**
A database object is any named thing you create inside a database: tables, views, indexes, stored procedures, functions, constraints, synonyms, sequences, triggers, etc. These are schema-scoped (they belong to a schema) and SQL Server tracks them in system catalog views so you can discover, manage and query metadata about them.

**Why this matters before creating tables**
Planning your objects (tables, keys, constraints, indexes, schemas) ensures data integrity, performance, maintainability and security. You should design columns, choose data types, set keys & constraints, decide schemas, and name objects consistently before you run DDL.

**What is object_id and why is it important?**
object_id is an integer identifier that SQL Server assigns to each schema-scoped object in a database. It’s unique within that database. System catalog views (like sys.objects, sys.tables, sys.columns) use object_id to link metadata rows together.

**Why use object_id instead of names?**
1) Faster joins and lookups — integers are quicker to compare than strings.
2) Reliable references inside system catalog queries — you can join sys.columns ➜ sys.objects by object_id to get columns for a specific object.
3) Resilient to name collisions — object names changeable by sp_rename, but object_id remains the same for that object. (Use OBJECT_NAME(object_id) to see the name for a given id.)

**Example Queries**
-- 1) Find an object’s id and type:
SELECT object_id, name, type, type_desc
FROM sys.objects
WHERE name = 'Patient_Visits';

-- 2) Get the name from an id:
SELECT OBJECT_NAME(123456);  -- returns the object name for object_id 123456


**Common type / type_desc codes in sys.objects**
1) U  — User table
2) S  — System base table
3) V  — View
4) P  — Stored procedure
5) TR — Trigger
6) FN — Scalar function
7) IF — Inline table-valued function
8) TF — Table-valued function
9) D  — Default constraint
10) C  — Check constraint
11) F  — Foreign key
12) PK — Primary key
13) UQ — Unique constraint
14) SN — Synonym
15) SO — Sequence
16) TT — User table type

-- Quick query to list distinct object types:
SELECT DISTINCT [type], type_desc
FROM sys.objects
ORDER BY [type];


**Before creating tables — Design Checklist**
1) Schema and naming conventions (dbo, sales, Archive, Admin)
2) Correct data types (INT, VARCHAR, DATE, DECIMAL, BIT)
3) Keys: primary key, natural vs surrogate, foreign keys
4) Constraints: NOT NULL, CHECK, UNIQUE, DEFAULT
5) Indexing strategy
6) Identity vs Sequence strategy
7) Partitioning / Archiving plan
8) Permissions planning (schema security)
9) Maintenance plan: backups, index & statistics maintenance


**Useful Catalog Queries**

-- 1) List all user tables:

SELECT name, object_id
FROM sys.objects
WHERE type = 'U';

-- 2) List foreign keys and referenced tables:

SELECT fk.name AS ForeignKeyName,
       OBJECT_NAME(fk.parent_object_id) AS ParentTable,
       OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable
FROM sys.foreign_keys fk;

-- 3) List columns for a given table by object_id:

SELECT c.name AS ColumnName,
       t.name AS DataType,
       c.max_length,
       c.is_nullable
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.Patients');


**Common "object not found" causes**
1) Wrong schema: table may be in Archive schema, not dbo
2) Spelling / case sensitivity
3) Object renamed or moved
4) Permission issues


**Find schema name of a table**
SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.name LIKE '%Patient%';


**Short DDL Troubleshooting Examples**
1) If moved to Archive schema:
ALTER TABLE Archive.Patient_Visits ...   -- not dbo.Patient_Visits

2) Drop FK:
ALTER TABLE <schema>.<table> DROP CONSTRAINT <fk_name>;

3) Check new table created using SELECT INTO:
SELECT name, type FROM sys.objects WHERE type = 'U';


**Final Mini Cheat Sheet**

-- Find object and its id/type:

SELECT object_id, name, type, type_desc
FROM sys.objects
WHERE name = 'Patient_Visits';

-- Find schema of a table:

SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.name = 'Patient_Visits';

-- List foreign keys:

SELECT fk.name AS ForeignKeyName,
       OBJECT_NAME(fk.parent_object_id) AS ParentTable,
       OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable
FROM sys.foreign_keys fk;

-- Distinct object types:

SELECT DISTINCT [type], type_desc FROM sys.objects ORDER BY [type];



