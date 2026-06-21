/obj/item/clothing/accessory/can_attach_accessory(obj/item/clothing/clothing_item, mob/user)
	if(!attachment_slot || (clothing_item?.attachment_slot_override & attachment_slot))
		return TRUE
	return ..()


/obj/item/clothing/accessory/chaps
	name = "皮护腿"
	desc = "通常穿在裤子外面，以更好地保护腿部外侧免受危险伤害的衬垫。"
	icon = 'icons/map_icons/clothing/accessory.dmi'
	icon_state = "/obj/item/clothing/accessory/chaps"
	post_init_icon_state = "chaps"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/shorts_pants_shirts.dmi'
	attachment_slot = LEGS //Worn over pants
	gender = PLURAL //"That's some chaps."
	greyscale_config = /datum/greyscale_config/chaps
	greyscale_config_worn = /datum/greyscale_config/chaps/worn
	greyscale_config_worn_digi = /datum/greyscale_config/chaps/worn/digi
	greyscale_colors = "#787878#252525#2B2B2B"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/accessory/chaps/click_ctrl_shift(mob/user)
	//Converts the Chaps into a Uniform.
	//See shorts_pants.dm for the Uniform version
	var/obj/item/clothing/under/pants/nova/chaps/chaps_uniform = new /obj/item/clothing/under/pants/nova/chaps(user.drop_location())
	chaps_uniform.greyscale_colors = greyscale_colors
	chaps_uniform.update_greyscale()
	user.balloon_alert(user, "已更改为制服！")
	qdel(src)
	user.put_in_hands(chaps_uniform)

/obj/item/clothing/accessory/chaps/examine(mob/user)
	. = ..()
	. += span_notice("它可以被[EXAMINE_HINT("ctrl+shift clicked")]以作为制服穿着。")

/obj/item/clothing/accessory/chaps/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(held_item != source)
		return .

	context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = "Wear as uniform"
	return CONTEXTUAL_SCREENTIP_SET
