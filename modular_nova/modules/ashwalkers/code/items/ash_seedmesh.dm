/obj/item/seed_mesh
	name = "种子筛网"
	desc = "一个小筛网，与沙子配合使用时，有可能过滤出大颗种子。"
	icon = 'modular_nova/modules/ashwalkers/icons/misc_tools.dmi'
	icon_state = "mesh"

	///which seeds cannot be obtained through shifting/sieving
	var/static/list/seeds_blacklist = list(
		/obj/item/seeds/lavaland,
		/obj/item/seeds/gatfruit,
		/obj/item/seeds/seedling/evil,
	)

/obj/item/seed_mesh/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/stack/ore/glass))
		var/obj/item/stack/ore/ore_item = attacking_item
		if(ore_item.points == 0)
			user.balloon_alert(user, "[ore_item]毫无价值！")
			return

		while(ore_item.amount >= 5)
			var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
			if(!do_after(user, 2 SECONDS * skill_modifier, src))
				user.balloon_alert(user, "必须保持静止！")
				return

			if(!ore_item.use(5))
				user.balloon_alert(user, "无法使用五个[ore_item]！")
				return

			if(prob(80 * skill_modifier)) //start at 80, go down to 40 at legendary skill
				user.balloon_alert(user, "[ore_item] 什么都没发现！")
				user.mind?.adjust_experience(/datum/skill/primitive, 2)
				continue

			var/spawn_seed = pick(subtypesof(/obj/item/seeds) - seeds_blacklist)
			new spawn_seed(get_turf(src))
			user.mind?.adjust_experience(/datum/skill/primitive, 2)
			user.balloon_alert(user, "[ore_item] 发现了东西！")

	return ..()
