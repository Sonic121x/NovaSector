/obj/item/storage/briefcase
	name = "公文包"
	desc = "它由AUTHENTIC人造革制成，价格标签还挂在上面。它的主人一定是个真正的专业人士。"
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "briefcase"
	inhand_icon_state = "briefcase"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 8
	hitsound = SFX_SWING_HIT
	throw_speed = 2
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("bashes", "batters", "bludgeons", "thrashes", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "thrash", "whack")
	resistance_flags = FLAMMABLE
	max_integrity = 150
	storage_type = /datum/storage/briefcase

	/// The path of the folder that gets spawned in New()
	var/folder_path = /obj/item/folder

/obj/item/storage/briefcase/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item)

/obj/item/storage/briefcase/PopulateContents()
	new /obj/item/pen(src)
	var/obj/item/folder/folder = new folder_path(src)
	for(var/i in 1 to 6)
		new /obj/item/paper(folder)

/obj/item/storage/briefcase/lawyer
	folder_path = /obj/item/folder/blue

/obj/item/storage/briefcase/lawyer/PopulateContents()
	new /obj/item/stamp/law(src)
	..()

/obj/item/storage/briefcase/suicide_act(mob/living/user)
	var/list/papers_found = list()
	var/turf/item_loc = get_turf(src)

	if(!item_loc)
		return OXYLOSS

	for(var/obj/item/potentially_paper in contents)
		if(istype(potentially_paper, /obj/item/paper) || istype(potentially_paper, /obj/item/paperplane))
			papers_found += potentially_paper
	if(!papers_found.len || !item_loc)
		user.visible_message(span_suicide("[user]用[src]猛击[user.p_them()]自己的头部！看起来[user.p_theyre()]试图自杀！"))
		return BRUTELOSS

	user.visible_message(span_suicide("[user]打开了[src]，[user.p_their()]所有的文件都飞了出来！"))
	for(var/obj/item/paper as anything in papers_found)	//Throws the papers in a random direction
		var/turf/turf_to_throw_at = prob(20) ? item_loc : get_ranged_target_turf(item_loc, pick(GLOB.alldirs))
		paper.throw_at(turf_to_throw_at, 2)

	stoplag(1 SECONDS)
	user.say("ARGGHH, HOW WILL I GET THIS WORK DONE NOW?!!")
	user.visible_message(span_suicide("[user]看起来被文书工作压垮了！看起来[user.p_theyre()]试图自杀！"))
	return OXYLOSS

// Empty subtype
/obj/item/storage/briefcase/empty/PopulateContents()
	return

/obj/item/storage/briefcase/sniper
	desc = "它的标签上写着“正宗硬化舰长皮革”，但可疑的是没有其他标签或品牌。闻起来像L'Air du Temps。"
	force = 10

/obj/item/storage/briefcase/sniper/PopulateContents()
	..() // in case you need any paperwork done after your rampage
	new /obj/item/gun/ballistic/rifle/sniper_rifle/syndicate(src)
	new /obj/item/clothing/neck/tie/red/hitman(src)
	new /obj/item/clothing/under/syndicate/sniper(src)
	new /obj/item/ammo_box/magazine/sniper_rounds(src)
	new /obj/item/ammo_box/magazine/sniper_rounds(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/disruptor(src)

/**
 * Secure briefcase
 * Uses the lockable storage component to give it a lock.
 */
/obj/item/storage/briefcase/secure
	name = "安全公文包"
	desc = "一个带有数字锁定系统的大号公文包。"
	icon_state = "secure"
	base_icon_state = "secure"
	inhand_icon_state = "sec-case"
	var/stored_lock_code

/obj/item/storage/briefcase/secure/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/lockable_storage, stored_lock_code)
	RegisterSignal(src, COMSIG_LOCKABLE_STORAGE_SET_CODE, PROC_REF(update_lock_code))

/obj/item/storage/briefcase/secure/proc/update_lock_code(obj/item/storage/briefcase/secure/briefacase, new_code)
	SIGNAL_HANDLER

	stored_lock_code = new_code

/// Base container used for gimmick disks.
/obj/item/storage/briefcase/secure/digital_storage
	name = "数字公文包"
	desc = "它由AUTHENTIC数字皮革制成，价格标签还挂在上面。它的主人一定是个真正的专业人士。"
	icon_state = "secure"
	base_icon_state = "secure"
	inhand_icon_state = "sec-case"

/obj/item/storage/briefcase/secure/digital_storage/PopulateContents()
	return

///Syndie variant of Secure Briefcase. Contains space cash, slightly more robust.
/obj/item/storage/briefcase/secure/syndie
	force = 15

/obj/item/storage/briefcase/secure/syndie/PopulateContents()
	. = ..()
	for(var/iterator in 1 to 5)
		new /obj/item/stack/spacecash/c1000(src)

/// A briefcase that contains various sought-after spoils
/obj/item/storage/briefcase/secure/riches/PopulateContents()
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/gun/ballistic/automatic/pistol(src)
	new /obj/item/suppressor(src)
	new /obj/item/melee/baton/telescopic(src)
	new /obj/item/clothing/mask/balaclava(src)
	new /obj/item/bodybag(src)
	new /obj/item/soap/nanotrasen(src)

/obj/item/storage/briefcase/hitchiker/PopulateContents()
	new /obj/item/food/sandwich/peanut_butter_jelly(src)
	new /obj/item/food/sandwich/peanut_butter_jelly(src)
	new /obj/item/reagent_containers/cup/glass/waterbottle/large(src)
	new /obj/item/soap(src)
	new /obj/item/pillow/random(src)
	new /obj/item/tank/internals/emergency_oxygen(src)
	new /obj/item/tank/internals/emergency_oxygen(src)

//Briefcase item that contains the launchpad.
/obj/item/storage/briefcase/launchpad
	var/obj/machinery/launchpad/briefcase/pad

/obj/item/storage/briefcase/launchpad/Initialize(mapload)
	pad = new(null, src) //spawns pad in nullspace to hide it from briefcase contents
	. = ..()

/obj/item/storage/briefcase/launchpad/Destroy()
	if(!QDELETED(pad))
		qdel(pad)
	pad = null
	return ..()

/obj/item/storage/briefcase/launchpad/PopulateContents()
	new /obj/item/pen(src)
	new /obj/item/launchpad_remote(src, pad)

/obj/item/storage/briefcase/launchpad/attack_self(mob/user)
	if(!isturf(user.loc)) //no setting up in a locker
		return
	add_fingerprint(user)
	user.visible_message(span_notice("[user]开始放下[src]..."), span_notice("你开始设置[pad]..."))
	if(do_after(user, 3 SECONDS, target = user))
		pad.forceMove(get_turf(src))
		pad.update_indicator()
		pad.closed = FALSE
		user.transferItemToLoc(src, pad, TRUE)
		atom_storage.close_all()

/obj/item/storage/briefcase/launchpad/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/launchpad_remote))
		return ..()
	var/obj/item/launchpad_remote/remote = tool
	if(remote.pad == WEAKREF(src.pad))
		return ..()
	remote.pad = WEAKREF(src.pad)
	to_chat(user, span_notice("你将[pad]链接到[remote]。"))
	return ITEM_INTERACT_BLOCKING

/obj/item/storage/briefcase/gun
	storage_type = /datum/storage/briefcase/gun

/obj/item/storage/briefcase/gun/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	for(var/obj/item/gun/weapon in src)
		return weapon.try_fire_gun(interacting_with, user, list2params(modifiers))
	return NONE

/obj/item/storage/briefcase/gun/examine_more(mob/user)
	. = ..()
	if(user.is_holding(src))
		. += span_notice("Upon closer inspection, you notice a hole in the side of the briefcase.")

/obj/item/storage/briefcase/gun/preloaded

/obj/item/storage/briefcase/gun/preloaded/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol(src)
	return ..()
