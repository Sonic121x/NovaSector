/*
*	GUNSET BOXES
*/
/obj/item/storage/toolbox/guncase/nova
	desc = "A thick gun case with foam inserts laid out to fit a weapon, magazines, and gear securely."
	icon = 'modular_nova/modules/modular_weapons/icons/obj/gunsets.dmi'
	icon_state = "guncase"
	worn_icon = 'modular_nova/modules/modular_weapons/icons/mob/worn/cases.dmi'
	worn_icon_state = "darkcase"
	lefthand_file = 'modular_nova/modules/modular_weapons/icons/mob/inhands/cases_lefthand.dmi'
	righthand_file = 'modular_nova/modules/modular_weapons/icons/mob/inhands/cases_righthand.dmi'
	inhand_icon_state = "darkcase"
	slot_flags = ITEM_SLOT_BACK
	material_flags = NONE
	storage_type = /datum/storage/toolbox/guncase/nova
	// Default our guncases to be empty (see /obj/item/storage/toolbox/guncase/nova/PopulateContents())
	weapon_to_spawn = null
	extra_to_spawn = null
	/// Is the case visually opened or not
	var/opened = FALSE

/datum/storage/toolbox/guncase/nova
	max_total_storage = 14 // Technically means you could fit multiple large guns in here but it's a case you cant backpack anyways so what it do
	max_slots = 6 // We store some extra items in these so lets make a little extra room

/obj/item/storage/toolbox/guncase/nova/update_icon()
	. = ..()
	if(opened)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)

/obj/item/storage/toolbox/guncase/nova/click_alt(mob/user)
	opened = !opened
	update_icon()
	return CLICK_ACTION_SUCCESS

/obj/item/storage/toolbox/guncase/nova/attack_self(mob/user)
	. = ..()
	opened = !opened
	update_icon()

//Quick overwrite of TG's guncase PopulateContents() to prevent runtimes
//Now it only tries to spawn stuff if there's actually stuff to spawn
/obj/item/storage/toolbox/guncase/nova/PopulateContents()
	if(weapon_to_spawn)
		new weapon_to_spawn (src)
	if(extra_to_spawn)
		for(var/iterate in 1 to 3)
			new extra_to_spawn (src)

// Small case for pistols and whatnot
/obj/item/storage/toolbox/guncase/nova/pistol
	name = "small gun case"
	icon_state = "guncase_s"
	slot_flags = NONE
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

/datum/storage/toolbox/guncase/nova/pistol
	max_specific_storage = WEIGHT_CLASS_NORMAL

/*
	Pre-Colored Variants
	(Since imports don't allow us to do reskins, and we don't want these reskinnable in-round)
*/
/obj/item/storage/toolbox/guncase/nova/green
	icon_state = "greencase"
	worn_icon_state = "greencase"
	inhand_icon_state = "greencase"

/obj/item/storage/toolbox/guncase/nova/green/pistol
	name = "small gun case"
	icon_state = "greencase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

/obj/item/storage/toolbox/guncase/nova/red
	icon_state = "redcase"
	worn_icon_state = "redcase"
	inhand_icon_state = "redcase"

/obj/item/storage/toolbox/guncase/nova/red/pistol
	name = "small gun case"
	icon_state = "redcase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

/obj/item/storage/toolbox/guncase/nova/blue
	icon_state = "bluecase"
	worn_icon_state = "bluecase"
	inhand_icon_state = "bluecase"

/obj/item/storage/toolbox/guncase/nova/blue/pistol
	name = "small gun case"
	icon_state = "bluecase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

/obj/item/storage/toolbox/guncase/nova/purple
	icon_state = "purplecase"
	worn_icon_state = "purplecase"
	inhand_icon_state = "purplecase"

/obj/item/storage/toolbox/guncase/nova/purple/pistol
	name = "small gun case"
	icon_state = "purplecase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

/obj/item/storage/toolbox/guncase/nova/orange
	icon_state = "orangecase"
	worn_icon_state = "orangecase"
	inhand_icon_state = "orangecase"

/obj/item/storage/toolbox/guncase/nova/orange/pistol
	name = "small gun case"
	icon_state = "orangecase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

/*
	Company Cases
	(Subtype off these when making presets supplied by these companies!)
*/

// Nanotrasen
/obj/item/storage/toolbox/guncase/nova/ntcase
	icon_state = "ntcase"
	worn_icon_state = "ntcase"
	inhand_icon_state = "ntcase"

/obj/item/storage/toolbox/guncase/nova/ntcase/examine(mob/user)
	. = ..()
	. += LANG("obj.b5a86bf321d9aa38", list(span_blue("Nanotrasen")))

/obj/item/storage/toolbox/guncase/nova/ntcase/pistol
	name = "small gun case"
	icon_state = "ntcase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

// Nanotrasen Centcom Case (CC/Gold Varient) (used for NTC/Blueshield & Other CC related drops)
/obj/item/storage/toolbox/guncase/nova/ntspecial
	icon_state = "cc_case"
	worn_icon_state = "cc_case"
	inhand_icon_state = "cc_case"

/obj/item/storage/toolbox/guncase/nova/ntspecial/examine(mob/user)
	. = ..()
	. += LANG("obj.f2062fbe2f84fc6f", list(span_blue("Nanotrasen")))


/obj/item/storage/toolbox/guncase/nova/ntspecial/pistol
	name = "small gun case"
	icon_state = "cc_case_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

// Solfed
/obj/item/storage/toolbox/guncase/nova/solfed
	icon_state = "solfedcase"
	worn_icon_state = "solfedcase"
	inhand_icon_state = "solfedcase"

/obj/item/storage/toolbox/guncase/nova/solfed/examine(mob/user)
	. = ..()
	. += LANG("obj.205c162433aa9673", list(span_cyan_nova("Solar Federation")))

/obj/item/storage/toolbox/guncase/nova/solfed/pistol
	name = "small gun case"
	icon_state = "solfedcase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

// Solfed Special
/obj/item/storage/toolbox/guncase/nova/solfedspec
	icon_state = "solfedspeccase"
	worn_icon_state = "solfedspeccase"
	inhand_icon_state = "solfedspeccase"

/obj/item/storage/toolbox/guncase/nova/solfedspec/examine(mob/user)
	. = ..()
	. += LANG("obj.205c162433aa9673", list(span_cyan_nova("Solar Federation")))

/obj/item/storage/toolbox/guncase/nova/solfedspec/pistol
	name = "small gun case"
	icon_state = "solfedspeccase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

// Syndicate
/obj/item/storage/toolbox/guncase/nova/syndicate
	icon_state = "syndicase"
	worn_icon_state = "syndicase"
	inhand_icon_state = "syndicase"

/obj/item/storage/toolbox/guncase/nova/syndicate/examine(mob/user)
	. = ..()
	. += LANG("obj.5fc9855ddf37abaf", list(span_red("Syndicate Conglomerate")))

/obj/item/storage/toolbox/guncase/nova/syndicate/pistol
	name = "small gun case"
	icon_state = "syndicase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

// Interdyne Pharmaceuticals
/obj/item/storage/toolbox/guncase/nova/interdyne
	icon_state = "dynecase"
	worn_icon_state = "dynecase"
	inhand_icon_state = "dynecase"

/obj/item/storage/toolbox/guncase/nova/interdyne/examine(mob/user)
	. = ..()
	. += LANG("obj.7746f8f12ac8010a", list(span_green("Interdyne Pharmaceuticals")))

/obj/item/storage/toolbox/guncase/nova/interdyne/pistol
	name = "small gun case"
	icon_state = "dynecase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

/// Interdyne Special Case
/obj/item/storage/toolbox/guncase/nova/interdynespec
	icon_state = "dynespeccase"
	worn_icon_state = "dynespeccase"
	inhand_icon_state = "dynespeccase"

/obj/item/storage/toolbox/guncase/nova/interdynespec/examine(mob/user)
	. = ..()
	. += LANG("obj.7746f8f12ac8010a", list(span_green("Interdyne Pharmaceuticals")))

/obj/item/storage/toolbox/guncase/nova/interdynespec/pistol
	name = "small gun case"
	icon_state = "dynespeccase_s"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/toolbox/guncase/nova/pistol

// Carwo Defense Systems & Trappiste Fabriek
/obj/item/storage/toolbox/guncase/nova/carwo_large_case
	icon_state = "case_carwo"
	worn_icon_state = "carwocase"
	inhand_icon_state = "carwocase"
	//No logo on this case

/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case
	icon_state = "case_trappiste"
	worn_icon_state = "carwocase"
	inhand_icon_state = "carwocase"

/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/examine(mob/user)
	. = ..()
	. += LANG("obj.5b1c9c61aaa0bbe0", list(span_red("Trappiste Fabriek")))

// Xhihao Light Arms
/obj/item/storage/toolbox/guncase/nova/xhihao_large_case
	icon_state = "case_xhihao"
	//No pistol variant (yet!)

/obj/item/storage/toolbox/guncase/nova/xhihao_large_case/examine(mob/user)
	. = ..()
	. += LANG("obj.55ce2592cc351467", list(span_purple("Xhihao Light Arms")))
