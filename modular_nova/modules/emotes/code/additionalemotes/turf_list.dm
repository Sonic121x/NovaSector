#define EXTRA_ABOVE_MOB_LAYER (ABOVE_MOB_LAYER + 0.01)

/obj/structure/mark_turf
	name = "地面"
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
			name = "手工编织的网"
			desc = "这是一张粘稠的网。"
			icon_state = pick("stickyweb1", "stickyweb2")
			playsound(get_turf(src), 'modular_nova/master_files/sound/effects/weave.ogg', 25, TRUE)

		if("vines")
			name = "蔓生的藤蔓"
			desc = "这是一团纠缠的藤蔓。"
			icon_state = pick("kudzu1", "kudzu1", "kudzu3")
			playsound(get_turf(src), 'sound/mobs/non-humanoids/venus_trap/venus_trap_hurt.ogg', 25, TRUE)


		if("water")
			name = "一滩水"
			desc = "这是一片水渍。"
			icon_state = "water"
			src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "water_top", EXTRA_ABOVE_MOB_LAYER))
			flick_overlay_static(image('modular_nova/modules/liquids/icons/obj/effects/splash.dmi', "splash", EXTRA_ABOVE_MOB_LAYER), 20)
			playsound(get_turf(src), 'modular_nova/master_files/sound/effects/watersplash.ogg', 25, TRUE)

		if("smoke")
			name = "炽热雾气"
			desc = "这是一阵烟雾风暴。"
			icon_state = "smoke"
			src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "smoke_top", EXTRA_ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'sound/effects/wounds/sizzle2.ogg', 25, TRUE)

		if("xenoresin")
			name = "树脂"
			desc = "看起来像是某种粘稠的树脂。"
			icon_state = "xenoresin"
			playsound(get_turf(src), 'sound/effects/splat.ogg', 25, TRUE)

		if("holobed")
			name = "实体全息影像"
			desc = "这是一个宠物床的全息影像。"
			icon_state = "holobed"
			playsound(get_turf(src), 'sound/machines/compiler/compiler-stage2.ogg', 25, TRUE)

		if("holoseat")
			name = "实体全息影像"
			desc = "这是一个吧凳的全息影像。"
			icon_state = "holoseat"
			src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects.dmi', "holoseat_top", EXTRA_ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'sound/machines/compiler/compiler-stage2.ogg', 25, TRUE)

		if("slime")
			name = "一滩渗出的粘液"
			desc = "这只是一堆粘液。"
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
					name = "粘液半身像" //rare obj/item/statuebust
					desc = "一座价值连城的粘液半身像，属于应该放在博物馆里的那种。"
					icon_state = "slimeobj4"
					AddElement(/datum/element/art, GREAT_ART)
				else
					return

		if("dust")
			name = "一团灰尘"
			desc = "这是一团闪闪发光的灰尘。"
			icon = 'modular_nova/master_files/icons/effects/turf_effects_64.dmi'
			icon_state = "dust"
			pixel_x = -16
			src.add_overlay(image('modular_nova/master_files/icons/effects/turf_effects_64.dmi', "dust_top", EXTRA_ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'modular_nova/master_files/sound/effects/wing_flap.ogg', 25, TRUE)

		if("borgmat")
			name = "软泡沫垫"
			desc = "这是一张铺开的垫子，不包含无线充电功能。"
			icon = 'modular_nova/master_files/icons/effects/turf_effects_64.dmi'
			icon_state = "borgmat"
			pixel_x = -16
			pixel_y = -4
			playsound(get_turf(src), 'sound/items/handling/taperecorder_pickup.ogg', 25, TRUE)

		//bodyparts
		if("tails")
			name = "尾巴"
			desc = "这是一条毛茸茸的尾巴。"
			icon = 'modular_nova/master_files/icons/effects/turf_effects_64.dmi'
			icon_state = "tails"
			pixel_x = -16 //correcting the offset for 64
			var/mutable_appearance/overlay = mutable_appearance('modular_nova/master_files/icons/effects/turf_effects_64.dmi', "tails_top", EXTRA_ABOVE_MOB_LAYER, src)
			overlay.appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER
			src.add_overlay(overlay)
			playsound(get_turf(src), 'sound/items/weapons/thudswoosh.ogg', 25, TRUE)

		if("coil")
			name = "tail"
			desc = "It's a scaly tail."
			icon = 'modular_nova/master_files/icons/effects/turf_effects_64.dmi'
			icon_state = "naga"
			pixel_x = -16
			var/mutable_appearance/overlay = mutable_appearance('modular_nova/master_files/icons/effects/turf_effects_64.dmi', "naga_top", EXTRA_ABOVE_MOB_LAYER, src)
			overlay.appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER
			src.add_overlay(overlay)
			playsound(get_turf(src), 'modular_nova/modules/emotes/sound/emotes/hiss.ogg', 25, TRUE)

		//prints
		if("pawprint")
			name = "爪印"
			desc = "这是留在地上的一个爪印。"
			icon_state = pick("pawprint", "pawprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/hardbarefoot1.ogg',
			'sound/effects/footstep/hardbarefoot2.ogg',
			'sound/effects/footstep/hardbarefoot3.ogg',
			'sound/effects/footstep/hardbarefoot4.ogg',
			'sound/effects/footstep/hardbarefoot5.ogg'), 50, TRUE)

		if("hoofprint")
			name = "蹄印"
			desc = "这是留在地上的一个蹄印。"
			icon_state = pick("hoofprint", "hoofprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/hardbarefoot1.ogg',
			'sound/effects/footstep/hardbarefoot2.ogg',
			'sound/effects/footstep/hardbarefoot3.ogg',
			'sound/effects/footstep/hardbarefoot4.ogg',
			'sound/effects/footstep/hardbarefoot5.ogg'), 50, TRUE)
		if("footprint")
			name = "脚印"
			desc = "这是留在地上的一个脚印。"
			icon_state = pick("footprint", "footprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/hardbarefoot1.ogg',
			'sound/effects/footstep/hardbarefoot2.ogg',
			'sound/effects/footstep/hardbarefoot3.ogg',
			'sound/effects/footstep/hardbarefoot4.ogg',
			'sound/effects/footstep/hardbarefoot5.ogg'), 50, TRUE)

		if("clawprint")
			name = "爪痕"
			desc = "这是留在地上的一个爪痕。"
			icon_state = pick("clawprint", "clawprint1")
			playsound(get_turf(src), pick('sound/effects/footstep/hardbarefoot1.ogg',
			'sound/effects/footstep/hardbarefoot2.ogg',
			'sound/effects/footstep/hardbarefoot3.ogg',
			'sound/effects/footstep/hardbarefoot4.ogg',
			'sound/effects/footstep/hardbarefoot5.ogg'), 50, TRUE)

		if("shoeprint")
			name = "鞋印"
			desc = "这是留在地面上的一个鞋印。"
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
