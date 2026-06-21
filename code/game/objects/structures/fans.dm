//Fans
/obj/structure/fans
	icon = 'icons/obj/mining_zones/survival_pod.dmi'
	icon_state = "fans"
	name = "环境调节系统"
	desc = "不断喷出空气的大型机器"
	anchored = TRUE
	density = TRUE
	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 5
	can_atmos_pass = ATMOS_PASS_NO

/obj/structure/fans/atom_deconstruct(disassembled = TRUE)
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)

/obj/structure/fans/wrench_act(mob/living/user, obj/item/I)
	user.visible_message(span_warning("[user]拆解了[src]."),
		span_notice("你开始拆卸[src]..."), span_hear("你听到叮当哐啷的响声。"))
	if(I.use_tool(src, user, 20, volume=50))
		deconstruct(TRUE)
	return TRUE

/obj/structure/fans/tiny
	name = "小风扇"
	desc = "一个小风扇，释放出稀薄的气流。"
	layer = ABOVE_NORMAL_TURF_LAYER
	density = FALSE
	icon_state = "fan_tiny"
	buildstackamount = 2

/obj/structure/fans/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE, TRUE)

/obj/structure/fans/Destroy()
	air_update_turf(TRUE, FALSE)
	. = ..()

//Invisible, indestructible fans
/obj/structure/fans/tiny/invisible
	name = "气流网"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	invisibility = INVISIBILITY_ABSTRACT

/obj/structure/fans/tiny/shield
	name = "穿梭机湾护保护罩"
	desc = "一个极其薄弱的能量护盾，仅能容纳空气，无法阻挡固体物体或人员。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old" // We should probably get these their own icon at some point
	light_color = LIGHT_COLOR_BLUE
	light_range = 4

/obj/structure/fans/tiny/shield/wrench_act(mob/living/user, obj/item/I)
	return ITEM_INTERACT_SKIP_TO_ATTACK //how you gonna wrench disassemble a shield?????????
