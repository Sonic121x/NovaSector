/obj/item/clothing/erp_leash
	name = "牵引绳"
	desc = "引导之手的挚友；采用时尚的半弹性包装。既可以夹在项圈上，也可以单独固定在颈部。"
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_belts.dmi'
	greyscale_colors = "#383840#dc7ef4#d1d3e0"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/erp_leash"
	post_init_icon_state = "neckleash"
	greyscale_config = /datum/greyscale_config/neckleash
	greyscale_config_worn = /datum/greyscale_config/neckleash/worn
	equip_sound = 'sound/items/equip/toolbelt_equip.ogg'
	drop_sound = 'sound/items/handling/toolbelt_drop.ogg'
	slot_flags = ITEM_SLOT_BELT
	obj_flags_nova = ERP_ITEM
	breakouttime = 3 SECONDS
	flags_1 = IS_PLAYER_COLORABLE_1

	/// Weakref to the leash component we're using, if it exists.
	var/datum/weakref/our_leash_component

	COOLDOWN_DECLARE(tug_cd)

/// HERE BE DRAGONS ///

/// Checks; leashing start
/obj/item/clothing/erp_leash/attack(mob/living/carbon/human/to_be_leashed, mob/living/user, params)
	var/datum/component/leash/erp/the_leash_component = our_leash_component?.resolve()
	if(the_leash_component)
		if(the_leash_component.parent == to_be_leashed) // We're hooked to them; and we have a component. Get 'em out!
			remove_leash(to_be_leashed)
			return
	else
		our_leash_component = null
	/// Check if we even CAN leash someone / if someone is leashing themselves. If so; prevent it.
	if(!istype(to_be_leashed) || user == to_be_leashed)
		return
	/// Check their ERP prefs; if they don't allow sextoys: BTFO
	if(!to_be_leashed.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, user, src))
		to_chat(user, span_danger("[to_be_leashed] 不想让你这么做。"))
		return
	/// Actually start the leashing part here
	to_be_leashed.visible_message(span_warning("[user] 将 [src] 举到 [to_be_leashed] 的颈部！"),\
				span_userdanger("[user] 开始将 [src] 带到你的颈部！"),\
				span_hear("你听到一声轻微的咔哒声，颈部的空气压力开始增加。"))
	if(!do_after(user, 2 SECONDS, to_be_leashed))
		return
	create_leash(user, to_be_leashed)

/// Leash Initialization
/obj/item/clothing/erp_leash/proc/create_leash(mob/user, mob/ouppy)
	if(!istype(ouppy))
		return

	ouppy.AddComponent(/datum/component/leash/erp, src, 2)
	if(our_leash_component.resolve()) // The component will immediately delete itself if there's an existing one; this sanity checks for feedback on if it failed.
		ouppy.balloon_alert(user, "已系上牵绳！")
		return
	else to_chat(user, span_danger("[ouppy] 身上已经系有牵引绳了。"))

/// Leash removal
/obj/item/clothing/erp_leash/proc/remove_leash(mob/free_bird)
	free_bird?.balloon_alert_to_viewers("unhooked")
	qdel(our_leash_component.resolve())

/*
	Leash Component
*/

/datum/component/leash/erp
	dupe_mode = COMPONENT_DUPE_UNIQUE

// 'owner' refers the leash item, while 'parent' refers to the one it's affixed to.
/datum/component/leash/erp/RegisterWithParent()
	. = ..()
	// Owner Signals
	RegisterSignal(owner, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_item_attack_self))
	RegisterSignal(owner, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))
	// Parent Signals
	RegisterSignal(parent, COMSIG_LIVING_RESIST, PROC_REF(on_parent_resist))
	if(istype(owner, /obj/item/clothing/erp_leash))
		var/obj/item/clothing/erp_leash/our_leash = owner
		our_leash.our_leash_component = WEAKREF(src)

/datum/component/leash/erp/UnregisterFromParent()
	if(owner) // Destroy() sets owner to null
		UnregisterSignal(owner, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_DROPPED))
		UnregisterSignal(parent, COMSIG_LIVING_RESIST)
	return ..()

/datum/component/leash/erp/Destroy() // Have to do this here too
	UnregisterSignal(owner, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_DROPPED))
	if(istype(owner, /obj/item/clothing/erp_leash))
		var/obj/item/clothing/erp_leash/our_leash = owner
		our_leash.our_leash_component = null
	return ..()


/datum/component/leash/erp/proc/on_item_attack_self(datum/source, mob/user)
	SIGNAL_HANDLER

	if(istype(source, /obj/item/clothing/erp_leash))
		var/obj/item/clothing/erp_leash/leash_hookin = source
		if(!COOLDOWN_FINISHED(leash_hookin, tug_cd))
			return
		if(istype(parent, /mob/living))
			var/mob/living/yoinked = parent
			yoinked.Move(get_step_towards(yoinked,user))
			yoinked.adjust_stamina_loss(10)
			yoinked.visible_message(span_warning("[yoinked] 被拉了过来，因为 [user] 拽动了 [source]！"),\
					span_userdanger("[user] 突然拽动 [source]，将你拉得更近！"),\
					span_userdanger("颈部传来一阵突然的拉扯，将你向前拽去！"))
			COOLDOWN_START(leash_hookin, tug_cd, 1 SECONDS)

/datum/component/leash/erp/proc/on_item_dropped(datum/source, mob/user)
	SIGNAL_HANDLER

	if(istype(parent, /mob))
		var/mob/our_parent = parent
		our_parent.balloon_alert_to_viewers("unhooked")
	qdel(src)

/datum/component/leash/erp/proc/on_parent_resist(datum/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(do_resist))

/datum/component/leash/erp/proc/do_resist(datum/source, mob/user)
	if(istype(parent, /mob) && istype(owner,/obj/item))
		var/mob/our_parent = parent
		var/obj/item/our_owner = owner
		our_parent.visible_message(span_warning("[our_parent] 试图将 [our_parent.p_them()] 自己从牵引绳上解开！"), \
			span_userdanger("你开始将自己从牵引绳上解开..."), \
			span_userdanger("你在黑暗中摸索着，试图解开牵引绳..."))
		if(do_after(our_parent, our_owner.breakouttime, target = our_parent))
			to_chat(our_parent, span_notice("你将自己从牵引绳上解开了。"))
			qdel(src)
	else qdel(src) // If they're not an item; something is very wrong - qdel anyways without the breakout time.
