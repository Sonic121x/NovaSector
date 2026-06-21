
//Ancient cryogenic sleepers. Players become NT crewmen from a hundred year old space station, now on the verge of collapse.
/obj/effect/mob_spawn/ghost_role/human/oldstation
	name = "旧式低温休眠舱"
	desc = "一个嗡嗡作响的低温休眠舱。在凝结的冰层下，你勉强能辨认出一套制服。机器正试图唤醒其中的居住者。"
	prompt_name = "一名远古船员"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/human
	you_are_text = "你是一名纳米传讯的船员，驻扎在一座先进的研究空间站上。"
	flavour_text = "You vaguely recall rushing into a cryogenics pod due to an oncoming radiation storm. \
	The last thing you remember is the station's Artificial Program telling you that you would only be asleep for eight hours. As you open \
	your eyes, everything seems rusted and broken, a dark feeling swells in your gut as you climb out of your pod."
	important_text = "与你的幸存者同伴团队合作，不要抛弃他们。"
	outfit = /datum/outfit/oldeng
	spawner_job_path = /datum/job/ancient_crew
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/human/oldstation/create(mob/mob_possessor, newname, apply_prefs)
	. = ..()
	if(!.)
		return
	notify_ghosts(
		"Someone just woke up on Charlie Station! Why not join them and help out?",
		source = ., //the spawned mob
		header = "Join in, help out!",
		click_interact = TRUE,
		notify_flags = NOTIFY_CATEGORY_NOFLASH,
	)

/obj/effect/mob_spawn/ghost_role/human/oldstation/Destroy()
	new /obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()


/obj/effect/mob_spawn/ghost_role/human/oldstation/sec
	desc = "一个嗡嗡作响的冷冻舱。从厚厚的冰层下几乎看不清那身安保制服了。这台机器正试图唤醒里面的乘客。"
	prompt_name = "一名安全官"
	you_are_text = "你是一名纳米传讯的安保干员，驻扎在一座先进的研究空间站上。"
	outfit = /datum/outfit/oldsec

/datum/outfit/oldsec
	name = "古老的安保"
	id = /obj/item/card/id/away/old/sec
	uniform = /obj/item/clothing/under/rank/security/officer
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/assembly/flash/handheld
	r_pocket = /obj/item/restraints/handcuffs

/obj/effect/mob_spawn/ghost_role/human/oldstation/eng
	desc = "一具嗡鸣的低温休眠舱。在凝结的冰层下，你依稀能辨认出一套工程师制服。机器正在试图唤醒舱内人员。"
	prompt_name = "一名工程师"
	you_are_text = "你是一名纳米传讯的工程师，驻扎在一座先进的研究空间站上。"
	outfit = /datum/outfit/oldeng

/datum/outfit/oldeng
	name = "远古工程师"
	id = /obj/item/card/id/away/old/eng
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	gloves = /obj/item/clothing/gloves/color/fyellow/old
	shoes = /obj/item/clothing/shoes/workboots
	l_pocket = /obj/item/tank/internals/emergency_oxygen

/datum/outfit/oldeng/mod
	name = "远古工程师（MOD防护服）"
	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/prototype
	mask = /obj/item/clothing/mask/breath
	internals_slot = ITEM_SLOT_SUITSTORE

/obj/effect/mob_spawn/ghost_role/human/oldstation/sci
	desc = "一个嗡嗡作响的低温休眠舱。在凝结的冰层下，你勉强能辨认出一套科研制服。机器正试图唤醒其中的居住者。"
	prompt_name = "一名科学家"
	you_are_text = "你是一名为纳米传讯工作的科学家，驻扎在一座先进的研究空间站上。"
	outfit = /datum/outfit/oldsci

/datum/outfit/oldsci
	name = "古代科学家"
	id = /obj/item/card/id/away/old/sci
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/stack/medical/bruise_pack

///asteroid comms agent

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/comms/space
	you_are_text = "你是一名辛迪加特工，被派往一个小型监听站，该站位于你憎恨的敌人的绝密研究设施：空间站13附近。"
	flavour_text = "尽你所能监视敌人的活动，并尽量保持低调。使用通讯设备为任何现场特工提供支持，并散布虚假信息以误导纳米传讯，使其无法追踪你们。绝不能让基地落入敌人手中！"
	important_text = "切勿放弃基地。"

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/comms/space/Initialize(mapload)
	. = ..()
	if(prob(85)) //only has a 15% chance of existing, otherwise it'll just be a NPC syndie.
		new /mob/living/basic/trooper/syndicate/ranged(get_turf(src))
		return INITIALIZE_HINT_QDEL

///battlecruiser stuff

/obj/effect/mob_spawn/ghost_role/human/syndicate/battlecruiser
	name = "辛迪加战列巡洋舰舰员"
	you_are_text = "你是辛迪加旗舰SBC星怒号上的一名船员。"
	flavour_text = "你的工作是服从舰长的命令，维护飞船，并确保电力供应。"
	important_text = "军械库不是糖果店，你的职责也不是直接攻击空间站，把那种工作留给突击队员。"
	prompt_name = "一名战列巡洋舰舰员"
	outfit = /datum/outfit/syndicate_empty/battlecruiser
	spawner_job_path = /datum/job/battlecruiser_crew
	uses = 4
	allow_custom_character = ALL

	/// The antag team to apply the player to
	var/datum/team/antag_team
	/// The antag datum to give to the player spawned
	var/antag_datum_to_give = /datum/antagonist/battlecruiser

/obj/effect/mob_spawn/ghost_role/human/syndicate/battlecruiser/allow_spawn(mob/user, silent = FALSE)
	if(!(user.ckey in antag_team.players_spawned))
		return TRUE
	if(!silent)
		to_chat(user, span_boldwarning("你已经用掉了扮演战列巡洋舰成员的机会。"))
	return FALSE

/obj/effect/mob_spawn/ghost_role/human/syndicate/battlecruiser/special(mob/living/spawned_mob, mob/possesser)
	. = ..()
	if(!spawned_mob.mind)
		spawned_mob.mind_initialize()
	var/datum/mind/mob_mind = spawned_mob.mind
	mob_mind.add_antag_datum(antag_datum_to_give, antag_team)
	antag_team.players_spawned += (spawned_mob.ckey)

/datum/outfit/syndicate_empty/battlecruiser
	name = "辛迪加战列巡洋舰特工"
	belt = /obj/item/storage/belt/military/assault
	l_pocket = /obj/item/gun/ballistic/automatic/pistol/clandestine
	r_pocket = /obj/item/knife/combat/survival

	box = /obj/item/storage/box/survival/syndie

/obj/effect/mob_spawn/ghost_role/human/syndicate/battlecruiser/assault
	name = "辛迪加战列巡洋舰突击特工"
	you_are_text = "你是辛迪加旗舰SBC星怒号上的一名突击队员。"
	flavour_text = "你的工作是服从舰长的命令，将入侵者挡在飞船之外，并攻击空间站13。船上有一个军械库、多艘突击艇以及用于攻击空间站的射束炮。"
	important_text = "与你的队友协同作战，制定攻击计划。如果寡不敌众，就撤回你们的飞船！"
	prompt_name = "一名战列巡洋舰特工"
	outfit = /datum/outfit/syndicate_empty/battlecruiser/assault
	uses = 8

/datum/outfit/syndicate_empty/battlecruiser/assault
	name = "辛迪加战列巡洋舰突击特工"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = /obj/item/gun/ballistic/automatic/pistol/clandestine
	back = /obj/item/storage/backpack
	belt = /obj/item/storage/belt/military
	mask = /obj/item/clothing/mask/gas/syndicate
	l_pocket = /obj/item/uplink/nuclear
	r_pocket = /obj/item/modular_computer/pda/nukeops

	skillchips = list(/obj/item/skillchip/disk_verifier)

/obj/effect/mob_spawn/ghost_role/human/syndicate/battlecruiser/captain
	name = "辛迪加战列巡洋舰舰长"
	you_are_text = "你是辛迪加旗舰SBC星怒号上的舰长。"
	flavour_text = "你的职责是监督船员、保卫战舰并摧毁13号空间站。战舰配有军械库、多艘舰载机、光束炮以及多名船员，足以完成此目标。"
	important_text = "作为舰长，整个行动的重担都落在你的肩上。协助你的突击队员在空间站上引爆核弹。"
	prompt_name = "一名战列巡洋舰舰长"
	outfit = /datum/outfit/syndicate_empty/battlecruiser/assault/captain
	spawner_job_path = /datum/job/battlecruiser_captain
	antag_datum_to_give = /datum/antagonist/battlecruiser/captain
	uses = 1

/datum/outfit/syndicate_empty/battlecruiser/assault/captain
	name = "辛迪加战列巡洋舰舰长"
	id = /obj/item/card/id/advanced/black/syndicate_command/captain_id
	id_trim = /datum/id_trim/battlecruiser/captain
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	suit_store = /obj/item/gun/ballistic/revolver/mateba
	back = /obj/item/storage/backpack/satchel/leather
	ears = /obj/item/radio/headset/syndicate/alt/leader
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	head = /obj/item/clothing/head/hats/hos/cap/syndicate
	mask = /obj/item/cigarette/cigar/havana
	l_pocket = /obj/item/melee/energy/sword/saber/red
	r_pocket = /obj/item/melee/baton/telescopic

//film studio space ruins, actors and such.
/obj/effect/mob_spawn/ghost_role/human/actor
	name = "低温休眠舱"
	desc = "一个嗡嗡作响的低温休眠舱。你认出里面的人是某种本地名人。"
	prompt_name = "一位演员"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/human
	you_are_text = "你是索弗罗尼亚广播公司旗下的一名演员/女演员，驻扎在本地的电视演播室。"
	flavour_text = "你最后的记忆是公司不知为何让所有人都进入低温休眠，其他人都去哪儿了？"
	important_text = "与你的演员同事和导演团队合作，为大众制作娱乐节目。"
	outfit = /datum/outfit/actor
	spawner_job_path = /datum/job/ghost_role
	allow_custom_character = ALL

/datum/outfit/actor
	name = "演员"
	id = /obj/item/card/id/away/filmstudio
	id_trim= /datum/id_trim/away/actor
	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/suit/charcoal
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/clothing/mask/chameleon
	r_pocket = /obj/item/card/id/advanced/chameleon

/obj/effect/mob_spawn/ghost_role/human/director
	name = "低温休眠舱"
	desc = "一个嗡嗡作响的低温休眠舱。你认出里面的人是某种本地名人。"
	prompt_name = "一位导演"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/human
	you_are_text = "你是索弗罗尼亚广播公司旗下的一名导演，驻扎在本地的电视演播室。"
	flavour_text = "你刚受雇于一家本地电视演播室，负责指导节目和娱乐内容制作，与你的团队一起尽力创作吧！"
	important_text = "与你的演员同事和导演团队合作，为大众制作娱乐节目。"
	outfit = /datum/outfit/actor/director
	spawner_job_path = /datum/job/ghost_role
	allow_custom_character = ALL

/datum/outfit/actor/director
	name = "导演"
	id_trim = /datum/id_trim/away/director
	uniform = /obj/item/clothing/under/suit/red
	head = /obj/item/clothing/head/beret/frenchberet
