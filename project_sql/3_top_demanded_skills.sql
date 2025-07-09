/*¨
Question:

What skills are the most demanded skills for Data Analysts and Data Scientists?
- Joined job_postings_fact, skills_job_dim, and skills_dim tables similar to query 2
- Identify the top 5 most demanded skills for Data Analysts and Data Scientists.
- Focus on all job postings, irrespective of salary or location.
- Why? Retrieves the top 5 skills with the highest demand in the market for Data Analysts and Data Scientists,
 providing insights into the skills that are most sought after by employers.

*/
WITH ranked_skills as(
    SELECT
        jp.job_title_short as job_title,
        skd.skills as skill_name,
        COUNT(jp.job_id) AS job_count,
        RANK() 
            OVER (PARTITION BY jp.job_title_short 
            ORDER BY COUNT(jp.job_id) DESC) AS skill_rank
    FROM
        job_postings_fact AS jp
    INNER JOIN
        skills_job_dim AS skjd ON jp.job_id = skjd.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        jp.job_title_short IN ('Data Analyst', 'Data Scientist')
    GROUP BY
        jp.job_title_short,
        skd.skills
    ORDER BY
        jp.job_title_short, job_count DESC)
        
    SELECT *
    FROM
        ranked_skills
    WHERE
        skill_rank <= 5;