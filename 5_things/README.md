Data Sources

Unizin Data Platform

Teaching and Learning Data Lake


course_projects table and the query to load data for this project, with key 2024_07_FIVE_THINGS





Example Queries
Get all course offerings for the intial 5 things course exploration

select * 
from `doit-at-lace-analytics-1764.courses.course_projects`
where projects = '2024_07_FIVE_THINGS'
