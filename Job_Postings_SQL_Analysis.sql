SELECT * FROM company_dim;
SELECT * FROM job_postings_fact;
SELECT * FROM skill_dim;
SELECT * FROM skill_job_dim;
---------------------------------------------------------------------
--1. Retrieve the top 10 highest-paid Data Analyst jobs.
     Exclude records with NULL salary values.
     Only include jobs where the location is 'Anywhere'.

SELECT 
	j.job_id,
	j.company_id,
	c.name,
	j.job_title_short,
	j.job_title,
	j.job_location,
	j.salary_year_avg 
FROM job_postings_fact j LEFT JOIN company_dim c ON j.company_id=c.company_id
WHERE j.job_location IN ('Anywhere')
	  AND
	  j.job_title_short ILIKE ('%Data Analyst%')
	  AND
	  j.salary_year_avg IS NOT NULL
ORDER BY j.salary_year_avg DESC
LIMIT 10;

--2. Retrieve the top 10 highest-paid Data Analyst jobs.
     Exclude records with NULL salary values.
     Only include jobs where the location is 'Anywhere'.
     What skill is required for the post.

SELECT 
	j.job_id,
	j.company_id,
	j.job_title_short,
	j.job_title,
	s.skills,
	j.job_location,
	j.salary_year_avg 
FROM job_postings_fact j LEFT JOIN skill_job_dim sj ON j.job_id=sj.job_id
						 LEFT JOIN skill_dim s      ON sj.skill_id=s.skill_id
WHERE j.job_location IN ('Anywhere')
	  AND
	  j.job_title_short ILIKE ('%Data Analyst%')
	  AND
	  j.salary_year_avg IS NOT NULL
ORDER BY j.salary_year_avg DESC
LIMIT 10;

-- 3.What are top 5 most demand skill for Data Analyst role

SELECT
	sj.skill_id,
	s.skills,
	COUNT(j.job_id) AS job_count
FROM job_postings_fact j LEFT JOIN skill_job_dim sj ON j.job_id=sj.job_id
						 LEFT JOIN skill_dim s      ON sj.skill_id=s.skill_id
WHERE j.job_title_short ILIKE ('%Data Analyst%')
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;

-- 4.What are the top 10 highest-paying job postings for the 'Data Analyst' role that require SQL skills?

SELECT
	j.job_id,
	j.company_id,
	c.name,
	j.job_title_short,
	j.job_title,
	s.skills,
	j.salary_year_avg
FROM job_postings_fact j JOIN skill_job_dim sj ON j.job_id=sj.job_id
						 JOIN skill_dim s      ON sj.skill_id=s.skill_id
						 JOIN company_dim c    ON j.company_id=c.company_id
WHERE j.salary_year_avg IS NOT NULL
	  AND
	  s.skills IN ('sql')
ORDER BY j.salary_year_avg DESC
LIMIT 10;

-- 5.Most demand and highest paying skill for Data Analyst

SELECT
	sj.skill_id,
	s.skills,
	COUNT(j.job_id) AS job_count,
	ROUND(AVG(salary_year_avg),2) AS averge_salary
FROM job_postings_fact j LEFT JOIN skill_job_dim sj ON j.job_id=sj.job_id
						 LEFT JOIN skill_dim s      ON sj.skill_id=s.skill_id
WHERE j.job_title_short ILIKE ('%Data Analyst%')
	  AND
	  j.salary_year_avg IS NOT NULL
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

-- 6.How many Data Analyst job postings were made in each month?

SELECT
	EXTRACT(YEAR FROM job_posted_date::DATE) AS year,
	TO_CHAR(job_posted_date::DATE,'YYYY-MM') AS year_month,
	TO_CHAR(job_posted_date::DATE,'MONTH') AS monthname,
	COUNT(job_id) AS job_counts	
FROM job_postings_fact
WHERE job_title_short ILIKE ('%Data Analyst%')
GROUP BY 1,2,3
ORDER BY 1 ASC, 2 ASC;

-- 7.Added a new column based on salary.find all location _category for data anlayst

SELECT 
	job_id,
	company_id,
	job_title_short,
	job_title,
	job_location,
	salary_year_avg,
	CASE
		WHEN salary_year_avg >= 100000 THEN 'Desired'
		WHEN salary_year_avg >= 50000 THEN 'High'
		WHEN salary_year_avg >= 30000 THEN 'Standard'
		else 'Low'
	END AS category
FROM job_postings_fact 
WHERE job_title_short ILIKE ('%Data Analyst%')
	  AND
	  salary_year_avg IS NOT NULL;

-- 8.Find the company has most data analyst job opening, 
     total number oj job(per customner_id) return with customer_name

SELECT 
	j.company_id,
	c.name,
	COUNT(j.job_id) AS total_job
FROM job_postings_fact j FULL JOIN company_dim c ON j.company_id=c.company_id
WHERE job_title_short ILIKE ('%Data Analyst%')
GROUP BY 1,2
ORDER BY 3 DESC;
	  
