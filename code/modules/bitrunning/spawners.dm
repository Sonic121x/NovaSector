/obj/effect/mob_spawn/ghost_role/human/virtual_domain
	outfit = /datum/outfit/virtual_pirate
	prompt_name = "一个虚拟域调试实体"
	flavour_text = "你大概不该看到这个，联系程序员！"
	you_are_text = "你根本不该出现在这里。你是怎么让这事发生的？"
	important_text = "比特跑者是一种犯罪行为，也是你的主要威胁。"
	temp_body = TRUE
	///Does this bit-entity get an antag datum with the goal of hunting bitrunners? TRUE by default
	var/antag = TRUE


/obj/effect/mob_spawn/ghost_role/human/virtual_domain/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	var/datum/mind/ghost_mind = mob_possessor.mind
	if(ghost_mind) // Preserves any previous bodies before making the switch
		spawned_mob.AddComponent(/datum/component/temporary_body, ghost_mind, return_on_death = TRUE)

	..()

	if(antag)
		spawned_mob.mind.add_antag_datum(/datum/antagonist/domain_ghost_actor)
		spawned_mob.mind.set_assigned_role(SSjob.get_job_type(/datum/job/bitrunning_glitch))

/// Simulates a ghost role spawn without calling special(), ie a bitrunner spawn instead of a ghost.
/obj/effect/mob_spawn/ghost_role/human/virtual_domain/proc/artificial_spawn(mob/living/runner)
	SEND_SIGNAL(src, COMSIG_BITRUNNER_SPAWNED, runner)

//Beach Bums (Friendly)
/obj/effect/mob_spawn/ghost_role/human/virtual_domain/beach
	prompt_name = "a virtual beach bum"
	name = "虚拟海滩流浪者休眠舱"
	you_are_text = "你，就像，完全是一个虚拟模拟出来的老兄，兄弟。"
	flavour_text = "Ch'yea. You came here, like, on spring break, hopin' to pick up some bangin' hot e-chicks, y'knaw?"
	important_text = "你对比特跑者毫无芥蒂：事实上，你甚至没意识到自己身处模拟之中。"
	outfit = /datum/outfit/beachbum
	spawner_job_path = /datum/job/beach_bum
	antag = FALSE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/human/virtual_domain/beach/lifeguard
	name = "虚拟救生员休眠舱"
	you_are_text = "你是一个充满活力的虚拟救生员！"
	flavour_text = "你的职责是确保没人掉线或被恶意软件之类的东西吞噬。"
	outfit = /datum/outfit/beachbum/lifeguard
	allow_custom_character = NONE

/obj/effect/mob_spawn/ghost_role/human/virtual_domain/beach/lifeguard/special(mob/living/carbon/human/lifeguard, mob/mob_possessor, apply_prefs)
	. = ..()
	lifeguard.gender = FEMALE
	lifeguard.update_body()

/obj/effect/mob_spawn/ghost_role/human/virtual_domain/beach/bartender
	name = "虚拟酒保休眠舱"
	you_are_text = "你是一个虚拟海滩酒保！"
	flavour_text = "你的工作是源源不断地提供虚拟渲染的饮品，并帮助老兄们体验醉酒模拟。"
	outfit = /datum/outfit/spacebartender
	allow_custom_character = ALL

//Skeleton Pirates
/obj/effect/mob_spawn/ghost_role/human/virtual_domain/pirate
	name = "虚拟海盗遗骸"
	desc = "一些无生命的骨头。感觉它们随时都可能活过来！"
	density = FALSE
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	prompt_name = "一个虚拟骷髅海盗"
	you_are_text = "你是一个虚拟海盗。哟嚯！"
	flavour_text = "有个旱鸭子盯上你的财宝了。阻止他们！"

/datum/outfit/virtual_pirate
	name = "虚拟海盗"
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/pirate
	uniform = /obj/item/clothing/under/costume/pirate
	suit = /obj/item/clothing/suit/costume/pirate/armored
	glasses = /obj/item/clothing/glasses/eyepatch
	head = /obj/item/clothing/head/costume/pirate/bandana/armored
	shoes = /obj/item/clothing/shoes/pirate/armored

/obj/effect/mob_spawn/ghost_role/human/virtual_domain/pirate/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.fully_replace_character_name(spawned_mob.real_name, "[pick(strings(PIRATE_NAMES_FILE, "generic_beginnings"))][pick(strings(PIRATE_NAMES_FILE, "generic_endings"))]")

//Syndicate
/obj/effect/mob_spawn/ghost_role/human/virtual_domain/syndie
	name = "虚拟辛迪加休眠舱"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	prompt_name = "一名虚拟辛迪加特工"
	you_are_text = "你是一名虚拟辛迪加特工。"
	flavour_text = "警报大作！我们正遭到登船袭击！"
	outfit = /datum/outfit/virtual_syndicate
	spawner_job_path = /datum/job/space_syndicate

/datum/outfit/virtual_syndicate
	name = "虚拟辛迪加成员"
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative
	uniform = /obj/item/clothing/under/syndicate
	back = /obj/item/storage/backpack
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	shoes = /obj/item/clothing/shoes/combat
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/virtual_syndicate/post_equip(mob/living/carbon/human/user, visuals_only)
	user.add_faction(ROLE_SYNDICATE)
