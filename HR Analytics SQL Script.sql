SELECT * FROM projects.hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20)NULL;

DESCRIBE hr;

SET sql_safe_updates = 0;
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%'THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate LIKE '%-%'THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE null 
END;
ALTER TABLE hr
MODIFY COlUMN birthdate DATE;
SELECT birthdate FROM hr;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%'THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN hire_date LIKE '%-%'THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE null 
END;

ALTER TABLE hr
MODIFY COlUMN hire_date DATE;
Select hire_date from hr;

UPDATE hr
SET termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate!='';

select termdate from hr;

ALTER TABLE hr
MODIFY COlUMN termdate DATE;
Select * from hr;
DESCRIBE hr;
SELECT * from hr;

ALTER TABLE hr ADD COLUMN age INT;
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());
SELECT * from hr;

 SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;
SELECT count(*) FROM hr WHERE age < 18;

#Questions
#1. What is the gender breakdown of employees in the compay?
SELECT gender, count(*) AS count
FROM hr
Where age >= 18 AND termdate = ''
group by gender;

#2 What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr
Where age >= 18 AND termdate = ''
GROUP BY race
ORDER BY count(*) DESC;

#3 What is the age distribution of the employees in the company?
SELECT
	min(age) AS youngest,
    max(age) As oldest
FROM hr
Where age >= 18 AND termdate = '';

SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY age_group
ORDER BY age_group;
# distribution of gender according to age groups
SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,gender,
    count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY age_group,gender
ORDER BY age_group,gender;

#4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY location;

#5. Average length of employment for employees who have been terminated?
SELECT
	round(avg(datediff(termdate,hire_date))/365,0)AS avg_length_employment
FROM hr
WHERE termdate<=curdate()AND termdate<>'' AND age>= 18;

#6 What is the gender distribution across departments and job titles?
SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = ''
GROUP BY department,gender
ORDER BY department;

#Which department has the highest turnover rate?
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM(
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate<> '' AND termdate<=curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
    ) AS subquery
order by termination_rate DESC;

#distribution of employees aross locations by city and state?
SELECT location_state,COUNT(*) as count
FROM hr
Where age >=18 AND termdate =''
GROUP BY location_state
ORDER BY count DESC;

#10 How has the company's employee count changed over time based on hire and term dates?
SELECT
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations)/hires * 100,2) AS net_change_percent
FROM(
	SELECT YEAR(hire_date) AS year,
    count(*) AS hires,
    SUM(CASE WHEN termdate <> '' AND termdate <= curdate()THEN 1 ELSE 0 END) AS terminations
	FROM hr
    WHere age >=18
    GROUP BY YEar(hire_date)
    ) AS subquery
ORDER BY year ASC;

#what is the tenure distribution for each department?

SELECT department,round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate<>''AND age >= 18
GROUP By department;




        

 