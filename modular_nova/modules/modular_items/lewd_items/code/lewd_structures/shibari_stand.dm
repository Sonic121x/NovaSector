/obj/structure/chair/shibari_stand
	name = "绳缚架"
	desc = "一个用于用绳索固定人的架子。"
	max_integrity = 75
	layer = 4
	item_chair = null
	buildstacktype = null
	///Overlays for ropes
	var/static/mutable_appearance/shibari_rope_overlay
	var/static/mutable_appearance/shibari_rope_overlay_behind
	var/static/mutable_appearance/shibari_shadow_overlay = mutable_appearance('modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_structures/shibari_stand.dmi', "shibari_shadow", LOW_OBJ_LAYER)

	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/structure/chair/shibari_stand"
	post_init_icon_state = "shibari_stand"
	greyscale_config = /datum/greyscale_config/shibari_stand
	greyscale_colors = "#bd8fcf"
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

	///obviously, this is for doing things to the currentmob
	var/mob/living/carbon/human/current_mob = null

	///The rope inside the stand, that's actually tying the person to it
	var/obj/item/stack/shibari_rope/ropee = null

/obj/structure/chair/shibari_stand/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tool_blocker, TOOL_WRENCH, TOOL_ACT_SECONDARY)

/obj/structure/chair/shibari_stand/MakeRotate()
	return

/obj/structure/chair/shibari_stand/Destroy()
	cut_overlay(shibari_shadow_overlay)
	cut_overlay(shibari_rope_overlay)
	cut_overlay(shibari_rope_overlay_behind)
	if(!QDELETED(ropee))
		ropee.forceMove(get_turf(src))
	ropee = null
	. = ..()
	if(!QDELETED(current_mob))
		if(current_mob.handcuffed)
			current_mob.handcuffed.dropped(current_mob)
		current_mob.set_handcuffed(null)
		current_mob.update_abstract_handcuffed()
		current_mob = null
	unbuckle_all_mobs(TRUE)

//Examine changes for this structure
/obj/structure/chair/shibari_stand/examine(mob/user)
	. = ..()
	if(!has_buckled_mobs() && can_buckle)
		. += span_notice("他们需要穿着<b>全身绳缚装</b>，并且你需要<b>手持绳索</b>！")

/obj/structure/chair/shibari_stand/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	var/mob/living/buckled = buckled_mob
	if(buckled)
		if(buckled != user)
			buckled.visible_message(span_notice("[user]开始将[buckled]从[src]上解开。"),\
				span_notice("[user]试图将你从[src]上解开。"),\
				span_hear("你听到松开的绳索声。"))
			if(!do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 5 SECONDS : 10 SECONDS, buckled))
				return FALSE
			buckled.visible_message(span_notice("[user]将[buckled]从[src]上解开了。"),\
				span_notice("[user]将你从[src]上解开了。"),\
				span_hear("你听到松开的绳索声。"))
		else
			user.visible_message(span_notice("[user]开始将自己从[src]上解开。"),\
				span_notice("[user]将自己从[src]上解开了。"),\
				span_hear("你听到松开的绳索声。"))
		add_fingerprint(user)
		if(isliving(buckled.pulledby))
			var/mob/living/living_mob = buckled.pulledby
			living_mob.set_pull_offsets(buckled, living_mob.grab_state)
	unbuckle_mob(buckled_mob)
	return buckled

/obj/structure/chair/shibari_stand/user_buckle_mob(mob/living/buckled, mob/user, check_loc = TRUE)

	if(!buckled.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, user, src))
		to_chat(user, span_danger("看起来[buckled]不想让你这么做。"))
		return FALSE

	if(!is_user_buckle_possible(buckled, user, check_loc))
		return FALSE
	add_fingerprint(user)

	if(!ishuman(buckled))
		return FALSE

	var/mob/living/carbon/human/hooman = buckled
	if(!(istype(hooman.w_uniform, /obj/item/clothing/under/shibari/full)))
		to_chat(user, span_warning("你需要完全绑住他们的身体！"))
		return FALSE
	if(!istype(user.get_active_held_item(), /obj/item/stack/shibari_rope))
		to_chat(user, span_warning("你需要手持绳缚绳索才能将他们绑到架子上！！"))
		return FALSE

	if(buckled != user)
		buckled.visible_message(span_warning("[user] 开始将 [buckled] 绑到 \the [src] 上！"),\
			span_userdanger("[user] 开始把你绑到 \the [src] 上！"),\
			span_hear("你听到绳索被拉紧的声音。"))
		if(!do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 5 SECONDS : 10 SECONDS, buckled))
			return FALSE

		if(!is_user_buckle_possible(buckled, user, check_loc))
			return FALSE

		if(!(istype(hooman.w_uniform, /obj/item/clothing/under/shibari/full)))
			to_chat(user, span_warning("你需要完全绑住他们的身体！"))
			return FALSE
		if(!istype(user.get_active_held_item(), /obj/item/stack/shibari_rope))
			to_chat(user, span_warning("你需要手持绳缚绳索才能将他们绑到架子上！"))
			return FALSE

		if(buckle_mob(buckled, check_loc = check_loc))
			var/obj/item/stack/shibari_rope/rope = user.get_active_held_item()
			ropee = new()
			ropee.set_greyscale(rope.greyscale_colors)
			rope.use(1)
			add_overlay(shibari_shadow_overlay)
			add_rope_overlays(ropee.greyscale_colors, hooman?.dna?.mutant_bodyparts[FEATURE_TAUR])
			buckled.visible_message(span_warning("[user] 把 [buckled] 绑到了 \the [src] 上！"),\
				span_userdanger("[user] 把你绑到了 \the [src] 上！"),\
				span_hear("你听到绳索被完全收紧的声音。"))
			return TRUE
		else
			return FALSE
	else
		to_chat(user, span_warning("你无法将自己绑在这个架子上，那种程度的自我束缚根本不可能存在！"))
		return FALSE

/obj/structure/chair/shibari_stand/atom_deconstruct(disassembled)
	qdel(src)

/obj/structure/chair/shibari_stand/proc/add_rope_overlays(color, taur)
	cut_overlay(shibari_rope_overlay)
	cut_overlay(shibari_rope_overlay_behind)
	var/icon/rope_overlays = SSgreyscale.GetColoredIconByType(/datum/greyscale_config/shibari_stand_ropes, color)
	shibari_rope_overlay = mutable_appearance(rope_overlays, "ropes_above[taur ? "_snek" : ""]", ABOVE_MOB_LAYER)
	shibari_rope_overlay_behind = mutable_appearance(rope_overlays, "ropes_behind", BELOW_MOB_LAYER)
	add_overlay(shibari_rope_overlay)
	add_overlay(shibari_rope_overlay_behind)

/obj/structure/chair/shibari_stand/post_buckle_mob(mob/living/buckled)
	buckled.add_offsets(type, y_add = 4)
	buckled.layer = BELOW_MOB_LAYER

	if(LAZYLEN(buckled_mobs))
		if(ishuman(buckled_mobs[1]))
			current_mob = buckled_mobs[1]

	if(current_mob)
		if(current_mob.handcuffed)
			current_mob.handcuffed.forceMove(loc)
			current_mob.handcuffed.dropped(current_mob)
			current_mob.set_handcuffed(null)

		var/obj/item/restraints/handcuffs/milker/shibari/cuffs = new (current_mob)
		current_mob.set_handcuffed(cuffs)
		cuffs.parent_chair = WEAKREF(src)
		if(HAS_TRAIT(current_mob, TRAIT_ROPEBUNNY))
			current_mob.handcuffed.breakouttime = 4 MINUTES
		current_mob.update_abstract_handcuffed()

//Restore the position of the mob after unbuckling.
/obj/structure/chair/shibari_stand/post_unbuckle_mob(mob/living/buckled)
	buckled.remove_offsets(type)
	buckled.layer = initial(buckled.layer)

	cut_overlay(shibari_shadow_overlay)
	cut_overlay(shibari_rope_overlay)
	cut_overlay(shibari_rope_overlay_behind)

	if(current_mob)
		if(current_mob.handcuffed)
			current_mob.handcuffed.dropped(current_mob)
		current_mob.set_handcuffed(null)
		current_mob.update_abstract_handcuffed()

	if(ropee)
		ropee.forceMove(get_turf(src))
	current_mob = null

/obj/item/restraints/handcuffs/milker/shibari
	name = "绳索"
	desc = "一根用于束缚双手的缚绳。"
	breakouttime = 2 MINUTES

//Disassembling shibari stand
/obj/structure/chair/shibari_stand/click_ctrl_shift(mob/user)
	to_chat(user, span_notice("你开始拆卸 \the [src] 的框架..."))
	if(!do_after(user, 8 SECONDS, src))
		to_chat(user, span_warning("你未能拆解 \the [src]。"))
		return FALSE

	to_chat(user, span_notice("你拆解了 \the [src]。"))
	var/obj/item/construction_kit/bdsm/shibari/kit = new(get_turf(src))
	kit.set_greyscale(greyscale_colors)
	unbuckle_all_mobs()
	qdel(src)
	return TRUE

//Changing color of shibari stand
/obj/structure/chair/shibari_stand/click_ctrl(mob/user)
	var/list/allowed_configs = list()
	allowed_configs += "[greyscale_config]"
	var/datum/greyscale_modify_menu/menu = new(
		src, usr, allowed_configs, null, \
		starting_icon_state = icon_state, \
		starting_config = greyscale_config, \
		starting_colors = greyscale_colors
	)
	menu.ui_interact(usr)
	to_chat(user, span_notice("你切换了框架塑料配件的颜色。"))
	return CLICK_ACTION_SUCCESS

/obj/structure/chair/shibari_stand/examine(mob/user)
	. = ..()
	. += span_purple("[src] 可以通过使用 <b>Ctrl+Shift+点击<b> 来拆解。")
	. += span_purple("[src] 的颜色可以通过 <b>Ctrl+点击</b> 来自定义。")
