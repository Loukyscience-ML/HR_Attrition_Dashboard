1. Create & Prepare Table

CREATE TABLE employees (
    EmpName VARCHAR(100),
    Age INT,
    Attrition BOOLEAN,
    BusinessTravel VARCHAR(100),
    Department VARCHAR(100),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(100),
    EmployeeCount INT,
    EmployeeID INT,
    Gender VARCHAR(20),
    JobLevel INT,
    JobRole VARCHAR(100),
    MaritalStatus VARCHAR(30),
    MonthlyIncome INT,
    NumCompaniesWorked INT,
    Over18 BOOLEAN,
    PercentSalaryHike INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    YearsAtCompany INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

-- Preview first 10 rows
SELECT * FROM employees LIMIT 10;

-- Rename column MonthlyIncome → AnnualIncome
ALTER TABLE employees RENAME COLUMN MonthlyIncome TO AnnualIncome;



2. General Employee Stats

-- Total employees
SELECT COUNT(*) AS total_employees FROM employees;

-- Employees who left
SELECT COUNT(*) AS left_employees FROM employees WHERE Attrition = TRUE;

-- Employees still working
SELECT COUNT(*) AS active_employees FROM employees WHERE Attrition = FALSE;

-- Attrition rate
SELECT ROUND( (COUNT(*) FILTER (WHERE Attrition = TRUE)::decimal / COUNT(*)) * 100, 2) AS attrition_percentage  
FROM employees;



3. Salary Insights

-- Average annual income
SELECT ROUND(AVG(AnnualIncome), 2) AS avg_income FROM employees;

-- Highest and lowest annual income
SELECT MAX(AnnualIncome) AS highest_income, MIN(AnnualIncome) AS lowest_income FROM employees;

-- Average & Median annual income
SELECT 
  ROUND(AVG(AnnualIncome), 2) AS avg_income,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY AnnualIncome) AS median_income
FROM employees;

-- Average income by job role
SELECT JobRole, ROUND(AVG(AnnualIncome), 2) AS avg_salary
FROM employees
GROUP BY JobRole
ORDER BY avg_salary DESC;

-- Income above company average
SELECT EmpName, AnnualIncome
FROM employees
WHERE AnnualIncome > (SELECT AVG(AnnualIncome) FROM employees)
ORDER BY AnnualIncome DESC;

-- Attrition rate by salary range
SELECT 
  CASE
    WHEN AnnualIncome < 50000 THEN 'Low (<50K)'
    WHEN AnnualIncome BETWEEN 50000 AND 100000 THEN 'Medium (50K-100K)'
    ELSE 'High (>100K)'
  END AS salary_group,
  ROUND( (COUNT(*) FILTER (WHERE Attrition = TRUE)::decimal / COUNT(*)) * 100, 2 ) AS attrition_rate
FROM employees
GROUP BY salary_group
ORDER BY attrition_rate DESC;




4. Attrition Analysis

-- Attrition rate by department
SELECT Department,
  ROUND( (COUNT(*) FILTER (WHERE Attrition = TRUE)::decimal / COUNT(*)) * 100, 2 ) AS attrition_rate
FROM employees
GROUP BY Department
ORDER BY attrition_rate DESC;

-- Attrition rate by job role
SELECT JobRole,
  ROUND( (COUNT(*) FILTER (WHERE Attrition = TRUE)::decimal / COUNT(*)) * 100, 2 ) AS attrition_rate
FROM employees
GROUP BY JobRole
ORDER BY attrition_rate DESC;

-- Attrition by years at company
SELECT YearsAtCompany,
  ROUND( (COUNT(*) FILTER (WHERE Attrition = TRUE)::decimal / COUNT(*)) * 100, 2 ) AS attrition_rate
FROM employees
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;

-- Years at company (Min, Max, Avg)
SELECT MIN(YearsAtCompany) AS min_years,
       MAX(YearsAtCompany) AS max_years,
       ROUND(AVG(YearsAtCompany), 2) AS avg_years
FROM employees;

-- Attrition rate by years range
SELECT 
  CASE
    WHEN YearsAtCompany BETWEEN 0 AND 5 THEN '0-5 years'
    WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 years'
    WHEN YearsAtCompany BETWEEN 11 AND 20 THEN '11-20 years'
    ELSE '21+ years'
  END AS years_group,
  ROUND( (COUNT(*) FILTER (WHERE Attrition = TRUE)::decimal / COUNT(*)) * 100, 2) AS attrition_rate
FROM employees
GROUP BY years_group
ORDER BY years_group;

