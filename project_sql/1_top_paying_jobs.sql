/*¨
Question:

What are the top-paying Data Analyst and Data Scientist roles?
- Identify the top-paying job 10 highest-paying roles for Data Analysts and Data Scientists that are available remotely
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
        ROW_NUMBER() OVER (
            PARTITION BY job_title
            ORDER BY salary_year_avg DESC
        ) AS rank
    FROM
        job_postings_fact
    WHERE
        job_title IN ('Data Analyst', 'Data Scientist')
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
)
SELECT
    rank,
    job_id,
    job_title,
    location,
    schedule_type,
    salary,
    job_posted_date
FROM
    ranked_jobs
WHERE
    rank <= 10;
