/obj/item/clothing/glasses/hud
	gender = NEUTER
	name = "HUD"
	desc = "一个平视显示器，提供（几乎）实时的重要信息。"
	flags_1 = null //doesn't protect eyes because it's a monocle, duh
	actions_types = list(/datum/action/item_action/toggle_wearable_hud)
	/// Whether the HUD info is on or off
	var/display_active = TRUE

/obj/item/clothing/glasses/hud/emp_act(severity)
	. = ..()
	if(obj_flags & EMAGGED || . & EMP_PROTECT_SELF)
		return
	obj_flags |= EMAGGED
	desc = "[desc]发出微弱的光"

/obj/item/clothing/glasses/hud/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	balloon_alert(user, "显示已扰乱")
	desc = "[desc] The display is flickering slightly."
	return TRUE

/obj/item/clothing/glasses/hud/suicide_act(mob/living/user)
	if(user.is_blind())
		return SHAME
	var/mob/living/living_user = user
	user.visible_message(span_suicide("[user] looks through [src] and looks overwhelmed with the information! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(living_user.get_organ_loss(ORGAN_SLOT_BRAIN) >= BRAIN_DAMAGE_SEVERE)
		var/mob/thing = pick((/mob in view()) - user)
		if(thing)
			user.say("VALID MAN IS WANTER, ARREST HE!!")
			user.pointed(thing)
		else
			user.say("WHY IS THERE A BAR ON MY HEAD?!!")
	return OXYLOSS

/obj/item/clothing/glasses/hud/equipped(mob/living/user, slot)
	. = ..()
	display_active = TRUE

/obj/item/clothing/glasses/hud/proc/toggle_hud_display(mob/living/carbon/eye_owner)
	if(display_active)
		display_active = FALSE
		for(var/hud_trait in clothing_traits)
			REMOVE_CLOTHING_TRAIT(eye_owner, hud_trait)
		balloon_alert(eye_owner, "HUD 已禁用")
		return

	display_active = TRUE
	for(var/hud_trait in clothing_traits)
		ADD_CLOTHING_TRAIT(eye_owner, hud_trait)
	balloon_alert(eye_owner, "HUD 已启用")

/obj/item/clothing/glasses/hud/health
	name = "健康扫描目镜"
	desc = "一个抬头显示器，能够扫描视野中的人型生物，并提供有关其健康状态的准确状况。"
	icon_state = "healthhud"
	clothing_traits = list(TRAIT_MEDICAL_HUD)
	glass_colour_type = /datum/client_colour/glass_colour/lightblue

/obj/item/clothing/glasses/hud/medsechud
	name = "health scanner security HUD"
	desc = "A heads-up display that scans the humanoids in view and provides accurate data about their health status, ID status and security records."
	icon_state = "medsechud"
	clothing_traits = list(TRAIT_MEDICAL_HUD, TRAIT_SECURITY_HUD)

/obj/item/clothing/glasses/hud/health/night
	name = "夜视健康扫描目镜"
	desc = "An advanced medical heads-up display that allows doctors to find patients in complete darkness."
	icon_state = "healthhudnight"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	flags_cover = GLASSESCOVERSEYES
	// Blue green, dark
	color_cutoffs = list(20, 20, 45)
	glass_colour_type = /datum/client_colour/glass_colour/lightgreen
	actions_types = list(/datum/action/item_action/toggle_nv)

/obj/item/clothing/glasses/hud/health/night/update_icon_state()
	. = ..()
	icon_state = length(color_cutoffs) ? initial(icon_state) : "night_off"

/obj/item/clothing/glasses/hud/health/night/meson
	name = "night vision meson health scanner HUD"
	desc = "Truly combat ready."
	vision_flags = SEE_TURFS

/obj/item/clothing/glasses/hud/health/night/science
	name = "night vision medical science scanner HUD"
	desc = "A clandestine medical science heads-up display that allows operatives to find \
		both dying captains and the perfect poison to finish them off, all in complete darkness."
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_MEDICAL_HUD)

/obj/item/clothing/glasses/hud/health/sunglasses
	gender = PLURAL
	name = "医疗HUD太阳镜"
	desc = "配有医疗HUD的太阳镜."
	icon_state = "sunhudmed"
	flash_protect = FLASH_PROTECTION_FLASH
	flags_cover = GLASSESCOVERSEYES
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/blue
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.55, /datum/material/iron = SMALL_MATERIAL_AMOUNT / 2)

/obj/item/clothing/glasses/hud/health/sunglasses/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/hudsunmedremoval)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/clothing/glasses/hud/diagnostic
	name = "诊断HUD"
	desc = "一个抬头显示器，能够分析赛博和机甲的完整性和电力状况。"
	icon_state = "diagnostichud"
	clothing_traits = list(TRAIT_DIAGNOSTIC_HUD)
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

/obj/item/clothing/glasses/hud/diagnostic/night
	name = "夜视诊断目镜"
	desc = "配有光放大器的诊断HUD."
	icon_state = "diagnostichudnight"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	flags_cover = GLASSESCOVERSEYES
	// Pale yellow
	color_cutoffs = list(25, 15, 5)
	glass_colour_type = /datum/client_colour/glass_colour/lightyellow
	actions_types = list(/datum/action/item_action/toggle_nv)

/obj/item/clothing/glasses/hud/diagnostic/night/update_icon_state()
	. = ..()
	icon_state = length(color_cutoffs) ? initial(icon_state) : "night_off"

/obj/item/clothing/glasses/hud/diagnostic/sunglasses
	gender = PLURAL
	name = "诊断太阳镜"
	desc = "配有诊断HUD的太阳镜。"
	icon_state = "sunhuddiag"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_FLASH
	flags_cover = GLASSESCOVERSEYES
	tint = 1
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.55, /datum/material/iron = SMALL_MATERIAL_AMOUNT / 2)

/obj/item/clothing/glasses/hud/diagnostic/sunglasses/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/hudsundiagremoval)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/clothing/glasses/hud/security
	name = "安保目镜"
	desc = "一个抬头显示器，能够扫描视野中的人型生物，并提供有关其身份和安全记录的准确状况。"
	icon_state = "securityhud"
	clothing_traits = list(TRAIT_SECURITY_HUD)
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/hud/security/chameleon
	name = "变色龙安保目镜"
	desc = "一个被窃取的安保目镜，集成了辛迪加的变色龙技术，能够提供闪光防护."
	flash_protect = FLASH_PROTECTION_FLASH
	actions_types = list(/datum/action/item_action/chameleon/change/glasses/no_preset)

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "眼罩HUD"
	desc = "HUD太阳镜的帅表亲。"
	icon_state = "hudpatch"
	base_icon_state = "hudpatch"
	actions_types = list(/datum/action/item_action/flip)

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch/attack_self(mob/user, modifiers)
	. = ..()
	icon_state = (icon_state == base_icon_state) ? "[base_icon_state]_flipped" : base_icon_state
	user.update_worn_glasses()

/obj/item/clothing/glasses/hud/security/sunglasses
	gender = PLURAL
	name = "安保HUD太阳镜"
	desc = "配有安保HUD的太阳镜."
	icon_state = "sunhudsec"
	flash_protect = FLASH_PROTECTION_FLASH
	flags_cover = GLASSESCOVERSEYES
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/darkred
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.55, /datum/material/iron = SMALL_MATERIAL_AMOUNT / 2)

/obj/item/clothing/glasses/hud/security/sunglasses/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/hudsunsecremoval)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/clothing/glasses/hud/security/night
	name = "夜视安保目镜"
	desc = "先进的头戴显示器，在完全黑暗中提供身份数据和视觉。"
	icon_state = "securityhudnight"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	flags_cover = GLASSESCOVERSEYES
	// Red with a tint of green
	color_cutoffs = list(40, 15, 10)
	glass_colour_type = /datum/client_colour/glass_colour/lightred
	actions_types = list(/datum/action/item_action/toggle_nv)

/obj/item/clothing/glasses/hud/security/night/update_icon_state()
	. = ..()
	icon_state = length(color_cutoffs) ? initial(icon_state) : "night_off"

/obj/item/clothing/glasses/hud/security/sunglasses/gars
	gender = PLURAL
	name = "\improper HUD gar glasses"
	desc = "带有HUD的GAR眼镜。"
	icon_state = "gar_sec"
	inhand_icon_state = "gar_black"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb_continuous = list("slices")
	attack_verb_simple = list("slice")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED

/obj/item/clothing/glasses/hud/security/sunglasses/gars/giga
	name = "giga HUD gar glasses"
	desc = "GIGA GAR glasses with a HUD."
	icon_state = "gigagar_sec"
	force = 12
	throwforce = 12

/obj/item/clothing/glasses/hud/toggle
	name = "Toggle HUD"
	desc = "具有多种功能的hud。"
	flags_cover = GLASSESCOVERSEYES
	actions_types = list(/datum/action/item_action/switch_hud)

/obj/item/clothing/glasses/hud/toggle/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wearer = user
	if (wearer.glasses != src)
		return

	if (TRAIT_MEDICAL_HUD in clothing_traits)
		detach_clothing_traits(TRAIT_MEDICAL_HUD)
	else if (TRAIT_SECURITY_HUD in clothing_traits)
		detach_clothing_traits(TRAIT_MEDICAL_HUD)
		attach_clothing_traits(TRAIT_SECURITY_HUD)
	else
		detach_clothing_traits(TRAIT_MEDICAL_HUD)
		attach_clothing_traits(TRAIT_SECURITY_HUD)

/datum/action/item_action/switch_hud
	name = "Switch HUD"

/obj/item/clothing/glasses/hud/toggle/thermal
	name = "热量HUD扫描仪"
	desc = "集成了热成像HUD的眼镜."
	icon_state = "thermal"
	vision_flags = SEE_MOBS
	color_cutoffs = list(25, 8, 5)
	glass_colour_type = /datum/client_colour/glass_colour/red
	clothing_traits = list(TRAIT_SECURITY_HUD)

/obj/item/clothing/glasses/hud/toggle/thermal/attack_self(mob/user)
	..()
	var/hud_type
	if (LAZYLEN(clothing_traits))
		hud_type = clothing_traits[1]
	switch (hud_type)
		if (TRAIT_MEDICAL_HUD)
			icon_state = "meson"
			color_cutoffs = list(5, 15, 5)
			change_glass_color(/datum/client_colour/glass_colour/green)
		if (TRAIT_SECURITY_HUD)
			icon_state = "thermal"
			color_cutoffs = list(25, 8, 5)
			change_glass_color(/datum/client_colour/glass_colour/red)
		else
			icon_state = "purple"
			color_cutoffs = list(15, 0, 25)
			change_glass_color(/datum/client_colour/glass_colour/purple)
	user.update_sight()
	user.update_worn_glasses()

/obj/item/clothing/glasses/hud/toggle/thermal/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	thermal_overload()

/obj/item/clothing/glasses/hud/spacecop
	gender = PLURAL
	name = "警察飞行员墨镜"
	desc = "你血腥的镇压少数民族和抗议者，然后还觉得自己很酷。"
	icon_state = "bigsunglasses"
	flash_protect = FLASH_PROTECTION_FLASH
	flags_cover = GLASSESCOVERSEYES
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/gray


/obj/item/clothing/glasses/hud/spacecop/hidden // for the undercover cop
	gender = PLURAL
	name = "太阳镜"
	desc = "这些太阳镜很特别，可以让你看到潜在的罪犯。"
	icon_state = "sun"
	inhand_icon_state = "sunglasses"
