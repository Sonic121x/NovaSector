GLOBAL_LIST_EMPTY(ashwalker_tunnels)

/obj/item/tunneling_worm
	name = "ashen tunneling worm"
	desc = "A purple glow seems to radiate from the worm. It slowly gnashes at the ground."
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "tunneling_worm"

	/// the amount of uses left
	var/tunnels_remaining = 2

	/// how long it takes to create a tunnel
	var/tunnel_creation = 10 SECONDS

/obj/item/tunneling_worm/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.454ca14e19ca168d", null))
	. += span_notice(LANG("obj.8464a174be7c9e4d", list(tunnels_remaining)))

/obj/item/tunneling_worm/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /turf/open/misc/asteroid/basalt/lava_land_surface)) //eventually we could spread this to more than just lavaland?
		var/turf/interacting_turf = interacting_with
		if(locate(/obj/structure/worm_tunnel) in interacting_turf)
			to_chat(user, span_warning(LANG("obj.1e217031371bf9ce", null)))
			return ITEM_INTERACT_BLOCKING

		var/tunnel_name = tgui_input_text(user, LANG("obj.4766d484ede08747", null), LANG("obj.1f9f3afe3089c782", null), max_length = 20)
		if(isnull(tunnel_name))
			to_chat(user, span_warning(LANG("obj.a307bf25f92b4369", null)))
			return ITEM_INTERACT_BLOCKING

		//if we have the primitive skill, perhaps add some functionality to this
		if(!do_after(user, tunnel_creation, target = interacting_turf))
			to_chat(user, span_warning(LANG("obj.a307bf25f92b4369", null)))
			return ITEM_INTERACT_BLOCKING

		var/obj/structure/worm_tunnel/created_tunnel = new /obj/structure/worm_tunnel(interacting_turf)
		created_tunnel.name = tunnel_name
		GLOB.ashwalker_tunnels += created_tunnel
		tunnels_remaining -= 1
		if(tunnels_remaining <= 0)
			to_chat(user, span_warning(LANG("obj.03795134b15c555a", list(src))))
			qdel(src)

		return ITEM_INTERACT_BLOCKING

	return ..()

/obj/structure/worm_tunnel
	name = "worm tunnel"
	desc = "A horrid stench rises from the hole, perhaps the visible bile residue is the cause?"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "worm_tunnel"
	anchored = TRUE
	density = FALSE

	/// whether the tunnel is covered or not
	var/covered_tunnel = FALSE

/obj/structure/worm_tunnel/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.2ba40bdaf78be6c4", null))
	. += span_notice(LANG("obj.983541b0d6038812", null))

/obj/structure/worm_tunnel/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/sheet/mineral/wood))
		if(covered_tunnel)
			to_chat(user, span_warning(LANG("obj.9f3ce6e6bb9461ea", list(src))))
			return ITEM_INTERACT_BLOCKING

		if(!tool.use(2))
			to_chat(user, span_warning(LANG("obj.c3779f35c16dbb8e", list(tool, src))))
			return ITEM_INTERACT_BLOCKING

		if(!do_after(user, 5 SECONDS, target = src))
			to_chat(user, span_notice(LANG("obj.1a9bcffd298d5123", list(src))))
			return ITEM_INTERACT_BLOCKING

		covered_tunnel = TRUE
		add_overlay("tunnel_cover")
		return ITEM_INTERACT_BLOCKING

	return ..()

/obj/structure/worm_tunnel/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(covered_tunnel)
		if(!do_after(user, 5 SECONDS, target = src))
			to_chat(user, span_notice(LANG("obj.b5343c68f75dd5a7", list(src))))
			return

		var/obj/item/stack/spawning_stack = new /obj/item/stack/sheet/mineral/wood(get_turf(user))
		spawning_stack.amount = 2
		cut_overlay("tunnel_cover")
		return

	var/obj/structure/worm_tunnel/tunnel_choice = tgui_input_list(user, LANG("obj.92bb454bb3758a1e", null), LANG("obj.c1a702faddc9f52b", null), GLOB.ashwalker_tunnels)
	if(isnull(tunnel_choice))
		return

	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(isashwalker(user))
		if(!do_after(user, 10 SECONDS * skill_modifier, target = src))
			to_chat(user, span_notice(LANG("obj.78e2684458008d5b", list(src))))
			return

	else
		to_chat(user, span_warning(LANG("obj.1efd7c97be62eaf7", list(src))))
		for(var/iterations in 1 to 3)
			if(!do_after(user, 6 SECONDS * skill_modifier, target = src))
				return
			user.adjust_brute_loss(10)

	if(tunnel_choice.covered_tunnel)
		to_chat(user, span_warning(LANG("obj.4f6e67565adae6f1", list(tunnel_choice))))
		return

	user.forceMove(get_turf(tunnel_choice))

/obj/structure/worm_tunnel/Destroy(force)
	GLOB.ashwalker_tunnels -= src
	return ..()

/obj/structure/worm_tunnel/shovel_act(mob/living/user, obj/item/tool)
	if(!do_after(user, 10 SECONDS, target = src))
		to_chat(user, span_notice(LANG("obj.76e8fe689d6bf11d", list(src))))
		return

	qdel(src)
