/obj/item/claymore/shishkebab
	name = "shishkebab"
	desc = "A slightly dull makeshift sword, rigged up to dispense hot injustice at the flip of a switch."
	icon = 'modular_gay/weapons/icon/melee.dmi'
	lefthand_file = 'modular_gay/weapons/icon/lefthand.dmi'
	righthand_file = 'modular_gay/weapons/icon/righthand.dmi'
	worn_icon = 'modular_gay/weapons/icon/worn.dmi'
	worn_icon_state = "empty_placeholder"
	icon_state = "shishkebab_off"
	inhand_icon_state = "shishkebab_off"
	worn_icon_state = "shishkebab"
	pickup_sound = 'modular_gay/sound/weapons/meleesounds/blade_pickup2.ogg'
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	wound_bonus = 5
	throwforce = 10
	exposed_wound_bonus = 5
	armour_penetration = 25
	toolspeed = 2
	var/on = FALSE

/obj/item/claymore/shishkebab/attack_self(mob/user)
	on = !on
	icon_state = "shishkebab_[on ? "on" : "off"]"
	inhand_icon_state = "shishkebab_[on ? "on" : "off"]"

	if(on)
		attack_verb_continuous = list("burned", "welded", "cauterized", "melted", "charred")
		attack_verb_simple = list("burn", "weld", "cauterize", "melt", "char")
		to_chat(user, "<span class='notice'>You open the valve and click the igniter, [src] begins to eject flames.")
		hitsound = 'modular_gay/sound/weapons/meleesounds/burn_sword.ogg'
		damtype = BURN
		force = 30

	else
		attack_verb_continuous = list("stabs", "slices", "slashes", "cuts", "rends")
		attack_verb_simple = list("stab", "slice", "slash", "cut", "rend")
		to_chat(user, "<span class='notice'>As you close the valve on [src], the flame goes out.")
		hitsound = 'modular_gay/sound/weapons/meleesounds/blade_hit1.ogg'
		damtype = BRUTE
		force = 20