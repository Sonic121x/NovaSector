/obj/item/seed_mesh
	name = "seed mesh"
	desc = "A little mesh that, when paired with sand, has the possibility of filtering out large seeds."
	icon = 'modular_nova/modules/ashwalkers/icons/misc_tools.dmi'
	icon_state = "mesh"

	///which seeds cannot be obtained through shifting/sieving
	var/static/list/seeds_blacklist = list(
		/obj/item/seeds/lavaland,
		/obj/item/seeds/gatfruit,
		/obj/item/seeds/seedling/evil,
	)

/obj/item/seed_mesh/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/ore/glass))
		var/obj/item/stack/ore/ore_item = tool
		if(ore_item.points == 0)
			user.balloon_alert(user, LANG("obj.80034cf0734c7fee", list(ore_item)))
			return ITEM_INTERACT_BLOCKING

		while(ore_item.amount >= 5)
			var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
			if(!do_after(user, 2 SECONDS * skill_modifier, src))
				user.balloon_alert(user, LANG("obj.e11afae0e63df866", null))
				return ITEM_INTERACT_BLOCKING

			if(!ore_item.use(5))
				user.balloon_alert(user, LANG("obj.04cf9a5eae93a37b", list(ore_item)))
				return ITEM_INTERACT_BLOCKING

			if(prob(80 * skill_modifier)) //start at 80, go down to 40 at legendary skill
				user.balloon_alert(user, LANG("obj.a6d3522268b77b91", list(ore_item)))
				user.mind?.adjust_experience(/datum/skill/primitive, 2)
				continue

			var/spawn_seed = pick(subtypesof(/obj/item/seeds) - seeds_blacklist)
			new spawn_seed(get_turf(src))
			user.mind?.adjust_experience(/datum/skill/primitive, 2)
			user.balloon_alert(user, LANG("obj.c977610f76f3e8b4", list(ore_item)))

	return ..()
