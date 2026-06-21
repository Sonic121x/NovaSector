/obj/item/banner
	name = "旗帜"
	desc = "一面印有纳米传讯公司标志的旗帜。"
	icon = 'icons/obj/banner.dmi'
	icon_state = "banner"
	inhand_icon_state = "banner"
	force = 8
	attack_verb_continuous = list("forcefully inspires", "violently encourages", "relentlessly galvanizes")
	attack_verb_simple = list("forcefully inspire", "violently encourage", "relentlessly galvanize")
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	item_flags = NO_PIXEL_RANDOM_DROP
	var/inspiration_available = TRUE //If this banner can be used to inspire crew
	var/morale_time = 0
	var/morale_cooldown = 600 //How many deciseconds between uses
	/// Mobs with assigned roles whose department bitflags match these will be inspired.
	var/job_loyalties = NONE
	/// Mobs with any of these special roles will be inspired
	var/list/role_loyalties
	var/warcry

/obj/item/banner/examine(mob/user)
	. = ..()
	if(inspiration_available)
		. += span_notice("在手中激活以鼓舞附近该旗帜阵营的盟友！")

/obj/item/banner/attack_self(mob/living/carbon/human/user)
	if(!inspiration_available || flags_1 & HOLOGRAM_1)
		return
	if(morale_time > world.time)
		to_chat(user, span_warning("你还没感到足够鼓舞，无法再次挥舞 [src]。"))
		return
	user.visible_message("<span class='big notice'>[user] 挥舞着 [src]！</span>", \
	span_notice("你将 [src] 高举向天，鼓舞了你的盟友！"))
	playsound(src, SFX_RUSTLE, 100, FALSE)
	if(warcry)
		user.say("[warcry]", forced="banner")
	var/old_transform = user.transform
	user.transform *= 1.2
	animate(user, transform = old_transform, time = 10)
	morale_time = world.time + morale_cooldown

	var/list/inspired = list()
	var/has_job_loyalties = job_loyalties != NONE
	var/has_role_loyalties = LAZYLEN(role_loyalties)
	inspired += user //The user is always inspired, regardless of loyalties
	for(var/mob/living/carbon/human/H in range(4, get_turf(src)))
		if(H.stat == DEAD || H == user)
			continue
		if(H.mind && (has_job_loyalties || has_role_loyalties))
			if(has_job_loyalties && (H.mind.assigned_role.departments_bitflags & job_loyalties))
				inspired += H
			else if(has_role_loyalties && length(H.mind.get_special_roles() & role_loyalties))
				inspired += H
		else if(check_inspiration(H))
			inspired += H

	for(var/V in inspired)
		var/mob/living/carbon/human/H = V
		if(H != user)
			to_chat(H, span_notice("当 [user] 挥舞着 [user.p_their()] [name] 时，你的信心高涨！"))
		inspiration(H)
		special_inspiration(H)

/obj/item/banner/proc/check_inspiration(mob/living/carbon/human/H) //Banner-specific conditions for being eligible
	return

/obj/item/banner/proc/inspiration(mob/living/carbon/human/inspired_human)
	var/need_mob_update = FALSE
	need_mob_update += inspired_human.adjust_brute_loss(-15, updating_health = FALSE)
	need_mob_update += inspired_human.adjust_fire_loss(-15, updating_health = FALSE)
	if(need_mob_update)
		inspired_human.updatehealth()
	inspired_human.AdjustStun(-4 SECONDS)
	inspired_human.AdjustKnockdown(-4 SECONDS)
	inspired_human.AdjustImmobilized(-4 SECONDS)
	inspired_human.AdjustParalyzed(-4 SECONDS)
	inspired_human.AdjustUnconscious(-4 SECONDS)
	playsound(inspired_human, 'sound/effects/magic/staff_healing.ogg', 25, FALSE)

/obj/item/banner/proc/special_inspiration(mob/living/carbon/human/H) //Any banner-specific inspiration effects go here
	return

/obj/item/banner/security
	name = "安全斯坦旗帜"
	desc = "安全斯坦的旗帜，以铁腕统治着空间站。"
	icon_state = "banner_security"
	inhand_icon_state = "banner_security"
	warcry = "EVERYONE DOWN ON THE GROUND!!"

/obj/item/banner/security/Initialize(mapload)
	. = ..()
	job_loyalties = DEPARTMENT_BITFLAG_SECURITY

/obj/item/banner/security/mundane
	inspiration_available = FALSE

/datum/crafting_recipe/security_banner
	name = "安全斯坦旗帜"
	result = /obj/item/banner/security/mundane
	time = 4 SECONDS
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/security/officer = 1)
	category = CAT_MISC

/obj/item/banner/medical
	name = "医疗托邦旗帜"
	desc = "医疗托邦的旗帜，慷慨的恩主治愈创伤、庇护弱者。"
	icon_state = "banner_medical"
	inhand_icon_state = "banner_medical"
	warcry = "No wounds cannot be healed!"

/obj/item/banner/medical/Initialize(mapload)
	. = ..()
	job_loyalties = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/banner/medical/mundane
	inspiration_available = FALSE

/obj/item/banner/medical/check_inspiration(mob/living/carbon/human/H)
	return H.stat //Meditopia is moved to help those in need

/datum/crafting_recipe/medical_banner
	name = "医疗托邦旗帜"
	result = /obj/item/banner/medical/mundane
	time = 4 SECONDS
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/medical/doctor = 1)
	category = CAT_MISC

/obj/item/banner/medical/special_inspiration(mob/living/carbon/human/inspired_human)
	var/need_mob_update = FALSE
	need_mob_update += inspired_human.adjust_tox_loss(-15, updating_health = FALSE)
	need_mob_update += inspired_human.set_oxy_loss(0, updating_health = FALSE)
	if(need_mob_update)
		inspired_human.updatehealth()
	inspired_human.reagents.add_reagent(/datum/reagent/medicine/inaprovaline, 5)

/obj/item/banner/science
	name = "科学西亚旗帜"
	desc = "科学西亚的旗帜，大胆无畏的术士与研究者，选择少有人走的路。"
	icon_state = "banner_science"
	inhand_icon_state = "banner_science"
	warcry = "For Cuban Pete!"

/obj/item/banner/science/Initialize(mapload)
	. = ..()
	job_loyalties = DEPARTMENT_BITFLAG_SCIENCE

/obj/item/banner/science/mundane
	inspiration_available = FALSE

/obj/item/banner/science/check_inspiration(mob/living/carbon/human/H)
	return H.on_fire //Sciencia is pleased by dedication to the art of Ordnance

/datum/crafting_recipe/science_banner
	name = "科学西亚旗帜"
	result = /obj/item/banner/science/mundane
	time = 4 SECONDS
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/rnd/scientist = 1)
	category = CAT_MISC

/obj/item/banner/cargo
	name = "货运尼亚旗帜"
	desc = "永恒货运尼亚的旗帜，拥有凭空召唤任何物品的神秘力量。"
	icon_state = "banner_cargo"
	inhand_icon_state = "banner_cargo"
	warcry = "Hail Cargonia!"

/obj/item/banner/cargo/Initialize(mapload)
	. = ..()
	job_loyalties = DEPARTMENT_BITFLAG_CARGO

/obj/item/banner/cargo/mundane
	inspiration_available = FALSE

/datum/crafting_recipe/cargo_banner
	name = "货运尼亚旗帜"
	result = /obj/item/banner/cargo/mundane
	time = 4 SECONDS
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/cargo/tech = 1)
	category = CAT_MISC

/obj/item/banner/engineering
	name = "工程乌托邦旗帜"
	desc = "工程托邦的旗帜，无限力量的持有者。"
	icon_state = "banner_engineering"
	inhand_icon_state = "banner_engineering"
	warcry = "All hail lord Singuloth!!"

/obj/item/banner/engineering/Initialize(mapload)
	. = ..()
	job_loyalties = DEPARTMENT_BITFLAG_ENGINEERING

/obj/item/banner/engineering/mundane
	inspiration_available = FALSE

/obj/item/banner/engineering/special_inspiration(mob/living/carbon/human/H)
	qdel(H.GetComponent(/datum/component/irradiated))

/datum/crafting_recipe/engineering_banner
	name = "工程乌托邦旗帜"
	result = /obj/item/banner/engineering/mundane
	time = 4 SECONDS
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/engineering/engineer = 1)
	category = CAT_MISC

/obj/item/banner/command
	name = "指挥旗帜"
	desc = "指挥部的旗帜，代表着官僚国王与女王们坚定而古老的世系。"
	//No icon state here since the default one is the NT banner
	warcry = "Hail Nanotrasen!"

/obj/item/banner/command/Initialize(mapload)
	. = ..()
	job_loyalties = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_CENTRAL_COMMAND //NOVA EDIT ADDITION

/obj/item/banner/command/mundane
	inspiration_available = FALSE

/obj/item/banner/command/check_inspiration(mob/living/carbon/human/H)
	return HAS_TRAIT(H, TRAIT_MINDSHIELD) //Command is stalwart but rewards their allies.

/datum/crafting_recipe/command_banner
	name = "指挥旗帜"
	result = /obj/item/banner/command/mundane
	time = 4 SECONDS
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/captain/parade = 1)
	category = CAT_MISC

/obj/item/banner/red
	name = "红色旗帜"
	icon_state = "banner-red"
	inhand_icon_state = "banner-red"
	desc = "一面印有红色神祇徽记的旗帜。"

/obj/item/banner/blue
	name = "蓝色旗帜"
	icon_state = "banner-blue"
	inhand_icon_state = "banner-blue"
	desc = "一面印有蓝色神明徽记的旗帜。"

/obj/item/storage/backpack/bannerpack
	name = "\improper 纳米传讯旗帜背包"
	desc = "It's a backpack with lots of extra room.  A banner with Nanotrasen's logo is attached, that can't be removed."
	icon_state = "backpack-banner"

/obj/item/storage/backpack/bannerpack/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 27 //6 more then normal, for the tradeoff of declaring yourself an antag at all times.

/obj/item/storage/backpack/bannerpack/red
	name = "红色旗帜背包"
	desc = "It's a backpack with lots of extra room.  A red banner is attached, that can't be removed."
	icon_state = "backpack-banner_red"

/obj/item/storage/backpack/bannerpack/blue
	name = "蓝色旗帜背包"
	desc = "It's a backpack with lots of extra room.  A blue banner is attached, that can't be removed."
	icon_state = "backpack-banner_blue"

//this is all part of one item set

/obj/item/clothing/head/helmet/plate/crusader
	name = "十字军兜帽"
	desc = "一顶棕色的兜帽。"
	icon = 'icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/head/chaplain.dmi'
	icon_state = "crusader"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_NORMAL
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE
	armor_type = /datum/armor/plate_crusader

/datum/armor/plate_crusader
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 60
	fire = 60
	acid = 60

/obj/item/clothing/head/helmet/plate/crusader/blue
	icon_state = "crusader-blue"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/plate/crusader/red
	icon_state = "crusader-red"
	inhand_icon_state = null

//Prophet helmet
/obj/item/clothing/head/helmet/plate/crusader/prophet
	name = "先知帽"
	desc = "一顶看起来很有宗教感的帽子。"
	icon_state = null
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	inhand_icon_state = null
	abstract_type = /obj/item/clothing/head/helmet/plate/crusader/prophet
	flags_1 = 0
	armor_type = /datum/armor/crusader_prophet
	worn_y_offset = 6

/datum/armor/crusader_prophet
	melee = 60
	bullet = 60
	laser = 60
	energy = 60
	bomb = 70
	bio = 50
	fire = 60
	acid = 60

/obj/item/clothing/head/helmet/plate/crusader/prophet/red
	icon_state = "prophet-red"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/plate/crusader/prophet/blue
	icon_state = "prophet-blue"
	inhand_icon_state = null

//Structure conversion staff
/obj/item/godstaff
	name = "神杖"
	desc = "这是根棍子..？"
	icon = 'icons/obj/weapons/staff.dmi'
	icon_state = "godstaff-red"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	var/conversion_color = "#ffffff"
	var/staffcooldown = 0
	var/staffwait = 30

/obj/item/godstaff/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/walking_aid)

/obj/item/godstaff/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(SHOULD_SKIP_INTERACTION(interacting_with, src, user))
		return NONE
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/godstaff/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(staffcooldown + staffwait > world.time)
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice("[user] 深沉地吟唱并挥舞着[user.p_their()]法杖！"))
	if(do_after(user, 2 SECONDS, interacting_with))
		interacting_with.add_atom_colour(conversion_color, WASHABLE_COLOUR_PRIORITY) //wololo
	staffcooldown = world.time
	return ITEM_INTERACT_SUCCESS

/obj/item/godstaff/red
	icon_state = "godstaff-red"
	conversion_color = "#ff0000"

/obj/item/godstaff/blue
	icon_state = "godstaff-blue"
	conversion_color = "#0000ff"

/obj/item/clothing/gloves/plate
	name = "板甲护手"
	icon_state = "crusader"
	desc = "它们就像手套，不过是金属做的。"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT

/obj/item/clothing/gloves/plate/red
	icon_state = "crusader-red"

/obj/item/clothing/gloves/plate/blue
	icon_state = "crusader-blue"

/obj/item/clothing/shoes/plate
	name = "板甲靴"
	desc = "金属靴子，看起来挺重的。"
	icon_state = "crusader"
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/shoes_plate
	body_parts_covered = FEET|LEGS
	clothing_traits = list(TRAIT_NO_SLIP_WATER)
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/datum/armor/shoes_plate
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 60
	fire = 60
	acid = 60

/obj/item/clothing/shoes/plate/red
	icon_state = "crusader-red"

/obj/item/clothing/shoes/plate/blue
	icon_state = "crusader-blue"

/obj/item/claymore/weak
	desc = "这把已经生锈了。"
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "claymore_old"
	worn_icon = 'icons/mob/clothing/back.dmi'
	worn_icon_state = "claymore"
	force = 30
	armour_penetration = 15

/obj/item/claymore/weak/make_stabby()
	AddComponent(/datum/component/alternative_sharpness, SHARP_POINTY, alt_continuous, alt_simple, -9)

/obj/item/claymore/weak/ceremonial
	desc = "一把生锈的阔剑，曾是一个被暴君镇压的强大苏格兰氏族的核心象征，它作为反抗的标志世代相传。"
	force = 15
	block_chance = 30
	armour_penetration = 5

/obj/item/claymore/weak/ceremonial/make_stabby()
	AddComponent(/datum/component/alternative_sharpness, SHARP_POINTY, alt_continuous, alt_simple, -5)
