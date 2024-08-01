delete from `courses.course_projects` where projects = '2024_07_FIVE_THINGS';

insert into `courses.course_projects`
select REGEXP_EXTRACT(course_keymap.sis_ext_id, r'\d{6}') as course_number
  , course_keymap.id as udp_course_offering_id
  , course_keymap.sis_ext_id as udp_sis_ext_id
  , course.academic_term_id as udp_term_id
  , course_status.num_students
  , '2024_07_FIVE_THINGS'
     from `udp-wisc-prod.context_store_keymap.course_offering` course_keymap
      inner join `udp-wisc-prod.context_store_entity.course_offering` course
        on course_keymap.id = course.course_offering_id
      inner join `ops_tool_usage.udp_account_tree` acct
        on course.learning_environment_organization_id = acct.second_level_id
      inner join `udp-wisc-prod.mart_course_offering.status` course_status
        on course_status.udp_course_offering_id = course.course_offering_id
    --Limit to timetable courses only based on the Course Guide sub account
    where acct.account_id = 333
    --Limit to the 6 most recent terms (Summer 2022 through Spring 2024)
    and course.academic_term_id in (37,36,35,34,33,32)
    --Limit to courses loaded by the CSI Course Load Process
    and sis_ext_id is not null
    --Course Shell is published (they are using canvas)
    and course_status.status in ('available','completed')
    --Randomly select some course numbers (the center of the SIS ID) based on critiera
    and REGEXP_EXTRACT(course_keymap.sis_ext_id, r'\d{6}') in (
        select 
          distinct REGEXP_EXTRACT(course_keymap.sis_ext_id, r'\d{6}') as course_number
        from `udp-wisc-prod.context_store_keymap.course_offering` course_keymap
          inner join `udp-wisc-prod.context_store_entity.course_offering` course
            on course_keymap.id = course.course_offering_id
          inner join `ops_tool_usage.udp_account_tree` acct
            on course.learning_environment_organization_id = acct.second_level_id
          inner join `udp-wisc-prod.mart_course_offering.status` course_status
            on course_status.udp_course_offering_id = course.course_offering_id
        --Limit to timetable courses only based on the Course Guide sub account
        where acct.account_id = 333
        --Select course numbers that had a course offering in Fall 2022
        and course.academic_term_id =33
        --Limit to courses loaded by the CSI Course Load Process
        and sis_ext_id is not null
        --Course Shell is published (they are using canvas)
        and course_status.status in ('available','completed')
        --Randomly select 1% of the results (to get about 50 course numbers)
        and rand() < 0.01
      )
order by course_number, udp_sis_ext_id
