/*
*	WALLS
*/

/turf/closed/indestructible/dungeon
	name = "石墙"
	desc = "冰冷的石墙。就像地牢一样。"
	icon = 'modular_nova/modules/mapping/icons/unique/dungeon.dmi'
	icon_state = "wall"
	base_icon_state = "wall"
	explosive_resistance = INFINITY

/turf/closed/indestructible/dungeon/corner
	icon_state = "wall-corner"
	base_icon_state = "wall-corner"

/*
*	TURFS
*/

/turf/open/floor/plating/cobblestone
	gender = PLURAL
	name = "鹅卵石"
	desc = "铺成永久道路的鹅卵石。有点老派。"
	icon = 'modular_nova/modules/mapping/icons/unique/dungeon.dmi'
	icon_state = "cobble"
	planetary_atmos = FALSE

/turf/open/floor/plating/cobblestone/planet
	baseturfs = /turf/open/misc/dirt/planet
	planetary_atmos = TRUE

/turf/open/floor/plating/cobblestone/dungeon
	icon_state = "cobble-dungeon"
	baseturfs = /turf/open/floor/plating/cobblestone/dungeon
	planetary_atmos = FALSE

// This one has a rocky texture to it.
/turf/open/floor/plating/cobblestone/sparse
	icon_state = "cobble_sparse"
	baseturfs = /turf/open/floor/plating/cobblestone/sparse

/turf/open/floor/plating/cobblestone/sparse/planet
	icon_state = "cobble_sparse"
	baseturfs = /turf/open/floor/plating/cobblestone/sparse/planet
	planetary_atmos = TRUE

/*
*	FAKE WALLS
*/

/obj/structure/dungeon
	name = "有个洞的石墙！"
	desc = "墙上的一个洞！它很小。"
	icon = 'modular_nova/modules/mapping/icons/unique/dungeon.dmi'
	icon_state = "wall-hole"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/dungeon/doorway
	name = "门口"
	desc = "在石墙上开凿出的门口。空间很狭窄。"
	icon = 'modular_nova/modules/mapping/icons/unique/dungeon.dmi'
	icon_state = "wall-doorway"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/railing/stone/Initialize(mapload)
	.=..()
	if(dir == 2)
		layer = ABOVE_MOB_LAYER
	else
		return

/obj/structure/railing/stone
	name = "石墙"
	desc = "鹅卵石墙。这相当坚固。"
	icon = 'modular_nova/modules/mapping/icons/unique/dungeon.dmi'
	icon_state = "cobble-wall"
	max_integrity = 100
	density = TRUE
	anchored = TRUE
	climbable = TRUE

/obj/structure/railing/stone/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	to_chat(user, span_notice("你皱起眉头，意识到这堵墙实际上是由石头制成的，无法仅用一把扳手就从地上拔起并拖走。"))
	return

/obj/structure/railing/stone/left
	icon_state = "cobble-wall-left"
	density = FALSE
	climbable = FALSE

/obj/structure/railing/stone/right
	icon_state = "cobble-wall-right"
	density = FALSE
	climbable = FALSE

/obj/structure/mineral_door/dungeon
	name = "木门"
	desc = "一扇小木门。它大概还能打开，只是有点小。"
	icon = 'modular_nova/modules/mapping/icons/unique/dungeon.dmi'
	icon_state = "wall-door"
	openSound = 'sound/effects/doorcreaky.ogg'
	closeSound = 'sound/effects/doorcreaky.ogg'
	sheetType = /obj/item/stack/sheet/mineral/wood
	max_integrity = 100

/obj/machinery/button/dungeon
	name = "石砖"
	desc = "一块从墙里凸出来的砖。嗯。"
	icon = 'modular_nova/modules/mapping/icons/unique/dungeon.dmi'
	base_icon_state = "doorctrl"
	icon_state = "doorctrl"
	power_channel = AREA_USAGE_ENVIRON
	use_power = NO_POWER_USE
	idle_power_usage = 0
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/button/dungeon/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_notice("你戳了戳砖块的边缘，试着把它塞进去。看来这样是弄不出来了。"))
		return
// Let's not open the maintenance panel of a stone brick.
