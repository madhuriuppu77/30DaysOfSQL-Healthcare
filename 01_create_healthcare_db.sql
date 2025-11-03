/* ==========================================================
   HEALTHCARE PRACTICE DATABASE
   Author: [Madhuri Uppunuthula]
   Description: Practice dataset for SQL SELECT, WHERE,
                GROUP BY, HAVING, JOINS, NULL handling, etc.
   ========================================================== */

-- Drop database if it already exists
IF DB_ID('HealthcareDB') IS NOT NULL
    DROP DATABASE HealthcareDB;
GO

-- Create fresh database
CREATE DATABASE HealthcareDB;
GO
USE HealthcareDB;
GO

/* ==========================================================
   TABLES CREATION
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

CREATE TABLE Doctors (
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50)
);

CREATE TABLE Visits (
    visit_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    department VARCHAR(50),
    visit_date DATE,
    diagnosis VARCHAR(100),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Prescriptions (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    visit_id INT,
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);
GO
