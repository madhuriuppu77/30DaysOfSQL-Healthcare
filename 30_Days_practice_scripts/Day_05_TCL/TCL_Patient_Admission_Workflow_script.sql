/*
====================================================================================
TCL (Transaction Control Language) – Step-by-Step Explanation for Healthcare
====================================================================================

SQL Implementation: Patient Admission Workflow with Detailed Step Explanation */

BEGIN TRY
    BEGIN TRANSACTION;
    -- Step 1️: Insert patient
    -- Purpose: Add a new patient record. This is the first step because
    -- other operations (bed assignment, billing) depend on the patient existing.
    INSERT INTO Patients(patient_id, name, age)
    VALUES (102, 'John Doe', 50);

    -- Step 2️: Assign bed
    -- Purpose: Allocate a bed for the patient in the Beds table.
    -- Ensures patient has a valid bed assignment.
    INSERT INTO Beds(bed_no, patient_id)
    VALUES ('B03', 102);

    -- Step 3️: Savepoint before billing
    -- Purpose: Create a checkpoint for partial rollback.
    -- If billing insertion fails, we can rollback to this point
    -- without affecting patient or bed records.
    SAVEPOINT BeforeBilling;

    -- Step 4️: Insert billing
    -- Purpose: Create billing entry for the patient.
    -- Ensures the patient is charged correctly for services.
    INSERT INTO Billing(bill_id, patient_id, amount, billing_date)
    VALUES (3, 102, 2500, GETDATE());

    -- Step 5️: Insert lab order
    -- Purpose: Place a lab test order for the patient.
    -- Optional step that may depend on available stock or other conditions.
    INSERT INTO LabOrders(patient_id, test_name)
    VALUES (102, 'Blood Test');

    -- Step 6️: Commit transaction
    -- Purpose: Save all changes permanently if all operations succeed.
    -- Ensures atomicity: all steps are applied together.
    COMMIT;

END TRY
BEGIN CATCH
    -- Step 7️: Rollback transaction
    -- Purpose: Undo all changes if any error occurs in the TRY block.
    -- Prevents partial or inconsistent data from being saved.
    ROLLBACK;

    -- Step 8️: Print error message
    -- Purpose: Display the error for debugging and logging.
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;

====================================================================================
/*
  Explanation of Steps:

1️ Insert patient
   - Ensures patient exists before assigning bed or billing.
   - Critical first step for referential integrity.

2️ Assign bed
   - Links patient to a physical bed.
   - Must occur after patient insertion.

3️ Savepoint before billing
   - Acts as a checkpoint for partial rollback.
   - Useful if optional or dependent steps fail.

4️ Insert billing
   - Charges patient for admission.
   - Failure here can rollback only billing using SAVEPOINT.

5️ Insert lab order
   - Adds lab test details.
   - Can be rolled back independently if needed.

6️ COMMIT
   - Saves all successful operations permanently.
   - Ensures atomicity of the workflow.

7️ ROLLBACK
   - Undo all operations if any step fails.
   - Maintains consistency and prevents partial data.

8️ ERROR_MESSAGE()
   - Captures error details for troubleshooting.
   - Important for audit and debugging in healthcare systems.

====================================================================================
Best Practices:

- Always wrap multi-step operations in BEGIN TRANSACTION … COMMIT/ROLLBACK.
- Use SAVEPOINT for partial rollback scenarios (optional steps).
- Use TRY…CATCH for clean and automatic error handling.
- Maintain logical order: patient → bed → billing → lab → insurance.
- Test workflow with failure scenarios to ensure robustness.
- Helps maintain **atomicity, consistency, isolation, durability** (ACID) critical in healthcare.

====================================================================================
Summary:

- TCL ensures **safe, reliable, and consistent database operations**.
- In healthcare, it protects **patient records, billing, lab orders, and insurance claims**.
- TRY…CATCH + SAVEPOINT + COMMIT/ROLLBACK = **robust transaction control**.
====================================================================================

*/
