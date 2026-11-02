// ZH EDIT - I18N: 动作名改为 LANG（见 modular_zh/modules/i18n/readme.md）
/datum/action/item_action/adjust
	name = "Adjust Item"

/datum/action/item_action/adjust/New(Target)
	..()
	var/obj/item/item_target = target
	name = LANG("_root.action_adjust", list(item_target)) // ZH EDIT CHANGE - I18N - 同 toggles.dm：拼出的名字不是目录键 - ORIGINAL: name = "Adjust [item_target.name]"

/datum/action/item_action/adjust/do_effect(trigger_flags)
	if(!isclothing(target))
		CRASH("adjust_visor action attempted to trigger on a non-clothing atom [target] ([target?.type]) owned by [owner] ([owner?.type]!")
	var/obj/item/clothing/as_clothing = target
	as_clothing.adjust_visor(owner)
	return TRUE

/datum/action/item_action/adjust_style
	name = "Adjust Item Style"

/datum/action/item_action/adjust_style/New(Target)
	..()
	var/obj/item/item_target = target
	name = LANG("_root.action_adjust_style", list(item_target)) // ZH EDIT CHANGE - I18N - ORIGINAL: name = "Adjust [item_target.name]'s Style"

/datum/action/item_action/adjust_visor
	name = "Adjust Visor"

/datum/action/item_action/adjust_visor/New(Target)
	..()
	var/obj/item/item_target = target
	name = LANG("_root.action_adjust_visor", list(item_target)) // ZH EDIT CHANGE - I18N - ORIGINAL: name = "Adjust [item_target.name] Visor"
