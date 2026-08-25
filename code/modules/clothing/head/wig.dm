// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/clothing/head/wig
	name = "wig"
	desc = "A bunch of hair without a head attached."
	icon = 'icons/mob/human/human_face.dmi'   // default icon for all hairs
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "hair_vlong"
	inhand_icon_state = "pwig"
	worn_icon_state = "wig"
	flags_inv = HIDEHAIR
	color = COLOR_BLACK
	var/hairstyle = "Very Long Hair"
	var/adjustablecolor = TRUE //can color be changed manually?

/obj/item/clothing/head/wig/Initialize(mapload)
	. = ..()
	update_appearance()
	AddComponent(/datum/component/hat_stabilizer, loose_hat = FALSE)

/obj/item/clothing/head/wig/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && (slot & ITEM_SLOT_HEAD))
		ADD_TRAIT(src, TRAIT_EXAMINE_SKIP, CLOTHING_TRAIT)

/obj/item/clothing/head/wig/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(src, TRAIT_EXAMINE_SKIP, CLOTHING_TRAIT)

/obj/item/clothing/head/wig/update_icon_state()
	var/datum/sprite_accessory/hair/hair_style = SSaccessories.hairstyles_list[hairstyle]
	if(hair_style)
		icon = hair_style.icon
		icon_state = hair_style.icon_state
	return ..()

/obj/item/clothing/head/wig/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file, bodyshape = NONE)
	. = ..()
	if(isinhands)
		return

	var/datum/sprite_accessory/hair/hair = SSaccessories.hairstyles_list[hairstyle]
	if(!hair)
		return

	var/mutable_appearance/hair_overlay = mutable_appearance(hair.icon, hair.icon_state, layer = -HAIR_LAYER, appearance_flags = RESET_COLOR)
	hair_overlay.color = color
	hair_overlay.pixel_z = hair.y_offset
	. += hair_overlay

	// So that the wig actually blocks emissives.
	hair_overlay.overlays += emissive_blocker(hair_overlay.icon, hair_overlay.icon_state, src, alpha = hair_overlay.alpha)

/obj/item/clothing/head/wig/attack_self(mob/user)
	var/new_style = tgui_input_list(user, LANG("obj.f24e1bc145540758", null), LANG("obj.ae48f8cf29eff916", null), SSaccessories.hairstyles_list - "Bald")
	var/newcolor = adjustablecolor ? tgui_color_picker(usr,"","Choose Color",color) : null
	if(!user.can_perform_action(src))
		return
	if(new_style && new_style != hairstyle)
		hairstyle = new_style
		user.visible_message(span_notice(LANG("obj.87f22090402f78af", list(user, src, new_style))), span_notice(LANG("obj.f0b7fea551b56aff", list(src, new_style))))
	if(newcolor && newcolor != color) // only update if necessary
		add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)
	update_appearance()

/obj/item/clothing/head/wig/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/clothing/head/wig/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with) || interacting_with == user)
		return NONE
	var/mob/living/carbon/human/target = interacting_with
	if(target.head)
		var/obj/item/clothing/head = target.head
		if((head.flags_inv & HIDEHAIR) && !istype(head, /obj/item/clothing/head/wig))
			to_chat(user, span_warning(LANG("obj.296db55e47923d7b", list(target.p_their()))))
			return ITEM_INTERACT_BLOCKING
	var/obj/item/bodypart/head/noggin = target.get_bodypart(BODY_ZONE_HEAD)
	if(!noggin)
		to_chat(user, span_warning(LANG("obj.749ab9d5cbcaf8bc", list(target.p_They()))))
		return ITEM_INTERACT_BLOCKING

	var/selected_hairstyle = null
	var/selected_hairstyle_color = null
	if(istype(target.head, /obj/item/clothing/head/wig))
		var/obj/item/clothing/head/wig/wig = target.head
		selected_hairstyle = wig.hairstyle
		selected_hairstyle_color = wig.color
	else if((noggin.head_flags & HEAD_HAIR) && target.hairstyle != "Bald")
		selected_hairstyle = target.hairstyle
		selected_hairstyle_color = "[target.hair_color]"

	if(selected_hairstyle)
		to_chat(user, span_notice(LANG("obj.581c05e0104971be", list(src, target.name, selected_hairstyle))))
		add_atom_colour(selected_hairstyle_color, FIXED_COLOUR_PRIORITY)
		hairstyle = selected_hairstyle
		update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/head/wig/random/Initialize(mapload)
	hairstyle = pick(SSaccessories.hairstyles_list - "Bald") //Don't want invisible wig
	add_atom_colour("#[random_short_color()]", FIXED_COLOUR_PRIORITY)
	. = ..()

/obj/item/clothing/head/wig/natural
	name = "natural wig"
	desc = "A bunch of hair without a head attached. This one changes color to match the hair of the wearer. Nothing natural about that."
	color = COLOR_WHITE
	adjustablecolor = FALSE
	custom_price = PAYCHECK_COMMAND

/obj/item/clothing/head/wig/natural/Initialize(mapload)
	hairstyle = pick(SSaccessories.hairstyles_list - "Bald")
	. = ..()

/obj/item/clothing/head/wig/natural/visual_equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(ishuman(user) && (slot & ITEM_SLOT_HEAD))
		if(color != user.hair_color) // only update if necessary
			add_atom_colour(user.hair_color, FIXED_COLOUR_PRIORITY)
			update_appearance()
		user.update_worn_head()
