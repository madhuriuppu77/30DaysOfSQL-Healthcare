

## TCL (Transaction Control Language) ##


## 1️) Purpose of TCL:
- TCL ensures that multiple related SQL operations (transactions) either succeed 
  together or fail together.
- Critical for healthcare to maintain data integrity, accuracy, and patient safety.
- Common commands: BEGIN TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT, SET TRANSACTION

## 2️) Key Concepts (ACID Properties):
- Atomicity: All operations succeed together or none (e.g., admit patient, assign bed, billing)
- Consistency: Data rules are always maintained (e.g., billing cannot exist without patient)
- Isolation: Concurrent transactions do not interfere (e.g., multiple admissions at once)
- Durability: Committed changes are permanent (e.g., patient admission saved safely)

## 3️) TCL Commands:
- BEGIN TRANSACTION: Start a transaction block
- COMMIT: Save all changes permanently
- ROLLBACK: Undo changes in the transaction
- SAVEPOINT: Create a checkpoint to rollback partially
- SET TRANSACTION: Set properties for the transaction

## 4️) TRY…CATCH (Error Handling):
- TRY block: Place all SQL statements expected to succeed
- CATCH block: Executes only if an error occurs; rollback and log error
- Safer and cleaner than checking @@ERROR manually

## 5️) Real Healthcare Scenario – Patient Admission Workflow:

Scenario:
- Admit patient (insert into Patients)
- Assign bed (insert into Beds)
- Create billing (insert into Billing)
- Insert lab order (insert into LabOrders)
- If any step fails, rollback transaction to maintain consistency





