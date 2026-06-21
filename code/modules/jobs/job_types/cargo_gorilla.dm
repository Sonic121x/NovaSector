/datum/job/cargo_gorilla
	title = JOB_CARGO_GORILLA
	description = "协助供应部门搬运货物和处理不需要的水果。"
	faction = FACTION_STATION
	total_positions = 0
	spawn_positions = 0
	supervisors = SUPERVISOR_QM
	spawn_type = /mob/living/basic/gorilla/cargorilla
	config_tag = "CARGO_GORILLA"
	random_spawns_possible = FALSE
	display_order = JOB_DISPLAY_ORDER_CARGO_GORILLA
	departments_list = list(/datum/job_department/cargo)
	mail_goodies = list(
		/obj/item/food/grown/banana = 1,
	)
	rpg_title = "Beast of Burden"
	allow_bureaucratic_error = FALSE
	job_flags = STATION_TRAIT_JOB_FLAGS | JOB_ANNOUNCE_ARRIVAL | JOB_NEW_PLAYER_JOINABLE | JOB_EQUIP_RANK |JOB_ANTAG_BLACKLISTED

/datum/job/cargo_gorilla/get_roundstart_spawn_point()
	if (length(GLOB.gorilla_start))
		return pick(GLOB.gorilla_start)
	return ..()

/datum/job/cargo_gorilla/get_spawn_mob(client/player_client, atom/spawn_point)
	if (!player_client)
		return
	var/mob/living/the_big_man = new spawn_type(get_turf(spawn_point))
	the_big_man.fully_replace_character_name(the_big_man.real_name, pick(GLOB.cargorilla_names))
	return the_big_man

/datum/job/cargo_gorilla/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	// Gorilla with a wage, what's he buyin?
	var/datum/bank_account/bank_account = new(spawned.real_name, src)
	bank_account.payday(STARTING_PAYCHECKS, free = TRUE)
	bank_account.replaceable = FALSE
	spawned.add_mob_memory(/datum/memory/key/account, remembered_id = bank_account.account_id)

	var/obj/item/card/id/advanced/cargo_gorilla/gorilla_id = new(spawned.loc)
	gorilla_id.registered_name = spawned.name
	gorilla_id.update_label()
	gorilla_id.registered_account = bank_account
	bank_account.bank_cards += gorilla_id
	spawned.put_in_hands(gorilla_id, del_on_fail = TRUE)

	to_chat(spawned, span_boldnotice("你是货运大猩猩，空间站的和平之友，货物的搬运工。"))
	to_chat(spawned, span_notice("你可以通过点击板条箱来拾取它们，并通过点击地面来放下它们。"))
	LAZYADD(spawned.mind.special_roles, "Cargorilla")
