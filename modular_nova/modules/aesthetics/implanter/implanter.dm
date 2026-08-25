/obj/item/implanter
	icon = 'modular_nova/modules/aesthetics/implanter/icons/implanter.dmi'

/obj/item/implantpad
	icon = 'modular_nova/modules/aesthetics/implanter/icons/implanter.dmi'

/obj/item/implantcase
	icon = 'modular_nova/modules/aesthetics/implanter/icons/implanter.dmi'

//Code to make the breathing tube aug_overlay toggleable
/obj/item/organ/cyberimp/mouth/breathing_tube/examine()
	. = ..()
	. += span_info(LANG("obj.fc9a3c4c1f6f1714", list(aug_overlay ? "physicially visible" : "practically invisible", EXAMINE_HINT("screwdriver"))))

/obj/item/organ/cyberimp/mouth/breathing_tube/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(isnull(aug_overlay))
		name = "breathing tube implant"
		aug_overlay = "breathing_tube"
		if(isnull(bodypart_aug)) //Need to ensure there's one of these on the Integrated one, which starts null
			bodypart_aug = new(src)
	else
		name = "integrated breathing tube implant"
		aug_overlay = null
		QDEL_NULL(bodypart_aug)
	tool.play_tool_sound(src)
	balloon_alert(user, LANG("obj.19b46eaf092a711c", null))

//And a preset for the loadout
/obj/item/organ/cyberimp/mouth/breathing_tube/hidden
	name = "integrated breathing tube implant"
	aug_overlay = null
