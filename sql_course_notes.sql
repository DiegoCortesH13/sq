-- SQL COURSE REPOSITORY



-- EXTRACT DATES
SELECT 
    count(job_id) as number_of_jobs,
    EXTRACT(MONTH FROM job_posted_date) as month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY company_id
    month
ORDER BY number_of_jobs DESC;

SELECT 
    job_schedule_type,
    ROUND(avg(salary_year_avg),2) as yearly_salary,
    ROUND(avg(salary_hour_avg),2) as hourly_salary
FROM 
    job_postings_fact
WHERE 
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    2,3 DESC;

-- TIME ZONES
SELECT 
    job_title_short as title,
    job_location as job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date 
FROM 
    job_postings_fact;

SELECT 
    EXTRACT(MONTH from job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT') as month,
    COUNT(job_id) as job_count
FROM 
    job_postings_fact
WHERE (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT')::date > '2022-12-31'
GROUP BY month
ORDER by month desc;

-- CREATE TABLES FROM OTHER TABLES 89172
DROP TABLE january_jobs;

CREATE TABLE january_jobs as 
    SELECT  * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)= 1;

CREATE TABLE february_jobs as 
    SELECT  * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)= 2;

CREATE TABLE march_jobs as 
    SELECT  * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)= 3;

-- CASE STATEMENTS

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN salary_year_avg <= 75000 THEN 'Low'
        WHEN salary_year_avg <= 102500 THEN 'Mid'
        ELSE 'High'
    END AS salary_category
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY 
    CASE
        WHEN salary_year_avg <= 75000 THEN 'Low'
        WHEN salary_year_avg <= 102500 THEN 'Mid'
        ELSE 'High'
    END
ORDER BY 
    number_of_jobs DESC;


--EXPLORATION OF DATA TO DETERMINE CATEGORIZATION RULES

SELECT 
    AVG(salary_year_avg) as average,
    MAX(salary_year_avg) as max_salary,
    MIN(salary_year_avg) as min_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_year_avg) AS median_salary,
    PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY salary_year_avg) AS third_salary,
    PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY salary_year_avg) AS two_third_salary
FROM
  job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL;

-- SUBQUERIES AND CTEs
SELECT *
FROM
    (SELECT *
    FROM 
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date)=1) as january_jobs
;

SELECT 
    company_id,
    name as company_name
FROM 
    company_dim
WHERE 
    company_id IN (
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE 
            job_no_degree_mention = TRUE
);

--CTE NOTATION

WITH january_jobs_CTE as 
(
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1
)
SELECT *
    FROM january_jobs_CTE;


-- UNIONS | Union = removes duplicates, UNION ALL = keeps duplicates
SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;

