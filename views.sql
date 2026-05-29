-- ============================================================
--  EMPLOYEE HIERARCHY DATABASE — VIEWS  (MySQL 8.0+)
-- ============================================================

-- ------------------------------------------------------------
-- 1. FULL EMPLOYEE DIRECTORY
--    Flat, human-readable snapshot of every active employee
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_employee_directory AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)          AS full_name,
    e.email,
    e.phone,
    e.hire_date,
    d.department_name,
    jt.title_name                                    AS job_title,
    jt.job_level,
    CONCAT(m.first_name, ' ', m.last_name)          AS manager_name,
    m.email                                          AS manager_email,
    e.salary,
    e.employment_status
FROM employees e
JOIN departments d  ON e.department_id = d.department_id
JOIN job_titles  jt ON e.job_title_id  = jt.job_title_id
LEFT JOIN employees m ON e.manager_id  = m.employee_id
ORDER BY jt.job_level DESC, d.department_name, e.last_name;

-- ------------------------------------------------------------
-- 2. ORGANISATION HIERARCHY (Recursive CTE)
--    Shows every employee's full chain from themselves up to CEO
--    Requires MySQL 8.0+
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_org_hierarchy AS
WITH RECURSIVE org_tree AS (
    -- Anchor: top-level executives (no manager)
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name)      AS full_name,
        e.email,
        jt.title_name                                AS job_title,
        jt.job_level,
        d.department_name,
        e.manager_id,
        CAST(CONCAT(e.first_name, ' ', e.last_name) AS CHAR(1000)) AS hierarchy_path,
        0                                            AS depth
    FROM employees e
    JOIN job_titles  jt ON e.job_title_id  = jt.job_title_id
    JOIN departments d  ON e.department_id = d.department_id
    WHERE e.manager_id IS NULL

    UNION ALL

    -- Recursive: employees who have a manager
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name),
        e.email,
        jt.title_name,
        jt.job_level,
        d.department_name,
        e.manager_id,
        CONCAT(ot.hierarchy_path, ' → ', e.first_name, ' ', e.last_name),
        ot.depth + 1
    FROM employees e
    JOIN org_tree    ot ON e.manager_id    = ot.employee_id
    JOIN job_titles  jt ON e.job_title_id  = jt.job_title_id
    JOIN departments d  ON e.department_id = d.department_id
)
SELECT
    employee_id,
    full_name,
    email,
    job_title,
    job_level,
    department_name,
    manager_id,
    depth,
    hierarchy_path
FROM org_tree
ORDER BY hierarchy_path;

-- ------------------------------------------------------------
-- 3. DIRECT REPORTS SUMMARY
--    For each manager: how many direct reports they have
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_direct_reports_summary AS
SELECT
    m.employee_id                                        AS manager_id,
    CONCAT(m.first_name, ' ', m.last_name)              AS manager_name,
    jt.title_name                                        AS manager_title,
    d.department_name,
    COUNT(r.employee_id)                                 AS direct_report_count,
    ROUND(AVG(r.salary), 2)                              AS avg_team_salary,
    GROUP_CONCAT(
        CONCAT(r.first_name, ' ', r.last_name)
        ORDER BY r.last_name
        SEPARATOR ', '
    )                                                    AS direct_reports
FROM employees m
JOIN employees   r  ON r.manager_id    = m.employee_id
JOIN job_titles  jt ON m.job_title_id  = jt.job_title_id
JOIN departments d  ON m.department_id = d.department_id
GROUP BY m.employee_id, m.first_name, m.last_name, jt.title_name, d.department_name
ORDER BY direct_report_count DESC;

-- ------------------------------------------------------------
-- 4. DEPARTMENT HEADCOUNT & SALARY SUMMARY
--    Note: MySQL has no FILTER clause; use SUM(CASE...) instead
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_department_summary AS
SELECT
    d.department_id,
    d.department_name,
    d.location,
    COUNT(e.employee_id)                                         AS total_employees,
    SUM(CASE WHEN e.employment_status = 'Active' THEN 1 ELSE 0 END) AS active_employees,
    ROUND(AVG(e.salary), 2)                                      AS avg_salary,
    MIN(e.salary)                                                AS min_salary,
    MAX(e.salary)                                                AS max_salary,
    SUM(e.salary)                                                AS total_payroll
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name, d.location
ORDER BY total_payroll DESC;

-- ------------------------------------------------------------
-- 5. SALARY BAND COMPLIANCE
--    Shows which employees are within / outside their job-title band
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_salary_band_compliance AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)           AS full_name,
    jt.title_name                                     AS job_title,
    jt.job_level,
    jt.min_salary                                     AS band_min,
    jt.max_salary                                     AS band_max,
    e.salary                                          AS actual_salary,
    CASE
        WHEN e.salary < jt.min_salary THEN 'Below Band'
        WHEN e.salary > jt.max_salary THEN 'Above Band'
        ELSE 'Within Band'
    END                                               AS band_status,
    e.salary - jt.min_salary                         AS delta_from_min,
    jt.max_salary - e.salary                         AS headroom_to_max
FROM employees e
JOIN job_titles jt ON e.job_title_id = jt.job_title_id
ORDER BY band_status, jt.job_level DESC;

-- ------------------------------------------------------------
-- 6. EMPLOYEE TENURE
--    Note: MySQL uses TIMESTAMPDIFF() instead of DATE_PART/AGE
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_employee_tenure AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)               AS full_name,
    e.hire_date,
    TIMESTAMPDIFF(YEAR,  e.hire_date, CURDATE())          AS years_of_service,
    MOD(TIMESTAMPDIFF(MONTH, e.hire_date, CURDATE()), 12) AS months_remainder,
    jt.title_name                                          AS job_title,
    d.department_name,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) >= 10 THEN 'Veteran (10 + yrs)'
        WHEN TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) >=  5 THEN 'Senior (5–9 yrs)'
        WHEN TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) >=  2 THEN 'Mid (2–4 yrs)'
        ELSE 'New (< 2 yrs)'
    END                                                    AS tenure_band
FROM employees e
JOIN job_titles  jt ON e.job_title_id  = jt.job_title_id
JOIN departments d  ON e.department_id = d.department_id
WHERE e.employment_status = 'Active'
ORDER BY years_of_service DESC, months_remainder DESC;

-- ------------------------------------------------------------
-- 7. PROJECT STAFFING
--    Each project with its assigned team members
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_project_staffing AS
SELECT
    p.project_id,
    p.project_name,
    p.status                                             AS project_status,
    p.start_date,
    p.end_date,
    d.department_name                                    AS owning_department,
    COUNT(pa.employee_id)                                AS team_size,
    GROUP_CONCAT(
        CONCAT(e.first_name, ' ', e.last_name, ' (', pa.role_in_project, ')')
        ORDER BY e.last_name
        SEPARATOR ', '
    )                                                    AS team_members
FROM projects p
JOIN departments          d  ON p.department_id   = d.department_id
LEFT JOIN project_assignments pa ON pa.project_id = p.project_id
LEFT JOIN employees        e  ON pa.employee_id   = e.employee_id
GROUP BY p.project_id, p.project_name, p.status, p.start_date, p.end_date, d.department_name
ORDER BY p.start_date;

-- ------------------------------------------------------------
-- 8. EMPLOYEE PROJECT LOAD
--    How many active projects each employee is on
--    Note: FILTER clause replaced with SUM(CASE...) for MySQL
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_employee_project_load AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)                       AS full_name,
    jt.title_name                                                  AS job_title,
    d.department_name,
    COUNT(pa.project_id)                                           AS total_projects,
    SUM(CASE WHEN p.status = 'Active' THEN 1 ELSE 0 END)          AS active_projects,
    GROUP_CONCAT(p.project_name ORDER BY p.project_name SEPARATOR ', ') AS project_names
FROM employees e
JOIN job_titles           jt ON e.job_title_id   = jt.job_title_id
JOIN departments          d  ON e.department_id  = d.department_id
LEFT JOIN project_assignments pa ON pa.employee_id = e.employee_id
LEFT JOIN projects         p  ON pa.project_id   = p.project_id
GROUP BY e.employee_id, e.first_name, e.last_name, jt.title_name, d.department_name
ORDER BY active_projects DESC, total_projects DESC;
