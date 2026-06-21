/obj/item/storage/lockbox
	name = "上锁的箱子"
	desc = "一个上了锁的箱子。"
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "lockbox+l"
	inhand_icon_state = "lockbox"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	req_access = list(ACCESS_ARMORY)
	storage_type = /datum/storage/lockbox

	var/broken = FALSE
	var/open = FALSE
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_open = "lockbox"
	var/icon_broken = "lockbox+b"

/obj/item/storage/lockbox/Initialize(mapload)
	. = ..()

	register_context()
	update_icon_state()
	AddElement(/datum/element/cuffable_item)

///screentips for lockboxes
/obj/item/storage/lockbox/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(!held_item)
		return NONE
	if(broken)
		return NONE
	if(!held_item.GetID())
		return NONE
	context[SCREENTIP_CONTEXT_LMB] = atom_storage.locked ? "Unlock with ID" : "Lock with ID"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/storage/lockbox/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	var/obj/item/card/card = tool.GetID()
	if(isnull(card))
		return ..()

	if(can_unlock(user, card))
		toggle_locked(user)
		return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/item/storage/lockbox/proc/can_unlock(mob/living/user, obj/item/card/id/id_card, silent = FALSE)
	if(check_access(id_card))
		return TRUE
	if(!silent)
		balloon_alert(user, "访问被拒绝！")
	return FALSE

/obj/item/storage/lockbox/proc/toggle_locked(mob/living/user)
	atom_storage.set_locked(atom_storage.locked ? STORAGE_NOT_LOCKED : STORAGE_FULLY_LOCKED)
	balloon_alert(user, atom_storage.locked ? "已锁定" : "已解锁")

/obj/item/storage/lockbox/update_icon_state()
	. = ..()
	if(broken)
		icon_state = icon_broken
	else if(atom_storage?.locked)
		icon_state = icon_locked
	else if(open)
		icon_state = icon_open
	else
		icon_state = icon_closed

/obj/item/storage/lockbox/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(!broken)
		broken = TRUE
		atom_storage.set_locked(STORAGE_NOT_LOCKED)
		balloon_alert(user, "锁已破坏")
		if (emag_card && user)
			user.visible_message(span_warning("[user] 用 [emag_card] 划过 [src]，把它弄坏了！"))
		return TRUE
	return FALSE

/obj/item/storage/lockbox/examine(mob/user)
	. = ..()
	if(broken)
		. += span_notice("它看起来已经损坏了。")

/obj/item/storage/lockbox/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	open = TRUE
	update_appearance()

/obj/item/storage/lockbox/Exited(atom/movable/gone, direction)
	. = ..()
	open = TRUE
	update_appearance()

/obj/item/storage/lockbox/loyalty
	name = "精神护盾植入物保险箱"
	req_access = list(ACCESS_SECURITY)

/obj/item/storage/lockbox/loyalty/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/implantcase/mindshield(src)
	new /obj/item/implanter/mindshield(src)

/obj/item/storage/lockbox/clusterbang
	name = "集束炸弹保险箱"
	desc = "你有一种不祥的预感，最好不要打开它。"
	req_access = list(ACCESS_SECURITY)

/obj/item/storage/lockbox/clusterbang/PopulateContents()
	new /obj/item/grenade/clusterbuster(src)

/obj/item/storage/lockbox/medal
	name = "勋章盒"
	desc = "一个用于存放荣誉勋章的带锁盒子。"
	icon_state = "medalbox+l"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	req_access = list(ACCESS_CAPTAIN)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"
	icon_open = "medalboxopen"
	storage_type = /datum/storage/lockbox/medal

/obj/item/storage/lockbox/medal/examine(mob/user)
	. = ..()
	if(!atom_storage.locked)
		. += span_notice("Alt-click to [open ? "close":"open"] it.")

/obj/item/storage/lockbox/medal/click_alt(mob/user)
	if(!atom_storage.locked)
		open = !open
		update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/storage/lockbox/medal/PopulateContents()
	new /obj/item/clothing/accessory/medal/gold/captain(src)
	new /obj/item/clothing/accessory/medal/silver/valor(src)
	new /obj/item/clothing/accessory/medal/silver/valor(src)
	new /obj/item/clothing/accessory/medal/silver/security(src)
	new /obj/item/clothing/accessory/medal/bronze_heart(src)
	new /obj/item/clothing/accessory/medal/plasma/nobel_science(src)
	new /obj/item/clothing/accessory/medal/plasma/nobel_science(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/conduct(src)

/obj/item/storage/lockbox/medal/update_overlays()
	. = ..()
	if(!contents || !open)
		return
	if(atom_storage?.locked)
		return
	for(var/i in 1 to contents.len)
		var/obj/item/clothing/accessory/medal/M = contents[i]
		var/mutable_appearance/medalicon = mutable_appearance(initial(icon), M.medaltype)
		if(i > 1 && i <= 5)
			medalicon.pixel_w += ((i-1)*3)
		else if(i > 5)
			medalicon.pixel_z -= 3
			medalicon.pixel_w += ((i-6)*3)
		. += medalicon

/obj/item/storage/lockbox/medal/hop
	name = "人事部长勋章盒"
	desc = "一个用于存放授予在管理方面表现卓越者的勋章的带锁盒子。"
	req_access = list(ACCESS_HOP)
	icon_state = "hopbox+l"
	icon_locked = "hopbox+l"
	icon_closed = "hopbox"

/obj/item/storage/lockbox/medal/hop/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/bureaucracy(src)
	new /obj/item/clothing/accessory/medal/gold/ordom(src)

/obj/item/storage/lockbox/medal/sec
	name = "安保勋章盒"
	desc = "一个用于存放授予安保部门成员的勋章的带锁盒子。"
	req_access = list(ACCESS_HOS)
	icon_state = "secbox+l"
	icon_locked = "secbox+l"
	icon_closed = "secbox"

/obj/item/storage/lockbox/medal/med
	name = "医疗勋章盒"
	desc = "一个用于存放授予医疗部门成员的勋章的带锁盒子。"
	req_access = list(ACCESS_CMO)
	icon_state = "medbox+l"
	icon_locked = "medbox+l"
	icon_closed = "medbox"

/obj/item/storage/lockbox/medal/med/PopulateContents()
	new /obj/item/clothing/accessory/medal/med_medal(src)
	new /obj/item/clothing/accessory/medal/med_medal2(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/emergency_services/medical(src)

/obj/item/storage/lockbox/medal/sec/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/security(src)

/obj/item/storage/lockbox/medal/cargo
	name = "货舱奖励盒"
	desc = "一个用于存放授予货舱部门成员的奖励的带锁盒子。"
	req_access = list(ACCESS_QM)
	icon_state = "cargobox+l"
	icon_locked = "cargobox+l"
	icon_closed = "cargobox"

/obj/item/storage/lockbox/medal/cargo/PopulateContents()
	new /obj/item/clothing/accessory/medal/ribbon/cargo(src)

/obj/item/storage/lockbox/medal/service
	name = "服务奖励盒"
	desc = "一个用于存放授予服务部门成员的奖励的带锁盒子。"
	req_access = list(ACCESS_HOP)
	icon_state = "srvbox+l"
	icon_locked = "srvbox+l"
	icon_closed = "srvbox"

/obj/item/storage/lockbox/medal/service/PopulateContents()
	new /obj/item/clothing/accessory/medal/silver/excellence(src)

/obj/item/storage/lockbox/medal/sci
	name = "科学勋章盒"
	desc = "一个用于存放准备授予科学部门成员的勋章的带锁盒子。"
	req_access = list(ACCESS_RD)
	icon_state = "scibox+l"
	icon_locked = "scibox+l"
	icon_closed = "scibox"


/obj/item/storage/lockbox/medal/sci/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/plasma/nobel_science(src)

/obj/item/storage/lockbox/medal/engineering
	name = "工程部勋章盒"
	desc = "一个用于存放准备授予工程部门成员的奖励的带锁盒子。"
	req_access = list(ACCESS_CE)
	icon_state = "engbox+l"
	icon_locked = "engbox+l"
	icon_closed = "engbox"

/obj/item/storage/lockbox/medal/engineering/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/emergency_services/engineering(src)
	new /obj/item/clothing/accessory/medal/silver/elder_atmosian(src)

/obj/item/storage/lockbox/order
	name = "订单锁箱"
	desc = "一个用于保护小型货物订单不被未订购者掠夺的箱子。没错，货运技术员，说的就是你。"
	icon_state = "secure"
	icon_closed = "secure"
	icon_locked = "secure_locked"
	icon_broken = "secure_locked"
	icon_open = "secure"
	inhand_icon_state = "sec-case"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	var/datum/bank_account/buyer_account

/obj/item/storage/lockbox/order/Initialize(mapload, datum/bank_account/_buyer_account)
	. = ..()
	buyer_account = _buyer_account
	ADD_TRAIT(src, TRAIT_NO_MISSING_ITEM_ERROR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NO_MANIFEST_CONTENTS_ERROR, TRAIT_GENERIC)
	//NOVA EDIT ADDITION START
	if(istype(buyer_account, /datum/bank_account/department))
		department_purchase = TRUE
		department_account = buyer_account
	//NOVA EDIT ADDITION END

/obj/item/storage/lockbox/order/can_unlock(mob/living/user, obj/item/card/id/id_card, silent = FALSE)
	if(id_card.registered_account == buyer_account)
		return TRUE
	//NOVA EDIT ADDITION START - private department orders
	if(department_purchase && id_card.registered_account?.account_job?.paycheck_department == department_account.department_id)
		return TRUE
	//NOVA EDIT ADDITION END
	if(!silent)
		balloon_alert(user, "银行账户不正确！")
	return FALSE

/obj/item/storage/lockbox/dueling
	name = "决斗手枪箱"
	desc = "让我们像太空绅士一样解决此事。"
	icon_state = "medalbox+l"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	req_access = list(ACCESS_CAPTAIN)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"
	base_icon_state = "medalbox"
	icon_open = "medalboxopen"
	storage_type = /datum/storage/lockbox/dueling

/obj/item/storage/lockbox/dueling/PopulateContents()
	. = ..()
	var/obj/item/gun/energy/dueling/gun_A = new(src)
	var/obj/item/gun/energy/dueling/gun_B = new(src)
	new /datum/duel(gun_A, gun_B)

/obj/item/storage/lockbox/bitrunning
	name = "基础级奇物"
	desc = "去找程序员谈谈。"
	req_access = list(ACCESS_INACCESSIBLE)
	icon_state = "bitrunning+l"
	inhand_icon_state = "bitrunning"
	base_icon_state = "bitrunning"
	icon_locked = "bitrunning+l"
	icon_closed = "bitrunning"
	icon_broken = "bitrunning+b"
	icon_open = "bitrunning"

/obj/item/storage/lockbox/bitrunning/encrypted
	name = "加密奇物"
	desc = "需要在安全屋解密后才能打开。"
	resistance_flags =  INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	/// Path for the loot we are assigned
	var/loot_path

/obj/item/storage/lockbox/bitrunning/encrypted/emag_act(mob/user, obj/item/card/emag/emag_card)
	return FALSE

/obj/item/storage/lockbox/bitrunning/decrypted
	name = "已解密奇物"
	desc = "从虚拟域编译而来。是成功比特行者获得的额外奖励。"
	storage_type = /datum/storage/lockbox/bitrunning_decrypted

	/// What virtual domain did we come from.
	var/datum/lazy_template/virtual_domain/source_domain

/obj/item/storage/lockbox/bitrunning/decrypted/Initialize(
	mapload,
	datum/lazy_template/virtual_domain/completed_domain,
	)

	if(isnull(completed_domain))
		log_runtime("Decrypted curiosity was created with no source domain.")
		return INITIALIZE_HINT_QDEL

	if(!istype(completed_domain, /datum/lazy_template/virtual_domain)) // Check if this is a proper virtual domain before doing anything with it
		log_runtime("Decrypted curiosity was created with an invalid source domain. [completed_domain.name] ([completed_domain.type]).")
		return INITIALIZE_HINT_QDEL

	source_domain = completed_domain

	. = ..()

	icon_state = icon_closed
	playsound(src, 'sound/effects/magic/blink.ogg', 50, TRUE)

/obj/item/storage/lockbox/bitrunning/decrypted/PopulateContents()
	var/choice = SSbitrunning.pick_secondary_loot(source_domain)
	new choice(src)
