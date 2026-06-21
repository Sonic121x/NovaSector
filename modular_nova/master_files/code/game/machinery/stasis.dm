/obj/machinery/stasis
	name = "生命体停滞装置MK-II"
	/// The radio channel used to send messages. May be overridden by away missions
	var/announcement_channel = RADIO_CHANNEL_MEDICAL

/obj/machinery/stasis/Initialize(mapload)
	. = ..()
	if (!mapload)
		return
	var/obj/item/circuitboard/machine/stasis/board = circuit
	if (board)
		var/area/my_area = get_area(src)
		if(my_area.type in GLOB.the_station_areas)
			board.announce_when_buckled = TRUE

/obj/machinery/stasis/post_buckle_mob(mob/living/buckled_mob)
	. = ..()
	var/obj/item/circuitboard/machine/stasis/board = circuit
	var/patient_status = (buckled_mob.maxHealth - buckled_mob.health) > 10 ? "Injured" : "Healthy"
	patient_status = buckled_mob.stat != CONSCIOUS ? "Critical" : patient_status
	if(board && board.announce_when_buckled)
		aas_config_announce(/datum/aas_config_entry/stasis_announcement, list(
			"PERSON" = buckled_mob.name,
			"AREA" = get_area_name(src),
		), src, list(announcement_channel), patient_status)

/obj/item/circuitboard/machine/stasis
	/// Controls wherever the stasis bed gives an announcement when someone is buckled to it or not.
	var/announce_when_buckled = FALSE

/obj/item/circuitboard/machine/stasis/multitool_act(mob/living/user)
	. = ..()
	announce_when_buckled = !announce_when_buckled
	to_chat(user, span_notice("Medbay announcement set to [announce_when_buckled ? "Enabled" : "Disabled"]."))

/obj/item/circuitboard/machine/stasis/examine(mob/user)
	. = ..()
	. += span_info("患者通知引脚现已[announce_when_buckled ? "enabled" : "disabled"]。你可以使用[EXAMINE_HINT("multitool")]来重新配置它。")

/datum/aas_config_entry/stasis_announcement
	name = "医疗警报：停滞舱通知"
	// Empty line will be dropped, so by default we will not report nurse taking a nap on stasis bed.
	announcement_lines_map = list(
		"Healthy" = "",
		"Injured" = "%PERSON正在%AREA的停滞舱中等待治疗。",
		"Critical" = "危重病人%PERSON已在%AREA的停滞舱中安置！",
	)
	vars_and_tooltips_map = list(
		"PERSON" = "将被替换为其姓名。",
		"AREA" = "替换为其位置。"
	)
