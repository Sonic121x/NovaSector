// NOVA MODULE IC-SPAWNING https://github.com/Skyrat-SS13/Skyrat-tg/pull/104

/mob/dead/observer/CtrlClickOn(mob/user)
	quickicspawn(user)

/mob/dead/observer/proc/quickicspawn(mob/user)
	if(isobserver(user) && check_rights(R_SPAWN))
		var/list/outfits = list()
		outfits["Bluespace Tech"] = /datum/outfit/debug/bst
		outfits["Bluespace Tech (MODsuit)"] = /datum/outfit/admin/bst
		outfits["Show All"] = "Show All"

		var/dresscode
		var/teleport_option = tgui_alert(usr, "你希望以何种方式生成？", "IC快速生成", list("Bluespace", "Pod", "Cancel"))
		if (teleport_option == "Cancel")
			return
		var/character_option = tgui_alert(usr, "选择哪个角色？", "IC快速生成", list("Selected Character", "Randomly Created", "Cancel"))
		if (character_option == "Cancel")
			return
		var/initial_outfits = tgui_alert(usr, "选择服装", "快速着装", list("Bluespace Tech", "Show All", "Cancel"))
		if (initial_outfits == "Cancel")
			return

		switch(initial_outfits)
			if("Bluespace Tech")
				dresscode = /datum/outfit/admin/bst
			if("Show All")
				dresscode = client.robust_dress_shop_skyrat()
				if (!dresscode)
					return

		// We're spawning someone else
		var/give_return
		if (user != usr)
			give_return = tgui_alert(usr, "你希望赋予他们返回的能力吗？不建议非管理员使用。", "赋予能力？", list("Yes", "No"))
			if(!give_return)
				return

		var/addquirks
		if(character_option == "Selected Character")
			addquirks = tgui_input_list(src, "包含特质？", "特性", list("Quirks & Loadout", "Quirks Only", "Loadout Only", "Neither"))
			if(!addquirks)
				return


		var/turf/current_turf = get_turf(user)
		var/mob/living/carbon/human/spawned_player = new(user)

		if (character_option == "Selected Character")
			spawned_player.name = user.name
			spawned_player.real_name = user.real_name

			var/mob/living/carbon/human/player_as_human = spawned_player
			user.client?.prefs.safe_transfer_prefs_to(player_as_human)
			if(addquirks == "Quirks & Loadout" || addquirks == "Loadout Only")
				if(dresscode == "Naked")
					player_as_human.equip_outfit_and_loadout(new /datum/outfit(), user.client?.prefs)
				else
					player_as_human.equip_outfit_and_loadout(dresscode, user.client?.prefs)
			else if(dresscode != "Naked")
				spawned_player.equipOutfit(dresscode)
			if(addquirks == "Quirks & Loadout" || addquirks == "Quirks Only")
				SSquirks.AssignQuirks(player_as_human, user.client)
			player_as_human.dna.update_dna_identity()
		else if(dresscode != "Naked")
			spawned_player.equipOutfit(dresscode)
		QDEL_IN(user, 1)

		if (teleport_option == "Bluespace")
			playsound(spawned_player, 'sound/effects/magic/Disable_Tech.ogg', 100, 1)

		if(user.mind && isliving(spawned_player))
			user.mind.transfer_to(spawned_player, 1) // second argument to force key move to new mob
		else
			spawned_player.ckey = user.key

		if(give_return != "No")
			var/datum/action/cooldown/spell/return_back/return_spell = new(spawned_player)
			return_spell.Grant(spawned_player)

		switch(teleport_option)
			if("Bluespace")
				spawned_player.forceMove(current_turf)
				do_sparks(10, TRUE, spawned_player, spark_type = /datum/effect_system/basic/spark_spread/quantum)

			if("Pod")
				var/obj/structure/closet/supplypod/empty_pod = new()

				empty_pod.style = /datum/pod_style/advanced
				empty_pod.bluespace = TRUE
				empty_pod.explosionSize = list(0,0,0,0)
				empty_pod.desc = "一个流线型、略显磨损的蓝空舱——它可能已经运送过许多货物了……"

				spawned_player.forceMove(empty_pod)

				new /obj/effect/pod_landingzone(current_turf, empty_pod)

/client/proc/robust_dress_shop_skyrat()
	var/list/baseoutfits = list("Naked","Custom","As Job...", "As Plasmaman...")
	var/list/outfits = list()
	var/list/paths = subtypesof(/datum/outfit) - typesof(/datum/outfit/job) - typesof(/datum/outfit/plasmaman)

	for(var/path in paths)
		// Get the datum from the path so we can grab its name.
		var/datum/outfit/path_as_outfit = path
		outfits[initial(path_as_outfit.name)] = path

	var/dresscode = tgui_input_list(src, "选择服装", "强力快速换装商店", baseoutfits + sort_list(outfits))

	if (isnull(dresscode))
		return

	if (outfits[dresscode])
		dresscode = outfits[dresscode]

	if (dresscode == "As Job...")
		var/list/job_paths = subtypesof(/datum/outfit/job)
		var/list/job_outfits = list()
		for(var/path in job_paths)
			var/datum/outfit/O = path
			job_outfits[initial(O.name)] = path

		dresscode = input("选择职业装备", "强力快速换装商店") as null|anything in sort_list(job_outfits)
		dresscode = job_outfits[dresscode]
		if(isnull(dresscode))
			return

	if (dresscode == "As Plasmaman...")
		var/list/plasmaman_paths = typesof(/datum/outfit/plasmaman)
		var/list/plasmaman_outfits = list()
		for(var/path in plasmaman_paths)
			var/datum/outfit/O = path
			plasmaman_outfits[initial(O.name)] = path

		dresscode = input("选择等离子人装备", "强力快速换装商店") as null|anything in sort_list(plasmaman_outfits)
		dresscode = plasmaman_outfits[dresscode]
		if(isnull(dresscode))
			return

	if (dresscode == "Custom")
		var/list/custom_names = list()
		for(var/datum/outfit/req_outfit in GLOB.custom_outfits)
			custom_names[req_outfit.name] = req_outfit
		var/selected_name = input("选择服装", "强力快速换装商店") as null|anything in sort_list(custom_names)
		dresscode = custom_names[selected_name]
		if(isnull(dresscode))
			return

	return dresscode
