
-------------------------------------------------------------
WHY WE USE:
IF OBJECT_ID('name','U') IS NOT NULL DROP TABLE name
-------------------------------------------------------------

-- SQL Server does NOT allow creating an object if it already exists.
-- This prevents the error:
--   "There is already an object named 'Patients' in the database."

-- SQL Server does not overwrite tables or views.
-- Therefore we DROP the object first so it can be created cleanly.

-------------------------------------------------------------
REASON 1 — Avoid Creation Errors
-------------------------------------------------------------
-- Prevents:
--   "There is already an object named 'Patients' in the database."

-------------------------------------------------------------
REASON 2 — Ensures a Clean, Predictable Environment
-------------------------------------------------------------
-- No leftover old tables
-- No outdated constraints
-- No partial objects
-- No schema/version conflicts
-- Every CREATE is fresh and stable

-------------------------------------------------------------
REASON 3 — object_id() Prevents Errors
-------------------------------------------------------------
-- object_id('Patients', 'U') returns:
--   * an internal ID if exists
--   * NULL if object does not exist
-- DROP executes only when object exists
-- This avoids:
--   "Cannot drop the table 'Patients', because it does not exist."

-------------------------------------------------------------
WHY SPECIFY OBJECT TYPE ('U', 'V', 'P', etc.)
-------------------------------------------------------------
-- SQL Server supports same object name across types:
--   Patients (Table)
--   Patients (View)
--   Patients (Synonym)
--
-- Type codes:
--   'U'  = User table
--   'V'  = View
--   'P'  = Stored Procedure
--   'FN' = Scalar Function
--   'TR' = Trigger

-- Prevents accidental drop of wrong object type

-------------------------------------------------------------
HOW IT WORKS INTERNALLY
-------------------------------------------------------------
-- sys.objects holds metadata:
--   object_id  (internal number)
--   name
--   schema_id
--   type

-- Example check:
--   SELECT object_id('Patients', 'U');

-- Returns object_id if Patients is a TABLE
-- Returns NULL if missing or different type


-------------------------------------------------------------
DDL (DATA DEFINITION LANGUAGE) — SIMPLE EXPLANATION
-------------------------------------------------------------
-- DDL = Commands that create or modify database structure
-- Core Commands: CREATE, ALTER, DROP, TRUNCATE

-------------------------------------------------------------
1) CREATE — Creates database objects
-------------------------------------------------------------
CREATE TABLE Patients (...);
CREATE VIEW ActivePatients AS SELECT ...;
CREATE SCHEMA Hospital;
CREATE INDEX idx_name ON Patients(Name);

-------------------------------------------------------------
2) ALTER — Modifies existing objects
-------------------------------------------------------------
ALTER TABLE Patients ADD Phone VARCHAR(20);
ALTER TABLE Patients ALTER COLUMN Age INT;
ALTER VIEW ActivePatients AS SELECT ...;
ALTER SCHEMA Archive TRANSFER dbo.Patients;

-------------------------------------------------------------
3) DROP — Removes objects permanently
-------------------------------------------------------------
DROP TABLE Patients;
DROP VIEW ActivePatients;
DROP INDEX idx_name ON Patients;
DROP SCHEMA Archive;


-------------------------------------------------------------
4) TRUNCATE — Removes all rows, keeps table structure
-------------------------------------------------------------
TRUNCATE TABLE Patients;

-- Difference:
--   DROP     → deletes object
--   TRUNCATE → deletes all rows (fast)
--   DELETE   → deletes rows with logging (slower)

-------------------------------------------------------------
WHY DDL IS IMPORTANT
-------------------------------------------------------------
-- Enables creation and management of DB structure
-- Supports versioning and schema evolution
-- Helps prepare clean environments for development/testing
-- Mandatory for every DB Developer / SQL Engineer

-------------------------------------------------------------
END OF DDL CONCEPT NOTE
-------------------------------------------------------------
