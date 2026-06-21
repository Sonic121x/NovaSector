GLOBAL_LIST_EMPTY(ashwalker_tunnels)

/obj/item/tunneling_worm
	name = "灰烬掘地蠕虫"
	desc = "蠕虫似乎散发着紫色的光芒。它正缓慢地啃噬着地面。"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "tunneling_worm"

	/// the amount of uses left
	var/tunnels_remaining = 2

	/// how long it takes to create a tunnel
	var/tunnel_creation = 10 SECONDS

/obj/item/tunneling_worm/examine(mob/user)
	. = ..()
	. += span_notice("<br>在行星表面使用以创建一条隧道。")
	. += span_notice("剩余 [tunnels_remaining] 条隧道。")

/obj/item/tunneling_worm/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /turf/open/misc/asteroid/basalt/lava_land_surface)) //eventually we could spread this to more than just lavaland?
		var/turf/interacting_turf = interacting_with
		if(locate(/obj/structure/worm_tunnel) in interacting_turf)
			to_chat(user, span_warning("这里已经有一条隧道了！"))
			return ITEM_INTERACT_BLOCKING

		var/tunnel_name = tgui_input_text(user, "你想给隧道起什么名字？", "隧道命名（最多20个字符）", max_length = 20)
		if(isnull(tunnel_name))
			to_chat(user, span_warning("你决定不创建隧道！"))
			return ITEM_INTERACT_BLOCKING

		//if we have the primitive skill, perhaps add some functionality to this
		if(!do_after(user, tunnel_creation, target = interacting_turf))
			to_chat(user, span_warning("你决定不创建隧道！"))
			return ITEM_INTERACT_BLOCKING

		var/obj/structure/worm_tunnel/created_tunnel = new /obj/structure/worm_tunnel(interacting_turf)
		created_tunnel.name = tunnel_name
		GLOB.ashwalker_tunnels += created_tunnel
		tunnels_remaining -= 1
		if(tunnels_remaining <= 0)
			to_chat(user, span_warning("[src] 已经耗尽了！"))
			qdel(src)

		return ITEM_INTERACT_BLOCKING

	return ..()

/obj/structure/worm_tunnel
	name = "蠕虫隧道"
	desc = "一股恶臭从洞中升起，也许是可见的胆汁残留物造成的？"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "worm_tunnel"
	anchored = TRUE
	density = FALSE

	/// whether the tunnel is covered or not
	var/covered_tunnel = FALSE

/obj/structure/worm_tunnel/examine(mob/user)
	. = ..()
	. += span_notice("<br>使用铲子可以摧毁隧道。")
	. += span_notice("使用两块木板可以封堵隧道，直到移除为止。")

/obj/structure/worm_tunnel/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/sheet/mineral/wood))
		if(covered_tunnel)
			to_chat(user, span_warning("[src]已经被木头堵住了！"))
			return ITEM_INTERACT_BLOCKING

		if(!tool.use(2))
			to_chat(user, span_warning("你无法用[tool]来覆盖[src]！"))
			return ITEM_INTERACT_BLOCKING

		if(!do_after(user, 5 SECONDS, target = src))
			to_chat(user, span_notice("你决定不覆盖[src]。"))
			return ITEM_INTERACT_BLOCKING

		covered_tunnel = TRUE
		add_overlay("tunnel_cover")
		return ITEM_INTERACT_BLOCKING

	return ..()

/obj/structure/worm_tunnel/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(covered_tunnel)
		if(!do_after(user, 5 SECONDS, target = src))
			to_chat(user, span_notice("你决定不揭开[src]。"))
			return

		var/obj/item/stack/spawning_stack = new /obj/item/stack/sheet/mineral/wood(get_turf(user))
		spawning_stack.amount = 2
		cut_overlay("tunnel_cover")
		return

	var/obj/structure/worm_tunnel/tunnel_choice = tgui_input_list(user, "你想前往哪个蠕虫隧道？", "蠕虫隧道选择", GLOB.ashwalker_tunnels)
	if(isnull(tunnel_choice))
		return

	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(isashwalker(user))
		if(!do_after(user, 10 SECONDS * skill_modifier, target = src))
			to_chat(user, span_notice("你决定不穿过[src]。"))
			return

	else
		to_chat(user, span_warning("你正试图进入[src]！它反抗了！也许坚持一下会有帮助？"))
		for(var/iterations in 1 to 3)
			if(!do_after(user, 6 SECONDS * skill_modifier, target = src))
				return
			user.adjust_brute_loss(10)

	if(tunnel_choice.covered_tunnel)
		to_chat(user, span_warning("[tunnel_choice]被覆盖了！返回起点！"))
		return

	user.forceMove(get_turf(tunnel_choice))

/obj/structure/worm_tunnel/Destroy(force)
	GLOB.ashwalker_tunnels -= src
	return ..()

/obj/structure/worm_tunnel/shovel_act(mob/living/user, obj/item/tool)
	if(!do_after(user, 10 SECONDS, target = src))
		to_chat(user, span_notice("你决定不填埋[src]。"))
		return

	qdel(src)
