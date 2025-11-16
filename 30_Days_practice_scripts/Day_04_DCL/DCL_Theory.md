
#                DCL (Data Control Language)               #


What is DCL?
------------
DCL (Data Control Language) is used to control access, permissions, and authorization on database objects such as tables, views, stored procedures, and schemas.
Its purpose is to provide security, restrict unauthorized access, and ensure controlled data usage.

Why DCL is Important?
---------------------
DCL ensures that only authorized users have the appropriate level of access.
Example use cases:
1) Doctors can update medical records
2) Nurses can record vitals but not modify diagnosis
3) Receptionists can view schedules but cannot modify medical data
4) Billing team can update invoices but not edit patient details
5) Admin users have full control

DCL supports data privacy rules such as HIPAA, GDPR, and ISO security standards.

------------------------------------------------------------
Main DCL Commands
------------------------------------------------------------
| Command                        | Purpose                                        |
| ------------------------------ | ---------------------------------------------- |
| GRANT                          | Assign permissions to users or roles           |
| REVOKE                         | Remove previously granted permissions          |
| DENY (SQL Server specific)     | Explicitly block permissions, even if granted  |

------------------------------------------------------------
Types of Permissions in DCL
------------------------------------------------------------
| Permission        | Purpose                         |
| ----------------- | ------------------------------- |
| SELECT            | Read data                       |
| INSERT            | Add new data                    |
| UPDATE            | Modify existing data            |
| DELETE            | Remove records                  |
| EXECUTE           | Run stored procedures/functions |
| CONTROL / ALL     | Full privileges                 |

------------------------------------------------------------
End of DCL Theory
------------------------------------------------------------

