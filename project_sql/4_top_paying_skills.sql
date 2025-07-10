/*¨
Question:

What skills are the top 5 skills for Data Analysts and Data Scientists based on salary?
- Look at the average salary associated with each skill for Data Analysts and Data Scientists. 
- Focus on roles with specified salaries (remove nulls) regardless of location.
 - Why? It provides insights into the skills that are most valuable in the job market for Data Analysts and Data Scientists,
helping job seekers indentify the skills that can lead to higher salaries and better job opportunities.

*/

WITH job_count_skill AS (
    SELECT 
        jp.job_title_short AS job_title,
        skd.skills AS skill_name,
        COUNT(*) AS job_count,
        ROUND(AVG(jp.salary_year_avg)) AS avg_salary
    FROM
        job_postings_fact AS jp
    INNER JOIN
        skills_job_dim AS skjd ON jp.job_id = skjd.job_id
    INNER JOIN
        skills_dim AS skd ON skjd.skill_id = skd.skill_id
    WHERE
        jp.job_title_short IN ('Data Analyst', 'Data Scientist')
        AND jp.salary_year_avg IS NOT NULL
    GROUP BY
        jp.job_title_short,
        skd.skills

), 
ranked_skills AS (
    SELECT
        RANK() OVER (PARTITION BY job_title ORDER BY avg_salary DESC) AS skill_rank,
        *
    FROM
        job_count_skill
    WHERE
        job_count > 100 -- Ensuring we have enough data points for each skill, ensuring a bit of robustness
)
SELECT
    *
FROM
    ranked_skills
WHERE
    ranked_skills.skill_rank <= 5
;

/*

1. Data Analyst: Highest Paying Skills
Rank	Skill	   Avg Salary	Job Count
1	    Spark	    $113,002	   187
2	   Databricks	$112,881	   102
3	   Snowflake	$111,578	   241
4	    Hadoop	    $110,888	   140
5	    NoSQL	    $108,331	   108

🔹 These are all big data and cloud-oriented tools, indicating that data analysts proficient in distributed 
processing and modern data platforms command higher salaries.


🧠 2. Data Scientist: Highest Paying Skills
   skill_rank       job_title         skill_name  job_count  avg_salary
0           1       Data Scientist     airflow       144      155878
1           2       Data Scientist     bigquery      135      149292
2           3       Data Scientist     looker        186      147538
3           4       Data Scientist         go        316      147466
4           5       Data Scientist    pytorch        564      145989

🔹 Airflow, BigQuery, and PyTorch indicate that high-paying data scientist roles favor:

    Cloud data engineering tools (Airflow, BigQuery)

    ML/deep learning libraries (PyTorch)

    Programming skills in systems languages (Go)

    BI and visualization tools (Looker)


🔑 Common Themes Across Both Roles:

    Modern cloud/data platforms (BigQuery, Snowflake, Databricks) dominate.

    Pipeline and orchestration tools (Airflow, Spark, Hadoop) are key to higher pay.

    Knowledge of scalable systems and NoSQL databases boosts salaries.

    Cross-functional skills in both analytics and engineering yield better compensation.