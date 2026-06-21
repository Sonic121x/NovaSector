
/obj/item/clothing/gloves/cargo_gauntlet
	name = "\improper H.A.U.L.护手"
	desc = "这些笨重的护手可以让你更有信心地拖着东西，而且有效防止物品从手里滑落。"
	icon_state = "haul_gauntlet"
	greyscale_colors = "#2f2e31"
	equip_delay_self = 3 SECONDS
	equip_delay_other = 4 SECONDS
	clothing_traits = list(TRAIT_CHUNKYFINGERS)
	undyeable = TRUE
	var/datum/weakref/pull_component_weakref

/obj/item/clothing/gloves/cargo_gauntlet/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(on_glove_equip))
	RegisterSignal(src, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(on_glove_unequip))
	AddElement(/datum/element/adjust_fishing_difficulty, 19)

/// Called when the glove is equipped. Adds a component to the equipper and stores a weak reference to it.
/obj/item/clothing/gloves/cargo_gauntlet/proc/on_glove_equip(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(!(slot & ITEM_SLOT_GLOVES))
		return

	var/datum/component/strong_pull/pull_component = pull_component_weakref?.resolve()
	if(pull_component)
		stack_trace("Gloves already have a pull component associated with \[[pull_component.parent]\] when \[[equipper]\] is trying to equip them.")
		QDEL_NULL(pull_component_weakref)

	to_chat(equipper, span_notice("你刚戴上手套就感觉到它们激活了，让你的拖拽力量更强了！"))

	pull_component_weakref = WEAKREF(equipper.AddComponent(/datum/component/strong_pull))

/*
 * Called when the glove is unequipped. Deletes the component if one exists.
 *
 * No component being associated on equip is a valid state, as holding the gloves in your hands also counts
 * as having them equipped, or even in pockets. They only give the component when they're worn on the hands.
 */
/obj/item/clothing/gloves/cargo_gauntlet/proc/on_glove_unequip(datum/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER

	var/datum/component/strong_pull/pull_component = pull_component_weakref?.resolve()

	if(!pull_component)
		return

	to_chat(pull_component.parent, span_warning("你失去了[src]的抓握力量！"))

	QDEL_NULL(pull_component_weakref)

/obj/item/clothing/gloves/rapid
	name = "北极星手套"
	desc = "光是看着就让你有一种想要狠狠揍别人一顿的冲动."
	icon_state = "rapid"
	inhand_icon_state = null
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/rapid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/punchcooldown)
	AddElement(/datum/element/adjust_fishing_difficulty, -9)

/obj/item/clothing/gloves/radio
	name = "翻译手套"
	desc = "A pair of electronic gloves which connect to nearby radios wirelessly. Allows for sign language users to 'speak' over comms."
	icon_state = "radio_g"
	inhand_icon_state = null
	clothing_traits = list(TRAIT_CAN_SIGN_ON_COMMS)
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.9, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.4)

/obj/item/clothing/gloves/race
	name = "竞赛手套"
	desc = "制作极为精细的手套，供运动员在速射比赛中使用。"
	clothing_traits = list(TRAIT_DOUBLE_TAP)
	icon_state = "black"
	greyscale_colors = "#2f2e31"

/obj/item/clothing/gloves/race/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -9)

/obj/item/clothing/gloves/captain
	desc = "华贵的蓝色手套，配有漂亮的金边、钻石防电涂层以及集成的隔热层。非常时髦。"
	name = "舰长的手套"
	icon_state = "captain"
	inhand_icon_state = null
	greyscale_colors = null
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 6 SECONDS
	armor_type = /datum/armor/captain_gloves
	resistance_flags = NONE
	clothing_traits = list(TRAIT_FAST_CUFFING)

/obj/item/clothing/gloves/captain/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -6)

/datum/armor/captain_gloves
	bio = 90
	fire = 70
	acid = 50

/obj/item/clothing/gloves/latex
	name = "乳胶手套"
	desc = "由乳胶制成的廉价无菌手套。良好的抓握力能提供更快的搬运速度。"
	icon_state = "latex"
	inhand_icon_state = "latex_gloves"
	greyscale_colors = null
	siemens_coefficient = 0.3
	armor_type = /datum/armor/latex_gloves
	clothing_traits = list(TRAIT_QUICK_CARRY)
	resistance_flags = NONE
	equip_sound = 'sound/items/equip/glove_equip.ogg'

/datum/armor/latex_gloves
	bio = 100

/obj/item/clothing/gloves/latex/nitrile
	name = "丁腈手套"
	desc = "价格昂贵、无菌且比乳胶更厚的手套。出色的抓握力确保能非常快速地搬运病人，同时加快各种化学相关物品的使用速度。"
	icon_state = "nitrile"
	inhand_icon_state = "greyscale_gloves"
	greyscale_colors = "#99eeff"
	clothing_traits = list(TRAIT_QUICKER_CARRY, TRAIT_FASTMED)

/obj/item/clothing/gloves/latex/nitrile/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -6)

/obj/item/clothing/gloves/latex/coroner
	name = "验尸官手套"
	desc = "由乳胶制成并带有超疏水涂层的黑色手套。用于抬起尸体而非拖拽留下血迹时非常有用。"
	icon_state = "latex_black"
	inhand_icon_state = "greyscale_gloves"
	greyscale_colors = "#15191a"
	clothing_traits = list(TRAIT_QUICK_CARRY, TRAIT_FASTMED)

/obj/item/clothing/gloves/latex/coroner/add_blood_DNA(list/blood_DNA_to_add, list/datum/disease/diseases)
	return FALSE

/obj/item/clothing/gloves/tinkerer
	name = "工匠手套"
	desc = "过度设计的工程手套，内置了自动化的建造子程序，穿戴时可加快建造速度。"
	inhand_icon_state = "greyscale_gloves"
	icon_state = "clockwork_gauntlets"
	greyscale_colors = "#996e23"
	siemens_coefficient = 0.8
	armor_type = /datum/armor/tinker_gloves
	clothing_traits = list(TRAIT_QUICK_BUILD)
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/silver=HALF_SHEET_MATERIAL_AMOUNT*1.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT)
	resistance_flags = NONE

/datum/armor/tinker_gloves
	bio = 70

/obj/item/clothing/gloves/atmos
	name = "大气救援手套"
	desc = "消防员专用的重型手套。它们厚实、阻燃，并能让你更快地搬运人员。"
	icon_state = "atmos"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	siemens_coefficient = 0.3
	clothing_traits = list(TRAIT_QUICKER_CARRY, TRAIT_CHUNKYFINGERS)
	clothing_flags = parent_type::clothing_flags | THICKMATERIAL|STOPSPRESSUREDAMAGE

/obj/item/clothing/gloves/atmos/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 6)

///A pair of gloves that both allow the user to fish without the need of a held fishing rod and provides athletics experience.
/obj/item/clothing/gloves/fishing
	name = "运动钓鱼手套"
	desc = "一副无需鱼竿，仅凭你原始的<b>运动</b>力量即可钓鱼的手套。它也可作为良好的锻炼设备。<i><b>警告</b>：捕捉较大的鱼时可能导致受伤。</i>"
	icon_state = "fishing_gloves"
	///The current fishing minigame datum the wearer is engaged in.
	var/datum/fishing_challenge/challenge

/obj/item/clothing/gloves/fishing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/profound_fisher, new /obj/item/fishing_rod/mob_fisher/athletic(src))
	AddElement(/datum/element/adjust_fishing_difficulty, -4) //on top of the extra that you get from the athletics skill.

/obj/item/clothing/gloves/fishing/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_GLOVES)
		RegisterSignal(user, COMSIG_MOB_BEGIN_FISHING_MINIGAME, PROC_REF(begin_workout))

/obj/item/clothing/gloves/fishing/dropped(mob/user)
	UnregisterSignal(user, COMSIG_MOB_BEGIN_FISHING_MINIGAME)
	if(challenge)
		stop_workout(user)
	return ..()

/obj/item/clothing/gloves/fishing/proc/begin_workout(datum/source, datum/fishing_challenge/challenge)
	SIGNAL_HANDLER
	RegisterSignal(source, COMSIG_MOB_COMPLETE_FISHING, PROC_REF(stop_workout))
	if(HAS_TRAIT(source, TRAIT_PROFOUND_FISHER)) //Only begin working out if we're fishing with these gloves and not some other fishing rod..
		START_PROCESSING(SSprocessing, src)
		src.challenge = challenge

/obj/item/clothing/gloves/fishing/proc/stop_workout(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_MOB_COMPLETE_FISHING)
	challenge = null
	STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/gloves/fishing/process(seconds_per_tick)
	var/mob/living/wearer = loc
	var/stamina_exhaustion = 2 + challenge.difficulty * 0.02
	var/is_heavy_gravity = wearer.has_gravity() > STANDARD_GRAVITY
	var/obj/item/organ/cyberimp/chest/spine/potential_spine = wearer.get_organ_slot(ORGAN_SLOT_SPINE)
	if(istype(potential_spine))
		stamina_exhaustion *= potential_spine.athletics_boost_multiplier
	if(HAS_TRAIT(wearer, TRAIT_STRENGTH))
		stamina_exhaustion *= 0.5

	var/experience = 0.3 + challenge.difficulty * 0.003
	if(is_heavy_gravity)
		stamina_exhaustion *= 1.5
		experience *= 2

	wearer.adjust_stamina_loss(stamina_exhaustion)
	wearer.mind?.adjust_experience(/datum/skill/athletics, experience)
	wearer.apply_status_effect(/datum/status_effect/exercised)

///The internal fishing rod of the athletic fishing gloves. The more athletic you're, the easier the minigame will be.
/obj/item/fishing_rod/mob_fisher/athletic
	name = "运动钓鱼手套"
	icon = /obj/item/clothing/gloves/fishing::icon
	icon_state = /obj/item/clothing/gloves/fishing::icon_state
	frame_state = "frame_athletic"
	line = null
	bait = null
	ui_description = "A pair of gloves to fish without a fishing rod while training your athletics."
	wiki_description = "<b>It requires the Advanced Fishing Technology Node to be researched to be printed.</b> It may hurt the user when catching larger fish."
	show_in_wiki = TRUE //Show this cool pair of gloves in the wiki.

/obj/item/fishing_rod/mob_fisher/athletic/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_FISHING_ROD_CAUGHT_FISH, PROC_REF(noodling_is_dangerous))

/obj/item/fishing_rod/mob_fisher/athletic/get_fishing_overlays()
	return list()

/obj/item/fishing_rod/mob_fisher/athletic/hook_hit(atom/atom_hit_by_hook_projectile, mob/user)
	difficulty_modifier = -3 * (user.mind?.get_skill_level(/datum/skill/athletics) - 1)
	return ..()

/obj/item/fishing_rod/mob_fisher/athletic/proc/noodling_is_dangerous(datum/source, atom/movable/reward, mob/living/user)
	SIGNAL_HANDLER
	if(!isfish(reward))
		return
	var/damage = 0
	var/obj/item/fish/fishe = reward
	switch(fishe.w_class)
		if(WEIGHT_CLASS_BULKY)
			damage = 10
		if(WEIGHT_CLASS_HUGE)
			damage = 14
		if(WEIGHT_CLASS_GIGANTIC)
			damage = 18
	if(!damage && fishe.weight >= 2000)
		damage = 5
	damage = round(damage * fishe.weight * 0.0005)
	if(damage)
		var/body_zone = pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
		user.apply_damage(damage, BRUTE, body_zone, user.run_armor_check(body_zone, MELEE))
		playsound(src,'sound/items/weapons/bite.ogg', damage * 2, TRUE)
