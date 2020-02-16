-- Import schema from Relational ERD
CREATE TABLE "departments" (
    "dept_no" VARCHAR(50)   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR(50)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(50)   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "employes" (
    "emp_no" INTEGER   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(100)   NOT NULL,
    "last_name" VARCHAR(100)   NOT NULL,
    "gender" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employes" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" INTEGER   NOT NULL,
    "title" VARCHAR(250)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employes" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employes" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employes" ("emp_no");

-- import departments.csv file into departments table
-- import employes.csv file into employes table
-- import dept_manager.csv file into dept_manager table
-- import dept_emp.csv file into dept_emp table
-- import salaries.csv file into salaries table
-- import titles.csv file into titles table

-- Data Analysis
-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.

SELECT
	employes.emp_no,
	employes.first_name,
	employes.last_name,
	employes.gender,
	salaries.salary
FROM 
	employes 
	LEFT JOIN salaries 
		ON employes.emp_no = salaries.emp_no

-- 2. List employees who were hired in 1986.
SELECT
	emp_no,
	first_name,
	last_name,
	gender,
	hire_date
	
FROM 
	employes 
WHERE
	hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- 3. List the manager of each department with the following information: department number, department name, 
-- the manager's employee number, last name, first name, and start and end employment dates.

SELECT
	dm.dept_no, 
	d.dept_name, 
	dm.emp_no,
	e.emp_no,
	e.last_name,
	e.first_name,
	dm.from_date,
	dm.to_date
	
FROM
	employes AS e
	INNER JOIN dept_manager AS dm
		ON e.emp_no = dm.emp_no
		INNER JOIN departments AS d
		ON d.dept_no=dm.dept_no;
		
-- 4. List the department of each employee with the following information: employee number, last name, 
-- first name, and department name.

SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employes AS e
	INNER JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
	INNER JOIN departments AS d
	ON d.dept_no = de.dept_no;
	
-- 5. List all employees whose first name is "Hercules" and last names begin with "B."

SELECT last_name, first_name
FROM employes
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'


-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employes AS e
	INNER JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
	INNER JOIN departments AS d
	ON d.dept_no = de.dept_no
WHERE
	d.dept_name = 'Sales';


-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employes AS e
	INNER JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
	INNER JOIN departments AS d
	ON d.dept_no = de.dept_no
WHERE
	d.dept_name = 'Sales' OR d.dept_name = 'Development';
--  d.dept_name IN ('Sales', 'Development');


-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT
	last_name AS "Last Name", count(last_name) AS "Frequency"
FROM
	employes
GROUP BY 
	last_name
ORDER BY 
	"Frequency" DESC;