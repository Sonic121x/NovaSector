#define MODE_OFF "off"
#define MODE_OFF_FLASH_PROTECTION "flash protection"
#define MODE_ON "on"
#define MODE_FREEZE_ANIMATION "freeze"

/obj/item/clothing/glasses/hud/ar
	name = "\improper AR眼镜"
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "glasses_regular"
	desc = "一种平视显示器，能提供（近乎）实时的重要信息。这些看起来好像不太管用"
	actions_types = list(/datum/action/item_action/toggle_mode)
	glass_colour_type = /datum/client_colour/glass_colour/gray
	/// Defines sound to be played upon mode switching
	var/modeswitch_sound = 'sound/effects/pop.ogg'
	/// Iconstate for when the status is off (TODO:  off_state --> modes_states list for expandability)
	var/off_state = "salesman_fzz"
	/// Sets a list of modes to cycle through
	var/list/modes = list(MODE_OFF, MODE_ON)
	/// The current operating mode
	var/mode
	/// Defines messages that will be shown to the user upon switching modes (e.g. turning it on)
	var/list/modes_msg = list(MODE_ON = "optical matrix enabled", MODE_OFF = "optical matrix disabled")

/// Reuse logic from engine_goggles.dm
/obj/item/clothing/glasses/hud/ar/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, ITEM_SLOT_EYES)

	// Set our initial values
	mode = MODE_ON

/obj/item/clothing/glasses/hud/ar/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/glasses/hud/ar/equipped(mob/living/carbon/human/user, slot)
	if(mode != MODE_OFF || slot != slot_flags)
		return ..()
	// when off: don't apply any huds or traits. but keep the list as-is so that we can still add them later
	var/traits = clothing_traits
	clothing_traits = null
	. = ..()
	clothing_traits = traits

/obj/item/clothing/glasses/hud/ar/proc/toggle_mode(mob/user, voluntary)

	if(!istype(user) || user.incapacitated)
		return

	if(mode == modes[mode])
		return // If there is only really one mode to cycle through, early return

	if(mode == MODE_FREEZE_ANIMATION)
		icon = initial(icon) /// Resets icon to initial value after MODE_FREEZE_ANIMATION, since MODE_FREEZE_ANIMATION replaces it with non-animated version of initial

	mode = get_next_mode(mode)

	switch(mode)
		if(MODE_ON)
			balloon_alert(user, modes_msg[mode])
			reset_vars() // Resets all the vars to their initial values (THIS PRESUMES THE DEFAULT STATE IS ON)
			add_hud(user)
		if(MODE_FREEZE_ANIMATION)
			balloon_alert(user, modes_msg[mode])
			freeze_animation()
		if(MODE_OFF)
			if(MODE_OFF_FLASH_PROTECTION in modes)
				flash_protect = FLASH_PROTECTION_FLASH
				balloon_alert(user, modes_msg[MODE_OFF_FLASH_PROTECTION])
			else
				balloon_alert(user, modes_msg[mode])
			icon_state = off_state
			disable_vars(user)
			remove_hud(user)

	playsound(src, modeswitch_sound, 50, TRUE) // play sound set in vars!
	update_sight(user)
	update_item_action_buttons()
	update_appearance()

/obj/item/clothing/glasses/hud/ar/proc/get_next_mode(current_mode)
	switch(current_mode)
		if(MODE_ON)
			if(MODE_FREEZE_ANIMATION in modes) // AR projectors go from on to freeze animation mode
				return MODE_FREEZE_ANIMATION
			else
				return MODE_OFF
		if(MODE_OFF)
			return MODE_ON
		if(MODE_FREEZE_ANIMATION)
			return MODE_OFF

/obj/item/clothing/glasses/hud/ar/proc/add_hud(mob/user)
	var/mob/living/carbon/human/human = user
	if(!ishuman(user) || human.glasses != src) // Make sure they're a human wearing the glasses first
		return
	for(var/trait in clothing_traits)
		if(trait == TRAIT_NEARSIGHTED_CORRECTED) // this isn't a HUD!
			continue
		ADD_CLOTHING_TRAIT(human, trait)

/obj/item/clothing/glasses/hud/ar/proc/remove_hud(mob/user)
	var/mob/living/carbon/human/human = user
	if(!ishuman(user) || human.glasses != src) // Make sure they're a human wearing the glasses first
		return
	for(var/trait in clothing_traits)
		if(trait == TRAIT_NEARSIGHTED_CORRECTED) // this isn't a HUD!
			continue
		REMOVE_CLOTHING_TRAIT(human, trait)

/obj/item/clothing/glasses/hud/ar/proc/reset_vars()
	worn_icon = initial(worn_icon)
	icon_state = initial(post_init_icon_state) || initial(icon_state)
	flash_protect = initial(flash_protect)
	tint = initial(tint)
	color_cutoffs = initial(color_cutoffs)
	vision_flags = initial(vision_flags)

/obj/item/clothing/glasses/hud/ar/proc/disable_vars(mob/user)
	vision_flags = 0 /// Sets vision_flags to 0 to disable meson view mainly
	color_cutoffs = null // Resets lighting_alpha to user's default one

/// Create new icon and worn_icon, with only the first frame of every state and setting that as icon.
/// this practically freezes the animation :)
/obj/item/clothing/glasses/hud/ar/proc/freeze_animation()
	var/icon/frozen_icon = new(icon, frame = 1)
	icon = frozen_icon
	var/icon/frozen_worn_icon = new(worn_icon, frame = 1)
	worn_icon = frozen_worn_icon

// Blah blah, fix vision and update icons
/obj/item/clothing/glasses/hud/ar/proc/update_sight(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		if(human.glasses == src)
			human.update_sight()

/obj/item/clothing/glasses/hud/ar/attack_self(mob/user)
	toggle_mode(user, TRUE)

/obj/item/clothing/glasses/hud/ar/aviator
	name = "飞行员墨镜"
	desc = "一副带有电致变色深色镜片的设计师太阳镜！"
	worn_icon = 'modular_nova/modules/modular_items/icons/modular_glasses_mob.dmi'
	icon_state = "aviator"
	off_state = "aviator_off"
	icon = 'modular_nova/modules/modular_items/icons/modular_glasses.dmi'
	flash_protect = FLASH_PROTECTION_FLASH
	modes = list(MODE_OFF, MODE_ON)
	tint = 0

/obj/item/clothing/glasses/fake_sunglasses/aviator
	name = "飞行员墨镜"
	desc = "一副设计师太阳镜。看起来似乎无法阻挡闪光。"
	worn_icon = 'modular_nova/modules/modular_items/icons/modular_glasses_mob.dmi'
	icon_state = "aviator"
	icon = 'modular_nova/modules/modular_items/icons/modular_glasses.dmi'

// Security Aviators
/obj/item/clothing/glasses/hud/ar/aviator/security
	name = "安保HUD飞行员墨镜"
	desc = "一种平视显示器，可扫描视野内的人形生物，并提供其身份状态和安保记录的准确数据。此HUD已安装在一副带有可切换电致变色调光功能的太阳镜内。"
	icon_state = "aviator_sec"
	off_state = "aviator_sec_flash"
	flash_protect = FLASH_PROTECTION_NONE
	clothing_traits = list(TRAIT_SECURITY_HUD)
	glass_colour_type = /datum/client_colour/glass_colour/red
	modes = list(MODE_OFF_FLASH_PROTECTION, MODE_ON)
	modes_msg = list(MODE_OFF_FLASH_PROTECTION = "flash protection mode", MODE_ON = "optical matrix enabled")

// Medical Aviators
/obj/item/clothing/glasses/hud/ar/aviator/health
	name = "医疗HUD飞行员墨镜"
	desc = "一种平视显示器，可扫描视野内的人形生物并提供其健康状况的准确数据。该HUD已安装在一副太阳镜内。"
	icon_state = "aviator_med"
	flash_protect = FLASH_PROTECTION_NONE
	clothing_traits = list(TRAIT_MEDICAL_HUD)
	glass_colour_type = /datum/client_colour/glass_colour/lightblue

// (Normal) meson scanner Aviators
/obj/item/clothing/glasses/hud/ar/aviator/meson
	name = "介子HUD飞行员墨镜"
	desc = "一种供工程和采矿人员使用的平视显示器，用于无视光照条件透过墙壁观察基本结构和地形布局。该HUD已安装在一副太阳镜内。"
	icon_state = "aviator_meson"
	flash_protect = FLASH_PROTECTION_NONE
	clothing_traits = list(TRAIT_MADNESS_IMMUNE)
	vision_flags = SEE_TURFS
	color_cutoffs = list(5, 15, 5)
	glass_colour_type = /datum/client_colour/glass_colour/lightgreen

// diagnostic Aviators
/obj/item/clothing/glasses/hud/ar/aviator/diagnostic
	name = "诊断HUD飞行员墨镜"
	desc = "一种能够分析机器人和外骨骼完整性与状态的平视显示器。该HUD已安装在一副太阳镜内。"
	icon_state = "aviator_diagnostic"
	flash_protect = FLASH_PROTECTION_NONE
	clothing_traits = list(TRAIT_DIAGNOSTIC_HUD)
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

// Science Aviators
/obj/item/clothing/glasses/hud/ar/aviator/science
	name = "科研飞行员墨镜"
	desc = "一副俗气的紫色飞行员太阳镜，佩戴者只需一瞥即可识别各种化合物。"
	icon_state = "aviator_sci"
	flash_protect = FLASH_PROTECTION_NONE
	glass_colour_type = /datum/client_colour/glass_colour/purple
	resistance_flags = ACID_PROOF
	armor_type = /datum/armor/aviator_science
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)

/datum/armor/aviator_science
	fire = 80
	acid = 100

/obj/item/clothing/glasses/hud/ar/aviator/security/prescription
	name = "处方安保HUD飞行员墨镜"
	desc = "一种平视显示器，可扫描视野内的人形生物并提供其ID状态和安保记录的准确数据。该HUD已安装在一副带有可切换电致变色调光功能的太阳镜内。配有帮助矫正视力的镜片。"
	clothing_traits = list(TRAIT_SECURITY_HUD, TRAIT_NEARSIGHTED_CORRECTED)

/obj/item/clothing/glasses/hud/ar/aviator/health/prescription
	name = "处方医疗HUD飞行员墨镜"
	desc = "一种平视显示器，可扫描视野内的人形生物并提供其健康状况的准确数据。该HUD已安装在一副配有帮助矫正视力镜片的太阳镜内。"
	clothing_traits = list(TRAIT_MEDICAL_HUD, TRAIT_NEARSIGHTED_CORRECTED)

/obj/item/clothing/glasses/hud/ar/aviator/meson/prescription
	name = "处方介子HUD飞行员墨镜"
	desc = "一种供工程和采矿人员使用的平视显示器，用于无视光照条件透过墙壁观察基本结构和地形布局。该HUD已安装在一副配有帮助矫正视力镜片的太阳镜内。"
	clothing_traits = list(TRAIT_MADNESS_IMMUNE, TRAIT_NEARSIGHTED_CORRECTED)

/obj/item/clothing/glasses/hud/ar/aviator/diagnostic/prescription
	name = "处方诊断HUD飞行员墨镜"
	desc = "一种能够分析机器人和外骨骼完整性与状态的平视显示器。该HUD已安装在一副配有帮助矫正视力镜片的太阳镜内。"
	clothing_traits = list(TRAIT_DIAGNOSTIC_HUD, TRAIT_NEARSIGHTED_CORRECTED)

/obj/item/clothing/glasses/hud/ar/aviator/science/prescription
	name = "处方科研飞行员墨镜"
	desc = "一副俗气的紫色飞行员太阳镜，佩戴者只需一瞥即可识别各种化合物，并配有帮助矫正视力的镜片。"
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER, TRAIT_NEARSIGHTED_CORRECTED)

// Retinal projector

/obj/item/clothing/glasses/hud/ar/projector
	name = "视网膜投影仪"
	desc = "一副配备扫描镜头和视网膜投影仪的头戴式耳机。它不提供任何眼部保护，但比护目镜更不显眼。"
	icon_state = "projector"
	worn_icon = 'modular_nova/modules/modular_items/icons/modular_glasses_mob.dmi'
	icon = 'modular_nova/modules/modular_items/icons/modular_glasses.dmi'
	flags_cover = null /// It doesn't actually cover up any parts
	off_state = "projector-off"
	modes = list(MODE_OFF, MODE_ON, MODE_FREEZE_ANIMATION)
	modes_msg = list(MODE_ON = "projector enabled", MODE_FREEZE_ANIMATION = "continuous beam mode", MODE_OFF = "projector disabled" )

/obj/item/clothing/glasses/hud/ar/projector/meson
	name = "视网膜投影器介子扫描HUD"
	icon_state = "projector_meson"
	vision_flags = SEE_TURFS
	color_cutoffs = list(10, 30, 10)

/obj/item/clothing/glasses/hud/ar/projector/health
	name = "视网膜投影器生命体征HUD"
	icon_state = "projector_med"
	clothing_traits = list(TRAIT_MEDICAL_HUD)

/obj/item/clothing/glasses/hud/ar/projector/security
	name = "视网膜投影器安保HUD"
	icon_state = "projector_sec"
	clothing_traits = list(TRAIT_SECURITY_HUD)

/obj/item/clothing/glasses/hud/ar/projector/diagnostic
	name = "视网膜投影器诊断HUD"
	icon_state = "projector_diagnostic"
	clothing_traits = list(TRAIT_DIAGNOSTIC_HUD)

/obj/item/clothing/glasses/hud/ar/projector/science
	name = "科研视网膜投影器"
	icon_state = "projector_sci"
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)

#undef MODE_OFF
#undef MODE_OFF_FLASH_PROTECTION
#undef MODE_ON
#undef MODE_FREEZE_ANIMATION
