/obj/effect/mob_spawn/ghost_role/robot
	name = "幽灵角色机器人"
	prompt_name = "一个机械人"
	you_are_text = "你是一个机械人。这大概不该发生。"
	flavour_text = "你是一个机械人。这大概不该发生。"
	mob_type = /mob/living/silicon/robot

/obj/effect/mob_spawn/ghost_role/robot/ghostcafe
	name = "咖啡馆机器人存储舱"
	prompt_name = "一个幽灵咖啡馆机械人"
	infinite_use = TRUE
	deletes_on_zero_uses_left = FALSE
	icon = 'modular_nova/modules/ghostcafe/icons/robot_storage.dmi'
	icon_state = "robostorage"
	anchored = TRUE
	density = FALSE
	spawner_job_path = /datum/job/ghostcafe
	you_are_text = "你是一个咖啡馆机械人！"
	flavour_text = "谁能想到呢？这家超棒的本地咖啡馆也欢迎机械人！"
	mob_type = /mob/living/silicon/robot/model/roleplay
	loadout_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/robot/ghostcafe/special(mob/living/silicon/robot/spawned_robot, mob/mob_possessor, apply_prefs)
	. = ..()
	if(spawned_robot.client)
		spawned_robot.custom_name = null
		spawned_robot.updatename(spawned_robot.client)
		spawned_robot.transfer_silicon_prefs(spawned_robot.client)
		spawned_robot.gender = NEUTER
		var/area/A = get_area(src)
		//spawned_robot.AddElement(/datum/element/ghost_role_eligibility, free_ghosting = TRUE) SKYRAT PORT -- Needs to be completely rewritten
		spawned_robot.AddElement(/datum/element/dusts_on_catatonia)
		spawned_robot.AddElement(/datum/element/dusts_on_leaving_area, list(A.type) + GLOB.ghost_cafe_areas)
		spawned_robot.RegisterSignal(spawned_robot, COMSIG_MOVABLE_USING_RADIO, TYPE_PROC_REF(/mob/living, on_using_radio))
		ADD_TRAIT(spawned_robot, TRAIT_SIXTHSENSE, TRAIT_GHOSTROLE)
		ADD_TRAIT(spawned_robot, TRAIT_FREE_GHOST, TRAIT_GHOSTROLE)
		to_chat(spawned_robot,span_warning("<b>幽灵化是免费的！</b>"))
		var/datum/action/toggle_dead_chat_mob/D = new(spawned_robot)
		D.Grant(spawned_robot)

/obj/effect/mob_spawn/ghost_role/human/ghostcafe
	name = "咖啡馆休眠舱"
	prompt_name = "一个幽灵咖啡馆人类"
	infinite_use = TRUE
	deletes_on_zero_uses_left = FALSE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	density = FALSE
	spawner_job_path = /datum/job/ghostcafe
	outfit = /datum/outfit/ghostcafe
	you_are_text = "你是一位咖啡馆访客！"
	flavour_text = "你正在休假，决定去你最喜欢的咖啡馆坐坐。好好享受吧。"
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	loadout_enabled = TRUE
	quirks_enabled = TRUE

/obj/effect/mob_spawn/ghost_role/human/ghostcafe/special(mob/living/spawned_human, mob/mob_possessor, apply_prefs)
	. = ..()
	if(spawned_human.client)
		var/area/A = get_area(src)
		spawned_human.AddElement(/datum/element/dusts_on_catatonia)
		spawned_human.AddElement(/datum/element/dusts_on_leaving_area, list(A.type) + GLOB.ghost_cafe_areas)
		spawned_human.RegisterSignal(spawned_human, COMSIG_MOVABLE_USING_RADIO, TYPE_PROC_REF(/mob/living, on_using_radio))
		ADD_TRAIT(spawned_human, TRAIT_SIXTHSENSE, TRAIT_GHOSTROLE)
		ADD_TRAIT(spawned_human, TRAIT_FREE_GHOST, TRAIT_GHOSTROLE)
		ADD_TRAIT(spawned_human, TRAIT_NOBREATH, TRAIT_GHOSTROLE)
		to_chat(spawned_human,span_warning("<b>鬼魂化是免费的！</b>"))
		var/datum/action/toggle_dead_chat_mob/dchat_toggle_ability = new(spawned_human)
		dchat_toggle_ability.Grant(spawned_human)

/mob/living/proc/on_using_radio(atom/movable/talking_movable)
	SIGNAL_HANDLER

	var/area/target_area = get_area(talking_movable)
	if(target_area.type in GLOB.ghost_cafe_areas)
		return COMPONENT_CANNOT_USE_RADIO

/datum/outfit/ghostcafe
	name = "咖啡馆访客"
	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = /obj/item/card/id/advanced/chameleon/ghost_cafe
	back = /obj/item/storage/backpack/chameleon
	backpack_contents = list(/obj/item/storage/box/syndie_kit/chameleon/ghostcafe = 1)

/datum/outfit/ghostcafe/pre_equip(mob/living/carbon/human/visitor, visuals_only = FALSE)
	..()
	if (isplasmaman(visitor))
		backpack_contents += list(/obj/item/tank/internals/plasmaman/belt/full = 2)
	if(isvox(visitor) || isvoxprimalis(visitor))
		backpack_contents += list(/obj/item/tank/internals/nitrogen/belt/full = 2)

/datum/action/toggle_dead_chat_mob
	button_icon = 'icons/mob/simple/mob.dmi'
	button_icon_state = "ghost"
	name = "切换死者聊天"
	desc = "开启或关闭你听取鬼魂声音的能力。"

/datum/action/toggle_dead_chat_mob/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/mob/M = target
	if(HAS_TRAIT_FROM(M,TRAIT_SIXTHSENSE,TRAIT_GHOSTROLE))
		REMOVE_TRAIT(M,TRAIT_SIXTHSENSE,TRAIT_GHOSTROLE)
		to_chat(M,span_notice("你不再能听到死者聊天了。"))
	else
		ADD_TRAIT(M,TRAIT_SIXTHSENSE,TRAIT_GHOSTROLE)
		to_chat(M,span_notice("你又能听到死者聊天了。"))

/obj/item/storage/box/syndie_kit/chameleon/ghostcafe
	name = "咖啡馆装扮套件"
	desc = "看起来就像你生前的样子——或者更好！"
	icon_state = "ghostcostuming"
	storage_type = /datum/storage/chameleon_cafe

/datum/storage/chameleon_cafe
	max_specific_storage = WEIGHT_CLASS_HUGE // This is ghost cafe only, balance is not given a shit about.
	max_slots = 14 // Holds all the starting stuff, plus a bit of change.
	max_total_storage = 50 // To actually acommodate the stuff being added.

/obj/item/storage/box/syndie_kit/chameleon/ghostcafe/PopulateContents() // Doesn't contain a PDA, for isolation reasons.
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/clothing/neck/chameleon(src)
	new /obj/item/storage/belt/chameleon(src)
	new /obj/item/hhmirror/syndie(src)

/obj/item/card/id/advanced/chameleon/ghost_cafe
	name = "\improper 咖啡馆ID卡"
	desc = "一张用于在咖啡馆内提供身份证明和确定权限的卡片。"
	icon_state = "card_grey"
	assigned_icon_state = null
	registered_age = null
	trim = /datum/id_trim/admin/ghost_cafe
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/datum/id_trim/admin/ghost_cafe
	assignment = "Cafe Visitor"
	trim_icon = 'modular_nova/master_files/icons/obj/card.dmi'
	trim_state = "trim_cafe"
	department_color = COLOR_PALE_GREEN
	subdepartment_color = COLOR_PALE_GREEN
