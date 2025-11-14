-DDL — 35 Practice Questions (Structure-Level)

--1)Create a new database named HealthcareDB_V2.
CREATE DATABASE HealthcareDB_V2;
GO
USE HealthcareDB_V2;
GO

--2)Create a table Departments with columns: department_id, department_name, head_doctor_id.
 CREATE TABLE Departments(
 department_id INT NOT NULL,
 department_name  VARCHAR(50) NOT NULL,
 head_doctor_id INT NOT NULL,
 CONSTRAINT pk_Departments PRIMARY KEY(department_id)
 )
  
--3)Create a table Patients with appropriate datatypes for storing ID, name, gender, date of birth, and city.
CREATE TABLE patients(
patient_id INT NOT NULL,
name VARCHAR(50) NOT NULL,
gender VARCHAR(15) NOT NULL,
date_of_birth DATE NOT NULL,
city VARCHAR(20),
CONSTRAINT pk_patients PRIMARY KEY(patient_id)
)

--4)Create a table Doctors with specialization, experience (in years), and phone number.
CREATE TABLE Doctors (
    doctor_id INT NOT NULL,  -- surrogate key
    name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    experience_years INT,
    phone_number VARCHAR(15) NOT NULL,
	CONSTRAINT pk_Doctors PRIMARY KEY(doctor_id)
);

--5)Create a table Visits with patient_id, doctor_id, visit_date, and reason_for_visit.
CREATE TABLE Visits (
    visit_id INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate unique key
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATE NOT NULL,
    reason_for_visit VARCHAR(100) NOT NULL,

    -- relationships (Foreign Keys)
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    CONSTRAINT fk_doctor FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

--6)Add a column email to the Patients table.
ALTER TABLE patients
ADD email_id VARCHAR (50) NOT NULL

--7)Add a column emergency_contact to the Patients table.
ALTER TABLE patients
ADD emergency_contact INT NOT NULL

--8)Modify the datatype of Doctors.phone_number to VARCHAR(15).
ALTER TABLE Doctors
ALTER COLUMN  phone_number VARCHAR(15);

--9)Rename the column specialization to speciality in the Doctors table.
 --Now rename column
EXEC sp_rename 'Doctors.specialization', 'speciality', 'COLUMN';

-- Check new column name
SELECT * FROM Doctors;

--10)Rename the table Visits to Patient_Visits.
SELECT * FROM Patient_Visits
EXEC sp_rename 'Visits','Patient_Visits';

--11)Create a table Medications with prescription_id, patient_id, drug_name, dosage, frequency.
CREATE TABLE Medications(
prescription_id INT NOT NULL,
patient_id INT NOT NULL,
drug_name VARCHAR(15) NOT NULL,
dosage INT NOT NULL,
frequency INT NOT NULL,
CONSTRAINT pk_Medications PRIMARY KEY(prescription_id))

  
--12)Add a cost column (DECIMAL) to the Medications table.
ALTER TABLE Medications
ADD  cost FLOAT NOT NULL;

--13)Remove the column reason_for_visit from the Patient_Visits table.
SELECT * FROM Patient_Visits
ALTER TABLE Patient_Visits
DROP COLUMN reason_for_visit;

--14)Drop the table Temp_Records.
DROP TABLE Temp_Records;
--explanation:
/*DROP TABLE permanently deletes the table structure and all data inside it.
After dropping, the table cannot be recovered unless you have a backup.

Optional safety check (commonly used):

If you want to avoid errors when the table doesn't exist:
IF OBJECT_ID('Temp_Records', 'U') IS NOT NULL
    DROP TABLE Temp_Records;*/


--15)Truncate the Medications table.
SELECT * FROM Medications

TRUNCATE TABLE Medications;

--16)Create a table Billing with invoice_id, patient_id, amount, billing_date, payment_status.
CREATE TABLE Billing(
invoice_id INT NOT NULL,
patient_id INT NOT NULL,
amount INT NOT NULL,
billing_date DATE NOT NULL,
payment_status VARCHAR (15) NOT NULL,
CONSTRAINT pk_Billing PRIMARY KEY (invoice_id))

--17)Add a constraint to make patient_id in Patients the primary key.
ALTER TABLE Patients
ADD CONSTRAINT pk_patient PRIMARY KEY (patient_id);

--18)Add a foreign key constraint between Patient_Visits.patient_id and Patients.patient_id.
ALTER TABLE Patient_Visits
ADD CONSTRAINT fk_patientvisits_patient
FOREIGN KEY (patient_id)
REFERENCES Patients(patient_id);
/*What this means — in plain English

You are telling SQL:
"In the Patient_Visits table, the column doctor_id should always match an existing doctor_id from the Doctors table."

So basically:
Every patient visit must be assigned to a real doctor who exists in the Doctors table.
SQL will automatically stop anyone from entering invalid doctor IDs. */

--19)Add a foreign key between Patient_Visits.doctor_id and Doctors.doctor_id.
ALTER TABLE Patient_Visits
ADD CONSTRAINT fk_patientVists_doctor
FOREIGN KEY (doctor_id)
REFERENCES Doctors(doctor_id);


--20)Set department_name as UNIQUE in the Departments table.
/*SELECT * FROM Departments
ALTER TABLE Departments
ADD department_name VARCHAR(20) UNIQUE

This statement means: “Add a new column named department_name and make it UNIQUE.”
But if the column already exists (which it usually does), this will throw an error:

“Column ‘department_name’ already exists in table ‘Departments’.”

Correct way (if column already exists)

If your table already has a column department_name and you just want to make it unique (no duplicates allowed):*/

ALTER TABLE Departments
ADD CONSTRAINT uq_department_name
UNIQUE (department_name);

--21)Add a DEFAULT constraint for payment_status as ‘Pending’.
/*SELECT * FROM Billing
ALTER TABLE Billing
ADD CONSTRAINT dfault_payment_status
DEFAULT (payment_status 'pending');
That’s almost correct, but two issues:

 *****Correct SQL syntax****
If the column payment_status already exists in the Billing table and you just want to add a default value:
*/
ALTER TABLE Billing
ADD CONSTRAINT df_payment_status
DEFAULT 'Pending' FOR payment_status;

/* 
If the column doesn’t exist yet:
If your Billing table doesn’t already have payment_status, then use:

ALTER TABLE Billing
ADD payment_status VARCHAR(20) DEFAULT 'Pending';
******That creates the column and sets its default at the same time.*****

| Situation                          | SQL                                                                                          |
| ---------------------------------- | -------------------------------------------------------------------------------------------- |
| Add default to **existing column** | `ALTER TABLE Billing ADD CONSTRAINT df_payment_status DEFAULT 'Pending' FOR payment_status;` |
| Add a **new column** with default  | `ALTER TABLE Billing ADD payment_status VARCHAR(20) DEFAULT 'Pending';`                      |
*/

--22)Add a CHECK constraint on Doctors.experience so it cannot be negative.

--23)Create an index on Doctors.speciality for faster search.
CREATE INDEX idx_doctors_speciality
ON Doctors(speciality);
/* Explanation:
You are creating an index called idx_doctors_speciality on the column speciality of the Doctors table.

This tells the database:
“Hey, people often search for doctors by speciality — please store this column in a way that makes searching much faster.”
Think of it like a book index
In a medical book:

**Without an index → you flip through every page to find “Cardiology”.

**With an index → you jump directly to the page number listed for “Cardiology”.
#### Index names often start with idx_
That’s just a naming convention (for clarity).*/

--24)Create a view Active_Doctors showing doctors with more than 5 years of experience.
CREATE OR ALTER VIEW Active_Doctors AS
SELECT
  doctor_id,
  name AS doctor_name,    -- aliasing if your column is named `name`
  speciality,
  experience_years
FROM Doctors
WHERE experience_years > 5;
GO
/*CREATE OR ALTER VIEW Active_Doctors AS

1)This creates a view named Active_Doctors.
If the view already exists, it will update (alter) it — so you don’t have to drop it first.
A view is like a saved SQL query — it doesn’t store data, but whenever you query it, it runs the SELECT statement inside and shows results like a virtual table.

Example idea :
Instead of writing the same query again and again to get “experienced doctors”, you can save it as a view and reuse it anytime.

2)SELECT doctor_id, doctor_name, speciality, experience_years FROM Doctors
This part defines what data the view should display.
It takes columns from your existing Doctors table:
doctor_id — unique ID for each doctor
doctor_name — name of the doctor
speciality — what they specialize in (like Cardiology, Orthopedics)
experience_years — how many years they’ve worked
So this tells the view what to include.

3)WHERE experience_years > 5; This is the filter condition.It only includes doctors who have more than 5 years of experience.
Doctors with 5 or fewer years won’t appear in this view.

4)GO
GO is a batch separator in SQL Server (SSMS or Azure Data Studio).
It tells SQL:
“Stop here, finish the CREATE VIEW command first, then start a new batch for the next command.”
Without GO, SQL thinks you’re trying to run both CREATE VIEW and SELECT in the same batch — and that’s why you saw the error:Incorrect syntax near the keyword 'SELECT'.
*/

--5) Run this after the view is created
SELECT * FROM Active_Doctors;
--This just runs the view. It behaves like you’re selecting from a table — but behind the scenes, it runs the query inside the view.It will show you only doctors with experience_years > 5.


-- 25) Create a temporary table Temp_Billing
CREATE TABLE #Temp_Billing (
    billing_id INT,
    patient_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20) DEFAULT 'Pending'
);

-- Insert sample data to test (optional)
INSERT INTO #Temp_Billing (billing_id, patient_id, amount)
VALUES (1, 101, 5000.00),
       (2, 102, 3000.50);

-- View data from temporary table
SELECT * FROM #Temp_Billing;
 /* Explanation:

*CREATE TABLE #Temp_Billing (...)
The "# " at the start means it’s a temporary table.It is stored temporarily in the tempdb system database
It only exists for your current SQL session — once you close your session or disconnect, it gets deleted automatically.
You can think of it like a scratchpad table — you can test queries, transformations, or calculations without touching the real data.*/

--26)Create a schema named Archive and move old tables to it.

-- 26) Create a schema named Archive
CREATE SCHEMA Archive;

-- Move old tables into Archive schema
ALTER SCHEMA Archive TRANSFER dbo.Billing;
ALTER SCHEMA Archive TRANSFER dbo.Departments;
ALTER SCHEMA Archive TRANSFER dbo.Doctors;
ALTER SCHEMA Archive TRANSFER dbo.Medications;
ALTER SCHEMA Archive TRANSFER dbo.patient_visits;
ALTER SCHEMA Archive TRANSFER dbo.patients;

--27)Create a table Insurance with patient_id, policy_number, and provider.
CREATE TABLE Insurance (
patient_id INT NOT NULL,
policy_number INT NOT NULL,
provider VARCHAR(25) NOT NULL,
CONSTRAINT pk_Insurance PRIMARY KEY (patient_id))

--28)Add a NOT NULL constraint to Patients.name.
ALTER TABLE patients
ADD CONSTRAINT pk_patients
NOT NULL(name)

/* above query is wrong because will add constraint only for primary keys 
correct query is  :*/
ALTER TABLE Patients
ALTER COLUMN name VARCHAR(255) NOT NULL;
/* Explanation:
ALTER TABLE → choose the table
MODIFY / ALTER COLUMN → change column
NOT NULL → apply non-null constraint
You cannot add NOT NULL with ADD CONSTRAINT.
This is done only for constraints like PRIMARY KEY, UNIQUE, FOREIGN KEY, CHECK, etc.*/

--29)Drop the foreign key between Visits and Patients.
--1. Find the foreign key name (if you don’t know it):
SELECT 
    name, 
    parent_object_id, 
    type_desc 
FROM sys.objects
WHERE type = 'F';
-- With result first note your foreign key which to drop in these case iam noting down fk_patientvisits_patient
ALTER TABLE Visits
DROP CONSTRAINT fk_patientvisits_patient;
--so i got error then again first i searched for how many foreign keys are avaible for this patient visit table then i got 4 rows
SELECT name FROM sys.tables;
SELECT 
    fk.name AS ForeignKeyName,
    t.name AS TableName
FROM 
    sys.foreign_keys fk
JOIN 
    sys.tables t ON fk.parent_object_id = t.object_id;
---- so now iam removing all four 
ALTER TABLE Patient_Visits DROP CONSTRAINT fk_patient;
ALTER TABLE Patient_Visits DROP CONSTRAINT fk_doctor;
ALTER TABLE Patient_Visits DROP CONSTRAINT fk_patientvisits_patient;
ALTER TABLE Patient_Visits DROP CONSTRAINT fk_patientVists_doctor;

--so still getiing error beacuse i have changed schema from dbo to archive so that iam getting eroor now i need to write query again
ALTER TABLE Archive.Patient_Visits
DROP CONSTRAINT fk_patientvisits_patient;
--
--30)Create a sequence starting from 1000 for auto patient IDs.
/*What is a SEQUENCE?

A sequence generates unique numbers automatically.
It’s similar to IDENTITY but more flexible, because you can:
 1)start from any number
 2)change increment
 3)use it across tables
**** Why we create it?
To auto-generate patient_id values starting from 1000.*/
CREATE SEQUENCE patient_id_seq
    START WITH 1000
    INCREMENT BY 1;
--How to use it when inserting a patient?
INSERT INTO Patients (patient_id, name, age)
VALUES (NEXT VALUE FOR patient_id_seq, 'John', 30);


--31)Create a synonym Docs for the Doctors table.
/*What is a SYNONYM?

A synonym is like a shortcut name or nickname for a table.

Example:
Instead of writing: Archive.Doctor
You can write:Docs
---- Why it is useful?
1)Makes queries shorter
2)Easy to replace table names
3)Good for long schema names
4)Helps when tables move to another schema

 SQL:

*)If Doctors table is in dbo:
CREATE SYNONYM Docs
FOR dbo.Doctors;

*)If Doctors is in Archive schema:*/

CREATE SYNONYM Docs
FOR Archive.Doctors;

-- *****Now you can do:

SELECT * FROM Docs;

--32)Disable all constraints on the Billing table.
/*What is disabling constraints?
This temporarily turns off:
1)FOREIGN KEY
2)CHECK
3)UNIQUE
4)DEFAULT

** Why disable constraints?
When you want to:
1)insert data without validation
2)load bulk data
3)avoid errors temporarily

Example: importing large files or inserting rows that violate constraints.
*/
ALTER TABLE Archive.Billing NOCHECK CONSTRAINT ALL;
--33)Enable all constraints again.
/* Enable all constraints again
 Why?
**After data loading or fixing data issues, you must enable constraints again.
*/
ALTER TABLE Archive.Billing CHECK CONSTRAINT ALL;
--This turns all FK + Check + Unique constraints back on.

--34)Create a backup table Patients_Backup using the structure of Patients.
/*What does "structure only" mean?
-Only column names + data types
-NO rows copied
-NO constraints copied
** Why do we do this?
-To create a backup design
-To test changes
-To store future data
*/
SELECT *
INTO Patients_Backup
FROM Archive.patients
WHERE 1 = 0;
--WHERE 1 = 0 is always false → so no data is copied.

--35)Copy structure and data from Doctors to Doctors_Backup.
/*This means:
1)Copy table structure
2)Copy all rows
3)Constraints are NOT copied

Identity is NOT copied (unless extra steps)
Why?

--To create a complete backup of the Doctors table.
*/
SELECT *
INTO Doctors_Backup
FROM Archive.Doctors;
--This creates a new table with the same column structure + all data.

