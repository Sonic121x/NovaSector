//Bluespace crystals, used in telescience and when crushed it will blink you to a random turf.
/obj/item/stack/ore/bluespace_crystal
	name = "bluespace crystal"
	desc = "一块发光的蓝空晶体，关于它们如何运作所知甚少。它看起来非常脆弱。"
	icon = 'icons/obj/ore.dmi'
	icon_state = "bluespace_crystal"
	singular_name = "bluespace crystal"
	dye_color = DYE_COSMIC
	w_class = WEIGHT_CLASS_TINY
	material_flags = MATERIAL_NO_DESCRIPTORS // Handles in-hand/thrown teleports by itself
	mats_per_unit = list(/datum/material/bluespace = SHEET_MATERIAL_AMOUNT)
	points = 50
	refined_type = /obj/item/stack/sheet/bluespace_crystal
	scan_state = "rock_bscrystal"
	merge_type = /obj/item/stack/ore/bluespace_crystal
	vein_type = ORE_VEIN_SCATTER
	vein_distance = 5
	min_vein_size = 1
	max_vein_size = 2
	/// The teleport range when crushed/thrown at someone.
	var/blink_range = 8

/obj/item/stack/ore/bluespace_crystal/refined
	name = "精炼蓝空晶体"
	points = 0
	refined_type = null
	merge_type = /obj/item/stack/ore/bluespace_crystal/refined
	drop_sound = null //till I make a better one
	pickup_sound = null

/obj/item/stack/ore/bluespace_crystal/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	AddElement(/datum/element/raptor_food, ability_modifier = 0.05, attack_modifier = 0.5, color_chances = string_list(list(/datum/raptor_color/black = 1)))

/obj/item/stack/ore/bluespace_crystal/get_part_rating()
	return 1

/obj/item/stack/ore/bluespace_crystal/attack_self(mob/user)
	user.visible_message(span_warning("[user]捏碎了[src]！"), span_danger("你捏碎了[src]！"))
	new /obj/effect/particle_effect/sparks(loc)
	playsound(loc, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	blink_mob(user)
	use(1)

/obj/item/stack/ore/bluespace_crystal/proc/blink_mob(mob/living/L)
	do_teleport(L, get_turf(L), blink_range, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/item/stack/ore/bluespace_crystal/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..()) // not caught in mid-air
		visible_message(span_notice("[src]在撞击时嘶嘶作响并消失了！"))
		var/turf/T = get_turf(hit_atom)
		new /obj/effect/particle_effect/sparks(T)
		playsound(loc, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		if(isliving(hit_atom))
			blink_mob(hit_atom)
		use(1)

/obj/item/stack/ore/bluespace_crystal/attack_self_secondary(mob/user, modifiers)
	interact(user)

//Artificial bluespace crystal, doesn't give you much research.
/obj/item/stack/ore/bluespace_crystal/artificial
	name = "人工蓝晶"
	desc = "一块人工制造的蓝晶，看起来十分脆弱。"
	mats_per_unit = list(/datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT)
	blink_range = 4 // Not as good as the organic stuff!
	points = 0 //nice try
	refined_type = null
	merge_type = /obj/item/stack/ore/bluespace_crystal/artificial
	drop_sound = null //till I make a better one
	pickup_sound = null

// Polycrystals, aka stacks
/obj/item/stack/sheet/bluespace_crystal
	name = "蓝晶聚合体"
	singular_name = "bluespace polycrystal"
	desc = "一种稳定的聚合晶体，由融合在一起的蓝晶构成。你或许可以掰下一块来。"
	icon_state = "polycrystal"
	inhand_icon_state = null
	material_flags = MATERIAL_NO_DESCRIPTORS
	gulag_valid = TRUE
	mats_per_unit = list(/datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	attack_verb_continuous = list("bluespace polybashes", "bluespace polybatters", "bluespace polybludgeons", "bluespace polythrashes", "bluespace polysmashes")
	attack_verb_simple = list("bluespace polybash", "bluespace polybatter", "bluespace polybludgeon", "bluespace polythrash", "bluespace polysmash")
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/bluespace_crystal
	material_type = /datum/material/bluespace
	var/crystal_type = /obj/item/stack/ore/bluespace_crystal/refined

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/stack/sheet/bluespace_crystal/attack_hand(mob/user, list/modifiers)
	if(user.get_inactive_held_item() != src)
		return ..()

	if(is_zero_amount(delete_if_zero = TRUE))
		return

	var/BC = new crystal_type(src)
	user.put_in_hands(BC)
	use(1)
	if(!amount)
		to_chat(user, span_notice("你掰下了最后一块晶体。"))
	else
		to_chat(user, span_notice("你掰下了一块晶体。"))

/obj/item/stack/sheet/bluespace_crystal/fifty
	amount = 50
