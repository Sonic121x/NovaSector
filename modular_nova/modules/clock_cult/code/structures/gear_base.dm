/obj/structure/destructible/clockwork/gear_base
	name = "齿轮基座"
	desc = "一个平放在地面上的大型齿轮。"
	icon_state = "gear_base"
	clockwork_desc = "A large cog lying on the floor at feet level."
	anchored = FALSE
	break_message = span_warning("哦，它坏了。")
	/// What's appeneded to the structure when unanchored
	var/unwrenched_suffix = "_unwrenched"
	/// If this can be moved at all by unwrenching it
	var/can_unwrench = TRUE


/obj/structure/destructible/clockwork/gear_base/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clockwork_structure_info)


/obj/structure/destructible/clockwork/gear_base/wrench_act(mob/living/user, obj/item/tool)
	if(!IS_CLOCK(user))
		return

	if(!can_unwrench)
		balloon_alert(user, "无法卸下！")
		return

	balloon_alert(user, "[anchored ? "unwrenching" : "wrenching"]...")

	if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
		return

	visible_message(span_notice("[user] [anchored ? "unwrenches" : "wrenches down"]了[src]。"), span_notice("你[anchored ? "unwrench" : "wrench"]了[src]。"))

	anchored = !anchored
	update_icon_state()

	return TRUE


/obj/structure/destructible/clockwork/gear_base/update_icon_state()
	. = ..()
	icon_state = initial(icon_state)

	if(!anchored)
		icon_state += unwrenched_suffix
