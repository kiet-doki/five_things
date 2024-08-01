/*
queries related to the summer 2024 5 things work 
there are multiple queries below, each must be run separately in GCP
*/


--query to get course assignment data - looking at only assignments that were published to the students
--this does not give any information on the student or whether the assignments were actually completed 
--only includes the metadata about the assignmnets in the course
select distinct
course_number, 
udp_course_offering_id, 
udp_sis_ext_id,
sis_id,
cco.title, 
udp_term_id, 
num_students,
learner_activity_id,
all_day_date, 
allowable_submission_types, 
created_date, 
description, 
drop_rule, 
due_date, 
grade_type, 
has_peer_reviews, 
has_peer_reviews_assigned, 
is_all_day, 
is_anonymous_peer_reviews, 
is_automatic_peer_reviews, 
is_grade_group_students_individually, 
is_hidden, 
is_lockable, 
locked_date, 
peer_review_count, 
peer_reviews_due_date, 
points_possible, 
position, 
status, 
title, 
unlocked_date, 
updated_date, 
visibility

from `doit-at-lace-analytics-1764.courses.course_projects` rand_course
left join `udp-wisc-prod.context_store_entity.learner_activity` la
on rand_course.udp_course_offering_id = la.course_offering_id
left join `udp-wisc-prod.mart_helper.context__course_offering` cco
on cco.course_offering_id=rand_course.udp_course_offering_id

where projects = '2024_07_FIVE_THINGS'
--limit to only the assignments that were actually published
and status='published'
--saved as a view titled assignments_2024_07


--query for metadata on discussions
--this will show discussion boards that may have been deleted
--does not show interaction informaiton
select * 
from `doit-at-lace-analytics-1764.courses.course_projects` rand_course
left join `udp-wisc-prod.context_store_entity.discussion` d
on d.course_offering_id=rand_course.udp_course_offering_id
where projects = '2024_07_FIVE_THINGS'
--saved as discussions_2024_07



--query for metadata on files
--does not show interaction informaiton
select distinct file_id,
rand_course.udp_course_offering_id,
course_number, udp_sis_ext_id, udp_term_id,
quiz_id, root_file_id, wiki_id, can_be_locked, content_type, created_date, deleted_date, display_name, is_locked, locked_date,  owner_entity_type, size, status, unlocked_date, updated_date
from `doit-at-lace-analytics-1764.courses.course_projects` rand_course
left join `udp-wisc-prod.context_store_entity.file` f
on f.course_offering_id=rand_course.udp_course_offering_id
where projects = '2024_07_FIVE_THINGS'
--saved as files_2024_07


--query for metadata on quizzes
--does not show interaction informaiton
select distinct q.quiz_id,
rand_course.udp_course_offering_id,
allowed_attempts,
correct_answers_display_policy, q.created_date as quiz_created_date, deleted_date, description, due_date, hide_correct_answers_date, ip_filter, is_allow_anonymous_submissions, is_allow_go_back_to_previous_question, is_browser_lockdown_monitor_required, is_browser_lockdown_required, is_browser_lockdown_required_to_display_results, is_can_be_locked, is_display_multiple_questions, is_shuffled_answer_display_order, locked_date, q.points_possible as quiz_points_possible, q.published_date as quiz_published_date, quiz_item_count, scoring_policy, show_correct_answers_date, show_results, q.status as quiz_status, time_limit, title, type, unlocked_date, unpublished_quiz_item_count, q.updated_date as quiz_updated_date,
qi.quiz_item_group_id, body, correct_comments, qi.created_date as quiz_item_created_date, incorrect_comments, is_regrade_option_available, qi.name as quiz_item_name, neutral_comments, qi.points_possible as quiz_item_points_possible, qi.position as quiz_item_position, quiz_item_type, qi.status as quiz_item_status, qi.updated_date as quiz_item_updated_date, qig.created_date as quiz_item_group_created_date, qig.name as quiz_item_group_name, pick_count, qig.position as quiz_item_group_position, qig.quiz_item_points as quiz_item_group_point, qig.updated_date as quiz_item_group_updated_date

from `doit-at-lace-analytics-1764.courses.course_projects` rand_course

left join `udp-wisc-prod.context_store_entity.quiz` q
on q.course_offering_id=rand_course.udp_course_offering_id
left join `udp-wisc-prod.context_store_entity.quiz_item` qi
on qi.quiz_id=q.quiz_id
left join `udp-wisc-prod.context_store_entity.quiz_item_group` qig
on qi.quiz_item_group_id=qig.quiz_item_group_id

where projects = '2024_07_FIVE_THINGS'
--saved as quizzes_2024_07


--query to pull metadata on canvas pages
--does not show interaction informaiton
select distinct wiki_page_id,
rand_course.udp_course_offering_id,
wiki_id, body, comments_count, could_be_locked, created_date, editing_roles, is_protected_editing, revised_date, status, title, updated_date, url, view_count

from `doit-at-lace-analytics-1764.courses.course_projects` rand_course

left join `udp-wisc-prod.mart_general.lms_tool` lms
on lms.udp_course_offering_id=rand_course.udp_course_offering_id
left join `udp-wisc-prod.context_store_keymap.wiki_page` as kwp
on case when lms.canvas_tool = 'Wiki page' then lms.asset_type_id end = kwp.lms_int_id
left join `udp-wisc-prod.context_store_entity.wiki_page` as wp
on kwp.id = wp.wiki_page_id

where projects = '2024_07_FIVE_THINGS'
--saved as pages_2024_07


--query to get you module metadata
select rc.udp_course_offering_id,
m.module_id, prerequisite_module_id, m.created_date, deleted_date, name, m.position as module_position, sequential, m.status as module_status, m.unlocked_date as module_unlocked_date, m.updated_date as module_updated_date, discussion_id, file_id, learner_activity_id, mi.module_item_id, quiz_id, wiki_page_id, completion_type, mi.created_date as module_item_created_date, mi.min_score, mi.position as module_item_position, mi.status as module_item_status, title, type, mi.updated_date as module_item_updated_date, url, module_item_completion_id, module_progression_id, completion_status, mic.min_score as module_completion_min_score, requirement_type, score

from `doit-at-lace-analytics-1764.courses.course_projects` rc
left join `udp-wisc-prod.context_store_entity.module` m
on m.course_offering_id=rc.udp_course_offering_id
left join `udp-wisc-prod.context_store_entity.module_item` mi
on mi.course_offering_id=rc.udp_course_offering_id
and mi.module_id=m.module_id
left join `udp-wisc-prod.context_store_entity.module_item_completion` mic
on mic.module_item_id=mi.module_item_id
--saved as module_2024_07



--query to show lms data interactions, i.e. when student X clicked on page Y
--does not give you metadata about the lms tool, just basically title and ID
--use one of the queries below to get metadata on the different tools
--this was not limited to students only, may way to do that in analysis
select
rc.udp_course_offering_id,
lms_course_offering_id,
udp_person_id,
lms_person_id,
role,
academic_term_name,
event_time,
canvas_tool,
asset_type,
asset_type_id,
asset_subtype,
asset_subtype_id,
kla.id as udp_learner_activity_id,
kd.id as udp_discussion_id,
kf.id as udp_file_id,
kmi.id as udp_module_item_id,
kq.id as udp_quiz_id,
kwp.id as udp_wiki_page_id,
la.title as learner_activity_title,
d.title as discussion_title,
f.display_name as file_display_name,
mi.title as module_item_title,
q.title as quiz_title,
wp.title as wiki_page_title,
 IfNull(lms.course_offering_start_date, lms.academic_term_start_date) as effective_course_start_date
from `doit-at-lace-analytics-1764.courses.course_projects` rc
left join `udp-wisc-prod.mart_general.lms_tool` lms
on lms.udp_course_offering_id=rc.udp_course_offering_id
left join `udp-wisc-prod.context_store_keymap.learner_activity` as kla
on case when lms.canvas_tool = 'Learner activity' then lms.asset_type_id end = kla.lms_int_id
left join `udp-wisc-prod.context_store_entity.learner_activity` as la
on kla.id = la.learner_activity_id
left join `udp-wisc-prod.context_store_keymap.discussion` as kd
on case when lms.canvas_tool = 'Discussion' then lms.asset_type_id end = kd.lms_int_id
left join `udp-wisc-prod.context_store_entity.discussion` as d
on kd.id = d.discussion_id
left join `udp-wisc-prod.context_store_keymap.file` as kf
on case when lms.canvas_tool = 'File' then lms.asset_type_id end = kf.lms_int_id
left join `udp-wisc-prod.context_store_entity.file` as f
on kf.id = f.file_id
left join `udp-wisc-prod.context_store_keymap.module_item` as kmi
on case when lms.canvas_tool = 'Module item' then lms.asset_type_id end = kmi.lms_int_id
left join `udp-wisc-prod.context_store_entity.module_item` as mi
on kmi.id = mi.module_item_id
left join `udp-wisc-prod.context_store_keymap.quiz` as kq
on case when lms.canvas_tool = 'Quiz' then lms.asset_type_id end = kq.lms_int_id
left join `udp-wisc-prod.context_store_entity.quiz` as q
on kq.id = q.quiz_id
left join `udp-wisc-prod.context_store_keymap.wiki_page` as kwp
on case when lms.canvas_tool = 'Wiki page' then lms.asset_type_id end = kwp.lms_int_id
left join `udp-wisc-prod.context_store_entity.wiki_page` as wp
on kwp.id = wp.wiki_page_id
where lms.event_time >= '2021-01-01'
and lms.asset_type is distinct from 'context_external_tool'
and projects = '2024_07_FIVE_THINGS'
--saved as lms_tool_data_2024_07


--query to pull interaction data on lti tools
select
rc.udp_course_offering_id,
lms_course_offering_id,
udp_person_id,
lms_person_id,
role,
academic_term_name,
event_time,
lti.launch_app_url,
lti.launch_app_domain,
lti.launch_app_name,
lti.tool_name,
lti.is_lti_tool, 
lti.is_redirect_tool,
 IfNull(lms.course_offering_start_date, lms.academic_term_start_date) as effective_course_start_date
from `doit-at-lace-analytics-1764.courses.course_projects` rc
left join `udp-wisc-prod.mart_general.lti_tool` lti
on lti.udp_course_offering_id=rc.udp_course_offering_id
where event_time >= '2021-01-01'
and projects = '2024_07_FIVE_THINGS'
and role='Learner'
--saved as lti_tool_data_2024_07


--query to pull SCID information
select rand_course.udp_course_offering_id, 
course_number, 
udp_sis_ext_id, 
udp_term_id,
academic_term_name, 
num_students, 
course_offering_title,
parent_learning_environment_organization_id,
parent_learning_environment_organization,
sub_learning_environment_organization_2,
sub_learning_environment_organization_3
from `doit-at-lace-analytics-1764.courses.course_projects` rand_course
left join `udp-wisc-prod.mart_course_offering.learning_environment_organization` leo
on rand_course.udp_course_offering_id=leo.udp_course_offering_id

where projects = '2024_07_FIVE_THINGS'
--saved as scid_2024_07 in bigquery
