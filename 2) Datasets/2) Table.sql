-- 1) Table with all Company Information
DROP TABLE IF EXISTS company_dim;

CREATE TABLE IF NOT EXISTS company_dim(
	 company_id 	INT 	PRIMARY KEY,
	 name 			TEXT,
	 link 			TEXT,
	 link_google 	TEXT,
	 thumbnail 		TEXT
);

COPY company_dim(company_id,name,link,link_google,thumBnail)
FROM 'D:\VCE\Sagar BCC\1) GIT HUB\2) SQL\1) Data Analysis Portifolio\6) Job_postings_2023\1) CSV Files\company_dim.csv'
DELIMITER ','
HEADER CSV;

SELECT * FROM company_dim;

-- 2)  Table with all Job Information
DROP TABLE IF EXISTS job_postings_fact;

CREATE TABLE IF NOT EXISTS job_postings_fact(
	  job_id 					INT 	PRIMARY KEY,
	  company_id 				INT,
	  job_title_short 			TEXT,
	  job_title 				TEXT,
	  job_location 				TEXT,
	  job_via 					TEXT,
	  job_schedule_type 		TEXT,
	  job_work_from_home 		BOOLEAN,
	  search_location 			TEXT,
	  job_posted_date 			TIMESTAMP,
	  job_no_degree_mention 	BOOLEAN,
	  job_health_insurance 		BOOLEAN,
	  job_country 				TEXT,
	  salary_rate 				VARCHAR(8),
	  salary_year_avg 			NUMERIC,
	  salary_hour_avg 			NUMERIC,

	  FOREIGN KEY(company_id) REFERENCES company_dim(company_id)
);
	  
COPY job_postings_fact(job_id,company_id,job_title_short,job_title,job_location,job_via,job_schedule_type,job_work_from_home,search_location,job_posted_date,job_no_degree_mention,job_health_insurance,job_country,salary_rate,salary_year_avg,salary_hour_avg)
FROM 'D:\VCE\Sagar BCC\1) GIT HUB\2) SQL\1) Data Analysis Portifolio\6) Job_postings_2023\1) CSV Files\job_postings_fact.csv'
DELIMITER ','
HEADER CSV;  

SELECT * FROM job_postings_fact;

--3) Table with all Skill requirement
DROP TABLE IF EXISTS skill_dim;

CREATE TABLE IF NOT EXISTS skill_dim(
	  skill_id 		INT 	   PRIMARY KEY,
	  skills 		VARCHAR(16),
	  type 			VARCHAR(16)
);

COPY skill_dim(skill_id,skills,type)
FROM 'D:\VCE\Sagar BCC\1) GIT HUB\2) SQL\1) Data Analysis Portifolio\6) Job_postings_2023\1) CSV Files\skills_dim.csv'
DELIMITER ','
HEADER CSV; 

SELECT * FROM skill_dim;

--4) Table with order_id and skill_id
DROP TABLE IF EXISTS skill_job_dim;

CREATE TABLE IF NOT EXISTS skill_job_dim(
	  job_id 	INT,
	  skill_id 	INT,

	  FOREIGN KEY(job_id) REFERENCES job_postings_fact(job_id),
	  FOREIGN KEY(skill_id) REFERENCES skill_dim(skill_id)	    
);

COPY skill_job_dim(job_id,skill_id)
FROM 'D:\VCE\Sagar BCC\1) GIT HUB\2) SQL\1) Data Analysis Portifolio\6) Job_postings_2023\1) CSV Files\skills_job_dim.csv'
DELIMITER ','
HEADER CSV; 

SELECT * FROM skill_job_dim;

------------------------------------------------------------
SELECT * FROM company_dim;
SELECT * FROM job_postings_fact;
SELECT * FROM skill_dim;
SELECT * FROM skill_job_dim;
