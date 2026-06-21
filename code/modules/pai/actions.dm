/datum/action/innate/pai
	name = "pAI运行"
	button_icon = 'icons/mob/actions/actions_silicon.dmi'
	var/mob/living/silicon/pai/pai_owner

/datum/action/innate/pai/Trigger(mob/clicker, trigger_flags)
	if(!ispAI(owner))
		return FALSE
	pai_owner = owner
	return ..()

/datum/action/innate/pai/software
	name = "软件界面"
	button_icon_state = "pai"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"

/datum/action/innate/pai/software/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	pai_owner.ui_act()

/datum/action/innate/pai/shell
	name = "切换全息形态"
	button_icon_state = "pai_holoform"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"

/datum/action/innate/pai/shell/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	if(pai_owner.holoform)
		pai_owner.fold_in(0)
	else
		pai_owner.fold_out()

/datum/action/innate/pai/chassis
	name = "全息底盘外观合成"
	button_icon_state = "pai_chassis"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"

/datum/action/innate/pai/chassis/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	pai_owner.choose_chassis()

/datum/action/innate/pai/rest
	name = "休息"
	button_icon_state = "pai_rest"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"

/datum/action/innate/pai/rest/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	pai_owner.toggle_resting()

/datum/action/innate/pai/light
	name = "切换集成灯带"
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "emp"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"

/datum/action/innate/pai/light/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	pai_owner.toggle_integrated_light()

/datum/action/innate/pai/messenger
	name = "与PDA交互"
	button_icon_state = "pda"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"

/datum/action/innate/pai/messenger/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/pai_card/pai_holder = owner.loc
	if(!istype(pai_holder.loc, /obj/item/modular_computer))
		owner.balloon_alert(owner, "不在PDA中！")
		return
	var/obj/item/modular_computer/computer_host = pai_holder.loc
	computer_host.interact(owner)
