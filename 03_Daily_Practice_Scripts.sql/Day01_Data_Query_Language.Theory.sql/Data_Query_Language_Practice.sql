# Day 1 — Data Query Language (DQL) in Healthcare SQL Practice

## Introduction
**Data Query Language (DQL)** is used to **fetch data** from a database.  
In healthcare analytics, DQL helps extract patient details, visit summaries, medication records, billing reports, and much more.  
DQL focuses on reading data, not changing it — it’s the foundation for insights, dashboards, and data validation.

---

## Why DQL Matters in Healthcare
Every decision in healthcare data — from patient diagnosis tracking to revenue optimization — starts with **querying**.  
Example:
- Identifying patients who visited cardiology in the past 6 months  
- Finding top-prescribed medications  
- Summarizing monthly department-wise visits  

---

## Core DQL Commands (SQL Server)

| Command | Description | Example (Healthcare Context) |
|----------|--------------|------------------------------|
| **SELECT** | Retrieves data from one or more tables | `SELECT * FROM Patients;` |
| **FROM** | Specifies the source table | SELECT name, age FROM Doctors;` |
| **WHERE** | Filters data based on a condition | `SELECT * FROM Visits WHERE department = 'Cardiology';` |
| **ORDER BY** | Sorts the results | `SELECT * FROM Patients ORDER BY age DESC;` |
| **DISTINCT** | Removes duplicate values | `SELECT DISTINCT department FROM Visits;` |
| **GROUP BY** | Groups rows to summarize data | `SELECT department, COUNT(*) FROM Visits GROUP BY department;` |
| **HAVING** | Filters grouped results | `SELECT department, COUNT(*) FROM Visits GROUP BY department HAVING COUNT(*) > 10;` |
| **TOP** | Limits the number of rows returned | `SELECT TOP 5 * FROM Billing ORDER BY amount DESC;` |

---

## Practical Example
sql
-- Find the top 3 departments with the highest number of patient visits
SELECT TOP 3 
    department,
    COUNT(visit_id) AS total_visits
FROM Visits
GROUP BY department
ORDER BY total_visits DESC;
