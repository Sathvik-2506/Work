-- ============================================================
--  EMPLOYEE HIERARCHY DATABASE — SAMPLE DATA
-- ============================================================

-- ------------------------------------------------------------
-- 1. DEPARTMENTS
-- ------------------------------------------------------------
INSERT INTO departments (department_name, location) VALUES
    ('Executive',           'HQ — Floor 10'),
    ('Engineering',         'HQ — Floor 4'),
    ('Product Management',  'HQ — Floor 5'),
    ('Human Resources',     'HQ — Floor 2'),
    ('Finance',             'HQ — Floor 3'),
    ('Marketing',           'HQ — Floor 6'),
    ('Sales',               'HQ — Floor 7'),
    ('Customer Support',    'Remote');

-- ------------------------------------------------------------
-- 2. JOB TITLES  (level 1 = entry → 10 = C-Suite)
-- ------------------------------------------------------------
INSERT INTO job_titles (title_name, job_level, min_salary, max_salary) VALUES
    ('Chief Executive Officer',         10, 300000.00, 600000.00),
    ('Chief Technology Officer',         9, 250000.00, 500000.00),
    ('Chief Financial Officer',          9, 230000.00, 480000.00),
    ('VP of Engineering',                8, 180000.00, 320000.00),
    ('VP of Product',                    8, 170000.00, 310000.00),
    ('VP of Sales',                      8, 160000.00, 300000.00),
    ('Engineering Manager',              7, 140000.00, 220000.00),
    ('Product Manager',                  6, 120000.00, 190000.00),
    ('Senior Software Engineer',         6, 110000.00, 180000.00),
    ('Software Engineer',                5,  85000.00, 130000.00),
    ('Junior Software Engineer',         4,  65000.00,  90000.00),
    ('QA Engineer',                      5,  80000.00, 120000.00),
    ('DevOps Engineer',                  6, 100000.00, 160000.00),
    ('HR Manager',                       7, 100000.00, 150000.00),
    ('HR Specialist',                    5,  60000.00,  90000.00),
    ('Financial Analyst',                5,  70000.00, 110000.00),
    ('Accountant',                       4,  55000.00,  85000.00),
    ('Marketing Manager',                7, 110000.00, 170000.00),
    ('Marketing Specialist',             5,  60000.00,  95000.00),
    ('Sales Manager',                    7, 120000.00, 190000.00),
    ('Sales Representative',             4,  50000.00,  80000.00),
    ('Customer Support Lead',            6,  70000.00, 100000.00),
    ('Customer Support Specialist',      3,  40000.00,  65000.00);

-- ------------------------------------------------------------
-- 3. EMPLOYEES  (inserted top-down so manager_id FK is valid)
-- ------------------------------------------------------------

-- ── C-Suite (no manager) ─────────────────────────────────────
INSERT INTO employees
    (first_name, last_name, email, phone, hire_date, department_id, job_title_id, manager_id, salary)
VALUES
    ('Diana',   'Morgan',   'diana.morgan@corp.com',   '+1-555-0100', '2015-03-01', 1,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Chief Executive Officer'),
        NULL, 520000.00),                                                  -- emp 1 : CEO

    ('Arjun',   'Sharma',   'arjun.sharma@corp.com',   '+1-555-0101', '2016-06-15', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Chief Technology Officer'),
        NULL, 420000.00),                                                  -- emp 2 : CTO

    ('Priya',   'Nair',     'priya.nair@corp.com',     '+1-555-0102', '2017-01-10', 5,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Chief Financial Officer'),
        NULL, 390000.00);                                                  -- emp 3 : CFO

-- ── VP Level ─────────────────────────────────────────────────
INSERT INTO employees
    (first_name, last_name, email, phone, hire_date, department_id, job_title_id, manager_id, salary)
VALUES
    ('Lucas',   'Kim',      'lucas.kim@corp.com',      '+1-555-0110', '2018-04-20', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'VP of Engineering'),
        (SELECT employee_id FROM employees WHERE email = 'arjun.sharma@corp.com'),
        280000.00),                                                        -- emp 4 : VP Eng

    ('Sanya',   'Mehta',    'sanya.mehta@corp.com',    '+1-555-0111', '2018-07-01', 3,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'VP of Product'),
        (SELECT employee_id FROM employees WHERE email = 'diana.morgan@corp.com'),
        260000.00),                                                        -- emp 5 : VP Product

    ('Carlos',  'Rivera',   'carlos.rivera@corp.com',  '+1-555-0112', '2019-02-14', 7,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'VP of Sales'),
        (SELECT employee_id FROM employees WHERE email = 'diana.morgan@corp.com'),
        250000.00);                                                        -- emp 6 : VP Sales

-- ── Manager Level ─────────────────────────────────────────────
INSERT INTO employees
    (first_name, last_name, email, phone, hire_date, department_id, job_title_id, manager_id, salary)
VALUES
    ('Ravi',    'Patel',    'ravi.patel@corp.com',     '+1-555-0120', '2019-09-01', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Engineering Manager'),
        (SELECT employee_id FROM employees WHERE email = 'lucas.kim@corp.com'),
        180000.00),                                                        -- emp 7 : Eng Mgr (Backend)

    ('Aisha',   'Omar',     'aisha.omar@corp.com',     '+1-555-0121', '2020-01-15', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Engineering Manager'),
        (SELECT employee_id FROM employees WHERE email = 'lucas.kim@corp.com'),
        175000.00),                                                        -- emp 8 : Eng Mgr (Frontend)

    ('Nina',    'Johansson','nina.johansson@corp.com', '+1-555-0122', '2018-11-01', 4,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'HR Manager'),
        (SELECT employee_id FROM employees WHERE email = 'diana.morgan@corp.com'),
        130000.00),                                                        -- emp 9 : HR Mgr

    ('Ethan',   'Brooks',   'ethan.brooks@corp.com',   '+1-555-0123', '2020-03-10', 6,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Marketing Manager'),
        (SELECT employee_id FROM employees WHERE email = 'diana.morgan@corp.com'),
        145000.00),                                                        -- emp 10 : Mkt Mgr

    ('Sofia',   'Torres',   'sofia.torres@corp.com',   '+1-555-0124', '2020-06-01', 7,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Sales Manager'),
        (SELECT employee_id FROM employees WHERE email = 'carlos.rivera@corp.com'),
        155000.00);                                                        -- emp 11 : Sales Mgr

-- ── Individual Contributors ────────────────────────────────────
INSERT INTO employees
    (first_name, last_name, email, phone, hire_date, department_id, job_title_id, manager_id, salary)
VALUES
    -- Backend Engineers (under Ravi Patel)
    ('James',   'Wilson',   'james.wilson@corp.com',   '+1-555-0130', '2021-02-01', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Senior Software Engineer'),
        (SELECT employee_id FROM employees WHERE email = 'ravi.patel@corp.com'),
        140000.00),

    ('Meera',   'Iyer',     'meera.iyer@corp.com',     '+1-555-0131', '2021-05-15', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Software Engineer'),
        (SELECT employee_id FROM employees WHERE email = 'ravi.patel@corp.com'),
        105000.00),

    ('Tom',     'Nguyen',   'tom.nguyen@corp.com',     '+1-555-0132', '2022-08-01', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Junior Software Engineer'),
        (SELECT employee_id FROM employees WHERE email = 'ravi.patel@corp.com'),
        72000.00),

    ('Fatima',  'Al-Rashid','fatima.alrashid@corp.com','+1-555-0133', '2022-11-01', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'DevOps Engineer'),
        (SELECT employee_id FROM employees WHERE email = 'ravi.patel@corp.com'),
        130000.00),

    -- Frontend Engineers (under Aisha Omar)
    ('Oliver',  'Grant',    'oliver.grant@corp.com',   '+1-555-0140', '2021-03-15', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Senior Software Engineer'),
        (SELECT employee_id FROM employees WHERE email = 'aisha.omar@corp.com'),
        138000.00),

    ('Lin',     'Chen',     'lin.chen@corp.com',       '+1-555-0141', '2022-01-10', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Software Engineer'),
        (SELECT employee_id FROM employees WHERE email = 'aisha.omar@corp.com'),
        102000.00),

    ('Sara',    'Ahmed',    'sara.ahmed@corp.com',     '+1-555-0142', '2022-06-01', 2,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'QA Engineer'),
        (SELECT employee_id FROM employees WHERE email = 'aisha.omar@corp.com'),
        95000.00),

    -- Product Managers (under Sanya Mehta)
    ('David',   'Park',     'david.park@corp.com',     '+1-555-0150', '2020-09-01', 3,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Product Manager'),
        (SELECT employee_id FROM employees WHERE email = 'sanya.mehta@corp.com'),
        155000.00),

    ('Amara',   'Diallo',   'amara.diallo@corp.com',   '+1-555-0151', '2021-07-15', 3,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Product Manager'),
        (SELECT employee_id FROM employees WHERE email = 'sanya.mehta@corp.com'),
        148000.00),

    -- HR Specialists (under Nina Johansson)
    ('Kevin',   'Brown',    'kevin.brown@corp.com',    '+1-555-0160', '2021-04-01', 4,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'HR Specialist'),
        (SELECT employee_id FROM employees WHERE email = 'nina.johansson@corp.com'),
        72000.00),

    -- Finance (under Priya Nair)
    ('Helen',   'Scott',    'helen.scott@corp.com',    '+1-555-0170', '2020-10-01', 5,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Financial Analyst'),
        (SELECT employee_id FROM employees WHERE email = 'priya.nair@corp.com'),
        95000.00),

    ('Marcus',  'Lee',      'marcus.lee@corp.com',     '+1-555-0171', '2021-09-01', 5,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Accountant'),
        (SELECT employee_id FROM employees WHERE email = 'priya.nair@corp.com'),
        68000.00),

    -- Marketing (under Ethan Brooks)
    ('Yuki',    'Tanaka',   'yuki.tanaka@corp.com',    '+1-555-0180', '2021-11-01', 6,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Marketing Specialist'),
        (SELECT employee_id FROM employees WHERE email = 'ethan.brooks@corp.com'),
        75000.00),

    -- Sales (under Sofia Torres)
    ('Ben',     'Harris',   'ben.harris@corp.com',     '+1-555-0190', '2022-03-01', 7,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Sales Representative'),
        (SELECT employee_id FROM employees WHERE email = 'sofia.torres@corp.com'),
        58000.00),

    ('Zara',    'Khan',     'zara.khan@corp.com',      '+1-555-0191', '2022-05-15', 7,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Sales Representative'),
        (SELECT employee_id FROM employees WHERE email = 'sofia.torres@corp.com'),
        56000.00),

    -- Customer Support (self-managed under CEO)
    ('Raj',     'Verma',    'raj.verma@corp.com',      '+1-555-0200', '2020-08-01', 8,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Customer Support Lead'),
        (SELECT employee_id FROM employees WHERE email = 'diana.morgan@corp.com'),
        82000.00),

    ('Chloe',   'Martin',   'chloe.martin@corp.com',   '+1-555-0201', '2023-01-10', 8,
        (SELECT job_title_id FROM job_titles WHERE title_name = 'Customer Support Specialist'),
        (SELECT employee_id FROM employees WHERE email = 'raj.verma@corp.com'),
        48000.00);

-- ------------------------------------------------------------
-- 4. PROJECTS
-- ------------------------------------------------------------
INSERT INTO projects (project_name, department_id, start_date, end_date, status)
VALUES
    ('Platform v3 Rewrite',         2, '2024-01-01', '2024-12-31', 'Active'),
    ('Mobile App Launch',           3, '2024-03-01', '2024-09-30', 'Completed'),
    ('Salesforce CRM Migration',    7, '2024-06-01', '2025-01-31', 'Active'),
    ('Annual Compliance Audit',     5, '2025-01-01', '2025-03-31', 'Completed'),
    ('Brand Refresh Campaign',      6, '2025-02-01', '2025-06-30', 'Active'),
    ('ML Recommendation Engine',    2, '2025-04-01', '2025-12-31', 'Planned');

-- ------------------------------------------------------------
-- 5. PROJECT ASSIGNMENTS
-- ------------------------------------------------------------
INSERT INTO project_assignments (project_id, employee_id, role_in_project)
VALUES
    -- Platform v3 Rewrite
    (1, (SELECT employee_id FROM employees WHERE email = 'ravi.patel@corp.com'),   'Tech Lead'),
    (1, (SELECT employee_id FROM employees WHERE email = 'james.wilson@corp.com'), 'Senior Engineer'),
    (1, (SELECT employee_id FROM employees WHERE email = 'meera.iyer@corp.com'),   'Backend Engineer'),
    (1, (SELECT employee_id FROM employees WHERE email = 'fatima.alrashid@corp.com'),'DevOps Lead'),
    (1, (SELECT employee_id FROM employees WHERE email = 'oliver.grant@corp.com'), 'Frontend Lead'),
    (1, (SELECT employee_id FROM employees WHERE email = 'lin.chen@corp.com'),     'Frontend Engineer'),
    (1, (SELECT employee_id FROM employees WHERE email = 'sara.ahmed@corp.com'),   'QA'),

    -- Mobile App Launch
    (2, (SELECT employee_id FROM employees WHERE email = 'david.park@corp.com'),   'Product Owner'),
    (2, (SELECT employee_id FROM employees WHERE email = 'aisha.omar@corp.com'),   'Engineering Lead'),
    (2, (SELECT employee_id FROM employees WHERE email = 'oliver.grant@corp.com'), 'Lead Developer'),

    -- Salesforce CRM Migration
    (3, (SELECT employee_id FROM employees WHERE email = 'sofia.torres@corp.com'), 'Project Sponsor'),
    (3, (SELECT employee_id FROM employees WHERE email = 'ben.harris@corp.com'),   'Sales Analyst'),
    (3, (SELECT employee_id FROM employees WHERE email = 'zara.khan@corp.com'),    'Data Validator'),

    -- Annual Compliance Audit
    (4, (SELECT employee_id FROM employees WHERE email = 'priya.nair@corp.com'),   'Executive Sponsor'),
    (4, (SELECT employee_id FROM employees WHERE email = 'helen.scott@corp.com'),  'Lead Analyst'),
    (4, (SELECT employee_id FROM employees WHERE email = 'marcus.lee@corp.com'),   'Accountant'),

    -- Brand Refresh
    (5, (SELECT employee_id FROM employees WHERE email = 'ethan.brooks@corp.com'), 'Owner'),
    (5, (SELECT employee_id FROM employees WHERE email = 'yuki.tanaka@corp.com'),  'Specialist'),

    -- ML Recommendation Engine
    (6, (SELECT employee_id FROM employees WHERE email = 'arjun.sharma@corp.com'), 'Executive Sponsor'),
    (6, (SELECT employee_id FROM employees WHERE email = 'ravi.patel@corp.com'),   'Tech Lead'),
    (6, (SELECT employee_id FROM employees WHERE email = 'james.wilson@corp.com'), 'ML Engineer'),
    (6, (SELECT employee_id FROM employees WHERE email = 'tom.nguyen@corp.com'),   'Junior Engineer'),
    (6, (SELECT employee_id FROM employees WHERE email = 'amara.diallo@corp.com'), 'Product Manager');
