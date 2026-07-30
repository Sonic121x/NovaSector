// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
//Bluespace crystals, used in telescience and when crushed it will blink you to a random turf.
/obj/item/stack/ore/bluespace_crystal
	name = "bluespace crystal"
	desc = "A glowing bluespace crystal, not much is known about how they work. It looks very delicate."
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
	name = "refined bluespace crystal"
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
	SEND_SIGNAL(user, COMSIG_MOB_CRUSHED_BLUESPACE_CRYSTAL, src)
	user.visible_message(span_warning(LANG("obj.a1d666d4", list(user, src))), span_danger(LANG("obj.e79ecc98", list(src))))
	new /obj/effect/particle_effect/sparks(loc)
	playsound(loc, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	blink_mob(user)
	use(1)

/obj/item/stack/ore/bluespace_crystal/proc/blink_mob(mob/living/L)
	do_teleport(L, get_turf(L), blink_range, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/item/stack/ore/bluespace_crystal/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..()) // not caught in mid-air
		visible_message(span_notice(LANG("obj.d8c434f3", list(src))))
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
	name = "artificial bluespace crystal"
	desc = "An artificially made bluespace crystal, it looks delicate."
	mats_per_unit = list(/datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT)
	blink_range = 4 // Not as good as the organic stuff!
	points = 0 //nice try
	refined_type = null
	merge_type = /obj/item/stack/ore/bluespace_crystal/artificial
	drop_sound = null //till I make a better one
	pickup_sound = null

// Polycrystals, aka stacks
/obj/item/stack/sheet/bluespace_crystal
	name = "bluespace polycrystal"
	singular_name = "bluespace polycrystal"
	desc = "A stable polycrystal, made of fused-together bluespace crystals. You could probably break one off."
	icon_state = "polycrystal"
	inhand_icon_state = null
	material_flags = MATERIAL_NO_DESCRIPTORS
	gulag_value = 100
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
		to_chat(user, span_notice(LANG("obj.7b64f981", null)))
	else
		to_chat(user, span_notice(LANG("obj.1e4b0cb9", null)))

/obj/item/stack/sheet/bluespace_crystal/fifty
	amount = 50
