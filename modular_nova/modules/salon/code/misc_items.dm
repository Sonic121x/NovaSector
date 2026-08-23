
/obj/item/storage/box/lipsticks
	name = "lipstick box"

/obj/item/storage/box/lipsticks/PopulateContents()
	..()
	new /obj/item/lipstick(src)
	new /obj/item/lipstick/purple(src)
	new /obj/item/lipstick/jade(src)
	new /obj/item/lipstick/black(src)

/obj/item/lipstick/quantum
	name = "quantum lipstick"

/obj/item/lipstick/quantum/attack(mob/attacked_mob, mob/user)
	if(!open || !ismob(attacked_mob))
		return

	if(!ishuman(attacked_mob))
		to_chat(user, span_warning(LANG("obj.25ec14bf37739a92", null)))
		return

	INVOKE_ASYNC(src, PROC_REF(async_set_color), attacked_mob, user)

/obj/item/lipstick/quantum/proc/async_set_color(mob/attacked_mob, mob/user)
	var/new_color = tgui_color_picker(
			user,
			"Select lipstick color",
			null,
			COLOR_WHITE,
		)

	var/mob/living/carbon/human/target = attacked_mob
	if(target.is_mouth_covered())
		to_chat(user, span_warning(LANG("obj.b40dd1bbda5fab3f", list(target == user ? "your" : "[target.p_their()]"))))
		return
	if(target.lip_style) //if they already have lipstick on
		to_chat(user, span_warning(LANG("obj.6f35b2db3c68b326", null)))
		return

	if(target == user)
		user.visible_message(span_notice(LANG("obj.977b44d3c54abdf0", list(user, user.p_their(), src))), \
			span_notice(LANG("obj.49bba65b9ba5ce6f", list(src))))
		target.update_lips("lipstick", new_color, lipstick_trait)
		return

	user.visible_message(span_warning(LANG("obj.322af48150e10194", list(user, target, src))), \
		span_notice(LANG("obj.924ee50920ece627", list(src, target))))
	if(!do_after(user, 2 SECONDS, target = target))
		return
	user.visible_message(span_notice(LANG("obj.d6dd24184e9e2c2b", list(user, target, src))), \
		span_notice(LANG("obj.e889d01febc5e5f8", list(src, target))))
	target.update_lips("lipstick", new_color, lipstick_trait)

/obj/item/hairbrush/comb
	name = "comb"
	desc = "A rather simple tool, used to straighten out hair and knots in it."
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "blackcomb"

/obj/item/hairstyle_preview_magazine
	name = "hip hairstyles magazine"
	desc = "A magazine featuring a magnitude of hairsytles!"

/obj/item/hairstyle_preview_magazine/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	// A simple GUI with a list of hairstyles and a view, so people can choose a hairstyle!

/obj/effect/decal/cleanable/hair
	name = "hair cuttings"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "cut_hair"

/obj/item/razor
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "razor"
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.7)
	// How long do we take to shave someone's (facial) hair?
	var/shaving_time = 5 SECONDS

/obj/item/razor/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide(LANG("obj.01acdff13c17e341", list(user, user.p_them(), user.p_theyre()))))
	shave(user, BODY_ZONE_PRECISE_MOUTH)
	shave(user, BODY_ZONE_HEAD)//doesnt need to be BODY_ZONE_HEAD specifically, but whatever
	return BRUTELOSS

/obj/item/razor/proc/shave(mob/living/carbon/human/target_human, location = BODY_ZONE_PRECISE_MOUTH)
	if(location == BODY_ZONE_PRECISE_MOUTH)
		target_human.set_facial_hairstyle("Shaved", update = TRUE)
	else
		target_human.set_hairstyle("Bald", update = TRUE)

	playsound(loc, 'sound/items/unsheath.ogg', 20, TRUE)


/obj/item/razor/attack(mob/attacked_mob, mob/living/user)
	if(!ishuman(attacked_mob))
		return ..()

	var/mob/living/carbon/human/target_human = attacked_mob
	var/location = user.zone_selected
	var/obj/item/bodypart/head/noggin = target_human.get_bodypart(BODY_ZONE_HEAD)
	var/static/list/head_zones = list(BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_HEAD)

	if(!noggin && (location in head_zones))
		to_chat(user, span_warning(LANG("obj.618bead4579c1526", list(target_human))))
		return

	if(!(location in head_zones) && !user.combat_mode)
		to_chat(user, span_warning(LANG("obj.d6bb17074b83e7e0", null)))
		return

	if(location == BODY_ZONE_PRECISE_MOUTH)
		if(!(noggin.head_flags & HEAD_FACIAL_HAIR))
			to_chat(user, span_warning(LANG("obj.f4b1d28669ff6554", null)))
			return

		var/covering = target_human.is_mouth_covered()
		if(covering)
			to_chat(user, span_warning(LANG("obj.f4935eb907e08bb0", list(covering))))
			return

		if(HAS_TRAIT(target_human, TRAIT_SHAVED))
			to_chat(user, span_warning(LANG("obj.41f7910e5594dccc", list(target_human))))
			return

		if(target_human.facial_hairstyle == "Shaved")
			to_chat(user, span_warning(LANG("obj.ca2845a9f1916c0c", null)))
			return

		var/self_shaving = target_human == user // Shaving yourself?
		user.visible_message(span_notice(LANG("obj.49952d541092345c", list(user, self_shaving ? user.p_their() : "[target_human]'s", src))), \
			span_notice(LANG("obj.f1e29016793c8e24", list(self_shaving ? "your" : "[target_human]'s", src))))

		if(do_after(user, shaving_time, target = target_human))
			user.visible_message(span_notice(LANG("obj.a7aac793de9caa07", list(user, self_shaving ? user.p_their() : "[target_human]'s", src))), \
				span_notice(LANG("obj.fcc5b055010514a0", list(self_shaving ? "your" : " [target_human]'s", src))))

			shave(target_human, location)

	else if(location == BODY_ZONE_HEAD)
		if(!(noggin.head_flags & HEAD_HAIR))
			to_chat(user, span_warning(LANG("obj.90a39cacb81c009a", null)))
			return

		if(!target_human.is_location_accessible(location))
			to_chat(user, span_warning(LANG("obj.080119ba56078521", null)))
			return

		if(target_human.hairstyle == "Bald" || target_human.hairstyle == "Balding Hair" || target_human.hairstyle == "Skinhead")
			to_chat(user, span_warning(LANG("obj.a6abc8b8218db1b0", null)))
			return

		if(HAS_TRAIT(target_human, TRAIT_SHAVED))
			to_chat(user, span_warning(LANG("obj.41f7910e5594dccc", list(target_human))))
			return

		var/self_shaving = target_human == user // Shaving yourself?
		user.visible_message(span_notice(LANG("obj.49952d541092345c", list(user, self_shaving ? user.p_their() : "[target_human]'s", src))), \
			span_notice(LANG("obj.f1e29016793c8e24", list(self_shaving ? "your" : "[target_human]'s", src))))

		if(do_after(user, shaving_time, target = target_human))
			user.visible_message(span_notice(LANG("obj.a7aac793de9caa07", list(user, self_shaving ? user.p_their() : "[target_human]'s", src))), \
				span_notice(LANG("obj.fcc5b055010514a0", list(self_shaving ? "your" : " [target_human]'s", src))))

			shave(target_human, location)

		return

	return ..()

/obj/structure/sign/barber
	name = "barbershop sign"
	desc = "A glowing red-blue-white stripe you won't mistake for any other!"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "barber"
	buildable_sign = FALSE // Don't want them removed, they look too jank.

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/barber, 13)

/obj/structure/sign/barber/Initialize(mapload)
	. = ..()
	if(mapload)
		find_and_mount_on_atom()

/obj/structure/sign/barber/get_turfs_to_mount_on()
	return list(get_step(src, dir))

/obj/item/storage/box/perfume
	name = "box of perfumes"

/obj/item/storage/box/perfume/PopulateContents()
	new /obj/item/perfume/cologne(src)
	new /obj/item/perfume/wood(src)
	new /obj/item/perfume/rose(src)
	new /obj/item/perfume/jasmine(src)
	new /obj/item/perfume/mint(src)
	new /obj/item/perfume/vanilla(src)
	new /obj/item/perfume/pear(src)
	new /obj/item/perfume/strawberry(src)
	new /obj/item/perfume/cherry(src)
	new /obj/item/perfume/amber(src)
