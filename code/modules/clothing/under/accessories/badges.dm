// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Badges, pins, and other very small items that slot onto a shirt.
/obj/item/clothing/accessory/lawyers_badge
	name = "attorney's badge"
	desc = "Fills you with the conviction of JUSTICE. Lawyers tend to want to show it to everyone they meet."
	icon_state = "lawyerbadge"

/obj/item/clothing/accessory/lawyers_badge/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "lawyer", BUBBLE_ICON_PRIORITY_ACCESSORY)

/obj/item/clothing/accessory/lawyers_badge/interact(mob/user)
	. = ..()
	if(prob(1))
		user.say(LANG("obj.635daae895b0b8af", null), forced = "[src]")
	user.point_at(src)

/obj/item/clothing/accessory/lawyers_badge/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	RegisterSignal(user, COMSIG_LIVING_SLAM_TABLE, PROC_REF(table_slam))

/obj/item/clothing/accessory/lawyers_badge/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(user, COMSIG_LIVING_SLAM_TABLE)

/obj/item/clothing/accessory/lawyers_badge/proc/table_slam(mob/living/source, obj/structure/table/the_table)
	SIGNAL_HANDLER

	ASYNC
		source.say(LANG("obj.006d275cf5db5bee", null), spans = list(SPAN_YELL), forced = "[src]")

/obj/item/clothing/accessory/clown_enjoyer_pin
	name = "\improper Clown Pin"
	desc = "A pin to show off your appreciation for clowns and clowning!"
	icon_state = "clown_enjoyer_pin"

/obj/item/clothing/accessory/clown_enjoyer_pin/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/clothing/accessory/mime_fan_pin) in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, LANG("obj.5cd15459b011c1a0", null))
		return FALSE
	return TRUE

/obj/item/clothing/accessory/clown_enjoyer_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_CLOWN_ENJOYER))
		user.add_mood_event("clown_enjoyer_pin", /datum/mood_event/clown_enjoyer_pin)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/clown_enjoyer_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	user.clear_mood_event("clown_enjoyer_pin")
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/mime_fan_pin
	name = "\improper Mime Pin"
	desc = "A pin to show off your appreciation for mimes and miming!"
	icon_state = "mime_fan_pin"

/obj/item/clothing/accessory/mime_fan_pin/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/clothing/accessory/clown_enjoyer_pin) in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, LANG("obj.5cd15459b011c1a0", null))
		return FALSE
	return TRUE

/obj/item/clothing/accessory/mime_fan_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_MIME_FAN))
		user.add_mood_event("mime_fan_pin", /datum/mood_event/mime_fan_pin)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/mime_fan_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	user.clear_mood_event("mime_fan_pin")
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/pocketprotector
	name = "pocket protector"
	desc = "Can protect your clothing from ink stains, but you'll look like a nerd if you're using one."
	icon_state = "pocketprotector"

/obj/item/clothing/accessory/pocketprotector/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/pocketprotector)

/obj/item/clothing/accessory/pocketprotector/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return

	if(!isnull(attach_to.atom_storage))
		if(user)
			attach_to.balloon_alert(user, LANG("obj.68951c6c67a8f9ed", null))
		return FALSE
	return TRUE

/obj/item/clothing/accessory/pocketprotector/full

/obj/item/clothing/accessory/pocketprotector/full/Initialize(mapload)
	. = ..()
	new /obj/item/pen/red(src)
	new /obj/item/pen(src)
	new /obj/item/pen/blue(src)

/obj/item/clothing/accessory/pocketprotector/cosmetology

/obj/item/clothing/accessory/pocketprotector/cosmetology/Initialize(mapload)
	. = ..()
	for(var/i in 1 to 3)
		new /obj/item/lipstick/random(src)

/obj/item/clothing/accessory/dogtag
	name = "Dogtag"
	desc = "Can't wear a collar, but this is fine?"
	icon_state = "allergy"
	w_class = WEIGHT_CLASS_TINY
	attachment_slot = NONE // actually NECK but that doesn't make sense
	/// What message is displayed when our dogtags / its clothes / its wearer is examined
	var/display = "Nothing!"

/obj/item/clothing/accessory/dogtag/examine(mob/user)
	. = ..()
	. += display

// Examining the clothes will display the examine message of the dogtag
/obj/item/clothing/accessory/dogtag/attach(obj/item/clothing/under/attached_to)
	. = ..()
	RegisterSignal(attached_to, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/obj/item/clothing/accessory/dogtag/detach(obj/item/clothing/under/detach_from)
	. = ..()
	UnregisterSignal(detach_from, COMSIG_ATOM_EXAMINE)

// Double examining the person wearing the clothes will display the examine message of the dogtag
/obj/item/clothing/accessory/dogtag/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	RegisterSignal(user, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine))

/obj/item/clothing/accessory/dogtag/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(user, COMSIG_ATOM_EXAMINE_MORE)

/// Adds the examine message to the clothes and mob.
/obj/item/clothing/accessory/dogtag/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	// Only show the examine message if we're close (2 tiles)
	if(!IN_GIVEN_RANGE(get_turf(user), get_turf(src), 2))
		return

	if(ismob(source))
		// Examining a mob wearing the clothes, wearing the dogtag will also show the message
		examine_list += LANG("obj.98bf88398540eb6d", list(source.p_their(), display))
	else
		examine_list += LANG("obj.4d92482aada879c2", list(source, display))

/obj/item/clothing/accessory/dogtag/allergy
	name = "Allergy dogtag"
	desc = "A dogtag with a listing of allergies."

/obj/item/clothing/accessory/dogtag/allergy/Initialize(mapload, allergy_string)
	. = ..()
	if(allergy_string)
		display = span_notice("The dogtag has a listing of allergies: [allergy_string]")
	else
		display = span_notice("The dogtag is all scratched up.")

/obj/item/clothing/accessory/dogtag/borg_ready
	name = "Pre-Approved Cyborg Candidate dogtag"
	display = "This employee has been screened for negative mental traits to an acceptable level of accuracy, and is approved for the NT Cyborg program as an alternative to medical resuscitation."

// Pride pin skins
/datum/atom_skin/pride_pin
	abstract_type = /datum/atom_skin/pride_pin

/datum/atom_skin/pride_pin/gay
	preview_name = "Rainbow Pride"
	new_icon_state = "pride"

/datum/atom_skin/pride_pin/bi
	preview_name = "Bisexual Pride"
	new_icon_state = "pride_bi"

/datum/atom_skin/pride_pin/pan
	preview_name = "Pansexual Pride"
	new_icon_state = "pride_pan"

/datum/atom_skin/pride_pin/ace
	preview_name = "Asexual Pride"
	new_icon_state = "pride_ace"

/datum/atom_skin/pride_pin/enby
	preview_name = "Non-binary Pride"
	new_icon_state = "pride_enby"

/datum/atom_skin/pride_pin/trans
	preview_name = "Transgender Pride"
	new_icon_state = "pride_trans"

/datum/atom_skin/pride_pin/intersex
	preview_name = "Intersex Pride"
	new_icon_state = "pride_intersex"

/datum/atom_skin/pride_pin/lesbian
	preview_name = "Lesbian Pride"
	new_icon_state = "pride_lesbian"

/datum/atom_skin/pride_pin/mlm
	preview_name = "Gay Pride"
	new_icon_state = "pride_gay"

/obj/item/clothing/accessory/pride
	name = "pride pin"
	desc = "A Nanotrasen Diversity & Inclusion Center-sponsored holographic pin to show off your pride, reminding the crew of their unwavering commitment to equity, diversity, and inclusion!"
	icon_state = "pride"
	obj_flags = UNIQUE_RENAME

/obj/item/clothing/accessory/pride/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/pride_pin, infinite = TRUE)

/obj/item/clothing/accessory/deaf_pin
	name = "deaf personnel pin"
	desc = "Indicates that the wearer is deaf."
	icon_state = "deaf_pin"

///Awarded for being dutiful and extinguishing the debt from the "Indebted" quirk.
/obj/item/clothing/accessory/debt_payer_pin
	name = "debt payer pin"
	desc = "I've paid my debt and all I've got was this pin."
	icon_state = "debt_payer_pin"

/// Self-identify as a dangerous subversive
/obj/item/clothing/accessory/anti_sec_pin
	name = "subversive pin"
	desc = "A badge which loudly and proudly proclaims your hostility to the Nanotrasen Security Team, and authority in general."
	icon_state = "anti_sec"
	clothing_traits = list(TRAIT_ALWAYS_WANTED)

/obj/item/clothing/accessory/anti_sec_pin/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/pinnable_accessory, silent = TRUE, pinning_time = 5 SECONDS)

/obj/item/clothing/accessory/anti_sec_pin/try_attach(obj/item/clothing/under/attach_to, mob/living/attacher)
	. = ..()
	if (!. || isnull(attacher))
		return

	var/target = ishuman(attach_to.loc) ? attach_to.loc : attach_to
	log_combat(attacher, target, "pinned an 'arrest me immediately' pin onto", src)
	return TRUE

/obj/item/clothing/accessory/anti_sec_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	. = ..()
	if (ishuman(user))
		var/mob/living/carbon/human/human_wearer = user
		human_wearer.sec_hud_set_security_status()

/obj/item/clothing/accessory/anti_sec_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	. = ..()
	if (ishuman(user))
		var/mob/living/carbon/human/human_wearer = user
		human_wearer.sec_hud_set_security_status()

/obj/item/clothing/accessory/press_badge
	name = "press badge"
	desc = "A blue press badge that clearly identifies the wearer as a member of the media. While it signifies press affiliation, it does not grant any special privileges or rights no matter how much the wearer yells about it."
	desc_controls = "Click person with it to show them it"
	icon_state = "press_badge"
	attachment_slot = NONE // actually NECK but that doesn't make sense
	/// The name of the person in the badge
	var/journalist_name
	/// The name of the press person is working for
	var/press_name

/obj/item/clothing/accessory/press_badge/examine(mob/user)
	. = ..()
	if(!journalist_name || !press_name)
		. += span_notice(LANG("obj.8d3e0b49efdbbdb0", null))
		return

	. += span_notice(LANG("obj.a8b90f43c464802a", list(journalist_name, press_name)))

/obj/item/clothing/accessory/press_badge/attack_self(mob/user, modifiers)
	. = ..()
	if(!journalist_name)
		journalist_name = tgui_input_text(user, LANG("obj.2f968a50a163a8da", null), LANG("obj.994cfa96cefd74e4", null), "[user.name]", max_length = MAX_NAME_LEN)
	if(!press_name)
		press_name = tgui_input_text(user, LANG("obj.477f03a1356a35c5", null), LANG("obj.0a838b1368a2c735", null), "Nanotrasen", max_length = MAX_CHARTER_LEN)

/obj/item/clothing/accessory/press_badge/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(!isliving(interacting_with))
		return

	var/mob/living/interacting_living = interacting_with
	if(user.combat_mode)
		playsound(interacting_living, 'sound/items/weapons/throw.ogg', 30)
		interacting_living.examinate(src)
		to_chat(interacting_living, span_userdanger(LANG("obj.20dbfa2bf8318f1e", list(user, src))))
		user.visible_message(span_warning(LANG("obj.e4872f2dccea6628", list(user, src, interacting_living))))
	else
		playsound(interacting_living, 'sound/items/weapons/throwsoft.ogg', 20)
		interacting_living.examinate(src)
		to_chat(interacting_living, span_boldwarning(LANG("obj.0b00b7732f5c8c5c", list(user, src))))
		user.visible_message(span_notice(LANG("obj.7eb4af6645b84aef", list(user, src, interacting_living))))
