
//i couldn't find any map that uses these, so they're delegated to admin events for now.

/obj/effect/mob_spawn/ghost_role/human/prisoner_transport
	name = "囚犯收容卧铺"
	desc = "一款专为使乘客陷入深度昏迷而设计的卧铺，一旦穿上便无法被破坏，直到卧铺被关闭为止。这件卧铺的玻璃部分已经破裂，你可以看到一张苍白的、熟睡的脸正向外凝视着。"
	prompt_name = "一名逃犯"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/lavalandprisoner
	you_are_text = "You're a prisoner, sentenced to hard work in one of Nanotrasen's labor camps, but it seems as \
	though fate has other plans for you."
	flavour_text = "很好。看来你的飞船坠毁了。你记得你被判刑是因为"
	spawner_job_path = /datum/job/escaped_prisoner
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/human/prisoner_transport/Initialize(mapload)
	. = ..()
	var/list/crimes = list("murder", "larceny", "embezzlement", "unionization", "dereliction of duty", "kidnapping", "gross incompetence", "grand theft", "collaboration with the Syndicate", \
	"worship of a forbidden deity", "interspecies relations", "mutiny")
	flavour_text += "[pick(crimes)]. but regardless of that, it seems like your crime doesn't matter now. You don't know where you are, but you know that it's out to kill you, and you're not going \
	to lose this opportunity. Find a way to get out of this mess and back to where you rightfully belong - your [pick("house", "apartment", "spaceship", "station")]."

/obj/effect/mob_spawn/ghost_role/human/prisoner_transport/Destroy()
	new /obj/structure/fluff/empty_sleeper/syndicate(get_turf(src))
	return ..()

/obj/effect/mob_spawn/ghost_role/human/prisoner_transport/special(mob/living/carbon/human/spawned_human, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_human.fully_replace_character_name(null, "NTP #LL-0[rand(111,999)]") //Nanotrasen Prisoner #Lavaland-(numbers)

/datum/outfit/lavalandprisoner
	name = "拉瓦兰囚犯"
	uniform = /obj/item/clothing/under/rank/prisoner
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/sneakers/orange
	r_pocket = /obj/item/tank/internals/emergency_oxygen


//spawners for the space hotel, which isn't currently in the code but heyoo secret away missions or something

//Space Hotel Staff
/obj/effect/mob_spawn/ghost_role/human/hotel_staff //not free antag u little shits
	name = "员工休眠舱"
	desc = "为客人来访之前的长期停滞而设计的卧铺。"
	prompt_name = "一名旅馆工作人员"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/hotelstaff
	you_are_text = "你是一家顶级太空酒店的职员！"
	flavour_text = "与你的同事一起服务来访的客人，宣传酒店，并确保经理不会解雇你。记住，顾客永远是对的！"
	important_text = "请勿离开酒店，否则将构成合同终止的理由。"
	spawner_job_path = /datum/job/hotel_staff
	allow_custom_character = ALL

/datum/outfit/hotelstaff
	name = "旅馆工作人员"
	uniform = /obj/item/clothing/under/misc/assistantformal
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/radio/off

	implants = list(
		/obj/item/implant/exile/noteleport,
		/obj/item/implant/mindshield,
	)

/obj/effect/mob_spawn/ghost_role/human/hotel_staff/security
	name = "旅馆保安人员"
	prompt_name = "一名旅馆保安人员"
	outfit = /datum/outfit/hotelstaff/security
	you_are_text = "你是一名维和人员。"
	flavour_text = "You have been assigned to this hotel to protect the interests of the company while keeping the peace between \
		guests and the staff."
	important_text = "请勿离开酒店，否则将构成合同终止的理由。"

/datum/outfit/hotelstaff/security
	name = "旅馆保安"
	uniform = /obj/item/clothing/under/rank/security/officer/blueshirt
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	back = /obj/item/storage/backpack/security
	belt = /obj/item/storage/belt/security/full
	head = /obj/item/clothing/head/helmet/blueshirt
	shoes = /obj/item/clothing/shoes/jackboots

/obj/effect/mob_spawn/ghost_role/human/hotel_staff/Destroy()
	new/obj/structure/fluff/empty_sleeper/syndicate(get_turf(src))
	return ..()

/obj/effect/mob_spawn/ghost_role/human/syndicate
	name = "辛迪加行动队"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	prompt_name = "一个辛迪加行动队员"
	you_are_text = "你是一名辛迪加特工。"
	flavour_text = "你已醒来，但没有接到指令。纳米传讯去死！如果周围有一些关于你应该做什么的线索，你最好遵循它们。"
	outfit = /datum/outfit/syndicate_empty
	spawner_job_path = /datum/job/space_syndicate
	allow_custom_character = ALL

/datum/outfit/syndicate_empty
	name = "无装备辛迪加特工"
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative
	uniform = /obj/item/clothing/under/syndicate
	back = /obj/item/storage/backpack
	ears = /obj/item/radio/headset/syndicate/alt
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	shoes = /obj/item/clothing/shoes/combat

	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicate_empty/post_equip(mob/living/carbon/human/H)
	H.add_faction(ROLE_SYNDICATE)

//For ghost bar.
/obj/effect/mob_spawn/ghost_role/human/space_bar_patron
	name = "酒吧低温舱"
	uses = INFINITY
	prompt_name = "一名太空酒吧顾客"
	you_are_text = "你是一名顾客！"
	flavour_text = "在酒吧里放松一下，和你的伙伴们聊聊天。聊完后随时可以回到低温休眠舱。"
	outfit = /datum/outfit/cryobartender
	spawner_job_path = /datum/job/space_bar_patron
	allow_custom_character = ALL

/obj/effect/mob_spawn/ghost_role/human/space_bar_patron/attack_hand(mob/user, list/modifiers)
	var/despawn = tgui_alert(usr, "返回低温休眠？（警告，你的角色将被删除！）", null, list("Yes", "No"))
	if(despawn == "No" || !loc || !Adjacent(user))
		return
	user.visible_message(span_notice("[user.name]爬回了低温休眠舱..."))
	qdel(user)

/datum/outfit/cryobartender
	name = "低温酒保"
	neck = /obj/item/clothing/neck/bowtie
	uniform = /obj/item/clothing/under/costume/buttondown/slacks/service
	suit = /obj/item/clothing/suit/armor/vest
	back = /obj/item/storage/backpack
	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	shoes = /obj/item/clothing/shoes/sneakers/black

//Timeless prisons: Spawns in Wish Granter prisons in lavaland. Ghosts become age-old users of the Wish Granter and are advised to seek repentance for their past.
/obj/effect/mob_spawn/ghost_role/human/exile
	name = "永恒监狱"
	desc = "尽管这个停滞舱看起来像是用于存放药物的容器，但它的设计似乎是为了将某种东西保存很长时间。"
	prompt_name = "一位忏悔的流亡者"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/shadow
	you_are_text = "你被诅咒了。"
	flavour_text = "Years ago, you sacrificed the lives of your trusted friends and the humanity of yourself to reach the Wish Granter. Though you \
	did so, it has come at a cost: your very body rejects the light, dooming you to wander endlessly in this horrible wasteland."
	spawner_job_path = /datum/job/exile

/obj/effect/mob_spawn/ghost_role/human/exile/Destroy()
	new/obj/structure/fluff/empty_sleeper(get_turf(src))
	return ..()

/obj/effect/mob_spawn/ghost_role/human/exile/special(mob/living/new_spawn, mob/mob_possessor, apply_prefs)
	. = ..()
	new_spawn.fully_replace_character_name(null,"Wish Granter's Victim ([rand(1,999)])")
	var/wish = rand(1,4)
	var/message = ""
	switch(wish)
		if(1)
			message = "<b>You wished to kill, and kill you did. You've lost track of how many, but the spark of excitement that murder once held has winked out. You feel only regret.</b>"
		if(2)
			message = "<b>You wished for unending wealth, but no amount of money was worth this existence. Maybe charity might redeem your soul?</b>"
		if(3)
			message = "<b>You wished for power. Little good it did you, cast out of the light. You are the [gender == MALE ? "king" : "queen"] of a hell that holds no subjects. You feel only remorse.</b>"
		if(4)
			message = "<b>You wished for immortality, even as your friends lay dying behind you. No matter how many times you cast yourself into the lava, you awaken in this room again within a few days. There is no escape.</b>"
	to_chat(new_spawn, span_infoplain("[message]"))

/obj/effect/mob_spawn/ghost_role/human/nanotrasensoldier
	name = "休眠舱"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	faction = list(FACTION_NANOTRASEN_PRIVATE)
	prompt_name = "一名私人安全官"
	you_are_text = "你是一名纳米传讯私人安保干员！"
	flavour_text = "如果上级有任务指派给你，你最好遵从。否则，消灭辛迪加。"
	outfit = /datum/outfit/nanotrasensoldier
	allow_custom_character = ALL

/obj/effect/mob_spawn/ghost_role/human/commander
	name = "休眠舱"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一名纳米传讯指挥官"
	you_are_text = "你是一名纳米传讯指挥官！"
	flavour_text = "纳米传讯的上层精英。你应该得到应有的尊重。"
	outfit = /datum/outfit/nanotrasencommander
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

//space doctor, a rat with cancer, and bessie from an old removed lavaland ruin.

/obj/effect/mob_spawn/ghost_role/human/doctor
	name = "休眠舱"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一名太空医生"
	you_are_text = "你是一名太空医生！"
	flavour_text = "照顾和治疗需要帮助的人，这是你的工作——不，是你作为医生的职责。"
	outfit = /datum/outfit/job/doctor
	spawner_job_path = /datum/job/space_doctor
	allow_custom_character = ALL

/obj/effect/mob_spawn/ghost_role/human/doctor/alive/equip(mob/living/carbon/human/doctor)
	. = ..()
	// Remove radio and PDA so they wouldn't annoy station crew.
	var/list/del_types = list(/obj/item/modular_computer/pda, /obj/item/radio/headset)
	for(var/del_type in del_types)
		var/obj/item/unwanted_item = locate(del_type) in doctor
		qdel(unwanted_item)

/obj/effect/mob_spawn/ghost_role/mouse
	name = "休眠舱"
	mob_type = /mob/living/basic/mouse
	prompt_name = "一只老鼠"
	you_are_text = "你是一只老鼠！"
	flavour_text = "呃……没错！吱吱叫，混蛋。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/effect/mob_spawn/ghost_role/cow
	name = "休眠舱"
	mob_name = "Bessie"
	mob_type = /mob/living/basic/cow
	prompt_name = "一头奶牛"
	you_are_text = "你是一头奶牛！"
	flavour_text = "去吃点草吧，臭烘烘的家伙。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/effect/mob_spawn/cow/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	gender = FEMALE

// snow operatives on snowdin - unfortunately seemingly removed in a map remake womp womp

/obj/effect/mob_spawn/ghost_role/human/snow_operative
	name = "休眠舱"
	prompt_name = "一个风雪行动队员"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	faction = list(ROLE_SYNDICATE)
	outfit = /datum/outfit/snowsyndie
	you_are_text = "你是一名辛迪加特工，最近刚从地下前哨的低温休眠中醒来。"
	flavour_text = "Monitor Nanotrasen communications and record information. All intruders should be disposed of \
	swiftly to assure no gathered information is stolen or lost. Try not to wander too far from the outpost as the \
	caves can be a deadly place even for a trained operative such as yourself."
	allow_custom_character = ALL

/datum/outfit/snowsyndie
	name = "辛迪加雪地特工"
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative
	uniform = /obj/item/clothing/under/syndicate/coldres
	ears = /obj/item/radio/headset/syndicate/alt
	shoes = /obj/item/clothing/shoes/combat/coldres
	r_pocket = /obj/item/gun/ballistic/automatic/pistol

	implants = list(/obj/item/implant/exile)

//Forgotten syndicate ship

/obj/effect/mob_spawn/ghost_role/human/syndicatespace
	name = "辛迪加船员"
	show_flavor = FALSE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	prompt_name = "赛博森船员"
	you_are_text = "你是一名辛迪加特工，被困在一艘老旧飞船里，身处敌对太空。"
	flavour_text = "你的飞船在敌对太空某处停靠了很长时间，报告出现故障。你被困在这里，附近就是纳米传讯空间站。修复飞船，找到为其供能的方法，并服从舰长的命令。"
	important_text = "服从舰长下达的命令。绝不能让飞船落入敌人手中。"
	outfit = /datum/outfit/syndicatespace/syndicrew
	spawner_job_path = /datum/job/syndicate_cybersun
	allow_custom_character = ALL

/obj/effect/mob_spawn/ghost_role/human/syndicatespace/special(mob/living/new_spawn, mob/mob_possessor, apply_prefs)
	. = ..()
	new_spawn.grant_language(/datum/language/codespeak, source = LANGUAGE_SPAWNER) // NOVA EDIT CHANGE - ORIGINAL: new_spawn.grant_language(/datum/language/codespeak, source = LANGUAGE_MIND)
	var/datum/job/spawn_job = SSjob.get_job_type(spawner_job_path)
	var/policy = get_policy(spawn_job.policy_index)
	if(policy)
		to_chat(new_spawn, span_bold("[policy]"))

/obj/effect/mob_spawn/ghost_role/human/syndicatespace/captain
	name = "辛迪加舰长"
	prompt_name = "一名赛博森舰长"
	you_are_text = "你是一艘老旧飞船的舰长，被困在敌对太空。"
	flavour_text = "你的飞船在敌对太空某处停靠了很长时间，报告出现故障。你被困在这里，附近就是纳米传讯空间站。指挥你的船员，将你的飞船打造成最坚固的堡垒。"
	important_text = "不惜以生命保护飞船和你背包里的秘密文件。"
	outfit = /datum/outfit/syndicatespace/syndicaptain
	spawner_job_path = /datum/job/syndicate_cybersun_captain
	allow_custom_character = ALL

/obj/effect/mob_spawn/ghost_role/human/syndicatespace/captain/Destroy()
	new /obj/structure/fluff/empty_sleeper/syndicate/captain(get_turf(src))
	return ..()

/datum/outfit/syndicatespace
	name = "辛迪加舰船基地"
	id = /obj/item/card/id/advanced/black/syndicate_command/crew_id
	uniform = /obj/item/clothing/under/syndicate/combat
	back = /obj/item/storage/backpack
	belt = /obj/item/storage/belt/military/assault
	ears = /obj/item/radio/headset/syndicate/alt
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat

	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicatespace/post_equip(mob/living/carbon/human/syndie_scum)
	syndie_scum.add_faction(ROLE_SYNDICATE)

/datum/outfit/syndicatespace/syndicrew
	name = "辛迪加船员"
	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/syndicate
	l_pocket = /obj/item/gun/ballistic/automatic/pistol
	r_pocket = /obj/item/knife/combat/survival

/datum/outfit/syndicatespace/syndicaptain
	name = "辛迪加舰长"
	id = /obj/item/card/id/advanced/black/syndicate_command/captain_id
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	ears = /obj/item/radio/headset/syndicate/alt/leader
	head = /obj/item/clothing/head/hats/hos/beret/syndicate
	r_pocket = /obj/item/knife/combat/survival
	backpack_contents = list(
		/obj/item/documents/syndicate/red,
		/obj/item/gun/ballistic/automatic/pistol/aps,
		/obj/item/paper/fluff/ruins/forgottenship/password,
	)
