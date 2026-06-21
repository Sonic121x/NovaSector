#define BRASS_TOOLSPEED_MOD 0.5

/obj/item/wirecutters/brass
	name = "黄铜线钳"
	desc = "一把黄铜制成的线钳。手柄摸起来微微发热。"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon = 'modular_nova/modules/clock_cult/icons/tools.dmi'
	icon_state = "cutters_brass"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = null
	random_color = FALSE
	toolspeed = BRASS_TOOLSPEED_MOD

/obj/item/screwdriver/brass
	name = "黄铜螺丝刀"
	desc = "一把黄铜制成的螺丝刀。手柄摸起来很温暖。"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon = 'modular_nova/modules/clock_cult/icons/tools.dmi'
	icon_state = "screwdriver_brass"
	toolspeed = BRASS_TOOLSPEED_MOD
	random_color = FALSE
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null

/obj/item/weldingtool/experimental/brass
	name = "黄铜焊接工具"
	desc = "一把似乎能不断自我补充燃料的黄铜焊枪。摸起来微微发热。"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon = 'modular_nova/modules/clock_cult/icons/tools.dmi'
	icon_state = "welder_brass"
	toolspeed = BRASS_TOOLSPEED_MOD

/obj/item/crowbar/brass
	name = "黄铜撬棍"
	desc = "一把黄铜撬棍。摸起来微微发热。"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon = 'modular_nova/modules/clock_cult/icons/tools.dmi'
	icon_state = "crowbar_brass"
	worn_icon_state = "crowbar"
	toolspeed = BRASS_TOOLSPEED_MOD

/obj/item/wrench/brass
	name = "黄铜扳手"
	desc = "一把黄铜扳手。摸起来微微发热。"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon = 'modular_nova/modules/clock_cult/icons/tools.dmi'
	icon_state = "wrench_brass"
	toolspeed = BRASS_TOOLSPEED_MOD

/obj/item/storage/belt/utility/clock
	name = "旧工具带"
	desc = "Holds tools. This one's seen better days, though. There's the outline of a cog roughly cut into the leather on one side."

/obj/item/storage/belt/utility/clock/PopulateContents()
	new /obj/item/screwdriver/brass(src)
	new /obj/item/crowbar/brass(src)
	new /obj/item/weldingtool/experimental/brass(src)
	new /obj/item/wirecutters/brass(src)
	new /obj/item/wrench/brass(src)
	new /obj/item/multitool(src)

#undef BRASS_TOOLSPEED_MOD
