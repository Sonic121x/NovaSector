/obj/item/clothing/erp_leash
	name = "leash"
	desc = "A guiding hand's best friend; in a sleek, semi-elastic package. Can either clip to a collar or be affixed to the neck on its own."
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
		to_chat(user, span_danger(LANG("obj.8d0a01828f0e2a19", list(to_be_leashed))))
		return
	/// Actually start the leashing part here
	to_be_leashed.visible_message(span_warning(LANG("obj.5d701de907728e46", list(user, src, to_be_leashed))),\
				span_userdanger(LANG("obj.4407d34feaecfc93", list(user, src))),\
				span_hear(LANG("obj.8f9d9ca9f163f537", null)))
	if(!do_after(user, 2 SECONDS, to_be_leashed))
		return
	create_leash(user, to_be_leashed)

/// Leash Initialization
/obj/item/clothing/erp_leash/proc/create_leash(mob/user, mob/ouppy)
	if(!istype(ouppy))
		return

	ouppy.AddComponent(/datum/component/leash/erp, src, 2)
	if(our_leash_component.resolve()) // The component will immediately delete itself if there's an existing one; this sanity checks for feedback on if it failed.
		ouppy.balloon_alert(user, LANG("obj.39eed4859fba2806", null))
		return
	else to_chat(user, span_danger(LANG("obj.264e86d2f58bcffe", list(ouppy))))

/// Leash removal
/obj/item/clothing/erp_leash/proc/remove_leash(mob/free_bird)
	free_bird?.balloon_alert_to_viewers(LANG("obj.78b1b0415f7b8fb9", null))
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
			yoinked.visible_message(span_warning(LANG("datum.adc2a27b55a4a24c", list(yoinked, user, source))),\
					span_userdanger(LANG("datum.23918ada7d84743e", list(user, source))),\
					span_userdanger(LANG("datum.edf79728f384539c", null)))
			COOLDOWN_START(leash_hookin, tug_cd, 1 SECONDS)

/datum/component/leash/erp/proc/on_item_dropped(datum/source, mob/user)
	SIGNAL_HANDLER

	if(istype(parent, /mob))
		var/mob/our_parent = parent
		our_parent.balloon_alert_to_viewers(LANG("datum.78b1b0415f7b8fb9", null))
	qdel(src)

/datum/component/leash/erp/proc/on_parent_resist(datum/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(do_resist))

/datum/component/leash/erp/proc/do_resist(datum/source, mob/user)
	if(istype(parent, /mob) && istype(owner,/obj/item))
		var/mob/our_parent = parent
		var/obj/item/our_owner = owner
		our_parent.visible_message(span_warning(LANG("datum.3b0ace6fe48d0caa", list(our_parent, our_parent.p_them()))), \
			span_userdanger(LANG("datum.f501b9fee7c4424a", null)), \
			span_userdanger(LANG("datum.4c6015eb79c8cb42", null)))
		if(do_after(our_parent, our_owner.breakouttime, target = our_parent))
			to_chat(our_parent, span_notice(LANG("datum.7f9648689a641a9a", null)))
			qdel(src)
	else qdel(src) // If they're not an item; something is very wrong - qdel anyways without the breakout time.
