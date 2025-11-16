```
What is DCL?

Data Control Language (DCL) in SQL is used to control access, authorization, and permissions on database objects such as tables, views, procedures, and schemas.
Its primary goal is to protect data, enforce security, and ensure proper access control inside a database system.

 Why DCL is Important?

DCL is essential because modern applications involve multiple users, roles, and departments, and not everyone should be allowed to see or modify sensitive data.
Example:
1)Doctors can update medical records
2)Nurses can view and record vitals
3)Receptionists can schedule appointments
4)Billing staff can update invoices
5)Administrators have full access

DCL helps maintain confidentiality, privacy, and compliance standards (HIPAA, GDPR, ISO).
Main DCL Commands:

| Command                        | Purpose                                        |
| ------------------------------ | ---------------------------------------------- |
| **GRANT**                      | Assigns permissions to users or roles          |
| **REVOKE**                     | Removes previously granted permissions         |
| **DENY** (SQL Server specific) | Explicitly blocks permissions, even if granted |

DCL Permission Types:

| Permission        | Purpose                         |
| ----------------- | ------------------------------- |
| **SELECT**        | Read data                       |
| **INSERT**        | Add new data                    |
| **UPDATE**        | Modify existing data            |
| **DELETE**        | Remove data                     |
| **EXECUTE**       | Run stored procedures/functions |
| **CONTROL / ALL** | Full privileges                 |

```
