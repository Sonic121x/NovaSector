#define EXTRA_ABOVE_MOB_LAYER (ABOVE_MOB_LAYER + 0.01)

/obj/structure/mark_turf
	name = "turf"
	icon = 'modular_nova/master_files/icons/effects/turf_effects.dmi'
	desc = "It's turf." //Debug stuff, won't be seen
	layer = ABOVE_OBJ_LAYER
	anchored = TRUE
	density = FALSE
	max_integrity = 15
	/// Things that leave a longer lasting mark
	var/static/list/long_trail = list(
		"pawprint"  = TRUE,
		"hoofprint" = TRUE,
		"clawprint" = TRUE,
		"footprint" = TRUE,
		"shoeprint" = TRUE
	)

/obj/structure/mark_turf/Initialize(mapload, current_turf)
	. = ..()

	switch(current_turf)
		if("web")
			name = "hand-sewn web"
			desc = LANG("obj.7688d08714210ae1", null)
			icon_state = pick("stickyweb1", "stickyweb2")
			playsound(get_turf(src), 'modular_nova/master_files/sound/effects/weave.ogg', 25, TRUE)

		if("vines")
			name = "sprouted vines"
			desc = LANG("obj.2e82a2e2f66f9c04", null)
			icon_state = pick("kudzu1", "kudzu1", "kudzu3")
			playsound(get_turf(src), 'sound/mobs/non-humanoids/venus_trap/venus_trap_hurt.ogg', 25, TRUE)


		if("water")
			name = "puddle of water"
			desc = LANG("obj.5e50d898a56c6cb0", null)
			icon_state = "water"
			src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "water_top", EXTRA_ABOVE_MOB_LAYER))
			flick_overlay_static(image('modular_nova/modules/liquids/icons/obj/effects/splash.dmi', "splash", EXTRA_ABOVE_MOB_LAYER), 20)
			playsound(get_turf(src), 'modular_nova/master_files/sound/effects/watersplash.ogg', 25, TRUE)

		if("smoke")
			name = "blazing mist"
			desc = LANG("obj.42699d87f0aa6eb5", null)
			icon_state = "smoke"
			src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "smoke_top", EXTRA_ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'sound/effects/wounds/sizzle2.ogg', 25, TRUE)

		if("xenoresin")
			name = "resin"
			desc = LANG("obj.3fbfd8624f446d2a", null)
			icon_state = "xenoresin"
			playsound(get_turf(src), 'sound/effects/splat.ogg', 25, TRUE)

		if("holobed")
			name = "physical hologram"
			desc = LANG("obj.65614e0138b902c1", null)
			icon_state = "holobed"
			playsound(get_turf(src), 'sound/machines/compiler/compiler-stage2.ogg', 25, TRUE)

		if("holoseat")
			name = "physical hologram"
			desc = LANG("obj.20caa074fab0e390", null)
			icon_state = "holoseat"
			src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "holoseat_top", EXTRA_ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'sound/machines/compiler/compiler-stage2.ogg', 25, TRUE)

		if("slime")
			name = "pile of oozing slime"
			desc = LANG("obj.c3a5da534a9bd43e", null)
			alpha = 155
			playsound(get_turf(src), 'sound/misc/soggy.ogg', 25, TRUE)
			switch(rand(1,1000))
				if(-INFINITY to 400)
					icon_state = "slimeobj1"
					src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "slimeobj1_top", EXTRA_ABOVE_MOB_LAYER))
				if(400 to 800)
					icon_state = "slimeobj2"
					src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "slimeobj2_top", EXTRA_ABOVE_MOB_LAYER))
				if(800 to 980)
					icon_state = "slimeobj3"
					src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "slimeobj3_top", EXTRA_ABOVE_MOB_LAYER))
				if(980 to INFINITY)
					name = "slime bust" //rare obj/item/statuebust
					desc = LANG("obj.1306027bd7311ea7", null)
					icon_state = "slimeobj4"
					AddElement(/datum/element/art, GREAT_ART)
				else
					return

		if("dust")
			name = "cloud of dust"
			desc = LANG("obj.e29893be0a0b172e", null)
			icon = 'modular_nova/master_files/icons/effects/turf_effects_64.dmi'
			icon_state = "dust"
			pixel_x = -16
			src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects_64.dmi', "dust_top", EXTRA_ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'modular_nova/master_files/sound/effects/wing_flap.ogg', 25, TRUE)

		if("borgmat")
			name = "soft-foam mat"
			desc = LANG("obj.832fa1b3d1c36027", null)
			icon = 'modular_nova/master_files/icons/effects/turf_effects_64.dmi'
			icon_state = "borgmat"
			pixel_x = -16
			pixel_y = -4
			playsound(get_turf(src), 'sound/items/handling/taperecorder_pickup.ogg', 25, TRUE)

		//bodyparts
		if("tails")
			name = "tail"
			desc = LANG("obj.ab68f89ef77b9e8c", null)
			icon = 'modular_nova/master_files/icons/effects/turf_effects_64.dmi'
			icon_state = "tails"
			pixel_x = -16 //correcting the offset for 64
			var/mutable_appearance/overlay = mutable_appearance('modular_nova/master_files/icons/effects/turf_effects_64.dmi', "tails_top", EXTRA_ABOVE_MOB_LAYER, src)
			overlay.appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER
			src.add_overlay(overlay)
			playsound(get_turf(src), 'sound/items/weapons/thudswoosh.ogg', 25, TRUE)

		if("coil")
			name = "tail"
			desc = LANG("obj.cac00c8e6ba12034", null)
			icon = 'modular_nova/master_files/icons/effects/turf_effects_64.dmi'
			icon_state = "naga"
			pixel_x = -16
			var/mutable_appearance/overlay = mutable_appearance('modular_nova/master_files/icons/effects/turf_effects_64.dmi', "naga_top", EXTRA_ABOVE_MOB_LAYER, src)
			overlay.appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER
			src.add_overlay(overlay)
			playsound(get_turf(src), 'modular_nova/modules/emotes/sound/emotes/hiss.ogg', 25, TRUE)

		//prints
		if("pawprint")
			name = "pawprint"
			desc = LANG("obj.45a44e67fb99a366", null)
			icon_state = pick("pawprint", "pawprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/hardbarefoot1.ogg',
			'sound/effects/footstep/hardbarefoot2.ogg',
			'sound/effects/footstep/hardbarefoot3.ogg',
			'sound/effects/footstep/hardbarefoot4.ogg',
			'sound/effects/footstep/hardbarefoot5.ogg'), 50, TRUE)

		if("hoofprint")
			name = "hoofprint"
			desc = LANG("obj.b2e98ad8a61b8b0e", null)
			icon_state = pick("hoofprint", "hoofprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/hardbarefoot1.ogg',
			'sound/effects/footstep/hardbarefoot2.ogg',
			'sound/effects/footstep/hardbarefoot3.ogg',
			'sound/effects/footstep/hardbarefoot4.ogg',
			'sound/effects/footstep/hardbarefoot5.ogg'), 50, TRUE)
		if("footprint")
			name = "footprint"
			desc = LANG("obj.4a148252bca278bd", null)
			icon_state = pick("footprint", "footprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/hardbarefoot1.ogg',
			'sound/effects/footstep/hardbarefoot2.ogg',
			'sound/effects/footstep/hardbarefoot3.ogg',
			'sound/effects/footstep/hardbarefoot4.ogg',
			'sound/effects/footstep/hardbarefoot5.ogg'), 50, TRUE)

		if("clawprint")
			name = "clawprint"
			desc = LANG("obj.80e43d9e8e2c5b98", null)
			icon_state = pick("clawprint", "clawprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/hardbarefoot1.ogg',
			'sound/effects/footstep/hardbarefoot2.ogg',
			'sound/effects/footstep/hardbarefoot3.ogg',
			'sound/effects/footstep/hardbarefoot4.ogg',
			'sound/effects/footstep/hardbarefoot5.ogg'), 50, TRUE)

		if("shoeprint")
			name = "shoeprint"
			desc = LANG("obj.2b7d208e8f0369bd", null)
			icon_state = pick("shoeprint", "shoeprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/floor1.ogg',
			'sound/effects/footstep/floor2.ogg',
			'sound/effects/footstep/floor3.ogg',
			'sound/effects/footstep/floor4.ogg',
			'sound/effects/footstep/floor5.ogg'), 50, TRUE)

		else
			return

/obj/structure/mark_turf/proc/turf_check(mob/living/user) //This gets called when a player leaves their turf
	var/owner_turf_name = user.owned_turf.name
	if(owner_turf_name == "tail") // no trail
		QDEL_NULL(src)
	if(owner_turf_name in long_trail)
		QDEL_IN(src, 150 SECONDS)
		user.owned_turf = null
	else
		QDEL_IN(src, 15 SECONDS)
		user.owned_turf = null

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		human_user.update_body_parts()

#undef EXTRA_ABOVE_MOB_LAYER
