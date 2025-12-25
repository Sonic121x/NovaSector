//合成急救员液压钳
/obj/item/crafting_conversion_kit/paramedic_jaws
	name = "急救员液压钳改装套件"
	desc = "用于将工程师液压钳转化成急救员液压钳的套件"
	icon = 'modular_z121/icons/obj/tools/kitsuitcase.dmi'
	icon_state = "paramedic_jaws"

/datum/crafting_recipe/paramedic_jaws
	name = "急救员液压钳"
	reqs = list(/obj/item/crowbar/power = 1,/obj/item/crafting_conversion_kit/paramedic_jaws = 1,
	)

	result =  /obj/item/crowbar/power/paramedic
	category = CAT_TOOLS

//外观更改
/obj/item/crowbar/power/paramedic/examine(mob/user)
	. = ..()
	. += span_info("[name]貌似可以通过螺丝刀松一些零件让它更好看")

/obj/item/crowbar/power/paramedic/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	var/change_icon = 'icons/obj/tools.dmi'
	if(I.use_tool(src, user, 0, volume=50))
		if(icon == change_icon)
			icon = initial(icon)
		else
			icon = change_icon
	return TRUE
