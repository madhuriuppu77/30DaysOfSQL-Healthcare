PURE DML QUESTIONS (ONLY INSERT / UPDATE / DELETE / MERGE)

--(All questions are valid even when tables are empty.)

-- INSERT — 15 QUESTIONS
--1) Insert a new department into the Departments table.
INSERT INTO Archive.Departments(department_id,department_name,head_doctor_id)
VALUES(1,'cardiology',11);

--2) Insert 5 doctors in one INSERT statement.
INSERT INTO Archive.Doctors(doctor_id,name,speciality,experience_years,phone_number)
VALUES(1,'latha','cardiology',11, '9848345477'),
(2,'madhu','neurology',05,'9177632952'),
(3,'raju','dermatology',11,'9948084899'),
(4,'nayani','cardiology',15,'9505134366'),
(5,'yashwan','hastrology',10,'9177524689');

--3) Insert the first patient using the patient_id_seq sequence.
/* so here i have create this in ddl command
CREATE SEQUENCE patient_id_seq
 START WITH 1000
 INCREMENT BY 1;

 so now we need to insert it so we no need to add squence number patient_id*/
 INSERT INTO Archive.Patients (patient_id, name, gender, date_of_birth, city)
VALUES (NEXT VALUE FOR patient_id_seq, 'Sita', 'Female', '1990-05-12', 'Hyderabad');

--No need to give manual patient_id and Sequence generates automatically
 
--4) Insert multiple patients 
INSERT INTO Archive.patients(patient_id,name,gender,date_of_birth,city)
VALUES(1,'rahul','MALE',02/05/1992,'Hyderabad'),
(2,'ramal','MALE',03/09/2000,'Hyderabad'),
(3,'mohini','FEMALE',19/09/2005,'Chennai')

--so here i got error because dates should in format like:Dates must always be in quotes 'YYYY-MM-DD'
--correct query is 
INSERT INTO Archive.Patients (patient_id, name, gender, date_of_birth, city)
VALUES 
(1, 'rahul', 'MALE', '1992-05-02', 'Hyderabad'),
(2, 'ramal', 'MALE', '2000-09-03', 'Hyderabad'),
(3, 'mohini', 'FEMALE', '2005-09-19', 'Chennai');

--5) Insert a doctor who has 10 years of experience and a phone number.
INSERT INTO Archive.Doctors(doctor_id,name,speciality,experience_years,phone_number)
VALUES(6,'lohitha','opthamologist',15, '9845285477')

--6) Insert a visit into Patient_Visits for a patient meeting a doctor.
INSERT INTO Archive.Patient_Visits(visit_id,patient_id,doctor_id,visit_date)
VALUES(12,1,1,'2025-06-25')--wrong query
/*i got a error saying:"Cannot insert explicit value for identity column in table 'Patient_Visits' when IDENTITY_INSERT is set to OFF".
Your table was created like this:
visit_id INT IDENTITY(1,1) PRIMARY KEY
This means:
SQL auto-generates visit_id
It starts at 1 and increases by 1
You are NOT allowed to insert a manual value*/
INSERT INTO Archive.Patient_Visits (patient_id, doctor_id, visit_date)
VALUES (1, 1, '2025-06-25');--correct query

--7) Insert 3 visit records in a single multi-row insert.
INSERT INTO Archive.Patient_Visits (patient_id, doctor_id, visit_date)
VALUES (2, 2, '2025-06-26'),
(3, 3, '2025-07-26'),
(4, 4, '2025-08-27');

--8) Insert the first record in Medications with drug name, dosage, and cost.
INSERT INTO Archive.Medications( prescription_id,patient_id,drug_name,dosage,frequency,cost)
VALUES(1,1,'Asprin',50,3,50.2)

--9) Insert 5 medications for 1 patient (test multi-insert).
INSERT INTO Archive.Medications( prescription_id,patient_id,drug_name,dosage,frequency,cost)
VALUES(1,1,'Asprin',50,3,50.2),
(2,1,'metformin',34,2,59.2),
(2,1,'thiazole',45,1,50),
(3,1,'acetophenlac',22,1,100),
(3,1,'domprazole',21,1,1980.00)
--again got error:"Violation of PRIMARY KEY constraint 'pk_Medications'. Cannot insert duplicate key in object 'Archive.Medications'. The duplicate key value is (1)."
/*Your table has:
**CONSTRAINT pk_Medications PRIMARY KEY(prescription_id)
That means:
 *)Each prescription_id must be unique
 *)No duplicates allowed
 so correct query is:*/
INSERT INTO Archive.Medications 
(prescription_id, patient_id, drug_name, dosage, frequency, cost)
VALUES
(1, 1, 'Aspirin', 50, 3, 50.2),
(2, 1, 'Metformin', 34, 2, 59.2),
(3, 1, 'Thiazole', 45, 1, 50),
(4, 1, 'Acetophenlac', 22, 1, 100),
(5, 1, 'Domprazole', 21, 1, 1980.00);

/* again if u get error check for identitty!!  got error because ,If prescription_id is IDENTITY?
Then you must NOT insert prescription_id manually.
You should do:*/
INSERT INTO Archive.Medications 
(patient_id, drug_name, dosage, frequency, cost)
VALUES
(1, 'Aspirin', 50, 3, 50.2),
(1, 'Metformin', 34, 2, 59.2),
(1, 'Thiazole', 45, 1, 50),
(1, 'Acetophenlac', 22, 1, 100),
(1, 'Domprazole', 21, 1, 1980.00);

--10) Insert a new entry into Billing with amount and billing_date.
INSERT INTO Archive.Billing(invoice_id,patient_id,amount,billing_date,payment_status)
VALUES(1,1,45000,'2025-06-25','pending');

--11) Insert a bill without specifying payment_status (test DEFAULT).
INSERT INTO Archive.Billing(invoice_id,patient_id,amount,billing_date,payment_status)
VALUES(7,8,5000,'2025-07-25','DEFAULT'); --THIS is wrong beacuse:

/*'DEFAULT' in quotes is treated as a string, not as the SQL keyword DEFAULT.
SQL will literally try to insert the word "DEFAULT" into the column → not what you want.
Also, if you want SQL to use the DEFAULT value (which you set as 'Pending') → you cannot include that column in VALUES as a string*/

INSERT INTO Archive.Billing(invoice_id, patient_id, amount, billing_date)
VALUES (7, 8, 5000, '2025-07-25');

--payment_status will automatically be 'Pending' because of the DEFAULT constraint.

--12) Insert an i for a patient in patient table.
INSERT INTO Archive.Patients (patient_id, name, gender, date_of_birth, city)
VALUES (5, 'mya', 'Female', '1999-07-12', 'ongole');

--13) Insert sample data into #Temp_Billing temporary table.
CREATE TABLE #Temp_Billing (
    invoice_id INT NOT NULL,
    patient_id INT NOT NULL,
    amount INT NOT NULL,
    billing_date DATE NOT NULL,
    payment_status VARCHAR(15) NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_Temp_Billing PRIMARY KEY (invoice_id)
);
--then insert sample data
INSERT INTO #Temp_Billing (invoice_id, patient_id, amount, billing_date)
VALUES
(1, 101, 5000, '2025-07-10'),
(2, 102, 3000, '2025-07-11');

--14) Insert all data from #Temp_Billing into Archive.Billing.
INSERT INTO Archive.Billing(invoice_id, patient_id, amount, billing_date)
SELECT invoice_id, patient_id, amount, billing_date
FROM #Temp_Billing 
--Error:Cannot insert the value NULL into column 'payment_status', table 'HealthcareDB_V2.Archive.Billing'; column does not allow nulls. INSERT fails.
/*You are not selecting payment_status, but SQL does not automatically use DEFAULT in INSERT ... SELECT.
 In INSERT ... SELECT, DEFAULT only works if you explicitly include DEFAULT keyword, otherwise SQL tries to insert NULL into that column → fails.
 */
 INSERT INTO Archive.Billing(invoice_id, patient_id, amount, billing_date, payment_status)
SELECT invoice_id, patient_id, amount, billing_date, DEFAULT
FROM #Temp_Billing;

/* still you will get error because,In SQL Server, you cannot use DEFAULT inside a SELECT statement.
INSERT ... SELECT does not allow DEFAULT like we use in INSERT ... VALUES.*/

--15) Insert all patients from Patients into Patients_Backup (INSERT…SELECT).
INSERT INTO Patients_Backup(patient_id, name, gender, date_of_birth, city)
SELECT patient_id, name, gender, date_of_birth, city
FROM Archive.patients

-- UPDATE — 10 QUESTIONS

  --16) Update a doctor’s phone number
UPDATE Archive.Doctors
SET phone_number= '9123456789'
WHERE doctor_id= 6

--17) Update patient name to pooja for id 1.
UPDATE Archive.patients
SET name='pooja',
gender='FEMALE'
WHERE patient_id=1 

--18) Increase experience_years of all doctors by 2 years.
UPDATE Archive.Doctors
SET experience_years = experience_years + 2;

--19) Update the speciality of all doctors from ‘Cardiology’ to ‘Senior Cardiology’.
UPDATE Archive.Doctors
SET speciality = 'Senior Cardiology'
WHERE speciality = 'cardiology'
--20) Update visit_date for all Patient_Visits to today’s date.

--21) Update billing amount by adding 500 to all entries.
UPDATE Archive.Billing
SET amount =amount +500

--22) Update payment_status from 'Pending' to 'Paid'.
UPDATE Archive.Billing
SET payment_status = 'paid'
WHERE payment_status = 'pending'

--23) Update cost of medications by reducing 10%.
INSERT INTO Archive.Medications 
(prescription_id, patient_id, drug_name, dosage, frequency, cost)
VALUES
(2, 2, 'Metformin', 34, 2, 59.2),
(3, 3, 'Thiazole', 45, 1, 50),
(4, 4, 'Acetophenlac', 22, 1, 100),
(5, 5, 'Domprazole', 21, 1, 1980.00);

UPDATE Archive.Medications
SET cost=cost-10

--24) Update patient’s city for a certain patient_id.
UPDATE Archive.patients
SET city= 'Bihar'
WHERE patient_id=2
--25) Update Doctors name as Rahul Doctors table for a specific id number 1.
SELECT * FROM Archive.Doctors
UPDATE Archive.Doctors
SET name= 'Rahul'
WHERE doctor_id=1

-- DELETE — 7 QUESTIONS
--26) Delete a patient using patient_id 1.
DELETE Archive.patients
WHERE patient_id=1

--27) Delete all patients where city is NULL.
DELETE Archive.patients
WHERE city IS NULL

--28) Delete a doctor using doctor_id 1.
DELETE Archive.Doctors
WHERE doctor_id=1
/* I got error: The DELETE statement conflicted with the REFERENCE constraint "fk_patientVists_doctor". 
The conflict occurred in database "HealthcareDB_V2", table "Archive.Patient_Visits", column 'doctor_id'.

explanation:
The error means you are trying to delete a doctor who is still referenced in another table (Archive.Patient_Visits) through a Foreign Key.
Because of the FK constraint fk_patientVists_doctor, SQL Server does not allow deleting a parent record while related records exist in the child table.

Why the error happened?

*Archive.Doctors = Parent table

*Archive.Patient_Visits = Child table
Column doctor_id in Archive.Patient_Visits refers to doctor_id in Archive.Doctors
So if doctor_id 1 exists in Patient_Visits, you cannot delete it directly.*/
DELETE FROM Archive.Patient_Visits
WHERE doctor_id = 1;

DELETE FROM Archive.Doctors
WHERE doctor_id = 1;

--29) Delete visits belonging to a specific patient_id 2.
DELETE FROM Archive.Patient_Visits
WHERE patient_id = 2;
/* You didn’t get an error when deleting visits, but did get an error when deleting a doctor.?
The difference is which table is parent and which is child in the foreign key relationship.

Foreign Key Relationship Logic:

*)A foreign key always points from child → parent.
In your case:
| Table                    | Role       | Key                     | Notes                         |
| ------------------------ | ---------- | ----------------------- | ----------------------------- |
| `Archive.Doctors`        | **Parent** | doctor_id (Primary Key) | Holds master doctor data      |
| `Archive.Patient_Visits` | **Child**  | doctor_id (Foreign Key) | Must match an existing doctor |
So, Patient_Visits depends on Doctors, not vice-versa.

Why the doctor delete failed
When you tried: DELETE FROM Archive.Doctors WHERE doctor_id = 1;
 **SQL found child rows referencing this doctor, and foreign key blocked deletion to prevent orphan data.
 Rule:
You CANNOT delete a parent while child rows still reference it.

Why deleting visits succeeded?

When you deleted: DELETE FROM Archive.Patient_Visits WHERE patient_id = 2;
You were deleting child records, not parent ones.
Deleting child records does not break any foreign key rule, so SQL allowed it.
 Rule:
Deleting child rows is allowed because nothing depends on them further.

Example Analogy:
Think of Doctors as teachers and Patient_Visits as class attendance entries:
Students’ attendance records (child) depend on teacher existing
If you delete the teacher first → attendance logs become meaningless → ERROR
If you delete attendance logs first → no dependency issue → OK 
*/

--30) Delete all medications with dosage less than 25.
 DELETE Archive.Medications
 WHERE dosage < 25
   
--31) Delete Billing records where payment_status = 'Cancelled'.
DELETE Archive.Billing
WHERE payment_status = 'Cancelled'
   
--32) Delete all rows from #Temp_Billing after transferring data.
DELETE #Temp_Billing
/* Error: Invalid object name '#Temp_Billing'.
Temp table already dropped automatically

#Temp_Billing is a local temporary table, meaning it exists only within the same session (same query window or same stored procedure).
If that session ended or if a DROP TABLE #Temp_Billing was already executed, the table no longer exists — so SQL gives an error.

Using wrong command

To delete rows from a table, the correct syntax is:*/

DELETE FROM #Temp_Billing; --You missed the FROM keyword

SELECT * INTO #Temp_Billing FROM Archive.Billing;
GO

DELETE FROM #Temp_Billing;   --  error if executed in different session

-- MERGE — 3 QUESTIONS

--(Advanced DML used in companies)

/*33) MERGE new doctor data into Doctors table:

If exists → update
If not → insert*/

-- Example source table: staging table with new/updated doctors
CREATE TABLE #Stg_Doctors (
  doctor_id INT,         -- primary key or business key
  name NVARCHAR(200),
  specialty NVARCHAR(100),
  phone NVARCHAR(50),
  last_updated DATETIME
);

-- Sample MERGE
;MERGE INTO Archive.Doctors AS t
USING (SELECT doctor_id, name, specialty, phone, last_updated FROM #Stg_Doctors) AS s
  ON t.doctor_id = s.doctor_id

-- When matched => update fields that changed
WHEN MATCHED AND (
      ISNULL(t.name,'') <> ISNULL(s.name,'')
  OR  ISNULL(t.specialty,'') <> ISNULL(s.specialty,'')
  OR  ISNULL(t.phone,'') <> ISNULL(s.phone,'')
) THEN
  UPDATE SET
    t.name = s.name,
    t.specialty = s.specialty,
    t.phone = s.phone,
    t.last_updated = s.last_updated

-- When not matched => insert new doctor
WHEN NOT MATCHED BY TARGET THEN
  INSERT (doctor_id, name, specialty, phone, last_updated)
  VALUES (s.doctor_id, s.name, s.specialty, s.phone, s.last_updated)

-- Optional: capture what happened
OUTPUT
  $action AS MergeAction, -- 'UPDATE' or 'INSERT'
  inserted.doctor_id,
  inserted.name,
  deleted.doctor_id AS DeletedID;


--34) MERGE patient data from Patients into Patients_Backup:

--Insert only missing records.
;MERGE INTO Archive.Patients_Backup AS t
USING (SELECT patient_id, name, dob, gender, address FROM Archive.Patients) AS s
  ON t.patient_id = s.patient_id

-- No WHEN MATCHED clause: do not update existing backup rows
WHEN NOT MATCHED BY TARGET THEN
  INSERT (patient_id, name, dob, gender, address)
  VALUES (s.patient_id, s.name, s.dob, s.gender, s.address)

OUTPUT
  $action AS ActionTaken, s.patient_id;


--35) MERGE Billing with #Temp_Billing:

--Update matching invoice_id and insert new rows.
-- Example temp table
CREATE TABLE #Temp_Billing (
  invoice_id INT,
  patient_id INT,
  amount DECIMAL(18,2),
  billing_date DATE,
  status NVARCHAR(50)
);

-- MERGE statement
BEGIN TRAN;
BEGIN TRY

;MERGE INTO Archive.Billing AS t
USING (SELECT invoice_id, patient_id, amount, billing_date, status FROM #Temp_Billing) AS s
  ON t.invoice_id = s.invoice_id

-- Update existing billing rows
WHEN MATCHED AND (
    ISNULL(t.amount,0) <> ISNULL(s.amount,0)
 OR ISNULL(t.billing_date,'19000101') <> ISNULL(s.billing_date,'19000101')
 OR ISNULL(t.status,'') <> ISNULL(s.status,'')
) THEN
  UPDATE SET
    t.patient_id = s.patient_id,
    t.amount = s.amount,
    t.billing_date = s.billing_date,
    t.status = s.status,
    t.last_modified = SYSUTCDATETIME()

-- Insert new billing rows
WHEN NOT MATCHED BY TARGET THEN
  INSERT (invoice_id, patient_id, amount, billing_date, status, created_at)
  VALUES (s.invoice_id, s.patient_id, s.amount, s.billing_date, s.status, SYSUTCDATETIME())

-- Optional: handle rows in target that are NOT in source (delete/archive) — commented out
-- WHEN NOT MATCHED BY SOURCE THEN
--   DELETE

OUTPUT
  $action AS ActionTaken,
  inserted.invoice_id AS NewInvoice,
  deleted.invoice_id  AS OldInvoice;

COMMIT TRAN;
END TRY
BEGIN CATCH
  ROLLBACK TRAN;
  THROW; -- rethrow error for visibility
END CATCH;
