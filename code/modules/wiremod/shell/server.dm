/**
 * # Server
 *
 * Immobile (but not dense) shells that can interact with
 * world.
 */
/obj/structure/server
	name = "服务器"
	icon = 'icons/obj/science/circuits.dmi'
	icon_state = "setup_stationary"

	density = TRUE
	light_system = OVERLAY_LIGHT
	light_on = FALSE

/obj/structure/server/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/shell, null, SHELL_CAPACITY_VERY_LARGE, SHELL_FLAG_REQUIRE_ANCHOR|SHELL_FLAG_USB_PORT)

/obj/structure/server/wrench_act(mob/living/user, obj/item/tool)
	set_anchored(!anchored)
	tool.play_tool_sound(src)
	balloon_alert(user, anchored ? "已固定" : "未固定")
	return TRUE
