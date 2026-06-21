/datum/action/item_action/mod/sprite_accessories
	name = "隐藏/显示突变部位"
	desc = "左键：部署/收起部位。右键：部署/收起所有部位。"
	button_icon = 'modular_nova/modules/customization/modules/mob/living/carbon/human/MOD_sprite_accessories/icons/radial.dmi' // What a great var name
	button_icon_state = "open"

/datum/action/item_action/mod/sprite_accessories/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/mod/control/mod = target
	if(trigger_flags & TRIGGER_SECONDARY_ACTION)
		mod.quick_sprite_accessories(usr)
	else
		mod.choose_sprite_accessories(usr)

/obj/item/mod/control/proc/quick_sprite_accessories(mob/living/carbon/human/user)
	playsound(user, 'sound/vehicles/mecha/mechmove03.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
	user.mutant_part_visibility(quick_toggle = TRUE)

/obj/item/mod/control/proc/choose_sprite_accessories(mob/living/carbon/human/user)
	user.mutant_part_visibility(quick_toggle = FALSE)
