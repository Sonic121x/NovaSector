#define SUPPLY_POD_QUICK_DAMAGE 40
#define SUPPLY_POD_QUICK_FIRE_RANGE 2

/// Quickly throws a supply pod at the target, optionally with an item
/datum/smite/supply_pod_quick
	name = "补给舱 (快速)"

	/// What is sent down with the pod
	var/target_path

/datum/smite/supply_pod_quick/configure(client/user)
	var/attempted_target_path = input(
		user,
		"输入你想用补给舱发送的原子的类型路径（输入\"empty\"以发送空舱）：",
		"类型路径",
		"/obj/item/food/grown/harebell",
	) as null|text

	if (isnull(attempted_target_path)) //The user pressed "Cancel"
		return FALSE

	if (attempted_target_path == "empty")
		target_path = null
		return

	// if you didn't type empty, we want to load the pod with a delivery
	var/delivery = text2path(attempted_target_path)
	if(!ispath(delivery))
		delivery = pick_closest_path(attempted_target_path)
		if(!delivery)
			tgui_alert(user, "错误：路径不正确/不合法。")
			return FALSE
	target_path = delivery

/datum/smite/supply_pod_quick/effect(client/user, mob/living/target)
	. = ..()
	podspawn(list(
		"target" = get_turf(target),
		"path" = /obj/structure/closet/supplypod/centcompod,
		"style" = /datum/pod_style/centcom,
		"spawn" = target_path,
		"damage" = SUPPLY_POD_QUICK_DAMAGE,
		"explosionSize" = list(0, 0, 0, SUPPLY_POD_QUICK_FIRE_RANGE),
		"effectStun" = TRUE
	))

#undef SUPPLY_POD_QUICK_DAMAGE
#undef SUPPLY_POD_QUICK_FIRE_RANGE
