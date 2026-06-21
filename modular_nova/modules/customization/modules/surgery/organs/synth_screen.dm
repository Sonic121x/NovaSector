/obj/item/organ/synth_screen
	name = "合成人屏幕"
	desc = "那肯定只是一堆LED灯，而不是一个复古投影屏，对吧？对吧...？"
	icon_state = "tonguerobot"

	mutantpart_key = FEATURE_SYNTH_SCREEN

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_SYNTH_SCREEN

	bodypart_overlay = /datum/bodypart_overlay/mutant/synth_screen
	use_mob_sprite_as_obj_sprite = TRUE

/datum/bodypart_overlay/mutant/synth_screen
	feature_key = FEATURE_SYNTH_SCREEN
	layers = EXTERNAL_FRONT_UNDER_CLOTHES
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/synth_screen/override_color(rgb_value)
	return draw_color

/datum/bodypart_overlay/mutant/synth_screen/get_global_feature_list()
	return SSaccessories.sprite_accessories[FEATURE_SYNTH_SCREEN]
