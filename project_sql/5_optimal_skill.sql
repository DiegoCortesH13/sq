/*¨
Question:

What are the most optimal skills to learn for Data Analysts and Data Scientists based on demand from companies and salary expectations?
- Identify skills high in demand and associated with high salaries for Data Analysts and Data Scientists. 
- Focus on roles with specified salaries, and positions located in Mexico City, Mexico or remote roles.
- Why? It is important to identify which skills offer the most job security (high demand) and offer the best economic 
   return (high salary) for Data Analysts and Data Scientists, helping job seekers prioritize their learning and career development.

*/



---- Both roles together
WITH skills_demand AS (
    SELECT
        skd.skill_id,
        skd.skills,
        jp.job_title_short,
        COUNT(skjd.job_id) AS demand_count
    FROM
        job_postings_fact AS jp
    INNER JOIN
        skills_job_dim AS skjd ON jp.job_id = skjd.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        jp.job_title_short IN ('Data Analyst', 'Data Scientist')
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_work_from_home = TRUE
    GROUP BY
        skd.skill_id, skd.skills, jp.job_title_short
    ),
    average_salary AS (
    SELECT
        skd.skill_id,
        skd.skills,
        jp.job_title_short,
        ROUND(AVG(jp.salary_year_avg), 0) AS avg_salary
    FROM
        job_postings_fact AS jp
    INNER JOIN
        skills_job_dim AS skjd ON jp.job_id = skjd.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        jp.job_title_short IN ('Data Analyst', 'Data Scientist')
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_work_from_home = TRUE
    GROUP BY
        skd.skill_id, skd.skills, jp.job_title_short
    ),
    top_paying_skills_results AS (
    SELECT
        sd.skill_id,
        sd.skills AS skill_name,
        sd.demand_count,
        avgs.avg_salary,
        sd.job_title_short
    FROM
        skills_demand AS sd
    INNER JOIN
        average_salary AS avgs 
        ON sd.skill_id = avgs.skill_id AND sd.job_title_short = avgs.job_title_short
    ),
    scored_skills AS (
    SELECT 
        job_title_short,
        skill_name,
        demand_count,
        avg_salary,
        ROUND((avg_salary * LOG(GREATEST(demand_count, 1)))::numeric, 2) AS demand_weighted_score
    FROM 
        top_paying_skills_results
    )
    SELECT *
    FROM (
        SELECT 
            ROW_NUMBER() OVER (PARTITION BY job_title_short ORDER BY demand_weighted_score DESC) AS rank,
            *
        FROM 
            scored_skills
    ) ranked
    WHERE rank <= 10
    ORDER BY job_title_short, demand_weighted_score DESC
    ;
