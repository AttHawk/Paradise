/datum/job/ai
	title = "AI"
	flag = JOB_AI
	department_flag = JOBCAT_ENGSEC
	total_positions = 0 // Not used for AI, see is_position_available below and modules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1
	selection_color = "#ccffcc"
	supervisors = "your laws"
	department_head = list("Captain")
	req_admin_notify = 1
	minimal_player_age = 30
	exp_requirements = 3000
	exp_type = EXP_TYPE_SILICON

/datum/job/ai/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

/datum/job/ai/is_position_available()
	return (GLOB.empty_playable_ai_cores.len != 0)


/datum/job/cyborg
	title = "Cyborg"
	flag = JOB_CYBORG
	department_flag = JOBCAT_ENGSEC
	total_positions = 2
	spawn_positions = 2
	supervisors = "your laws and the AI"	//Nodrak
	department_head = list("AI")
	selection_color = "#ddffdd"
	minimal_player_age = 21
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW
	alt_titles = list("Robot")

/datum/job/cyborg/equip(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/mob/living/silicon/robot/new_robot = H.Robotize()
	if(new_robot)
		SSticker?.score?.save_silicon_laws(new_robot, additional_info = "job assignment", log_all_laws = TRUE)
	return new_robot
