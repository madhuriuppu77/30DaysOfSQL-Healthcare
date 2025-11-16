DCL_Practice_scripts
------------------------------------------
-- SECTION A — GRANT Permissions
-----------------------------------------

--1) Allow NurseUser to view patient details from Patients table.
GRANT SELECT
ON Patients
TO NurseUser;

--2) Give ReceptionUser permission to insert appointment records.
GRANT INSERT
ON Appointments
TO ReceptionUser;

--3) Allow DoctorUser to update diagnosis and treatment plan.
GRANT UPDATE
ON Medical_Records
TO DoctorUser;

--4) Give BillingUser access to insert and view records.
GRANT SELECT, INSERT
ON Billing
TO BillingUser;

--5) Allow PharmacyUser to view and update drug stock.
GRANT SELECT, UPDATE
ON Pharmacy
TO PharmacyUser;

--6) Grant DoctorUser permission to execute stored procedure.
GRANT EXECUTE
ON OBJECT::sp_GetPatientHistory
TO DoctorUser;

--7) Allow AdminUser to have ALL permissions on ALL tables.
-- NOTE: Use DATABASE scope, not (*)
GRANT CONTROL
ON DATABASE::HealthcareDB
TO AdminUser;

--8) Give ReceptionUser permission to view doctor availability.
GRANT SELECT
ON Doctors
TO ReceptionUser;

--9) Allow InsuranceUser to insert claims.
GRANT INSERT
ON Insurance_Claims
TO InsuranceUser;

--10) Grant NurseUser permission to update vital signs.
GRANT UPDATE
ON Medical_Records
TO NurseUser;


-----------------------------------------
-- SECTION B — REVOKE Permissions
-----------------------------------------

--11) Remove DELETE permission from AdminUser.
REVOKE DELETE
ON Patients
FROM AdminUser;

--12) Revoke UPDATE access from ReceptionUser.
REVOKE UPDATE
ON Appointments
FROM ReceptionUser;

--13) Remove PharmacyUser permission to view billing data.
REVOKE SELECT
ON Billing
FROM PharmacyUser;

--14) Remove INSERT permission from InsuranceUser.
REVOKE INSERT
ON Insurance_Claims
FROM InsuranceUser;

--15) Revoke SELECT permission from NurseUser.
REVOKE SELECT
ON Patients
FROM NurseUser;

--16) Remove all permissions granted earlier from ReceptionUser.
-- Correct method requires revoking individually, or dropping login/role if needed.
-- Example (generic):
REVOKE SELECT, INSERT, UPDATE, DELETE, EXECUTE
ON Appointments
FROM ReceptionUser;

--17) Revoke EXECUTE permission from DoctorUser.
REVOKE EXECUTE
ON OBJECT::sp_GetPatientHistory
FROM DoctorUser;

--18) Remove VIEW permission from PharmacyUser on Medical_Records.
REVOKE SELECT
ON Medical_Records
FROM PharmacyUser;

--19) Revoke INSERT and UPDATE permissions from BillingUser.
REVOKE INSERT, UPDATE
ON Billing
FROM BillingUser;

--20) Remove ALL ACCESS from InsuranceUser (employee resigned).
-- Must revoke on all objects or DROP USER / LOGIN
REVOKE SELECT, INSERT, UPDATE, DELETE, EXECUTE
ON Database::HealthcareDB
FROM InsuranceUser;

--*) SECTION C — Scenario-based Questions
/* Important SQL Server rules before we start

1)GRANT/REVOKE works on one object at a time → not comma-separated table list.
2)GRANT ALL is not valid → must list permissions.
3)ON * or (*) is not valid → use ON SCHEMA::dbo or run per table.
4)UPDATE, INSERT, DELETE apply only if the object supports them.
5)Procedure permissions use: ON OBJECT::sp_name*/

--21)A new TraineeDoctor user joins. Allow SELECT only on Patients, Doctors, Medical_Records.
--No UPDATE/DELETE.
GRANT SELECT
ON  Patients, Doctors, Medical_Records ---THIS IS WRONG
TO TraineeDoctoruser;
-- CORRECT QUERY IS:
GRANT SELECT ON dbo.Patients TO TraineeDoctorUser;
GRANT SELECT ON dbo.Doctors TO TraineeDoctorUser;
GRANT SELECT ON dbo.Medical_Records TO TraineeDoctorUser;


--22)A lead doctor returns from vacation; restore full access to medical records and appointments.
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE
ON medical records, appointments-----------------------THIS IS WRONG
TO leaddoctor
---CORRECT QUERY IS:
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Medical_Records TO LeadDoctor;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Appointments TO LeadDoctor;

--23)A Hospital Auditor needs temporary read-only access to all patient-related tables.After audit is done, revoke access.
GRANT SELECT
ON patients
TO HospitalAuditor------------------THIS IS WRONG

REVOKE SELECT
ON patients
FROM HospitalAuditor

---CORRECT QUERY IS:
GRANT SELECT ON dbo.Patients TO HospitalAuditor;
GRANT SELECT ON dbo.Medical_Records TO HospitalAuditor;
GRANT SELECT ON dbo.Appointments TO HospitalAuditor;

REVOKE SELECT ON dbo.Patients FROM HospitalAuditor;
REVOKE SELECT ON dbo.Medical_Records FROM HospitalAuditor;
REVOKE SELECT ON dbo.Appointments FROM HospitalAuditor;


--24)A pharmacy staff was found misusing data; immediately remove all access.
 REVOKE SELECT,INSERT,UPDATE,DELETE,EXECUTE
 ON DATABASE:HealthcareDB_V2-------------------------THIS IS WRONG
 FROM pharmacy staff

 --CORRECT QUERY IS
REVOKE SELECT, INSERT, UPDATE, DELETE ON dbo.Pharmacy TO PharmacyStaff;
REVOKE SELECT, INSERT, UPDATE ON dbo.Medical_Records TO PharmacyStaff;
REVOKE SELECT ON dbo.Billing TO PharmacyStaff;

--25)During COVID emergency, temporarily allow every doctor to update all patient records.
GRANT UPDATE
ON pateints
TO doctor
--*) Bonus Practical Tasks

--26)Create a role ReadOnlyStaff and assign SELECT only permissions to Patients, Appointments.
-----------------------------------------
-- 26) Create ReadOnlyStaff Role
-----------------------------------------

-- Step 1: Create the Role
CREATE ROLE ReadOnlyStaff;
GO

-- Step 2: Grant SELECT permissions to specific tables
GRANT SELECT ON dbo.Patients TO ReadOnlyStaff;
GRANT SELECT ON dbo.Appointments TO ReadOnlyStaff;
GO

-- Step 3: Add users to the role (example users)
-- You can change usernames as needed
ALTER ROLE ReadOnlyStaff ADD MEMBER NurseUser;
ALTER ROLE ReadOnlyStaff ADD MEMBER ReceptionUser;
GO

-----------------------------------------
-- Step 4 (Optional): Verify Role Members
-----------------------------------------
SELECT 
    r.name AS RoleName,
    m.name AS MemberUser
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE r.name = 'ReadOnlyStaff';
GO

-----------------------------------------
-- Step 5 (Optional): Test Access Results
-----------------------------------------
-- Try queries under a ReadOnlyStaff user login like NurseUser
-- Expected: Allowed
SELECT * FROM Patients;
SELECT * FROM Appointments;

-- Expected: Denied
-- UPDATE Patients SET gender='Male' WHERE patient_id=1;
-- DELETE FROM Appointments WHERE appointment_id=10;


--27)Create a role DataEntryStaff with INSERT & UPDATE only on Appointments and Billing.
-----------------------------------------
-- 27) Create DataEntryStaff Role
-----------------------------------------

-- Step 1: Create Role
CREATE ROLE DataEntryStaff;
GO

-- Step 2: Grant INSERT & UPDATE permissions on required tables
GRANT INSERT, UPDATE ON dbo.Appointments TO DataEntryStaff;
GRANT INSERT, UPDATE ON dbo.Billing TO DataEntryStaff;
GO

-- Step 3: Add users to the role
ALTER ROLE DataEntryStaff ADD MEMBER NurseUser;
ALTER ROLE DataEntryStaff ADD MEMBER HeadNurseUser;
GO

-----------------------------------------
-- Step 4 (Optional): Verify Role Members
-----------------------------------------
SELECT 
    r.name AS RoleName,
    m.name AS MemberUser
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE r.name = 'DataEntryStaff';
GO


--28)Transfer all privileges of NurseUser to HeadNurseUser.
------------------------------------------------------------
-- 28) Transfer all privileges of NurseUser to HeadNurseUser
------------------------------------------------------------

-- Step 1: Create a new role (only if not created earlier)
CREATE ROLE NurseRole;
GO

-- Step 2: Assign permissions that NurseUser originally had
-- (Use only the correct permissions based on your system)
GRANT SELECT ON dbo.Patients TO NurseRole;
GRANT UPDATE ON dbo.Medical_Records TO NurseRole;
-- Add any extra permissions below if required...
-- GRANT SELECT, UPDATE ON dbo.Appointments TO NurseRole;
-- GRANT SELECT ON dbo.Billing TO NurseRole;

GO

-- Step 3: Add both users to the role
ALTER ROLE NurseRole ADD MEMBER NurseUser;
ALTER ROLE NurseRole ADD MEMBER HeadNurseUser;
GO

-- Step 4: Remove NurseUser (Complete transfer)
ALTER ROLE NurseRole DROP MEMBER NurseUser;
GO

------------------------------------------------------------
-- Final: Verify members (optional)
------------------------------------------------------------
SELECT 
    r.name AS RoleName,
    m.name AS Member
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE r.name = 'NurseRole';
GO

--29)Create a view View_Patient_Details and grant access to only ReceptionUser.( only for ROLE)
CREATE ROLE View_Patient_Details
GO;

GRANT SELECT ON View_Patient_Details TO Receptionuser
GO;

ALTER ROLE View_Patient_Details ADD MEMBER Receptionuser
GO;

--FOR VIEW
------------------------------------------------------------
-- 29) Create a View and Grant Access Only to ReceptionUser
------------------------------------------------------------

-- Step 1: Create the view
CREATE VIEW dbo.View_Patient_Details AS
SELECT
    patient_id,
    first_name,
    last_name,
    age,
    gender,
    phone_number,
    address
FROM dbo.Patients;
GO

-- Step 2: Grant SELECT permission on the view to ReceptionUser
GRANT SELECT ON dbo.View_Patient_Details TO ReceptionUser;
GO

--30)Revoke all permissions for PUBLIC for security audit.
REVOKE SELECT, INSERT, UPDATE, DELETE, EXECUTE
FROM PUBLIC;
