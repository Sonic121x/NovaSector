/obj/item/firing_pin
	name = "电子撞针"
	desc = "一种小型认证装置，需插入枪支接收器内以实现操作。根据纳米传讯枪支安全法规，所有新设计的枪支都必须配备这种装置。"
	icon = 'icons/obj/devices/gunmod.dmi'
	icon_state = "firing_pin"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("pokes")
	attack_verb_simple = list("poke")
	var/fail_message = "invalid user!"
	/// Explode when user check is failed.
	var/selfdestruct = FALSE
	/// Can forcefully replace other pins.
	var/force_replace = FALSE
	/// Can be replaced by any pin.
	var/pin_hot_swappable = FALSE
	///Can be removed from the gun using tools or replaced by a pin with force_replace
	var/pin_removable = TRUE
	var/obj/item/gun/gun
	var/default_pin_auth = TRUE

/obj/item/firing_pin/Destroy()
	if(gun)
		gun_remove()
	return ..()

/obj/item/firing_pin/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isgun(interacting_with))
		return NONE

	var/obj/item/gun/targeted_gun = interacting_with
	var/obj/item/firing_pin/old_pin = targeted_gun.pin
	if(old_pin?.pin_removable && (force_replace || old_pin.pin_hot_swappable))
		if(Adjacent(user))
			user.put_in_hands(old_pin)
		else
			old_pin.forceMove(targeted_gun.drop_location())
		old_pin.gun_remove(user)

	if(!targeted_gun.pin)
		if(!user.temporarilyRemoveItemFromInventory(src))
			return .
		if(gun_insert(user, targeted_gun))
			if(old_pin)
				balloon_alert(user, "已更换击针")
			else
				balloon_alert(user, "已插入击发撞针")
	else
		to_chat(user, span_notice("这把枪械已安装有击发撞针。"))

	return ITEM_INTERACT_SUCCESS

/obj/item/firing_pin/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	balloon_alert(user, "身份验证检查已覆盖")
	return TRUE

/obj/item/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/new_gun, starting = FALSE)
	gun = new_gun
	forceMove(gun)
	gun.pin = src
	SEND_SIGNAL(gun, COMSIG_GUN_PIN_INSERTED, src, user, starting)
	return TRUE

/obj/item/firing_pin/proc/gun_remove(mob/living/user)
	gun.pin = null
	SEND_SIGNAL(gun, COMSIG_GUN_PIN_REMOVED, src, user)
	gun = null
	return

/obj/item/firing_pin/proc/pin_auth(mob/living/user)
	var/result = SEND_SIGNAL(user, COMSIG_LIVING_FIRING_PIN_CHECK, src)
	if(result & ALLOW_FIRE)
		return TRUE
	if(result & BLOCK_FIRE)
		return FALSE
	return default_pin_auth

/obj/item/firing_pin/proc/auth_fail(mob/living/user)
	if(user)
		balloon_alert(user, fail_message)
	if(selfdestruct)
		if(user)
			user.show_message("[span_danger("SELF-DESTRUCTING...")]<br>", MSG_VISUAL)
			to_chat(user, span_userdanger("[gun] 爆炸了！"))
		explosion(src, devastation_range = -1, light_impact_range = 2, flash_range = 3)
		if(gun)
			qdel(gun)


/obj/item/firing_pin/magic
	name = "魔法晶体碎片"
	desc = "一块小小的魔法碎片，能让魔法武器发射出攻击。"


// Test pin, works only near firing range.
/obj/item/firing_pin/test_range
	name = "射击场撞针"
	desc = "这个安全撞针限制武器在靠近射击场时才能进行发射。"
	fail_message = "test range check failed!"
	pin_hot_swappable = TRUE

/obj/item/firing_pin/test_range/pin_auth(mob/living/user)
	if(!istype(user))
		return FALSE
	if (istype(get_area(user), /area/station/security/range))
		return TRUE
	return FALSE


// Implant pin, checks for implant
/obj/item/firing_pin/implant
	name = "植入物撞针"
	desc = "这是一个安全撞针，只有安装了特定设备的用户才能使用它。"
	fail_message = "implant check failed!"
	var/obj/item/implant/req_implant = null

/obj/item/firing_pin/implant/pin_auth(mob/living/user)
	if(user)
		for(var/obj/item/implant/I in user.implants)
			if(req_implant && I.type == req_implant)
				return TRUE
	return FALSE

/obj/item/firing_pin/implant/mindshield
	name = "心盾撞针"
	desc = "这是一个安全撞针，只有注射了心灵护盾的用户才能使用它。"
	icon_state = "firing_pin_loyalty"
	req_implant = /obj/item/implant/mindshield

/obj/item/firing_pin/implant/pindicate
	name = "辛迪加撞针"
	icon_state = "firing_pin_pindi"
	req_implant = /obj/item/implant/weapons_auth



// Honk pin, clown's joke item.
// Can replace other pins. Replace a pin in cap's laser for extra fun!
/obj/item/firing_pin/clown
	name = "滑稽撞针"
	desc = "先进的小丑技术能够将任何枪支改造为更具实用性的物品。"
	color = COLOR_YELLOW
	fail_message = "honk!"
	force_replace = TRUE

/obj/item/firing_pin/clown/pin_auth(mob/living/user)
	playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE)
	return FALSE

// Ultra-honk pin, clown's deadly joke item.
// A gun with ultra-honk pin is useful for clown and useless for everyone else.
/obj/item/firing_pin/clown/ultra
	name = "超滑稽撞针"

/obj/item/firing_pin/clown/ultra/pin_auth(mob/living/user)
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, TRUE)
	if(QDELETED(user))  //how the hell...?
		stack_trace("/obj/item/firing_pin/clown/ultra/pin_auth called with a [isnull(user) ? "null" : "invalid"] user.")
		return TRUE
	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clumsy
		return TRUE
	if(user.mind)
		if(is_clown_job(user.mind.assigned_role)) //traitor clowns can use this, even though they're technically not clumsy
			return TRUE
		if(user.mind.has_antag_datum(/datum/antagonist/nukeop/clownop)) //clown ops aren't clumsy by default and technically don't have an assigned role of "Clown", but come on, they're basically clowns
			return TRUE
		if(user.mind.has_antag_datum(/datum/antagonist/nukeop/leader/clownop)) //Wanna hear a funny joke?
			return TRUE //The clown op leader antag datum isn't a subtype of the normal clown op antag datum.
	return FALSE

/obj/item/firing_pin/clown/ultra/gun_insert(mob/living/user, obj/item/gun/new_gun, starting = FALSE)
	..()
	new_gun.clumsy_check = FALSE

/obj/item/firing_pin/clown/ultra/gun_remove(mob/living/user)
	gun.clumsy_check = initial(gun.clumsy_check)
	..()

// Now two times deadlier!
/obj/item/firing_pin/clown/ultra/selfdestruct
	name = "究超滑稽撞针"
	desc = "先进的小丑技术，可以把任何武器变成更实用的东西。"
	selfdestruct = TRUE


// DNA-keyed pin.
// When you want to keep your toys for yourself.
/obj/item/firing_pin/dna
	name = "DNA锁撞针"
	desc = "一个使用DNA锁定的撞针，仅授权给单个用户。尝试进行首次射击以链接DNA。"
	icon_state = "firing_pin_dna"
	fail_message = "dna check failed!"
	var/unique_enzymes = null

/obj/item/firing_pin/dna/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(iscarbon(interacting_with))
		var/mob/living/carbon/M = interacting_with
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			balloon_alert(user, "DNA锁已设置")
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/item/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(user && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return TRUE
	return FALSE

/obj/item/firing_pin/dna/auth_fail(mob/living/carbon/user)
	if(!unique_enzymes)
		if(user && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			balloon_alert(user, "DNA锁已设置")
	else
		..()

/obj/item/firing_pin/dna/dredd
	desc = "一个使用DNA锁定的撞针，仅授权给单个用户。尝试进行首次射击以链接DNA。这个上面还附带了一个小型爆炸装置。"
	selfdestruct = TRUE

// Paywall pin, brought to you by ARMA 3 DLC.
// Checks if the user has a valid bank account on an ID and if so attempts to extract a one-time payment to authorize use of the gun. Otherwise fails to shoot.
/obj/item/firing_pin/paywall
	name = "收费墙撞针"
	desc = "一个内置了可配置付费墙的撞针."
	color = COLOR_GOLD
	fail_message = ""
	/// List of account IDs which have accepted the license prompt. If this is the multi-payment pin, then this means they accepted the waiver that each shot will cost them money
	var/list/gun_owners = list()
	/// How much gets paid out to license yourself to the gun
	var/payment_amount
	/// Owner of the gun
	var/datum/bank_account/pin_owner
	/// If true, user has to pay everytime they fire the gun
	var/multi_payment = FALSE
	/// Purchase prompt to prevent spamming it, set to the user who opens to prompt to prevent locking the gun up for other users.
	var/active_prompt_user

/obj/item/firing_pin/paywall/attack_self(mob/user)
	multi_payment = !multi_payment
	to_chat(user, span_notice("你将撞针设置为[multi_payment ? "process payment for every shot" : "one-time license payment"]。"))

/obj/item/firing_pin/paywall/examine(mob/user)
	. = ..()
	if(pin_owner)
		. += span_notice("此击发撞针当前已授权向[pin_owner.account_holder]的账户付款。")

/obj/item/firing_pin/paywall/gun_insert(mob/living/user, obj/item/gun/new_gun, starting = FALSE)
	if(pin_owner || starting)
		. = ..()
		gun.desc += span_notice("这把[gun.name]的[multi_payment ? "per-shot" : "license permit"]费用为[payment_amount] [MONEY_NAME_AUTOPURAL(payment_amount)]。")
		return

	if(isnull(user))
		forceMove(new_gun.drop_location())
	else
		to_chat(user, span_warning("错误：安装击发撞针前请先刷取有效的身份识别卡！"))
		user.put_in_hands(src)
	return FALSE

/obj/item/firing_pin/paywall/gun_remove(mob/living/user)
	gun.desc = gun::desc
	. = ..()

/obj/item/firing_pin/paywall/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!isidcard(tool))
		return NONE
	var/obj/item/card/id/id = tool
	if(!id.registered_account)
		to_chat(user, span_warning("错误：身份识别卡缺少已注册的银行账户！"))
		return ITEM_INTERACT_BLOCKING
	if(pin_owner && id.registered_account != pin_owner)
		to_chat(user, span_warning("错误：此击发撞针已被授权！"))
		return ITEM_INTERACT_BLOCKING
	if(id.registered_account == pin_owner)
		to_chat(user, span_notice("你已将卡片与击发撞针解除关联。"))
		gun_owners -= user.get_bank_account()
		pin_owner = null
		return ITEM_INTERACT_SUCCESS
	var/transaction_amount = tgui_input_number(user, "输入购买枪支的有效存款金额", "资金存款")
	if(!transaction_amount || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return ITEM_INTERACT_BLOCKING
	pin_owner = id.registered_account
	payment_amount = transaction_amount
	gun_owners += user.get_bank_account()
	to_chat(user, span_notice("你将卡片与击针链接。"))
	return ITEM_INTERACT_SUCCESS

/obj/item/firing_pin/paywall/pin_auth(mob/living/user)
	if(!istype(user))//nice try commie
		return FALSE
	var/datum/bank_account/credit_card_details = user.get_bank_account()
	if(credit_card_details in gun_owners)
		if(multi_payment && credit_card_details)
			if(!gun.can_shoot())
				return TRUE //So you don't get charged for attempting to fire an empty gun.
			if(credit_card_details.adjust_money(-payment_amount, "Firing Pin: Gun Rent"))
				if(pin_owner)
					pin_owner.adjust_money(payment_amount, "Firing Pin: Payout For Gun Rent")
				return TRUE
			to_chat(user, span_warning("错误：用户余额不足以完成交易！"))
			return FALSE
		return TRUE
	if(!credit_card_details)
		to_chat(user, span_warning("错误：用户没有有效的银行账户来扣除必要资金！"))
		return FALSE
	if(active_prompt_user == user)
		return FALSE
	active_prompt_user = user
	var/license_request = tgui_alert(user, "你愿意支付[payment_amount] [MONEY_NAME_AUTOPURAL(payment_amount)]来[( multi_payment ) ? "each shot of [gun.name]" : "usage license of [gun.name]"]吗？", "武器购买", list("Yes", "No"), 15 SECONDS)
	if(!user.can_perform_action(src))
		active_prompt_user = null
		return FALSE
	switch(license_request)
		if("Yes")
			if(multi_payment)
				gun_owners += credit_card_details
				to_chat(user, span_notice("枪支租赁条款已同意，祝您有安全的一天！"))

			else if(credit_card_details.adjust_money(-payment_amount, "Firing Pin: Gun License"))
				if(pin_owner)
					pin_owner.adjust_money(payment_amount, "Firing Pin: Gun License Bought")
				gun_owners += credit_card_details
				to_chat(user, span_notice("枪支许可证已购买，祝您有安全的一天！"))
			else
				to_chat(user, span_warning("错误：用户余额不足以完成交易！"))

		if("No", null)
			to_chat(user, span_warning("错误：用户拒绝购买枪支许可证！"))

	active_prompt_user = null
	return FALSE //we return false here so you don't click initially to fire, get the prompt, accept the prompt, and THEN the gun

// Explorer Firing Pin- Prevents use on station Z-Level, so it's justifiable to give Explorers guns that don't suck.
/obj/item/firing_pin/explorer
	name = "澳洲撞针"
	desc = "澳大利亚国防军使用的击针，经过改装以防止在空间站上发射武器。"
	icon_state = "firing_pin_explorer"
	fail_message = "cannot fire while on station, mate!"

// This checks that the user isn't on the station Z-level.
/obj/item/firing_pin/explorer/pin_auth(mob/living/user)
	var/turf/station_check = get_turf(user)
	if(!station_check || is_station_level(station_check.z))
		return FALSE
	return TRUE

// Laser tag pins
/obj/item/firing_pin/tag
	name = "镭射标记撞针"
	desc = "一种用于娱乐射击游戏的撞针，其作用是确保玩家都穿戴好背心。"
	fail_message = "suit check failed!"
	default_pin_auth = FALSE
	var/tagcolor = LASERTAG_TEAM_NEUTRAL

/obj/item/firing_pin/tag/auth_fail(mob/living/user)
	. = ..()
	to_chat(user, span_warning("你需要穿着[tagcolor]激光标签护甲！"))

/obj/item/firing_pin/tag/red
	name = "红镭射标记撞针"
	icon_state = "firing_pin_red"
	tagcolor = LASERTAG_TEAM_RED

/obj/item/firing_pin/tag/blue
	name = "蓝镭射标记撞针"
	icon_state = "firing_pin_blue"
	tagcolor = LASERTAG_TEAM_BLUE

/obj/item/firing_pin/monkey
	name = "猴锁击针"
	desc = "这种击针能防止非猴子开枪。"
	fail_message = "not a monkey!"

/obj/item/firing_pin/monkey/pin_auth(mob/living/user)
	if(!is_simian(user))
		playsound(src, SFX_SCREECH, 75, TRUE)
		return FALSE
	return TRUE
