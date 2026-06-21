/obj/item/choice_beacon/job_locker
	name = "职业储物柜信标"
	desc = "一个能召唤装有某职业物品储物柜的信标，还有什么好说的呢。"
	company_source = "Nanotrasen"
	var/locker_path = list()

/obj/item/choice_beacon/job_locker/generate_display_names()
	if(!locker_path)
		return
	var/locker_list = list()
	for(var/obj/structure/closet/secure_closet/path as anything in locker_path)
		locker_list[initial(path.name)] = path
	return locker_list

/obj/item/choice_beacon/job_locker/debug
	name = "调试职业储物柜信标"
	company_source = /obj/item/choice_beacon::company_source

/obj/item/choice_beacon/job_locker/debug/generate_display_names()
	var/locker_list = list()
	for(var/obj/structure/closet/secure_closet/path as anything in subtypesof(/obj/structure/closet/secure_closet))
		locker_list[initial(path.name)] = path
	return locker_list
