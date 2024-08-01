# five_things

Exploration of the impact of course design and implementation in Canvas and the broader Digital Learning Enviornment (DLE)

## About

* [Kiet's notes](https://docs.google.com/document/d/1nhfdB_JqI3r-_KMNnEofBMfZfM39pfYrDjT-NCXNul4/edit)


## Data Sources
* [Unizin Data Platform](https://git.doit.wisc.edu/lace/tech-team/unizin-data-platform)
* [Teaching and Learning Data Lake](https://git.doit.wisc.edu/lace/tech-team/lace-data-lake)
    * [course_projects table](https://git.doit.wisc.edu/lace/tech-team/lace-data-lake/-/blob/main/docs/courses/course_projects.md) and the [query to load data](queries/get_courses.sql) for this project, with key `2024_07_FIVE_THINGS`

## Example Queries
Get all course offerings for the intial 5 things course exploration

```
select * 
from `doit-at-lace-analytics-1764.courses.course_projects`
where projects = '2024_07_FIVE_THINGS'
```
