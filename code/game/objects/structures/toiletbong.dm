// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/toiletbong
	name = "toilet bong"
	desc = "A repurposed toilet with re-arranged piping and an attached flamethrower. Why would anyone build this?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toiletbong"
	base_icon_state = "toiletbong"
	density = FALSE
	anchored = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.7)
	var/smokeradius = 1
	var/mutable_appearance/weed_overlay

/obj/structure/toiletbong/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/simple_rotation, post_rotation_proccall = PROC_REF(post_rotation))
	create_storage(storage_type = /datum/storage/toiletbong)

	weed_overlay = mutable_appearance('icons/obj/watercloset.dmi', "[base_icon_state]_overlay")
	START_PROCESSING(SSobj, src)

/obj/structure/toiletbong/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	var/obj/structure/toilet/toilet = locate(/obj/structure/toilet) in components
	if(toilet)
		for(var/obj/item/cistern_item in toilet.contents)
			cistern_item.forceMove(crafter.drop_location())
			to_chat(crafter, span_warning(LANG("obj.0faaa105847c0343", list(cistern_item))))
		setDir(toilet.dir)
		forceMove(toilet.loc)

	crafter.visible_message(
		span_notice(LANG("obj.ab5097c7cc8e3e8e", list(crafter))),
		span_notice(LANG("obj.2764ac655c23b6cc", null)),
	)
	return ..()

/obj/structure/toiletbong/update_overlays()
	. = ..()
	if (LAZYLEN(contents))
		. += weed_overlay

/obj/structure/toiletbong/attack_hand(mob/living/carbon/user)
	. = ..()
	if (!anchored)
		user.balloon_alert(user, LANG("obj.e30cef1e78b85e3b", null))
		return
	if (!LAZYLEN(contents))
		user.balloon_alert(user, LANG("obj.76a90f7c0f5ea424", null))
		return
	user.visible_message(span_boldnotice(LANG("obj.9912c4774db40b0e", list(user, src))))
	if (!do_after(user, 2 SECONDS, target = src))
		return
	var/turf/toiletbong_location = loc
	toiletbong_location.hotspot_expose(1000, 5)
	for (var/obj/item/item in contents)
		if (item.resistance_flags & INDESTRUCTIBLE)
			user.balloon_alert(user, LANG("obj.a19196597b6861d3", list(item.name)))
			continue
		playsound(src, 'sound/items/modsuit/flamethrower.ogg', 50)

		var/smoke_amount = DIAMOND_AREA(smokeradius)
		do_chem_smoke(amount = smoke_amount, holder = src, location = loc, carry = item.reagents, carry_limit = 20, smoke_type = /datum/effect_system/fluid_spread/smoke/chem/smoke_machine)
		if (prob(5) && !(obj_flags & EMAGGED))
			if(user.get_liked_foodtypes() & GORE)
				user.balloon_alert(user, LANG("obj.3f5fa41f018c7373", null))
				user.visible_message(span_danger(LANG("obj.75c206b477ac3966", list(user))))
			else
				to_chat(user, span_userdanger(LANG("obj.836dffd7860df41e", null)))
				user.visible_message(span_danger(LANG("obj.e83468cd684ca8be", list(user))))
				user.adjust_disgust(50)
				user.vomit(VOMIT_CATEGORY_DEFAULT)
			var/mob/living/spawned_mob = new /mob/living/basic/mouse(get_turf(user))
			spawned_mob.add_faction("[REF(user)]")
			if(prob(50))
				for(var/j in 1 to rand(1, 3))
					step(spawned_mob, pick(NORTH,SOUTH,EAST,WEST))
		qdel(item)
		if(!(obj_flags & EMAGGED))
			break
	update_appearance(UPDATE_ICON)

/obj/structure/toiletbong/wrench_act(mob/living/user, obj/item/tool)
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

///Called in the simple rotation's post_rotation callback, playing a sound cue to players.
/obj/structure/toiletbong/proc/post_rotation(mob/user, degrees)
	playsound(src, 'sound/items/deconstruct.ogg', 50)

/obj/structure/toiletbong/crowbar_act(mob/living/user, obj/item/tool)
	if(anchored)
		return FALSE
	tool.play_tool_sound(src)
	to_chat(user, span_notice(LANG("obj.6cb50b2d21a79b41", list(src))))
	if (!do_after(user, 10 SECONDS, target = src))
		return FALSE
	new /obj/item/flamethrower(get_turf(src))
	var/obj/item/tank/internals/plasma/ptank = new /obj/item/tank/internals/plasma(get_turf(src))
	ptank.air_contents.set_gas(/datum/gas/plasma, 0)
	drop_custom_materials()
	qdel(src)
	return TRUE

/obj/structure/toiletbong/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	smokeradius = 2
	playsound(src, 'sound/effects/fish_splash.ogg', 50)
	balloon_alert(user, LANG("obj.8e94d9080485c920", null))
	if (emag_card)
		to_chat(user, span_boldwarning(LANG("obj.08a106701c40a98b", list(emag_card))))
	return TRUE
