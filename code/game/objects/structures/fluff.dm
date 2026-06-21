/**
 * # Fluff structure
 *
 * Fluff structures serve no purpose and exist only for enriching the environment. By default, they can be deconstructed with a wrench.
 */
/obj/structure/fluff
	name = "杂乱结构"
	desc = "比绵羊还要蓬松。这东西本不该存在。"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "minibar"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	///If true, the structure can be deconstructed into a metal sheet with a wrench.
	var/deconstructible = TRUE

/obj/structure/fluff/attackby(obj/item/I, mob/living/user, list/modifiers, list/attack_modifiers)
	if(I.tool_behaviour == TOOL_WRENCH && deconstructible)
		user.visible_message(span_notice("[user] starts disassembling [src]..."), span_notice("You start disassembling [src]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 50))
			user.visible_message(span_notice("[user] disassembles [src]!"), span_notice("You break down [src] into scrap metal."))
			playsound(user, 'sound/items/deconstruct.ogg', 50, TRUE)
			new/obj/item/stack/sheet/iron(drop_location())
			qdel(src)
		return
	..()

/**
 * Empty terrariums are created when a preserved terrarium in a lavaland seed vault is activated.
 */
/obj/structure/fluff/empty_terrarium
	name = "空的玻璃饲养箱"
	desc = "一种古老的机器，似乎用来储存植物。它的舱门半开着。"
	icon = 'icons/obj/mining_zones/spawners.dmi'
	icon_state = "terrarium_open"
	density = TRUE

/**
 * Empty sleepers are created by a good few ghost roles in lavaland.
 */
/obj/structure/fluff/empty_sleeper
	name = "空休眠舱"
	desc = "一个敞开的休眠仓。看起来就像是在等待另一个病人，如果它没有坏掉的话。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper-open"

/obj/structure/fluff/empty_sleeper/nanotrasen
	name = "坏了的冬眠舱"
	desc = "A Nanotrasen hypersleep chamber - this one appears broken. \
		There are exposed bolts for easy disassembly using a wrench."
	icon_state = "sleeper-o"

/obj/structure/fluff/empty_sleeper/syndicate
	icon_state = "sleeper_s-open"

/**
 * Empty cryostasis sleepers are created when a malfunctioning cryostasis sleeper in a lavaland shelter is activated.
 */
/obj/structure/fluff/empty_cryostasis_sleeper
	name = "空冷冻休眠舱"
	desc = "虽然很舒服，但这款睡眠机除了当床外什么也不能做。"
	icon = 'icons/obj/mining_zones/spawners.dmi'
	icon_state = "cryostasis_sleeper_open"

/**
 * Ash drake status spawn on either side of the necropolis gate in lavaland.
 */
/obj/structure/fluff/drake_statue
	name = "灰烬雕像"
	desc = "一块高耸的玄武岩雕像，雕刻了一只骄傲而威严的龙的形象。它的六只眼睛闪烁着宝石的光芒。"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "drake_statue"
	pixel_x = -16
	maptext_height = 64
	maptext_width = 64
	density = TRUE
	deconstructible = FALSE
	layer = EDGED_TURF_LAYER

/**
 * shower drain placed usually under showers just so it looks like something picks the water up.
 */
/obj/structure/fluff/shower_drain
	name = "shower drain"
	desc = "Ew, I think I see a hairball."
	icon = 'icons/obj/mining_zones/survival_pod.dmi'
	icon_state = "fan_tiny"
	plane = FLOOR_PLANE
	layer = BELOW_CATWALK_LAYER

/**
 * A variety of statue in disrepair; parts are broken off and a gemstone is missing
 */
/obj/structure/fluff/drake_statue/falling
	desc = "一块高耸的玄武岩雕像，雕刻了一只龙的形象。它的表面布满了裂纹，而且一部分垮塌了。"
	icon_state = "drake_statue_falling"


/obj/structure/fluff/bus
	name = "巴士"
	desc = "上学去。读本书。"
	icon = 'icons/obj/fluff/bus.dmi'
	icon_state = null
	density = TRUE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/bus/dense
	name = "bus"
	icon_state = "backwall"

/obj/structure/fluff/bus/passable
	name = "bus"
	icon_state = "frontwalltop"
	density = FALSE
	layer = ABOVE_ALL_MOB_LAYER //except for the stairs tile, which should be set to OBJ_LAYER aka 3.
	plane = ABOVE_GAME_PLANE


/obj/structure/fluff/bus/passable/seat
	name = "座位"
	desc = "系好安全带！...你说没有安全带是什么意思？！"
	icon_state = "backseat"
	pixel_y = 17
	layer = OBJ_LAYER
	plane = GAME_PLANE


/obj/structure/fluff/bus/passable/seat/driver
	name = "驾驶员座椅"
	desc = "太空耶稣是我的副驾驶。"
	icon_state = "driverseat"

/obj/structure/fluff/bus/passable/seat/driver/attack_hand(mob/user, list/modifiers)
	playsound(src, 'sound/items/carhorn.ogg', 50, TRUE)
	. = ..()

/obj/structure/fluff/paper
	name = "厚厚一层纸"
	desc = "墙角散落着厚厚一层纸。"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "paper"
	deconstructible = FALSE

/obj/structure/fluff/paper/corner
	icon_state = "papercorner"

/obj/structure/fluff/paper/stack
	name = "厚厚一叠纸"
	desc = "一堆各种各样的文件，每一页上都散落着孩子们的涂鸦。"
	icon_state = "paperstack"


/obj/structure/fluff/divine
	name = "神迹"
	icon = 'icons/obj/service/hand_of_god_structures.dmi'
	icon_state = "error"
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/divine/nexus
	name = "nexus"
	desc = "It anchors a deity to this world. It radiates an unusual aura. It looks well protected from explosive shock."
	icon_state = "nexus"

/obj/structure/fluff/divine/conduit
	name = "conduit"
	desc = "It allows a deity to extend their reach.  Their powers are just as potent near a conduit as a nexus."
	icon_state = "conduit"

/obj/structure/fluff/divine/convertaltar
	name = "conversion altar"
	desc = "An altar dedicated to a deity."
	icon_state = "convertaltar"
	density = FALSE
	can_buckle = 1

/obj/structure/fluff/divine/powerpylon
	name = "power pylon"
	desc = "A pylon which increases the deity's rate it can influence the world."
	icon_state = "powerpylon"
	can_buckle = 1

/obj/structure/fluff/divine/defensepylon
	name = "defense pylon"
	desc = "A pylon which is blessed to withstand many blows, and fire strong bolts at nonbelievers. A god can toggle it."
	icon_state = "defensepylon"

/obj/structure/fluff/divine/shrine
	name = "shrine"
	desc = "A shrine dedicated to a deity."
	icon_state = "shrine"

/obj/structure/fluff/fokoff_sign
	name = "粗制标牌"
	desc = "一块做工粗糙的标志牌，上面用红色颜料写着“滚开”。"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "fokof"

/obj/structure/fluff/big_chain
	name = "巨大铁链"
	desc = "一条延申至天花板的巨大铁链"
	icon = 'icons/effects/32x96.dmi'
	icon_state = "chain"
	anchored = TRUE
	density = TRUE
	deconstructible = FALSE
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/structure/fluff/beach_towel
	name = "沙滩毛巾"
	desc = "一条用各种沙滩主题图案装饰的毛巾。"
	icon = 'icons/obj/railings.dmi'
	icon_state = "railing"
	density = FALSE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/beach_umbrella
	name = "沙滩伞"
	desc = "一款精美的遮阳伞，专为保护游客免受沙滩阳光直射而设计。"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "brella"
	density = FALSE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/beach_umbrella/security
	icon_state = "hos_brella"

/obj/structure/fluff/beach_umbrella/science
	icon_state = "rd_brella"

/obj/structure/fluff/beach_umbrella/engine
	icon_state = "ce_brella"

/obj/structure/fluff/beach_umbrella/cap
	icon_state = "cap_brella"

/obj/structure/fluff/beach_umbrella/syndi
	icon_state = "syndi_brella"

/obj/structure/fluff/clockwork
	name = "钟表杂物"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "error"
	deconstructible = FALSE

/obj/structure/fluff/clockwork/alloy_shards
	name = "复制合金碎片"
	desc = "一些具有奇特可塑性的金属碎片。它们偶尔会自行移动而且看起来似乎在发光。"
	icon_state = "alloy_shards"

/obj/structure/fluff/clockwork/alloy_shards/small
	icon_state = "shard_small1"

/obj/structure/fluff/clockwork/alloy_shards/medium
	icon_state = "shard_medium1"

/obj/structure/fluff/clockwork/alloy_shards/medium_gearbit
	icon_state = "gear_bit1"

/obj/structure/fluff/clockwork/alloy_shards/large
	icon_state = "shard_large1"

/obj/structure/fluff/clockwork/blind_eye
	name = "盲眼"
	desc = "一只沉重的铜制眼球，它的红色瞳孔暗淡无光。"
	icon_state = "blind_eye"

/obj/structure/fluff/clockwork/fallen_armor
	name = "残破盔甲"
	desc = "毫无生气的盔甲碎片。它们的设计方式很奇特，你穿不进去。"
	icon_state = "fallen_armor"

/obj/structure/fluff/clockwork/clockgolem_remains
	name = "钟表傀儡残骸"
	desc = "一堆废金属。看起来已经没法修复了。"
	icon_state = "clockgolem_dead"

/obj/structure/fluff/tram_rail
	name = "电车轨道"
	desc = "对于有轨电车来说很棒，但对于滑板来说就不那么好了。"
	icon = 'icons/obj/tram/tram_rails.dmi'
	icon_state = "rail"
	layer = TRAM_RAIL_LAYER
	plane = FLOOR_PLANE
	resistance_flags =  INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	deconstructible = FALSE
	can_buckle = TRUE
	buckle_requires_restraints = TRUE
	buckle_lying = 90

/obj/structure/fluff/tram_rail/post_buckle_mob(mob/living/target)
	. = ..()
	target.pixel_y += dir == SOUTH ? -3 : 14
	RegisterSignal(target, COMSIG_LIVING_HIT_BY_TRAM, PROC_REF(on_buckled_tram_smashed))

/obj/structure/fluff/tram_rail/post_unbuckle_mob(mob/living/target)
	. = ..()
	target.pixel_y -= dir == SOUTH ? -3 : 14
	UnregisterSignal(target, COMSIG_LIVING_HIT_BY_TRAM)

/// If someone gets hit by the tram while buckled to us (mission accomplished) unbuckle them so that they can fly away
/// Also we rip one of their arms off to "uncuff" them
/obj/structure/fluff/tram_rail/proc/on_buckled_tram_smashed(mob/living/smashed)
	SIGNAL_HANDLER
	unbuckle_mob(smashed, force = TRUE, can_fall = FALSE) // Make sure they don't fall down a z-level until they've been thrown

/obj/structure/fluff/tram_rail/floor
	name = "tram rail protective cover"
	icon_state = "rail_floor"

/obj/structure/fluff/tram_rail/end
	icon_state = "railend"

/obj/structure/fluff/tram_rail/anchor
	name = "电车轨道防爬器"
	icon_state = "anchor"

/obj/structure/fluff/tram_rail/electric
	desc = "Great for trams, not so great for skating. This one is a power rail."
	/// What power channel from the APC do we check for power?
	var/power_channel = AREA_USAGE_ENVIRON

/obj/structure/fluff/tram_rail/electric/anchor
	name = "电车轨道防爬器"
	icon_state = "anchor"

/obj/structure/fluff/tram_rail/electric/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/electrified_buckle,\
		input_requirements = SHOCK_REQUIREMENT_AREA_POWER,\
		shock_immediately = TRUE,\
		print_message = FALSE,\
		damage_on_shock = 5,\
		loop_length = 8 SECONDS,\
		area_power_channel = power_channel,\
		shock_flags = SHOCK_NOSTUN\
	)

/obj/structure/fluff/tram_rail/electric/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/area/our_area = get_area(src)
	if(our_area?.powered(power_channel) && user.electrocute_act(75, src))
		do_sparks(5, TRUE, src)

/obj/structure/fluff/broken_canister_frame
	name = "broken canister frame"
	desc = "A torn apart canister. It looks like some metal can be salvaged with a wrench."
	icon_state = "broken_canister"
	anchored = FALSE
	density = TRUE
	deconstructible = TRUE

/obj/structure/fluff/wallsign
	name = "direction sign"
	desc = "Now, where to go?"
	density = FALSE
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "wallsign"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/fluff/wallsign, 32)
