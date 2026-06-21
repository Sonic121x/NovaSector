///AI Upgrades
/obj/item/aiupgrade
	name = "AI升级磁盘"
	desc = "你本不该看到这个"
	icon = 'icons/obj/devices/floppy_disks.dmi'
	icon_state = "datadisk3"
	///The upgrade that will be applied to the AI when installed
	var/datum/ai_module/to_gift = /datum/ai_module

/obj/item/aiupgrade/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!isAI(target))
		return ..()
	var/mob/living/silicon/ai/AI = target
	var/datum/action/innate/ai/action = locate(to_gift.power_type) in AI.actions
	var/datum/ai_module/gifted_ability = new to_gift
	if(!to_gift.upgrade)
		if(!action)
			var/ability = to_gift.power_type
			var/datum/action/gifted_action = new ability
			gifted_action.Grant(AI)
		else if(gifted_ability.one_purchase)
			to_chat(user, "[AI] already has \a [src] installed!")
			return
		else
			action.uses += initial(action.uses)
			action.desc = "[initial(action.desc)] 它还有 [action.uses] 次使用use\s 剩余。"
			action.build_all_button_icons()
	else
		if(!action)
			gifted_ability.upgrade(AI)
			if(gifted_ability.unlock_text)
				to_chat(AI, gifted_ability.unlock_text)
			if(gifted_ability.unlock_sound)
				AI.playsound_local(AI, gifted_ability.unlock_sound, 50, 0)
		update_static_data(AI)
	to_chat(user, span_notice("你安装了[src]，升级了[AI]。"))
	to_chat(AI, span_userdanger("[user] 已用 [src] 对你进行了升级！"))
	user.log_message("has upgraded [key_name(AI)] with a [src].", LOG_GAME)
	qdel(src)
	return TRUE


//Malf Picker
/obj/item/malf_upgrade
	name = "战斗软件升级"
	desc = "一种高度非法且极其危险的人工智能单元升级，赋予它们多种能力以及入侵APC的权限。<br>此升级不会覆盖任何现行法律，必须直接应用于激活的AI核心。"
	icon = 'icons/obj/devices/floppy_disks.dmi'
	icon_state = "datadisk3"

/obj/item/malf_upgrade/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)

/obj/item/malf_upgrade/pre_attack(atom/A, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!isAI(A))
		return ..()
	var/mob/living/silicon/ai/AI = A
	if(AI.malf_picker)
		AI.malf_picker.processing_time += 50
		to_chat(AI, span_userdanger("[user] 试图用你已经拥有的战斗软件升级你。你获得了50点可用于购买故障模块的点数。"))
	else
		to_chat(AI, span_userdanger("[user] 已用战斗软件升级了你！"))
		to_chat(AI, span_userdanger("你当前的定律和目标保持不变。")) //this unlocks malf powers, but does not give the license to plasma flood
		AI.add_malf_picker()
		AI.hack_software = TRUE
		log_silicon("[key_name(user)] has upgraded [key_name(AI)] with a [src].")
		message_admins("[ADMIN_LOOKUPFLW(user)] has upgraded [ADMIN_LOOKUPFLW(AI)] with a [src].")
	to_chat(user, span_notice("你安装了 [src]，升级了 [AI]。"))
	qdel(src)
	return TRUE


//Lipreading
/obj/item/aiupgrade/surveillance_upgrade
	name = "监视软件升级"
	desc = "An illegal software package that will allow an artificial intelligence to 'hear' from its cameras via lip reading and hidden microphones."
	to_gift = /datum/ai_module/malf/upgrade/eavesdrop

/obj/item/aiupgrade/surveillance_upgrade/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)


/obj/item/aiupgrade/power_transfer
	name = "电力传输升级"
	desc = "一个合法的升级，允许人工智能从远处直接为 APC 供电"
	to_gift = /datum/ai_module/power_apc
