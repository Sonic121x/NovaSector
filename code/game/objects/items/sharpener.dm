// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
* # Whetstone
*
* Items used for sharpening stuff
*
* Whetstones can be used to increase an item's force, throw_force and wound_bonus and it changes its sharpness to SHARP_EDGED. Whetstones do not work with energy weapons. Two-handed weapons will only get the throw_force bonus. A whetstone can only be used once.
*
*/
/obj/item/sharpener
	name = "whetstone"
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "sharpener"
	desc = "A block that makes things sharp."
	force = 5
	///Amount of uses the whetstone has. Set to -1 for functionally infinite uses.
	var/uses = 1
	///How much force the whetstone can add to an item.
	var/increment = 4
	///Maximum force sharpening items with the whetstone can result in
	var/max = 30
	///The prefix a whetstone applies when an item is sharpened with it
	var/prefix = "sharpened"
	///If TRUE, the whetstone will only sharpen already sharp items
	var/requires_sharpness = TRUE

/obj/item/sharpener/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(uses == 0)
		to_chat(user, span_warning(LANG("obj.ae6145a3cf45cf8d", null)))
		return ITEM_INTERACT_BLOCKING
	if(tool.force >= max || tool.throwforce >= max) //So the whetstone never reduces force or throw_force
		to_chat(user, span_warning(LANG("obj.bdf27dd30f363da6", list(tool))))
		return ITEM_INTERACT_BLOCKING
	if(requires_sharpness && !tool.get_sharpness())
		to_chat(user, span_warning(LANG("obj.873c233f293fc78e", null)))
		return ITEM_INTERACT_BLOCKING
	if(is_type_in_list(tool, list(/obj/item/melee/energy, /obj/item/dualsaber))) //You can't sharpen the photons in energy meelee weapons
		to_chat(user, span_warning(LANG("obj.505009f4d0302252", list(tool, src))))
		return ITEM_INTERACT_BLOCKING

	//This block is used to check more things if the item has a relevant component.
	var/signal_out = SEND_SIGNAL(tool, COMSIG_ITEM_SHARPEN_ACT, increment, max) //Stores the bitflags returned by SEND_SIGNAL
	if(signal_out & COMPONENT_BLOCK_SHARPEN_MAXED) //If the item's components enforce more limits on maximum power from sharpening,  we fail
		to_chat(user, span_warning(LANG("obj.bdf27dd30f363da6", list(tool))))
		return ITEM_INTERACT_BLOCKING
	if(signal_out & COMPONENT_BLOCK_SHARPEN_BLOCKED)
		to_chat(user, span_warning(LANG("obj.7ed84f5a22af7cb3", list(tool))))
		return ITEM_INTERACT_BLOCKING
	if((signal_out & COMPONENT_BLOCK_SHARPEN_ALREADY) || (tool.force > initial(tool.force) && !signal_out)) //No sharpening stuff twice
		to_chat(user, span_warning(LANG("obj.77690bcad0726579", list(tool))))
		return ITEM_INTERACT_BLOCKING
	if(!(signal_out & COMPONENT_BLOCK_SHARPEN_APPLIED)) //If the item has a relevant component and COMPONENT_BLOCK_SHARPEN_APPLIED is returned, the item only gets the throw force increase
		tool.force = clamp(tool.force + increment, 0, max)
		tool.wound_bonus = tool.wound_bonus + increment //wound_bonus has no cap
	user.visible_message(span_notice(LANG("obj.cc11a52cc35f57e5", list(user, tool, src))), span_notice(LANG("obj.6c61e32738e2d1de", list(tool))))
	playsound(src, 'sound/items/unsheath.ogg', 25, TRUE)
	if(!(signal_out & COMPONENT_BLOCK_SHARPEN_SHARPNESS))
		tool.sharpness = SHARP_EDGED //When you whetstone something, it becomes an edged weapon, even if it was previously dull or pointy
	tool.throwforce = clamp(tool.throwforce + increment, 0, max)
	tool.name = "[prefix] [tool.name]" //This adds a prefix and a space to the item's name regardless of what the prefix is
	desc = LANG("obj.a7042ee21bafceb2", list(desc))
	uses-- //this doesn't cause issues because we check if uses == 0 earlier in this proc
	if(uses == 0)
		name = "worn out [name]" //whetstone becomes used whetstone
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/sharpener/update_name()
	name = "[!uses ? "worn out " : null][initial(name)]"
	return ..()

/**
* # Super whetstone
*
* Extremely powerful admin-only whetstone
*
* Whetstone that adds 200 damage to an item, with the maximum force and throw_force reachable with it being 200. As with normal whetstones, energy weapons cannot be sharpened with it and two-handed weapons will only get the throw_force bonus.
*
*/
/obj/item/sharpener/super
	name = "super whetstone"
	desc = "A block that will make your weapon sharper than Einstein on adderall."
	increment = 200
	max = 200
	prefix = "super-sharpened"
	requires_sharpness = FALSE //Super whetstones can sharpen even tooboxes
