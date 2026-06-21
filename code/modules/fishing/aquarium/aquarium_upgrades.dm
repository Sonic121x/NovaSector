
/// Aquarium upgrades, can be applied to a basic aquarium to upgrade it into an advanced subtype.
/obj/item/aquarium_upgrade
	name = "水族箱升级套件"
	desc = "一个升级套件。"

	icon = 'icons/obj/aquarium/supplies.dmi'
	icon_state = "construction_kit"
	/// What kind of aquarium can accept this upgrade. Strict type check, no subtypes.
	var/upgrade_from_type = /obj/structure/aquarium
	/// typepath of the new aquarium subtype created.
	var/upgrade_to_type = /obj/structure/aquarium

/obj/item/aquarium_upgrade/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!HAS_TRAIT(interacting_with, TRAIT_IS_AQUARIUM))
		return NONE
	if(upgrade_from_type != interacting_with.type)
		interacting_with.balloon_alert(user, "水族箱类型不对！")
		return ITEM_INTERACT_BLOCKING
	interacting_with.balloon_alert(user, "正在升级...")
	if(!PERFORM_ALL_TESTS(aquarium_upgrade) && !do_after(user, 5 SECONDS, interacting_with))
		return ITEM_INTERACT_BLOCKING
	var/atom/movable/upgraded_aquarium = new upgrade_to_type(interacting_with.drop_location())
	//This should transfer all the fish, reagents and settings from the aquarium component
	interacting_with.TransferComponents(upgraded_aquarium)
	upgraded_aquarium.balloon_alert(user, "已升级")
	qdel(src)
	qdel(interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/aquarium_upgrade/bioelec_gen
	name = "水族箱生物电套件"
	desc = "使水族箱能够利用生物电鱼类能量的所有必需组件。"
	icon_state = "bioelec_kit"
	upgrade_to_type = /obj/structure/aquarium/bioelec_gen

/obj/structure/aquarium/bioelec_gen
	name = "生物电发电机"
	desc = "一种非常规的发电机，能增强并收集生物电鱼类产生的能量。"

	icon_state = "bioelec_map"
	base_icon_state = "bioelec"

	default_beauty = 0

/obj/structure/aquarium/bioelec_gen/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_BIOELECTRIC_GENERATOR, INNATE_TRAIT)

/obj/structure/aquarium/bioelec_gen/zap_act(power, zap_flags)
	var/explosive = zap_flags & ZAP_MACHINE_EXPLOSIVE
	if(!explosive)
		return //immune to all other shocks to make sure power can be generated without breaking the generator itself
	return ..()

/obj/structure/aquarium/bioelec_gen/examine(mob/user)
	. = ..()
	. += span_boldwarning("警告！警告！警告！")
	. += span_warning("内部鱼类的生物电潜能被发电机放大到了危险水平。")
	. += span_notice("需要特斯拉线圈来收集这些被放大的能量……你还需要一根接地棒来保护自己。")

/obj/item/aquarium_upgrade/bluespace_tank
	name = "蓝空间鱼缸套件"
	desc = "将你的便携式鱼缸升级为无底的手持水族箱所需的组件。"
	icon_state = "bluespace_kit"
	upgrade_from_type = /obj/item/fish_tank
	upgrade_to_type = /obj/item/fish_tank/bluespace

/obj/item/fish_tank/bluespace
	name = "蓝空间鱼缸"
	desc = "将庞大房间水族箱的所有容量，压缩进一个袋子大小的长方体里。"
	icon_state = "fish_tank_bluespace_map"
	base_icon_state = "fish_tank_bluespace"
	w_class = WEIGHT_CLASS_NORMAL
	maximum_relative_size = INFINITY
	max_total_size = 2000
	slowdown_coeff = 0.15
	min_fluid_temp = MIN_AQUARIUM_TEMP
	max_fluid_temp = MAX_AQUARIUM_TEMP
	reagent_size = 6
