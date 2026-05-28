# Complete DBMS and Git Notes

---

# Table of Contents

1. DBMS, RDBMS and NoSQL
2. Difference Between DBMS and RDBMS
3. Types of DBMS
4. Data Redundancy and Data Inconsistency
5. DDL, DML and DQL
6. Normalization (1NF to 5NF)
7. ACID Properties
8. Transactions in DBMS
9. Rollback and Rollback to Savepoint
10. Types of NoSQL Databases
11. Types of Joins
12. Introduction to Git
13. Git Basic Commands
14. Complete Git Workflow

---

# 1. DBMS, RDBMS and NoSQL

## DBMS (Database Management System)

A DBMS is software used to store, manage and retrieve data.

### Features
- Stores data in files or tables
- Supports insert, update and delete operations
- Suitable for small applications

### Examples
- dBase
- File systems

---

## RDBMS (Relational Database Management System)

Stores data in related tables using keys.

### Features
- Uses SQL
- Supports normalization
- Uses primary and foreign keys
- Supports ACID properties

### Examples
- MySQL
- Oracle
- PostgreSQL

---

## NoSQL Database

Used for large-scale unstructured or semi-structured data.

### Features
- Flexible schema
- High scalability
- Distributed architecture

### Examples
- MongoDB
- Redis
- Cassandra
- Neo4j

---

# 2. Difference Between DBMS and RDBMS

| Feature | DBMS | RDBMS |
|---|---|---|
| Storage | Files/Tables | Related Tables |
| Relationships | Limited | Strong |
| Security | Lower | Higher |
| Normalization | Not necessary | Used |
| Multi-user Support | Limited | Strong |

---

# 3. Types of DBMS

## 1. Hierarchical DBMS
- Tree structure
- Parent-child relationship

## 2. Network DBMS
- Graph structure
- Many-to-many relationships

## 3. Relational DBMS
- Table-based
- Uses SQL

## 4. Object-Oriented DBMS
- Stores data as objects

## 5. NoSQL DBMS
- Flexible and scalable

---

# 4. Data Redundancy and Data Inconsistency

## Data Redundancy
Unnecessary duplication of data.

### Problems
- Storage wastage
- Difficult updates

---

## Data Inconsistency
Different values of same data in different places.

### Problems
- Incorrect information
- Reduced reliability

---

# 5. DDL, DML and DQL

## DDL Commands

| Command | Purpose |
|---|---|
| CREATE | Creates objects |
| ALTER | Modifies structure |
| DROP | Deletes objects |
| TRUNCATE | Removes all rows |
| RENAME | Renames objects |

### Example
```sql
CREATE TABLE Student(
   id INT,
   name VARCHAR(50)
);
```

---

## DML Commands

| Command | Purpose |
|---|---|
| INSERT | Adds data |
| UPDATE | Modifies data |
| DELETE | Removes data |

### Example
```sql
INSERT INTO Student VALUES(1,'Ravi');
```

---

## DQL Commands

| Command | Purpose |
|---|---|
| SELECT | Retrieves data |

### Example
```sql
SELECT * FROM Student;
```

---

# 6. Normalization

Normalization reduces redundancy and improves consistency.

---

## 1NF
- Atomic values only
- No repeating groups

## 2NF
- Must be in 1NF
- Removes partial dependency

## 3NF
- Removes transitive dependency

## BCNF
- Every determinant must be a candidate key

## 4NF
- Removes multi-valued dependency

## 5NF
- Removes join dependency

---

# Summary of Normal Forms

| Normal Form | Removes |
|---|---|
| 1NF | Repeating groups |
| 2NF | Partial dependency |
| 3NF | Transitive dependency |
| BCNF | Non-candidate dependency |
| 4NF | Multi-valued dependency |
| 5NF | Join dependency |

---

# 7. ACID Properties

## A - Atomicity
All operations happen or none happen.

## C - Consistency
Database remains valid before and after transaction.

## I - Isolation
Transactions do not interfere with each other.

## D - Durability
Committed data remains permanent.

---

# 8. Transactions in DBMS

A transaction is a group of SQL operations executed as a single unit.

## TCL Commands
- COMMIT
- ROLLBACK
- SAVEPOINT

---

# 9. Rollback and Rollback To Savepoint

## ROLLBACK
Cancels the entire transaction.

```sql
ROLLBACK;
```

---

## ROLLBACK TO SAVEPOINT
Cancels changes up to a specific savepoint.

```sql
ROLLBACK TO A;
```

---

# 10. Types of NoSQL Databases

## 1. Key-Value Database
Stores data as key-value pairs.

## 2. Document Database
Stores JSON-like documents.

## 3. Column-Oriented Database
Stores data in columns.

## 4. Graph Database
Stores nodes and relationships.

---

# 11. Types of Joins

## INNER JOIN
Returns matching rows only.

## LEFT JOIN
Returns all rows from left table.

## RIGHT JOIN
Returns all rows from right table.

## FULL OUTER JOIN
Returns all rows from both tables.

## CROSS JOIN
Returns Cartesian product.

## SELF JOIN
Table joins with itself.

---

# 12. Introduction to Git

## What is Git?

Git is a version control system used to:
- Track changes
- Save project history
- Collaborate with teams

---

## What is GitHub?

GitHub is an online platform to store Git repositories.

- Git = Tool
- GitHub = Cloud platform

---

# 13. Git Basic Commands

## Configure Git

### Set Username
```bash
git config --global user.name "Your Name"
```

### Set Email
```bash
git config --global user.email "yourmail@gmail.com"
```

---

## Initialize Git Repository

```bash
git init
```

---

## Clone Repository

```bash
git clone <repo-url>
```

---

## Check Status

```bash
git status
```

---

## Add Files

### Single File
```bash
git add filename
```

### All Files
```bash
git add .
```

---

## Commit Changes

```bash
git commit -m "message"
```

---

## Push Changes

```bash
git push origin main
```

---

## Pull Changes

```bash
git pull origin main
```

---

## Create Branch

```bash
git branch branch-name
```

---

## Switch Branch

```bash
git checkout branch-name
```

---

## Create and Switch Branch

```bash
git checkout -b branch-name
```

---

## Merge Branch

```bash
git merge branch-name
```

---

## View Commit History

```bash
git log
```

---

# 14. Complete Git Workflow

## Step 1: Clone Repository

```bash
git clone <repo-url>
```

---

## Step 2: Create Branch

```bash
git checkout -b feature-name
```

---

## Step 3: Add Files

```bash
git add .
```

---

## Step 4: Commit Changes

```bash
git commit -m "Added new feature"
```

---

## Step 5: Push Changes

```bash
git push origin feature-name
```

---

# Easy Git Flow

```text
Code Changes
     ↓
git add
     ↓
git commit
     ↓
git push
```

---

# Most Important Git Commands

| Command | Purpose |
|---|---|
| git init | Start Git |
| git clone | Download repo |
| git status | Check changes |
| git add | Stage files |
| git commit | Save changes |
| git push | Upload changes |
| git pull | Download updates |
| git branch | Create/view branches |
| git checkout | Switch branches |
| git merge | Combine branches |

---

# End of Notes
