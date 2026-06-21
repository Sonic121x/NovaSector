/obj/effect/mine/explosive/light/ancient_milsim
	arm_delay = 1.5 SECONDS
	light_range = 1
	light_power = 0.5
	light_color = COLOR_VIVID_RED

/obj/effect/mine/explosive/light/ancient_milsim/now_armed()
	. = ..()
	alpha = 155
	set_light_on(TRUE)

/obj/item/minespawner/ancient_milsim
	name = "已停用的低当量隐形地雷"
	desc = "激活后，将在1.5秒后部署一枚低当量、低可见度的爆炸性地雷，非常适合在狭窄走廊设置陷阱。"
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "landmine-inactive"

	mine_type = /obj/effect/mine/explosive/light/ancient_milsim
