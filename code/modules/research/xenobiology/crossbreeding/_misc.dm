// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*
Slimecrossing Items
	General items added by the slimecrossing system.
	Collected here for clarity.
*/

//Rewind camera - I'm already Burning Sepia
/obj/item/camera/rewind
	name = "sepia-tinted camera"
	desc = "They say a picture is like a moment stopped in time."
	pictures_left = 1
	pictures_max = 1
	can_customise = FALSE
	default_picture_name = "A nostalgic picture"

/datum/saved_bodypart
	var/obj/item/bodypart/old_part
	var/bodypart_type
	var/brute_dam
	var/burn_dam

/datum/saved_bodypart/New(obj/item/bodypart/part)
	old_part = part
	bodypart_type = part.type
	brute_dam = part.brute_dam
	burn_dam = part.burn_dam

/mob/living/carbon/proc/apply_saved_bodyparts(list/datum/saved_bodypart/parts)
	var/list/dont_chop = list()
	for(var/zone in parts)
		var/datum/saved_bodypart/saved_part = parts[zone]
		var/obj/item/bodypart/already = get_bodypart(zone)
		if(QDELETED(saved_part.old_part))
			saved_part.old_part = new saved_part.bodypart_type
		if(!already || already != saved_part.old_part)
			saved_part.old_part.replace_limb(src)
		saved_part.old_part.heal_damage(INFINITY, INFINITY, null, FALSE)
		saved_part.old_part.receive_damage(saved_part.brute_dam, saved_part.burn_dam, wound_bonus=CANT_WOUND)
		dont_chop[zone] = TRUE

/mob/living/carbon/proc/save_bodyparts()
	var/list/datum/saved_bodypart/ret = list()
	for(var/obj/item/bodypart/part as anything in get_bodyparts(include_stumps = TRUE))
		var/datum/saved_bodypart/saved_part = new(part)
		ret[part.body_zone] = saved_part
	return ret

/obj/item/camera/rewind/on_flash(atom/target, mob/user)
	. = ..()
	if(user == target)
		to_chat(user, span_notice(LANG("obj.afae693bcb7eaa36", null)))
	else
		to_chat(user, span_notice(LANG("obj.dffc9f6f62e91917", list(target))))
		to_chat(target, span_notice(LANG("obj.c02e391bb694120c", list(user))))
	to_chat(target, span_boldnotice(LANG("obj.be4b557ff560751c", null)))

	target.AddComponent(/datum/component/dejavu, 2)

//Timefreeze camera - Old Burning Sepia result. Kept in case admins want to spawn it
/obj/item/camera/timefreeze
	name = "sepia-tinted camera"
	desc = "They say a picture is like a moment stopped in time."
	pictures_left = 1
	pictures_max = 1

/obj/item/camera/timefreeze/on_flash(atom/target, mob/user)
	. = ..()
	new /obj/effect/timestop(get_turf(target), 2, 50, list(user))

//Hypercharged slime cell - Charged Yellow
/obj/item/stock_parts/power_store/cell/high/slime_hypercharged
	name = "hypercharged slime core"
	desc = "A charged yellow slime extract, infused with plasma. It almost hurts to touch."
	icon = 'icons/mob/simple/slimes.dmi'
	icon_state = "yellow-core"
	rating = 7
	custom_materials = null
	maxcharge = 50 * STANDARD_CELL_CHARGE
	chargerate = 2.5 * STANDARD_CELL_RATE
	charge_light_type = null
	connector_type = "slimecore"

//Barrier cube - Chilling Grey
/obj/item/barriercube
	name = "barrier cube"
	desc = "A compressed cube of slime. When squeezed, it grows to massive size!"
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "barriercube"
	w_class = WEIGHT_CLASS_TINY

/obj/item/barriercube/attack_self(mob/user)
	if(locate(/obj/structure/barricade/slime) in get_turf(loc))
		to_chat(user, span_warning(LANG("obj.67ffba57386dacb3", null)))
		return
	to_chat(user, span_notice(LANG("obj.c6edd408db9aaaa2", list(src))))
	var/obj/B = new /obj/structure/barricade/slime(get_turf(loc))
	B.visible_message(span_warning(LANG("obj.beefbf5deba48e4f", list(src))))
	qdel(src)

//Slime barricade - Chilling Grey
/obj/structure/barricade/slime
	name = "gelatinous barrier"
	desc = "A huge chunk of grey slime. Bullets might get stuck in it."
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "slimebarrier"
	proj_pass_rate = 40
	max_integrity = 60

//Melting Gel Wall - Chilling Metal
/obj/effect/forcefield/slimewall
	name = "solidified gel"
	desc = "A mass of solidified slime gel - completely impenetrable, but it's melting away!"
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "slimebarrier_thick"
	can_atmos_pass = ATMOS_PASS_NO
	opacity = TRUE
	initial_duration = 10 SECONDS

//Rainbow barrier - Chilling Rainbow
/obj/effect/forcefield/slimewall/rainbow
	name = "rainbow barrier"
	desc = "Despite others' urgings, you probably shouldn't taste this."
	icon_state = "rainbowbarrier"

//Ice stasis block - Chilling Dark Blue
/obj/structure/ice_stasis
	name = "ice block"
	desc = "A massive block of ice. You can see something vaguely humanoid inside."
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "frozen"
	density = TRUE
	max_integrity = 100
	armor_type = /datum/armor/structure_ice_stasis

/datum/armor/structure_ice_stasis
	melee = 30
	bullet = 50
	laser = -50
	energy = -50
	fire = -80
	acid = 30

/obj/structure/ice_stasis/Initialize(mapload)
	. = ..()
	playsound(src, 'sound/effects/magic/ethereal_exit.ogg', 50, TRUE)

/obj/structure/ice_stasis/Destroy()
	for(var/atom/movable/M in contents)
		M.forceMove(loc)
	playsound(src, 'sound/effects/glass/glassbr3.ogg', 50, TRUE)
	return ..()

//Gold capture device - Chilling Gold
/obj/item/capturedevice
	name = "gold capture device"
	desc = "Bluespace technology packed into a roughly egg-shaped device, used to store nonhuman creatures. Can't catch them all, though - it only fits one."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "capturedevice"
	///traits we give and remove from the mob on exit and entry
	var/static/list/traits_on_transfer = list(
		TRAIT_IMMOBILIZED,
		TRAIT_HANDS_BLOCKED,
		TRAIT_AI_PAUSED,
	)

/obj/item/capturedevice/attack(mob/living/pokemon, mob/user)
	if(length(contents))
		to_chat(user, span_warning(LANG("obj.13d7cfe6099faea7", null)))
		return
	if(!isanimal_or_basicmob(pokemon))
		to_chat(user, span_warning(LANG("obj.b6eb583c2b0f416f", null)))
		return
	if(pokemon.mind)
		to_chat(user, span_notice(LANG("obj.2a23d6929f17bbe5", list(pokemon))))
		if(tgui_alert(pokemon, LANG("obj.899669bb2376c434", list(user)), LANG("obj.baa986aa7a9f44ab", null), list("Yes", "No")) == "Yes")
			if(user.can_perform_action(src) && user.can_perform_action(pokemon))
				to_chat(user, span_notice(LANG("obj.e1789f822ad97805", list(pokemon))))
				to_chat(pokemon, span_notice(LANG("obj.ebbaa69281dfdd98", null)))
				store(pokemon, user)
			else
				to_chat(user, span_warning(LANG("obj.d57ab25d7bdf85ce", list(pokemon))))
				to_chat(pokemon, span_warning(LANG("obj.d57ab25d7bdf85ce", list(user))))
		else
			to_chat(user, span_warning(LANG("obj.7cb5edae152bb745", list(pokemon))))
			return
	else if(!pokemon.has_faction(FACTION_NEUTRAL))
		to_chat(user, span_warning(LANG("obj.e34d6a427004b4d2", null)))
		return
	to_chat(user, span_notice(LANG("obj.e1789f822ad97805", list(pokemon))))
	store(pokemon)

/obj/item/capturedevice/attack_self(mob/user)
	if(contents.len)
		to_chat(user, span_notice(LANG("obj.a7eb70b0ce770237", null)))
		release()
	else
		to_chat(user, span_warning(LANG("obj.adbd88b72e7aef4a", null)))

/obj/item/capturedevice/proc/store(mob/living/pokemon)
	pokemon.forceMove(src)
	pokemon.add_traits(traits_on_transfer, ABSTRACT_ITEM_TRAIT)
	pokemon.cancel_camera()

/obj/item/capturedevice/proc/release()
	for(var/mob/living/pokemon in contents)
		pokemon.forceMove(get_turf(loc))
		pokemon.remove_traits(traits_on_transfer, ABSTRACT_ITEM_TRAIT)
		pokemon.cancel_camera()
