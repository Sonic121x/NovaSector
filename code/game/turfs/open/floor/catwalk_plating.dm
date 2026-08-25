// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * ## catwalk flooring
 *
 * They show what's underneath their catwalk flooring (pipes and the like)
 * you can screwdriver it to interact with the underneath stuff without destroying the tile...
 * unless you want to!
 */
/turf/open/floor/catwalk_floor	//the base type, meant to look like a maintenance panel
	icon = 'icons/turf/floors/catwalk_plating.dmi'
	icon_state = "maint_above"
	name = "catwalk floor"
	desc = "Flooring that shows its contents underneath. Engineers love it!"
	baseturfs = /turf/open/floor/plating
	floor_tile = /obj/item/stack/tile/catwalk_tile
	layer = CATWALK_LAYER
	footstep = FOOTSTEP_CATWALK
	overfloor_placed = TRUE
	underfloor_accessibility = UNDERFLOOR_VISIBLE
	rust_resistance = RUST_RESISTANCE_BASIC
	var/covered = TRUE
	var/catwalk_type = "maint"

/turf/open/floor/catwalk_floor/Initialize(mapload)
	. = ..()
	underlays += mutable_appearance(icon, "[catwalk_type]_below", LOW_FLOOR_LAYER, src, FLOOR_PLANE)
	update_appearance()

/turf/open/floor/catwalk_floor/examine(mob/user)
	. = ..()

	if(covered)
		. += span_notice(LANG("turf.5415cbeff4717a24", null))
	else
		. += span_notice(LANG("turf.348d6a274fa3bce8", null))
		. += span_notice(LANG("turf.ff9d66d17aebc7c4", null))

/turf/open/floor/catwalk_floor/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	covered = !covered
	if(!covered)
		underfloor_accessibility = UNDERFLOOR_INTERACTABLE
		layer = LOW_FLOOR_LAYER
		icon_state = "[catwalk_type]_below"
		ADD_TRAIT(src, TRAIT_UNCOVERED_TURF, INNATE_TRAIT)
	else
		underfloor_accessibility = UNDERFLOOR_VISIBLE
		icon_state = "[catwalk_type]_above"
		layer = initial(layer)
		REMOVE_TRAIT(src, TRAIT_UNCOVERED_TURF, INNATE_TRAIT)

	levelupdate()
	user.balloon_alert(user, "[!covered ? "cover removed" : "cover added"]")
	tool.play_tool_sound(src)
	update_appearance()

/turf/open/floor/catwalk_floor/update_overlays()
	. = ..()
	if (!covered)
		. += mutable_appearance(icon, "[catwalk_type]_overlay", CATWALK_LAYER, src, FLOOR_PLANE, appearance_flags = KEEP_APART)

/turf/open/floor/catwalk_floor/crowbar_act(mob/user, obj/item/crowbar)
	if(covered)
		user.balloon_alert(user, LANG("turf.627322fda424d134", null))
		return FALSE
	. = ..()

//Reskins! More fitting with most of our tiles, and appear as a radial on the base type
/turf/open/floor/catwalk_floor/iron
	name = "iron plated catwalk floor"
	icon_state = "iron_above"
	floor_tile = /obj/item/stack/tile/catwalk_tile/iron
	catwalk_type = "iron"

/turf/open/floor/catwalk_floor/iron_white
	name = "white plated catwalk floor"
	icon_state = "whiteiron_above"
	floor_tile = /obj/item/stack/tile/catwalk_tile/iron_white
	catwalk_type = "whiteiron"

/turf/open/floor/catwalk_floor/iron_dark
	name = "dark plated catwalk floor"
	icon_state = "darkiron_above"
	floor_tile = /obj/item/stack/tile/catwalk_tile/iron_dark
	catwalk_type = "darkiron"

/turf/open/floor/catwalk_floor/titanium
	name = "titanium plated catwalk floor"
	icon_state = "titanium_above"
	floor_tile = /obj/item/stack/tile/catwalk_tile/titanium
	catwalk_type = "titanium"
	rust_resistance = RUST_RESISTANCE_TITANIUM

/turf/open/floor/catwalk_floor/iron_smooth //the original green type
	name = "smooth plated catwalk floor"
	icon_state = "smoothiron_above"
	floor_tile = /obj/item/stack/tile/catwalk_tile/iron_smooth
	catwalk_type = "smoothiron"

//Airless variants of the above
/turf/open/floor/catwalk_floor/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/catwalk_floor/iron/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/catwalk_floor/iron_white/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/catwalk_floor/iron_dark/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/catwalk_floor/iron_dark/telecomms
	initial_gas_mix = TCOMMS_ATMOS

/turf/open/floor/catwalk_floor/titanium/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/catwalk_floor/iron_smooth/airless
	initial_gas_mix = AIRLESS_ATMOS
