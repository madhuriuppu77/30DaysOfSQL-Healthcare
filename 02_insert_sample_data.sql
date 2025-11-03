/* ==========================================================
   HEALTHCARE PRACTICE DATABASE
   Author: [Madhuri Uppunuthula]
   Description: Practice dataset for SQL SELECT, WHERE,
                GROUP BY, HAVING, JOINS, NULL handling, etc.
   ========================================================== */
/* ==========================================================
   INSERT SAMPLE DATA (with NULLs)
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

INSERT INTO Doctors (first_name, last_name, department) VALUES
('Arun', 'Sharma', 'Cardiology'),
('Neha', 'Singh', 'Neurology'),
('Vikas', 'Patel', 'Orthopedics'),
('Sneha', 'Rao', 'Dermatology'),
('Kiran', 'Nair', NULL);
GO

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
   VERIFY DATA
   ========================================================== */

SELECT * FROM Patients;
SELECT * FROM Doctors;
SELECT * FROM Visits;
SELECT * FROM Prescriptions;
GO
