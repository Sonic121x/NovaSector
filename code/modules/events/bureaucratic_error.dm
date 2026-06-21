/datum/round_event_control/bureaucratic_error
	name = "官僚错误"
	typepath = /datum/round_event/bureaucratic_error
	max_occurrences = 1
	weight = 5
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "随机开放和关闭职位槽位，并更改溢出角色。"

/datum/round_event/bureaucratic_error
	announce_when = 1

/datum/round_event/bureaucratic_error/announce(fake)
	priority_announce("有机资源部门近期的文书错误可能导致某些部门人员短缺，而其他部门人员冗余。", "文书工作失误警报")

/datum/round_event/bureaucratic_error/start()
	var/list/jobs = SSjob.get_valid_overflow_jobs()
	/* NOVA EDIT REMOVAL START - No more locking off jobs
	if(prob(33)) // Only allows latejoining as a single role.
		var/datum/job/overflow = pick_n_take(jobs)
		overflow.spawn_positions = -1
		overflow.total_positions = -1 // Ensures infinite slots as this role. Assistant will still be open for those that cant play it.
		for(var/job in jobs)
			var/datum/job/current = job
			current.total_positions = 0
		return
	*/ // NOVA EDIT REMOVAL END
	// Adds/removes a random amount of job slots from all jobs.
	for(var/datum/job/current as anything in jobs)
		current.total_positions = max(current.total_positions + rand(1,4), 0) // NOVA EDIT - no more locking off jobs - ORIGINAL: current.total_positions = max(current.total_positions + rand(-2,4), 0)
