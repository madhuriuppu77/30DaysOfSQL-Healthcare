/* ==========================================================
   HEALTHCARE PRACTICE DATABASE
   Author: Madhuri Uppunuthula
   Description:
   Complete SQL practice database covering:
   SELECT, WHERE, GROUP BY, HAVING, JOINS,
   STRING, NUMBER, DATE, NULL, CASE, AGGREGATE functions
   ========================================================== */

------------------------------------------------------------
-- DROP DATABASE IF EXISTS
------------------------------------------------------------
IF DB_ID('HealthcareDB') IS NOT NULL
BEGIN
    DROP DATABASE HealthcareDB;
END;
GO

------------------------------------------------------------
-- CREATE DATABASE
------------------------------------------------------------
CREATE DATABASE HealthcareDB;
GO

USE HealthcareDB;
GO

/* ==========================================================
   DROP TABLES IF THEY EXIST (SAFE ORDER)
   ========================================================== */

IF OBJECT_ID('Prescriptions', 'U') IS NOT NULL DROP TABLE Prescriptions;
IF OBJECT_ID('Visits', 'U') IS NOT NULL DROP TABLE Visits;
IF OBJECT_ID('Billing', 'U') IS NOT NULL DROP TABLE Billing;
IF OBJECT_ID('DateTimePractice', 'U') IS NOT NULL DROP TABLE DateTimePractice;
IF OBJECT_ID('Doctors', 'U') IS NOT NULL DROP TABLE Doctors;
IF OBJECT_ID('Patients', 'U') IS NOT NULL DROP TABLE Patients;
GO

/* ==========================================================
   TABLE: Patients
   ========================================================== */
CREATE TABLE Patients (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender CHAR(1) CHECK (gender IN ('M','F')),
    age INT CHECK (age > 0),
    city VARCHAR(50),
    phone VARCHAR(15)
);
GO

/* ==========================================================
   TABLE: Doctors
   ========================================================== */
CREATE TABLE Doctors (
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50)
);
GO

/* ==========================================================
   TABLE: Visits
   ========================================================== */
CREATE TABLE Visits (
    visit_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    department VARCHAR(50),
    visit_date DATE,
    diagnosis VARCHAR(100),
    CONSTRAINT FK_Visits_Patient
        FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    CONSTRAINT FK_Visits_Doctor
        FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
GO

/* ==========================================================
   TABLE: Prescriptions
   ========================================================== */
CREATE TABLE Prescriptions (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    visit_id INT,
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    CONSTRAINT FK_Prescriptions_Visit
        FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);
GO

/* ==========================================================
   TABLE: Billing
   ========================================================== */
CREATE TABLE Billing (
    bill_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    consultation_fee DECIMAL(10,2),
    medicine_cost DECIMAL(10,2),
    discount DECIMAL(10,2),       -- Can be negative (ABS practice)
    tax_percent DECIMAL(5,2),
    created_date DATE,
    CONSTRAINT FK_Billing_Patient
        FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    CONSTRAINT FK_Billing_Doctor
        FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
GO

/* ==========================================================
   TABLE: DateTimePractice
   ========================================================== */
CREATE TABLE DateTimePractice (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    event_name VARCHAR(100),
    event_date DATE,
    event_time TIME,
    event_datetime DATETIME
);
GO

/* ==========================================================
   DATABASE SETUP COMPLETED SUCCESSFULLY
   ========================================================== */

