#define HYPO_INJECT 1
#define HYPO_SPRAY 0

#define WAIT_INJECT 1.5 SECONDS
#define WAIT_SPRAY 1.5 SECONDS
#define SELF_INJECT 2 SECONDS
#define SELF_SPRAY 2 SECONDS

#define DELUXE_WAIT_INJECT 0.5 SECONDS
#define DELUXE_WAIT_SPRAY 0.5 SECONDS
#define DELUXE_SELF_INJECT 1 SECONDS
#define DELUXE_SELF_SPRAY 1 SECONDS

#define COMBAT_WAIT_INJECT 0
#define COMBAT_WAIT_SPRAY 0
#define COMBAT_SELF_INJECT 0
#define COMBAT_SELF_SPRAY 0

/obj/item/hypospray/mkii
	name = "注射器 Mk.II"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "hypo2"
	icon = 'modular_nova/modules/hyposprays/icons/hyposprays.dmi'
	greyscale_config = /datum/greyscale_config/hypospray_mkii
	desc = "这是DeForest医疗公司的新产品，这款注射器使用50单位的小瓶作为药物供应，便于更换。"
	w_class = WEIGHT_CLASS_TINY
	/// Allowed types for insertion into the vial slot.  These should always be hypovial subtypes.
	var/list/allowed_containers = list(/obj/item/reagent_containers/cup/vial/small)
	/// The presently-inserted vial.
	var/obj/item/reagent_containers/cup/vial/vial
	/// If the Hypospray starts with a vial, which vial does it start with?
	var/obj/item/reagent_containers/cup/vial/start_vial

	/// Time taken to inject others
	var/inject_wait = WAIT_INJECT
	/// Time taken to spray others
	var/spray_wait = WAIT_SPRAY
	/// Time taken to inject self
	var/inject_self = SELF_INJECT
	/// Time taken to spray self
	var/spray_self = SELF_SPRAY

	/// Can you hotswap vials?
	var/quickload = TRUE
	/// Does it penetrate clothing?
	var/penetrates = null
	/// What options for injection amount does this hypospray frame support?
	var/list/possible_transfer_amounts = list(1,3,5,10,15)
	/// Currently-selected maximum transfer amount.
	var/amount_per_transfer = 1

	/// Used for GAGS-ified hypos.
	var/gags_bodystate = "hypo2_normal"
	/// The original icon file where our overlays reside.
	var/original_icon = 'modular_nova/modules/hyposprays/icons/hyposprays.dmi'

/obj/item/hypospray/mkii/deluxe
	name = "注射器 Mk.II 豪华版"
	allowed_containers = list(/obj/item/reagent_containers/cup/vial/small, /obj/item/reagent_containers/cup/vial/large)
	icon_state = "bighypo2"
	gags_bodystate = "hypo2_deluxe"
	desc = "DeForest注射器Mk. II系列的豪华变体，能够同时容纳100u和50u的小瓶。"

/obj/item/hypospray/mkii/piercing
	name = "注射器 Mk.II 高级版"
	icon_state = "piercinghypo2"
	gags_bodystate = "hypo2_piercing"
	desc = "DeForest注射器Mk. II系列的高级变体，能够穿透厚重的护甲。"
	penetrates = INJECT_CHECK_PENETRATE_THICK

/obj/item/hypospray/mkii/piercing/atropine
	start_vial = /obj/item/reagent_containers/cup/vial/small/atropine

// Deluxe hypo upgrade Kit
/obj/item/device/custom_kit/deluxe_hypo2
	name = "注射器 Mk.II 豪华版改装套件"
	desc = "将DeForest注射器Mk. II升级以支持更大的小瓶。"
	// don't tinker with a loaded (medi)gun. fool
	from_obj = /obj/item/hypospray/mkii
	to_obj = /obj/item/hypospray/mkii/deluxe

/obj/item/device/custom_kit/deluxe_hypo2/pre_convert_check(obj/target_obj, mob/user)
	var/obj/item/hypospray/mkii/our_hypo = target_obj
	if(our_hypo.type in subtypesof(/obj/item/hypospray/mkii/))
		balloon_alert(user, "仅适用于基础型 mk. ii 注射器！")
		return FALSE
	if(our_hypo.vial != null)
		balloon_alert(user, "先取出药瓶！")
		return FALSE
	return TRUE

/obj/item/hypospray/mkii/deluxe/cmo
	name = "注射器 Mk.II 豪华版：医疗总监特别版"
	icon_state = "cmo2"
	gags_bodystate = "hypo2_cmo"
	desc = "医疗总监珍视的注射器Mk. II豪华版，能够同时容纳100u和50u的小瓶，作用更快，可穿透护甲，并且每次喷射能输送更多试剂。"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	inject_wait = DELUXE_WAIT_INJECT
	spray_wait = DELUXE_WAIT_SPRAY
	spray_self = DELUXE_SELF_SPRAY
	inject_self = DELUXE_SELF_INJECT
	penetrates = INJECT_CHECK_PENETRATE_THICK
	possible_transfer_amounts = list(0.1,1,3,5,10,15,20,30)

/obj/item/hypospray/mkii/deluxe/cmo/combat
	name = "注射器 Mk.II 豪华版：战斗版"
	icon_state = "combat2"
	gags_bodystate = "hypo2_tactical"
	desc = "注射器Mk. II豪华版的变体，能够同时容纳100u和50u的小瓶，配备过载高容量注射头和穿甲针头。"
	// Made non-indestructible since this is typically an admin spawn.  still robust though!
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	inject_wait = COMBAT_WAIT_INJECT
	spray_wait = COMBAT_WAIT_SPRAY
	spray_self = COMBAT_SELF_INJECT
	inject_self = COMBAT_SELF_SPRAY
	penetrates = INJECT_CHECK_PENETRATE_THICK

/obj/item/hypospray/mkii/interdyne
	name = "注射器 Mk.II-Y"
	allowed_containers = list(/obj/item/reagent_containers/cup/vial/interdyne_medium)
	icon_state = "interdyne2"
	gags_bodystate = "hypo2_interdyne"
	desc = "Interdyne的专业注射器型号，采用改进的Mk. II内部结构和坚固的机身框架，适合使用外部高容量小瓶。"
	inject_wait = DELUXE_WAIT_INJECT
	spray_wait = DELUXE_WAIT_SPRAY
	spray_self = DELUXE_SELF_SPRAY
	inject_self = DELUXE_SELF_INJECT
	penetrates = INJECT_CHECK_PENETRATE_THICK

/obj/item/hypospray/mkii/interdyne/deckoff
	name = "高级型 Mk.II-Y 注射器"
	icon_state = "interdynedeck2"
	gags_bodystate = "hypo2_interdynedeck"
	desc = "这是辛迪加专用注射器型号的进一步升级版，采用了改进和超频的 Mk. II 内部组件，以及一个坚固的、适合外接大容量药瓶的机身框架。"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	inject_wait = COMBAT_WAIT_INJECT
	spray_wait = COMBAT_WAIT_SPRAY
	spray_self = COMBAT_SELF_INJECT
	inject_self = COMBAT_SELF_SPRAY
	possible_transfer_amounts = list(0.1,1,3,5,10,15,20,30)

/obj/item/hypospray/mkii/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	if(!isnull(start_vial))
		vial = new start_vial
		update_appearance()

/obj/item/hypospray/mkii/update_overlays()
	. = ..()
	if(!vial)
		return
	if(vial.reagents.total_volume)
		var/vial_spritetype = "chem-color"
		if(istype(vial, /obj/item/reagent_containers/cup/vial/large))
			vial_spritetype += "[vial.type_suffix]"
		else
			vial_spritetype += "-s"
		var/mutable_appearance/chem_loaded = mutable_appearance(original_icon, vial_spritetype)
		chem_loaded.color = vial.chem_color
		. += chem_loaded
	if(vial.greyscale_colors != null)
		var/mutable_appearance/vial_overlay = mutable_appearance(original_icon, "[vial.icon_state]-body")
		vial_overlay.color = vial.greyscale_colors
		. += vial_overlay
		var/mutable_appearance/vial_overlay_glass = mutable_appearance(original_icon, "[vial.icon_state]-glass")
		. += vial_overlay_glass
	else
		var/mutable_appearance/vial_overlay = mutable_appearance(original_icon, vial.icon_state)
		. += vial_overlay

/obj/item/hypospray/mkii/examine(mob/user)
	. = ..()
	if(vial)
		. += "[vial] has [vial.reagents.total_volume]u remaining."
	else
		. += "It has no vial loaded in."
	. += span_notice("Ctrl-Shift-点击以更改颜色或重置。")
	. += span_notice("手持时左键或右键点击以增加或减少其单次注射量。当前设置为 [amount_per_transfer] 单位。")

/obj/item/hypospray/mkii/click_ctrl_shift(mob/user)
	var/choice = tgui_input_list(user, "将注射器GAGS化还是重置为默认？", "外观", list("GAGS", "Nope"))
	if(choice == "GAGS")
		icon_state = gags_bodystate
		//choices go here
		var/atom/fake_atom = src
		var/list/allowed_configs = list()
		var/config = initial(fake_atom.greyscale_config)
		allowed_configs += "[config]"
		if(greyscale_colors == null)
			greyscale_colors = "#00AAFF#FFAA00"

		var/datum/greyscale_modify_menu/menu = new(src, usr, allowed_configs)
		menu.ui_interact(usr)
	else
		icon_state = initial(icon_state)
		icon = original_icon
		greyscale_colors = null

/obj/item/hypospray/mkii/proc/unload_hypo(obj/item/hypo, mob/user)
	if((istype(hypo, /obj/item/reagent_containers/cup/vial)))
		var/obj/item/reagent_containers/cup/vial/container = hypo
		container.forceMove(user.loc)
		user.put_in_hands(container)
		to_chat(user, span_notice("你从 [src] 中取出了 [vial]。"))
		vial = null
		update_icon()
		playsound(loc, 'sound/items/weapons/empty.ogg', 50, 1)
	else
		to_chat(user, span_notice("这个注射器没有装药瓶！"))
		return

/obj/item/hypospray/mkii/proc/insert_vial(obj/item/new_vial, mob/living/user)
	if(!is_type_in_list(new_vial, allowed_containers))
		to_chat(user, span_notice("[src] 不接受这种类型的药瓶。"))
		return FALSE
	var/atom/quickswap_loc = new_vial.loc
	if(!user.transferItemToLoc(new_vial, src))
		return FALSE
	if(!isnull(vial))
		if(quickswap_loc == user)
			user.put_in_hands(vial)
		else
			vial.forceMove(quickswap_loc)
	vial = new_vial
	user.visible_message(span_notice("[user] 已将药瓶装入 [src]。"), span_notice("你已将 [vial] 装入 [src]。"))
	playsound(loc, 'sound/items/weapons/autoguninsert.ogg', 35, 1)
	update_appearance()

/obj/item/hypospray/mkii/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/reagent_containers/cup/vial))
		return NONE
	if(isnull(vial) || quickload)
		insert_vial(tool, user)
		return ITEM_INTERACT_SUCCESS
	to_chat(user, span_warning("[src] 最多只能容纳一个药瓶！"))
	return ITEM_INTERACT_BLOCKING

/obj/item/hypospray/mkii/attack_self(mob/user)
	. = ..()
	change_transfer_amount(user, FORWARD)
	return TRUE

/obj/item/hypospray/mkii/attack_self_secondary(mob/user)
	. = ..()
	change_transfer_amount(user, BACKWARD)
	return TRUE

/obj/item/hypospray/mkii/proc/change_transfer_amount(mob/user, direction = FORWARD)
	var/list_len = length(possible_transfer_amounts)
	if(!list_len)
		return
	var/index = possible_transfer_amounts.Find(amount_per_transfer) || 1
	switch(direction)
		if(FORWARD)
			index = (index % list_len) + 1
		if(BACKWARD)
			index = (index - 1) || list_len
		else
			CRASH("change_transfer_amount() called with invalid direction value")
	amount_per_transfer = possible_transfer_amounts[index]
	balloon_alert(user, "正在转移[amount_per_transfer]单位")

/obj/item/hypospray/mkii/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		to_chat(user, "[src] 碰巧已经过载了。")
		return FALSE
	if(inject_wait == DELUXE_WAIT_INJECT)
		inject_wait = COMBAT_WAIT_INJECT
		spray_wait = COMBAT_WAIT_SPRAY
		spray_self = COMBAT_SELF_INJECT
		inject_self = COMBAT_SELF_SPRAY
	else
		inject_wait = DELUXE_WAIT_INJECT
		spray_wait = DELUXE_WAIT_SPRAY
		spray_self = DELUXE_SELF_INJECT
		inject_self = DELUXE_SELF_SPRAY
	to_chat(user, "你使 [src] 的控制电路过载了。")
	obj_flags |= EMAGGED
	return TRUE

/obj/item/hypospray/mkii/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/item/reagent_containers/cup/vial))
		insert_vial(interacting_with, user)
		return ITEM_INTERACT_SUCCESS
	return do_inject(interacting_with, user, mode=HYPO_SPRAY)

/obj/item/hypospray/mkii/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	return do_inject(interacting_with, user, mode=HYPO_INJECT)

/obj/item/hypospray/mkii/proc/do_inject(mob/living/injectee, mob/living/user, mode)
	if(!isliving(injectee))
		return NONE

	if(!injectee.reagents || !injectee.can_inject(user, user.zone_selected, penetrates))
		return NONE

	if(iscarbon(injectee))
		var/obj/item/bodypart/affecting = injectee.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			to_chat(user, span_warning("该肢体缺失！"))
			return ITEM_INTERACT_BLOCKING
	//Always log attemped injections for admins
	var/contained = vial.reagents.get_reagent_log_string()
	log_combat(user, injectee, "attemped to inject", src, addition="which had [contained]")

	if(!vial)
		to_chat(user, span_notice("[src] 没有安装任何药瓶！"))
		return ITEM_INTERACT_BLOCKING
	if(!vial.reagents.total_volume)
		to_chat(user, span_notice("[src] 的药瓶是空的！"))
		return ITEM_INTERACT_BLOCKING

	var/fp_verb = mode == HYPO_SPRAY ? "spray" : "inject"

	if(injectee != user)
		injectee.visible_message(span_danger("[user] 正试图用 [src] [fp_verb] [injectee]！"), \
						span_userdanger("[user] 正试图用 [src] [fp_verb] 你！"))

	var/selected_wait_time
	if(injectee == user)
		selected_wait_time = (mode == HYPO_INJECT) ? inject_self : spray_self
	else
		selected_wait_time = (mode == HYPO_INJECT) ? inject_wait : spray_wait

	if(!do_after(user, selected_wait_time, injectee, extra_checks = CALLBACK(injectee, /mob/living/proc/can_inject, user, user.zone_selected, penetrates)))
		return ITEM_INTERACT_BLOCKING
	if(!vial || !vial.reagents.total_volume)
		return ITEM_INTERACT_BLOCKING
	log_attack("<font color='red'>[user.name] ([user.ckey]) applied [src] to [injectee.name] ([injectee.ckey]), which had [contained] (COMBAT MODE: [uppertext(user.combat_mode)]) (MODE: [mode])</font>")
	if(injectee != user)
		injectee.visible_message(span_danger("[user] 对 [injectee] 使用了 [src]！"), \
						span_userdanger("[user] 对你使用了 [src]！"))
	else
		injectee.log_message("<font color='orange'>applied [src] to themselves ([contained]).</font>", LOG_ATTACK)

	switch(mode)
		if(HYPO_INJECT)
			vial.reagents.trans_to(injectee, amount_per_transfer, methods = INJECT)
		if(HYPO_SPRAY)
			vial.reagents.trans_to(injectee, amount_per_transfer, methods = PATCH)

	var/long_sound = amount_per_transfer >= 15
	playsound(loc, long_sound ? 'modular_nova/modules/hyposprays/sound/hypospray_long.ogg' : pick('modular_nova/modules/hyposprays/sound/hypospray.ogg','modular_nova/modules/hyposprays/sound/hypospray2.ogg'), 50, 1, -1)
	to_chat(user, span_notice("你[fp_verb]了[amount_per_transfer]单位的溶液。注射器的药筒现在含有[vial.reagents.total_volume]单位。"))
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/hypospray/mkii/attack_hand(mob/living/user)
	if(user && loc == user && user.is_holding(src))
		if(user.incapacitated)
			return
		else if(!vial)
			. = ..()
			return
		else
			unload_hypo(vial,user)
	else
		. = ..()

/obj/item/hypospray/mkii/examine(mob/user)
	. = ..()
	. += span_notice("<b>左键点击</b>病人进行喷洒，<b>右键点击</b>进行注射。")

#undef HYPO_INJECT
#undef HYPO_SPRAY
#undef WAIT_INJECT
#undef WAIT_SPRAY
#undef SELF_INJECT
#undef SELF_SPRAY
#undef DELUXE_WAIT_INJECT
#undef DELUXE_WAIT_SPRAY
#undef DELUXE_SELF_INJECT
#undef DELUXE_SELF_SPRAY
#undef COMBAT_WAIT_INJECT
#undef COMBAT_WAIT_SPRAY
#undef COMBAT_SELF_INJECT
#undef COMBAT_SELF_SPRAY
