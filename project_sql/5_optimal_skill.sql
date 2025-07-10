/*¨
Question:

What are the most optimal skills to learn for Data Analysts and Data Scientists based on demand from companies and salary expectations?
- Identify skills high in demand and associated with high salaries for Data Analysts and Data Scientists. 
  We are going to separate the analysis for both roles.
- Focus on roles with specified salaries, and positions located in Mexico City, Mexico or remote roles.
 - Why? It is important to identify which skills offer the most job security (high demand) and offer the best economic 
   return (high salary) for Data Analysts and Data Scientists, helping job seekers prioritize their learning and career development.

*/

WITH skills_demand as(
    SELECT
        skd.skill_id,
        skills,
        Count(skjd.job_id) AS demand_count
    FROM
        job_postings_fact AS jp
    INNER JOIN
        skills_job_dim AS skjd ON jp.job_id = skjd.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        jp.job_title_short = 'Data Analyst'
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_work_from_home = TRUE
    GROUP BY
        skd.skill_id, skd.skills
    ORDER BY
        demand_count DESC
),
average_salary as(
    SELECT
        skd.skill_id,
        skd.skills,
        ROUND(AVG(jp.salary_year_avg),0) AS avg_salary
    FROM
        job_postings_fact AS jp
    INNER JOIN
        skills_job_dim AS skjd ON jp.job_id = skjd.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        jp.job_title_short = 'Data Analyst'
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_work_from_home = TRUE
    GROUP BY
        skd.skill_id, skd.skills
    ORDER BY
        avg_salary DESC
),
top_paying_skills_results as (
SELECT
    sd.skill_id,
    sd.skills as skill_name,
    sd.demand_count,
    avgs.avg_salary
FROM
    skills_demand AS sd
INNER JOIN
    average_salary AS avgs ON sd.skill_id = avgs.skill_id
ORDER BY
    sd.skill_id
)
SELECT 
    skill_name,
    demand_count,
    avg_salary,
    ROUND((avg_salary * LOG(GREATEST(demand_count, 1)))::numeric, 2) AS demand_weighted_score
FROM 
    top_paying_skills_results
ORDER BY 
    demand_weighted_score DESC
LIMIT 10
;


-- Same exercise for Data Scientist

WITH skills_demand as(
    SELECT
        skd.skill_id,
        skills,
        Count(skjd.job_id) AS demand_count
    FROM
        job_postings_fact AS jp
    INNER JOIN
        skills_job_dim AS skjd ON jp.job_id = skjd.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        jp.job_title_short = 'Data Scientist'
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_work_from_home = TRUE
    GROUP BY
        skd.skill_id, skd.skills
    ORDER BY
        demand_count DESC
),
average_salary as(
    SELECT
        skd.skill_id,
        skd.skills,
        ROUND(AVG(jp.salary_year_avg),0) AS avg_salary
    FROM
        job_postings_fact AS jp
    INNER JOIN
        skills_job_dim AS skjd ON jp.job_id = skjd.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        jp.job_title_short = 'Data Scientist'
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_work_from_home = TRUE
    GROUP BY
        skd.skill_id, skd.skills
    ORDER BY
        avg_salary DESC
),
top_paying_skills_results as (
SELECT
    sd.skill_id,
    sd.skills as skill_name,
    sd.demand_count,
    avgs.avg_salary
FROM
    skills_demand AS sd
INNER JOIN
    average_salary AS avgs ON sd.skill_id = avgs.skill_id
ORDER BY
    sd.skill_id
)
SELECT 
    skill_name,
    demand_count,
    avg_salary,
    ROUND((avg_salary * LOG(GREATEST(demand_count, 1)))::numeric, 2) AS demand_weighted_score
FROM 
    top_paying_skills_results
ORDER BY 
    demand_weighted_score DESC
LIMIT 10
;