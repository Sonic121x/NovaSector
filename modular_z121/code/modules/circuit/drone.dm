/mob/living/circuit_drone/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	outfit()

/mob/living/circuit_drone/verb/outfit()
	set name = "无人机外观"
	set category = "Object"
	set src in usr
	var/mob/user_mob = usr

	var/list/outfits = list("无人机")

	//添加所有玩偶到outfits
	outfits.Add(subtypesof(/obj/item/toy/plush))

	//生成列表ui
	var/selected_outfit = tgui_input_list(user_mob, "无人机外观", "选择外观", outfits, 0)
	if(isnull(selected_outfit))
		return

	//找到所选选项对应的索引
	var/index = outfits.Find(selected_outfit)
	update_outfit(outfits[index])

/mob/living/circuit_drone/proc/update_outfit(selected_outfit)
	if(selected_outfit == "无人机")
		src.icon = 'icons/obj/science/circuits.dmi'
		src.icon_state = "setup_medium_med"
		return

	var/obj/item/toy/plush/copies = selected_outfit
	src.icon = copies.icon
	src.icon_state = copies.icon_state
