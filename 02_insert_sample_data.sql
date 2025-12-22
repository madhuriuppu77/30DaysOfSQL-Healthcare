/* ==========================================================
   HEALTHCARE PRACTICE DATABASE – SAMPLE DATA INSERT SCRIPT
   Author: Madhuri Uppunuthula
   Description:
   Initial data insertion for practicing:
   SELECT, WHERE, JOINS, NULL handling,
   STRING, NUMBER, DATE, CASE, AGGREGATE functions
   ========================================================== */

USE HealthcareDB;
GO

/* ==========================================================
   CLEAN EXISTING DATA (SAFE ORDER)
   ========================================================== */

IF OBJECT_ID('Prescriptions', 'U') IS NOT NULL DELETE FROM Prescriptions;
IF OBJECT_ID('Visits', 'U') IS NOT NULL DELETE FROM Visits;
IF OBJECT_ID('Billing', 'U') IS NOT NULL DELETE FROM Billing;
IF OBJECT_ID('DateTimePractice', 'U') IS NOT NULL DELETE FROM DateTimePractice;
IF OBJECT_ID('Doctors', 'U') IS NOT NULL DELETE FROM Doctors;
IF OBJECT_ID('Patients', 'U') IS NOT NULL DELETE FROM Patients;
GO

/* ==========================================================
   INSERT DATA INTO Patients
   ========================================================== */
INSERT INTO Patients (first_name, last_name, gender, age, city, phone) VALUES
('Ravi', 'Kumar', 'M', 45, 'Hyderabad', '9876543210'),
('Sita', 'Devi', 'F', 62, 'Chennai', NULL),
('Anil', 'Reddy', 'M', 34, 'Bangalore', '8877665544'),
('Meena', 'Patel', 'F', 29, NULL, '7766554433'),
('Kiran', 'Naik', 'M', 53, 'Hyderabad', '6655443322'),
('Lakshmi', 'Iyer', 'F', 71, 'Chennai', '9988123456'),
('Rahul', 'Verma', 'M', NULL, 'Delhi', '9000099999'),
('Priya', 'Menon', 'F', 37, 'Kochi', NULL);
GO

/* ==========================================================
   INSERT DATA INTO Doctors
   ========================================================== */
INSERT INTO Doctors (first_name, last_name, department) VALUES
('Arun', 'Sharma', 'Cardiology'),
('Neha', 'Singh', 'Neurology'),
('Vikas', 'Patel', 'Orthopedics'),
('Sneha', 'Rao', 'Dermatology'),
('Kiran', 'Nair', NULL);
GO

/* ==========================================================
   INSERT DATA INTO Visits
   ========================================================== */
INSERT INTO Visits (patient_id, doctor_id, department, visit_date, diagnosis) VALUES
(1, 1, 'Cardiology', '2024-02-14', 'Hypertension'),
(2, 2, 'Neurology', '2024-03-01', 'Migraine'),
(3, 3, 'Orthopedics', '2024-03-12', 'Fracture'),
(1, 5, 'Cardiology', '2024-03-15', NULL),
(4, 4, 'Dermatology', '2024-04-10', 'Allergy'),
(5, 1, 'Cardiology', '2024-04-21', 'Chest Pain'),
(6, 2, 'Neurology', NULL, 'Dementia'),
(7, 3, 'Orthopedics', '2024-05-20', 'Back Pain'),
(8, 4, 'Dermatology', '2024-05-25', 'Acne'),
(3, 5, NULL, '2024-06-01', 'Checkup');
GO

/* ==========================================================
   INSERT DATA INTO Prescriptions
   ========================================================== */
INSERT INTO Prescriptions (visit_id, medication_name, dosage) VALUES
(1, 'Amlodipine', '5mg'),
(2, 'Sumatriptan', '50mg'),
(3, 'Ibuprofen', '400mg'),
(4, 'Aspirin', '75mg'),
(5, 'Cetirizine', NULL),
(6, 'Metoprolol', '50mg'),
(7, 'Donepezil', '10mg'),
(8, 'Paracetamol', '500mg'),
(9, NULL, '300mg'),
(10, 'Atorvastatin', '20mg');
GO

/* ==========================================================
   INSERT DATA INTO Billing
   ========================================================== */
INSERT INTO Billing
(patient_id, doctor_id, consultation_fee, medicine_cost, discount, tax_percent, created_date)
VALUES
(1, 1, 500.00, 1200.50, -50.00, 5.00, '2024-02-14'),
(2, 2, 700.00, 800.00, 0.00, 12.00, '2024-03-01'),
(3, 3, 650.50, 1500.75, -120.00, 18.00, '2024-03-12'),
(4, 4, 400.00, 450.00, 20.00, 5.00, '2024-04-10'),
(5, 1, 550.50, 900.25, -10.00, 12.00, '2024-04-21'),
(6, 2, 600.00, NULL, 0.00, 5.00, '2024-04-25'),
(7, 3, NULL, 1100.40, -35.00, 18.00, '2024-05-20'),
(8, 4, 750.00, 300.00, 15.00, 12.00, '2024-05-25'),
(3, 5, 850.00, 950.70, -200.00, 18.00, '2024-06-01'),
(1, 5, 500.00, 600.00, NULL, 5.00, '2024-06-05');
GO

/* ==========================================================
   INSERT DATA INTO DateTimePractice
   ========================================================== */
INSERT INTO DateTimePractice (event_name, event_date, event_time, event_datetime) VALUES
('Morning Checkup', '2024-01-10', '09:15:00', '2024-01-10 09:15:00'),
('Evening Surgery', '2024-02-05', '18:45:00', '2024-02-05 18:45:00'),
('Night Emergency', '2024-03-12', '23:50:00', '2024-03-12 23:50:00'),
('Midnight Case', '2024-04-01', '00:05:00', '2024-04-01 00:05:00'),
('Early Appointment', '2024-04-15', '06:30:00', '2024-04-15 06:30:00'),
('Lunch Break', '2024-05-02', '13:00:00', '2024-05-02 13:00:00'),
('Follow-up Visit', '2024-06-20', '15:20:00', '2024-06-20 15:20:00'),
('Report Upload', '2024-07-10', '10:45:30', '2024-07-10 10:45:30'),
('System Backup', '2024-08-01', '02:15:15', '2024-08-01 02:15:15'),
('Year-End Summary', '2024-12-31', '23:59:59', '2024-12-31 23:59:59');
GO

/* ==========================================================
   VERIFY DATA
   ========================================================== */
SELECT * FROM Patients;
SELECT * FROM Doctors;
SELECT * FROM Visits;
SELECT * FROM Prescriptions;
SELECT * FROM Billing;
SELECT * FROM DateTimePractice;
GO

