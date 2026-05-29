-- ============================================================
--  EMPLOYEE HIERARCHY DATABASE — SCHEMA
-- ============================================================

-- ------------------------------------------------------------
-- 1. DEPARTMENTS
-- ------------------------------------------------------------
CREATE TABLE departments (
    department_id   SERIAL          PRIMARY KEY,
    department_name VARCHAR(100)    NOT NULL UNIQUE,
    location        VARCHAR(100),
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- 2. JOB TITLES
-- ------------------------------------------------------------
CREATE TABLE job_titles (
    job_title_id    SERIAL          PRIMARY KEY,
    title_name      VARCHAR(100)    NOT NULL UNIQUE,
    job_level       INT             NOT NULL CHECK (job_level BETWEEN 1 AND 10),
    -- 1 = Entry-level  …  10 = C-Suite
    min_salary      NUMERIC(12, 2)  NOT NULL,
    max_salary      NUMERIC(12, 2)  NOT NULL,
    CONSTRAINT chk_salary_range CHECK (max_salary >= min_salary)
);

-- ------------------------------------------------------------
-- 3. EMPLOYEES  (self-referencing for hierarchy)
-- ------------------------------------------------------------
CREATE TABLE employees (
    employee_id     SERIAL          PRIMARY KEY,
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    phone           VARCHAR(20),
    hire_date       DATE            NOT NULL DEFAULT CURRENT_DATE,
    department_id   INT             NOT NULL REFERENCES departments(department_id),
    job_title_id    INT             NOT NULL REFERENCES job_titles(job_title_id),
    manager_id      INT             REFERENCES employees(employee_id),
    -- NULL manager_id  →  this employee is a top-level executive
    salary          NUMERIC(12, 2)  NOT NULL,
    employment_status VARCHAR(20)   NOT NULL DEFAULT 'Active'
                        CHECK (employment_status IN ('Active','On Leave','Terminated')),
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- 4. EMPLOYEE AUDIT LOG
-- ------------------------------------------------------------
CREATE TABLE employee_audit (
    audit_id        SERIAL          PRIMARY KEY,
    employee_id     INT             NOT NULL REFERENCES employees(employee_id),
    changed_field   VARCHAR(50)     NOT NULL,
    old_value       TEXT,
    new_value       TEXT,
    changed_by      INT             REFERENCES employees(employee_id),
    changed_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- 5. PROJECTS
-- ------------------------------------------------------------
CREATE TABLE projects (
    project_id      SERIAL          PRIMARY KEY,
    project_name    VARCHAR(150)    NOT NULL,
    department_id   INT             REFERENCES departments(department_id),
    start_date      DATE,
    end_date        DATE,
    status          VARCHAR(20)     DEFAULT 'Planned'
                        CHECK (status IN ('Planned','Active','Completed','Cancelled'))
);

-- ------------------------------------------------------------
-- 6. PROJECT ASSIGNMENTS  (many-to-many: employees ↔ projects)
-- ------------------------------------------------------------
CREATE TABLE project_assignments (
    assignment_id   SERIAL          PRIMARY KEY,
    project_id      INT             NOT NULL REFERENCES projects(project_id),
    employee_id     INT             NOT NULL REFERENCES employees(employee_id),
    role_in_project VARCHAR(100),
    assigned_at     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (project_id, employee_id)
);

-- ------------------------------------------------------------
-- INDEXES for common hierarchy / lookup queries
-- ------------------------------------------------------------
CREATE INDEX idx_emp_manager      ON employees(manager_id);
CREATE INDEX idx_emp_department   ON employees(department_id);
CREATE INDEX idx_emp_job_title    ON employees(job_title_id);
CREATE INDEX idx_emp_status       ON employees(employment_status);
CREATE INDEX idx_audit_employee   ON employee_audit(employee_id);
CREATE INDEX idx_assign_project   ON project_assignments(project_id);
CREATE INDEX idx_assign_employee  ON project_assignments(employee_id);

-- ------------------------------------------------------------
-- TRIGGER: keep updated_at current on employees
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_employee_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();
