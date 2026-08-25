// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/wallframe/light_fixture
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	result_path = /obj/structure/light_construct
	wall_external = TRUE

/obj/item/wallframe/light_fixture/find_support_structure(atom/structure)
	return istype(structure, /obj/structure/window) ? structure : ..()

/obj/item/wallframe/light_fixture/try_build(atom/support, mob/user)
	var/area/A = get_area(user)
	if(A.always_unpowered)
		balloon_alert(user, LANG("obj.503cb4c57dfefe6a", null))
		return FALSE
	return ..()

/obj/item/wallframe/light_fixture/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	result_path = /obj/structure/light_construct/small
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)

/obj/item/wallframe/light_fixture/try_build(turf/on_wall, user)
	if(!..())
		return
	var/area/local_area = get_area(user)
	if(!local_area.static_lighting)
		to_chat(user, span_warning(LANG("obj.020656f68c6d9619", list(src))))
		return
	return TRUE

/obj/item/wallframe/light_fixture/small/attack_self(mob/user)
	var/turf/local_turf = get_turf(user)
	var/area/local_area = get_area(user)
	if(!isturf(user.loc) || !isfloorturf(local_turf))
		balloon_alert(user, LANG("obj.76e1c3bd20a1e9f0", null))
		return
	if(local_area.always_unpowered || !local_area.static_lighting)
		balloon_alert(user, LANG("obj.503cb4c57dfefe6a", null))
		return
	for(var/obj/object in local_turf)
		if(object.density && !(object.obj_flags & IGNORE_DENSITY) || object.obj_flags & BLOCKS_CONSTRUCTION)
			balloon_alert(user, LANG("obj.ae97e927b85b5520", null))
			return
	if(local_turf.underfloor_accessibility < UNDERFLOOR_INTERACTABLE)
		balloon_alert(user, LANG("obj.0d1f39e91e5c3d13", null))
		return
	if(locate(/obj/structure/light_construct/floor) in local_turf)
		balloon_alert(user, LANG("obj.f08e630f0ae009b4", null))
		return
	if(locate(/obj/machinery/light/floor) in local_turf)
		balloon_alert(user, LANG("obj.f08e630f0ae009b4", null))
		return

	playsound(src.loc, 'sound/machines/click.ogg', 75, TRUE)
	user.visible_message(span_notice(LANG("obj.930e8417b1d0cf5e", list(user.name, src))),
		span_notice(LANG("obj.867aa3e9f135ceed", list(src))),
		span_hear(LANG("obj.dcc6c1b00318bad4", null)))

	new /obj/structure/light_construct/floor(local_turf)
	qdel(src)

