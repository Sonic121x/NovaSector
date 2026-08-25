// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
GLOBAL_LIST_INIT(high_priority_sentience, typecacheof(list(
	/mob/living/basic/bat,
	/mob/living/basic/butterfly,
	/mob/living/basic/carp/pet/cayenne,
	/mob/living/basic/chicken,
	/mob/living/basic/crab,
	/mob/living/basic/cow,
	/mob/living/basic/goat,
	/mob/living/basic/goose/vomit,
	/mob/living/basic/lizard,
	/mob/living/basic/mouse/brown/tom,
	/mob/living/basic/parrot,
	/mob/living/basic/pet,
	/mob/living/basic/pig,
	/mob/living/basic/rabbit,
	/mob/living/basic/sheep,
	/mob/living/basic/sloth,
	/mob/living/basic/snake,
	/mob/living/basic/spider/giant/sgt_araneus,
	/mob/living/basic/bot/secbot/beepsky,
	/mob/living/basic/bear/snow/misha,
	/mob/living/basic/mining/lobstrosity/juvenile,
)))

/datum/round_event_control/sentience
	name = "Random Human-level Intelligence"
	typepath = /datum/round_event/ghost_role/sentience
	weight = 10
	category = EVENT_CATEGORY_FRIENDLY
	description = "An animal or robot becomes sentient!"
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 7


/datum/round_event/ghost_role/sentience
	minimum_required = 1
	role_name = "random animal"
	var/animals = 1
	var/one = "one"
	fakeable = TRUE

/datum/round_event/ghost_role/sentience/announce(fake)
	var/sentience_report = ""

	var/data = pick("scans from our long-range sensors", "our sophisticated probabilistic models", "our omnipotence", "the communications traffic on your station", "energy emissions we detected", "\[REDACTED\]")
	var/pets = pick("animals/bots", "bots/animals", "pets", "simple animals", "lesser lifeforms", "\[REDACTED\]")
	var/strength = pick("human", "moderate", "lizard", "security", "command", "clown", "low", "very low", "\[REDACTED\]")

	var/one_local = one
	// NOVA EDIT ADDITION START - I18N - localize the picked flavor args via local maps; the announcement template is reverse-matched but these args are common words (command/security/human/low) we must keep out of the global reverse/state tables to avoid collisions elsewhere
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		var/static/list/zh_data = list("scans from our long-range sensors" = "来自我们远程传感器的扫描", "our sophisticated probabilistic models" = "我们精密的概率模型", "our omnipotence" = "我们的全知全能", "the communications traffic on your station" = "你们空间站上的通讯流量", "energy emissions we detected" = "我们探测到的能量辐射", "\[REDACTED\]" = "\[已删除\]")
		var/static/list/zh_pets = list("animals/bots" = "动物/机器人", "bots/animals" = "机器人/动物", "pets" = "宠物", "simple animals" = "简单动物", "lesser lifeforms" = "低等生命体", "\[REDACTED\]" = "\[已删除\]")
		var/static/list/zh_strength = list("human" = "人类", "moderate" = "中等", "lizard" = "蜥蜴", "security" = "保安", "command" = "指挥", "clown" = "小丑", "low" = "低等", "very low" = "极低", "\[REDACTED\]" = "\[已删除\]")
		var/static/list/zh_one = list("one" = "一只", "all" = "全部", "both" = "两只")
		data = zh_data[data] || data
		pets = zh_pets[pets] || pets
		strength = zh_strength[strength] || strength
		one_local = zh_one[one] || one
	// NOVA EDIT ADDITION END

	sentience_report += "Based on [data], we believe that [one_local] of the station's [pets] has developed [strength] level intelligence, and the ability to communicate."

	priority_announce(sentience_report,LANG("datum.fe8d8b47948e6395", list(command_name())))

/datum/round_event/ghost_role/sentience/spawn_role()
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghost_candidates(check_jobban = ROLE_SENTIENCE, role = ROLE_SENTIENCE, alert_pic = /obj/item/slimepotion/sentience, role_name_text = role_name)
	if(!length(candidates))
		return NOT_ENOUGH_PLAYERS

	// find our chosen mob to breathe life into
	// Mobs have to be simple animals, mindless, on station, and NOT holograms.
	// prioritize starter animals that people will recognise


	var/list/potential = list()

	var/list/hi_pri = list()
	var/list/low_pri = list()

	for(var/mob/living/simple_animal/check_mob in GLOB.alive_mob_list)
		set_mob_priority(check_mob, hi_pri, low_pri)
	for(var/mob/living/basic/check_mob in GLOB.alive_mob_list)
		set_mob_priority(check_mob, hi_pri, low_pri)

	shuffle_inplace(hi_pri)
	shuffle_inplace(low_pri)

	potential = hi_pri + low_pri

	if(!potential.len)
		return WAITING_FOR_SOMETHING
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/spawned_animals = 0
	while(spawned_animals < animals && candidates.len && potential.len)
		var/mob/living/selected = popleft(potential)
		var/mob/dead/observer/picked_candidate = pick_n_take(candidates)

		spawned_animals++

		selected.PossessByPlayer(picked_candidate.key)

		selected.grant_all_languages(UNDERSTOOD_LANGUAGE, grant_omnitongue = FALSE, source = LANGUAGE_ATOM)

		if (isanimal(selected))
			var/mob/living/simple_animal/animal_selected = selected
			animal_selected.sentience_act()
			animal_selected.del_on_death = FALSE
		else if	(isbasicmob(selected))
			var/mob/living/basic/animal_selected = selected
			animal_selected.basic_mob_flags &= ~DEL_ON_DEATH

		selected.maxHealth = max(selected.maxHealth, 200)
		selected.health = selected.maxHealth
		spawned_mobs += selected

		to_chat(selected, span_userdanger(LANG("datum.793c10bc0b28c378", null)))
		to_chat(selected, span_warning(LANG("datum.41dd5958e2032c95", null)))

	return SUCCESSFUL_SPAWN

/// Adds a mob to either the high or low priority event list
/datum/round_event/ghost_role/sentience/proc/set_mob_priority(mob/living/checked_mob, list/high, list/low)
	var/turf/mob_turf = get_turf(checked_mob)
	if(!mob_turf || !is_station_level(mob_turf.z))
		return
	if((checked_mob in GLOB.player_list) || checked_mob.mind || (checked_mob.flags_1 & HOLOGRAM_1))
		return
	if(is_type_in_typecache(checked_mob, GLOB.high_priority_sentience))
		high += checked_mob
	else
		low += checked_mob

/datum/round_event_control/sentience/all
	name = "Station-wide Human-level Intelligence"
	typepath = /datum/round_event/ghost_role/sentience/all
	weight = 0
	category = EVENT_CATEGORY_FRIENDLY
	description = "ALL animals and robots become sentient, provided there is enough ghosts."

/datum/round_event/ghost_role/sentience/all
	one = "all"
	animals = INFINITY // as many as there are ghosts and animals
	// cockroach pride, station wide
