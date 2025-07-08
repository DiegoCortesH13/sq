-- delete later
-- Version 2

SELECT *
FROM job_postings_fact
LIMIT 10;

SELECT * from january_jobs
Where EXTRACT(MONTH, job_posted_date) = 1
LIMIT 10;

