/*¨
Question:

What skills are required for the top-paying Data Analyst and Data Scientist jobs?
- Use the top 10 highest-paying roles identified in the first query.
- Add the specific skills required for each job.
- Why? It provides  a detail look at the skills needed for these high-paying roles, 
helping job seekers understand the qualifications required to secure these positions.

*/



    WITH jobs_with_skills AS (
        SELECT DISTINCT
            jpf.job_id,
            jpf.job_title,
            jpf.salary_year_avg AS salary,
            jpf.company_id
        FROM
            job_postings_fact AS jpf
        INNER JOIN
            skills_job_dim AS skjd ON skjd.job_id = jpf.job_id
        WHERE
            jpf.job_title IN ('Data Analyst', 'Data Scientist')
            AND jpf.job_location IN ('Anywhere', 'Mexico', 'Mexico City', 'Remote')
            AND jpf.salary_year_avg IS NOT NULL
    ),
    ranked_jobs AS (
        SELECT *,
            ROW_NUMBER() OVER (
                PARTITION BY job_title
                ORDER BY salary DESC
            ) AS rank
        FROM jobs_with_skills
    )
    SELECT
        r.rank,
        r.job_id,
        r.job_title,
        c.name AS company_name,
        r.salary,
        STRING_AGG(skd.skills, ', ') AS skill_list 
    FROM
        ranked_jobs AS r
    LEFT JOIN
        company_dim AS c ON r.company_id = c.company_id
    INNER JOIN
        skills_job_dim AS skjd ON skjd.job_id = r.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        r.rank <= 10
    GROUP BY
        r.rank, r.job_id, r.job_title, c.name, r.salary;

