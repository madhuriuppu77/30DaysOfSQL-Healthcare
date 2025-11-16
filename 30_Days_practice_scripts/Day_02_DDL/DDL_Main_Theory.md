#####
**WHY WE USE
IF OBJECT_ID('name','U') IS NOT NULL DROP TABLE name**???
This pattern exists because SQL Server does NOT allow creating an object if an object with the same name already exists.
**Reason 1 — To avoid errors like:**
                         ERROR   ***There is already an object named 'Patients' in the database.***
SQL Server does not “overwrite” tables or views.
So before creating a new version, you must remove the old one.
**Reason 2 — To guarantee a clean, predictable environment**
When practicing, testing, or rebuilding your schema, you want:
1)No leftover old tables
2)No old constraints
3)No partial objects
4)No wrong schema issues
5)Dropping the object ensures fresh creation every time.
**Reason 3 — object_id ensures the object actually exists**
object_id('Patients','U') returns the internal ID of the object only if:
1)the object exists
2)the type matches (e.g., 'U' = user table, 'V' = view, 'P' = procedure)
3)If it doesn’t exist, object_id = NULL → DROP is skipped → no error.
####
**Why specify type ('U', 'V', 'P', etc.)?**
Because SQL Server can have multiple objects with the same name but different types, e.g.:
      Patients → table
      Patients → view
      Patients → synonym
So we write:
      'U' → table
      'V' → view
      'P' → stored procedure
      'FN' → scalar function
      'TR' → trigger
This prevents accidental deletion of the wrong object.
**How it works internally?**
The catalog view sys.objects stores:
object_id: internal numeric ID
name
schema_id
type
    **When you run:**
 **SELECT object_id('Patients', 'U');**
SQL Server checks:
1)Is there an object named "Patients"?
2)Is its type U (table)?
    **If yes → return the internal ID (positive number)**
    **If no → return NULL**
DROP only executes if object_id is NOT NULL.
This prevents errors like:
Cannot drop the table 'Patients', because it does not exist.

**Now: DDL Explained Clearly (The Easiest Explanation)**

**DDL stands for Data Definition Language:**
*Commands used to define and manage database structures.
****The four core DDL commands are:
**1. CREATE**
Used to create new database objects.
**Examples:**
CREATE TABLE Patients (...);
CREATE VIEW ActivePatients AS SELECT ...;
CREATE SCHEMA Hospital;
CREATE INDEX idx_name ON Patients(Name);
**2. ALTER**
Used to modify existing objects without dropping them.
**Examples:**
ALTER TABLE Patients ADD Phone VARCHAR(20);
ALTER TABLE Patients ALTER COLUMN Age INT;
ALTER VIEW ActivePatients AS SELECT ...;
ALTER SCHEMA Archive TRANSFER dbo.Patients;
**3. DROP**
Used to delete objects permanently.
**Examples:**
DROP TABLE Patients;
DROP VIEW ActivePatients;
DROP INDEX idx_name ON Patients;
DROP SCHEMA Archive;
This is why DROP is used before CREATE during development.
**4. TRUNCATE**
Removes all data from a table VERY fast, but keeps structure.
TRUNCATE TABLE Patients;

Not the same as DROP:
        DROP removes object
        TRUNCATE removes rows
        DELETE removes rows but slower

** Why DDL is important?**
It allows you to:

1)Build database structures
2)Modify them as needs change
3)Remove outdated or incorrect designs
4)Create staging/backup tables
5)Build schemas and organize objects
6)Prepare environments for testing
7)Every database developer MUST know DDL.

