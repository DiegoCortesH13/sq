/*¨
Question:

What are the top-paying Data Analyst and Data Scientist roles?
- Identify the top-paying job 10 highest-paying roles for Data Analysts and Data Scientists that are available remotely or in Mexico/Mexico City.
- Focuses on job postings with specified salaries (remove nulls)
- Why? Highlightthe top-oportunities for Data Analysts and Data Scientists, ofering insights into employment trends and salary expectations.
*/

WITH ranked_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location AS location,
        job_schedule_type AS schedule_type,
        salary_year_avg AS salary,
        job_posted_date,
        company_id,
        ROW_NUMBER() OVER (
            PARTITION BY job_title
            ORDER BY salary_year_avg DESC
        ) AS rank
    FROM
        job_postings_fact
    WHERE
        job_title IN ('Data Analyst', 'Data Scientist')
        AND job_location IN ('Anywhere', 'Mexico', 'Mexico City', 'Remote')
        AND salary_year_avg IS NOT NULL
)
SELECT
    rank,
    job_id,
    job_title,
    location,
    company_dim.name AS company_name,
    schedule_type,
    salary,
    job_posted_date
FROM
    ranked_jobs
LEFT JOIN
    company_dim ON ranked_jobs.company_id = company_dim.company_id
WHERE
    rank <= 10;

SELECT DISTINCT(job_location) as location
FROM
    job_postings_fact
WHERE
    job_title IN ('Data Analyst', 'Data Scientist')
    AND salary_year_avg IS NOT NULL;
